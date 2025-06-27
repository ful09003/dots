;; Starting here, using https://protesilaos.com/codelog/2024-11-28-basic-emacs-configuration/
(setq custom-file (locate-user-emacs-file "custom.el"))
(load custom-file :no-error-if-file-is-missing)

(require 'package)
(package-initialize)

(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))

(when (< emacs-major-version 29)
  (unless (package-installed-p 'use-package)
    (unless package-archive-contents
      (package-refresh-contents))
    (package-install 'use-package)))

(add-to-list 'display-buffer-alist
	     '("\\`\\*\\(Warnings\\|Compile-Log\\)\\*\\'"
	       (display-buffer-no-window)
	       (allow-no-window . t)))

(use-package delsel
  :ensure nil ; built-in
  :hook (after-init . delete-selection-mode))

(defun prot/keyboard-quit-dwim ()
  "Do-What-I-Mean behaviour for a general 'keyboard-quit'.

The generic 'keyboard-quit' does not do the expected thing when the minibuffer is open.
We want it to close the minibuffer even if not focused.

DWIM means:

- When the region is active, disable it
- When a minibuffer is open but not focused, close it
- When the Completions buffer is selected, close it.
- In every other case use regular 'keyboard-quit'."
  (interactive)
  (cond
   ((region-active-p)
    (keyboard-quit))
   ((derived-mode-p 'completion-list-mode)
    (delete-completion-window))
   ((> (minibuffer-depth) 0)
    (abort-recursive-edit))
   (t
    (keyboard-quit))))

(define-key global-map (kbd "C-g") #'prot/keyboard-quit-dwim)

(menu-bar-mode -1)
(scroll-bar-mode -1)
(tool-bar-mode -1)

(use-package nerd-icons
  :ensure t
  :custom (nerd-icons-font-family "Symbols Nerd Font Mono"))

(use-package nerd-icons-completion
  :ensure t
  :after marginalia
  :config
  (add-hook 'marginalia-mode-hook #'nerd-icons-completion-marginalia-setup))

(use-package nerd-icons-corfu
  :ensure t
  :after corfu
  :config
  (add-to-list 'corfu-margin-formatters #'nerd-icons-corfu-formatter))

(use-package nerd-icons-dired
  :ensure t
  :hook
  (dired-mode . nerd-icons-dired-mode))

(use-package vertico
  :ensure t
  :hook (after-init . vertico-mode))

(use-package marginalia
  :ensure t
  :hook (after-init . marginalia-mode))

(use-package savehist
  :ensure nil ; built-in
  :hook (after-init . savehist-mode))

(use-package orderless
  :ensure t
  :config
  (setq completion-styles '(orderless basic))
  (setq completion-category-defaults nil)
  (setq completion-category-overrides nil))

(use-package corfu
  :ensure t
  :hook (after-init . global-corfu-mode)
  :bind (:map corfu-map ("<tab>" . corfu-complete))
  :config
  (setq tab-always-indent 'complete)
  (setq corfu-preview-current nil)
  (setq corfu-min-width 20)

  (setq corfu-popupinfo-delay '(1.24 . 0.5))
  (corfu-popupinfo-mode 1) ; shows documentation after 'corfu-popupinfo-delay'

  ;; sort by input history
  (with-eval-after-load 'savehist
    (corfu-history-mode 1)
    (add-to-list 'savehist-additional-variables 'corfu-history)))

(use-package dired
  :ensure nil ; default
  :commands (dired)
  :hook
  ((dired-mode . hl-line-mode))
  :config
  (setq dired-recursive-copies 'always)
  (setq dired-recursive-deletes 'always)
  (setq delete-by-moving-to-trash t)
  (setq dired-dwim-target t))

(use-package dired-subtree
  :ensure t
  :after dired
  :bind
  ( :map dired-mode-map
    ("<tab>" . dired-subtree-toggle)
    ("TAB" . dired-subtree-toggle)
    ("<backtab>" . dired-subtree-remove)
    ("S-TAB" . dired-subtree-remove))
  :config
  (setq dired-subtree-use-backgrounds nil))

(use-package trashed
  :ensure t
  :commands (trashed)
  :config
  (setq trashed-action-confirmer 'y-or-n-p)
  (setq trashed-use-header-line t)
  (setq trashed-sort-key '("Date deleted" . t))
  (setq trashed-date-format "%Y-%m-%d %H:%M:%S"))

;; my own configs, starting here

;; rebind other-window (C-x o) to M-o for convenience
(global-set-key (kbd "M-o") 'other-window)
;; rebind C-x C-b to buffer-menu so that I can select buffer in current window
(global-set-key (kbd "C-x C-b") 'buffer-menu)
;; install magit
(use-package magit
  :ensure t
  :bind
  (("C-x g" . magit-status)))

;; nov.el
(use-package nov
  :ensure t)

;; For org mode, hl-todo and org-modern
(use-package hl-todo
  :ensure t)
(use-package org-modern
  :ensure t
  :custom
  (org-modern-hide-stars nil)
  (org-modern-table nil)
   (org-modern-list 
   '(;; (?- . "-")
     (?* . "•")
     (?+ . "‣")))
  :hook
  (org-mode . org-modern-mode)
  (org-agenda-finalize . org-modern-agenda))
(setq
 org-auto-align-tags nil
 org-tags-column 0
 org-catch-invisible-edits 'show-and-error
 org-special-ctrl-a/e t
 org-insert-heading-respect-content t
 org-hide-emphasis-markers t
 org-pretty-entities t
 org-agent-tags-column 0
 org-ellipsis "..."
 org-startup-indented t
 ;; do not add newlines before entries 
 org-black-before-new-entry '((heading . nil) (plain-list-item . nil)))
;; org-modern-indent for nice indentation w/ org-modern
(use-package org-modern-indent
  :straight (org-modern-indent :type git :host github :repo "jdtsmith/org-modern-indent")
  :config
  (add-hook 'org-mode-hook #'org-modern-indent-mode 90))

;; org-mode configs
;; https://github.com/james-stoup/emacs-org-mode-tutorial, does not implement all of that.
;; org states
(setq org-capture-templates
      '(
	("n" "Note"
	 entry (file+headline "~/Documents/notes/random.org" "Random Thoughts")
	 "** %?"
	 :empty-lines 0)
	("g" "General TODO"
	 entry (file+headline "~/Documents/notes/todos.org" "General TODOs")
	 "* TODO [#B] %?\n:Created: %T\n "
	 :empty-lines 0)
	("c" "Content-specific TODO"
	 entry (file+headline "~/Documents/notes/todos.org" "Content-Specific TODOs")
	 "* TODO [#B] %?\n:Created: %T\n%i\n%a\nCommentary: "
	 :empty-lines 0)
	 )
      org-todo-keywords
	'(
	  (sequence "TODO(t)" "PLANNING(p)" "IN-PROGRESS(i@/!)" "VERIFYING(v!)" "BLOCKED(b@)" "|" "DONE(d!)" "RIP(r@/!)"))
	)

;; auto-mode config
(add-to-list 'auto-mode-alist '(
				"\\.epub\\'" . nov-mode))

;; instead of suffering at the hands of my own theme attempts, use the beautiful (to me) standard-themes
(use-package standard-themes
  :ensure t)
(mapc #'disable-theme custom-enabled-themes)
(set-face-attribute 'default nil :family "JuliaMono" :height 135 :weight 'light)
(setq standard-themes-bold-constructs t
      standard-dark-tinted-palette-overrides
      '((bg-main "#44355B") ;original is #182440
	))
(load-theme 'standard-dark-tinted :no-confirm)

;; TRAMP-related; https://coredumped.dev/2025/06/18/making-tramp-go-brrrr./
(setq remote-file-name-inhibit-locks t
      tramp-use-scp-direct-remote-copying t
      remote-file-name-inhibit-auto-save t
      tramp-copy-size-limit (* 1024 1024) ;; 1MB
      tramp-verbose 2)

(connection-local-set-profile-variables
 'remote-direct-async-process
 '((tramp-direct-async-process . t)))

(connection-local-set-profiles
 '(:application tramp :protocol "scp")
 'remote-direct-async-process)

(setq magit-tramp-pipe-stty-settings 'pty)

(with-eval-after-load 'tramp
  (with-eval-after-load 'compile
    (remove-hook 'compilation-mode-hook #'tramp-compile-disable-ssh-controlmaster-options)))

;; Start in fullscreen :bless:
(add-hook 'window-setup-hook #'toggle-frame-fullscreen)
