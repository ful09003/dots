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
  :ensure nil
  :hook (after-init . delete-selection-mode))

(defun prot/keyboard-quit-dwim ()
  "Do-What-I-Mean behavior for `keyboard-quit'.

- When region active: deactivate it
- When minibuffer is open (but not focused): close it
- When Completions buffer is selected: close it
- Otherwise: standard `keyboard-quit'"
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

;; Disable UI clutter
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
  :hook (dired-mode . nerd-icons-dired-mode))

(use-package vertico
  :ensure t
  :hook (after-init . vertico-mode))

(use-package marginalia
  :ensure t
  :hook (after-init . marginalia-mode))

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
  ;; Tab key triggers completion only when in minibuffer/completion context
  (setq tab-always-indent nil)
  (setq corfu-preview-current nil)
  (setq corfu-min-width 20)
  (setq corfu-popupinfo-delay '(1.24 . 0.5))
  (corfu-popupinfo-mode 1)

  ;; Sort by history
  (with-eval-after-load 'savehist
    (corfu-history-mode 1)
    (add-to-list 'savehist-additional-variables 'corfu-history)))

(use-package savehist
  :ensure nil
  :hook (after-init . savehist-mode))

;;; Dired & friends
(use-package dired
  :ensure nil
  :commands (dired)
  :hook (dired-mode . hl-line-mode)
  :config
  (setq dired-recursive-copies 'always)
  (setq dired-recursive-deletes 'always)
  (setq delete-by-moving-to-trash t)
  (setq dired-dwim-target t))

(use-package dired-subtree
  :ensure t
  :after dired
  :bind (:map dired-mode-map
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

;;; Custom keybindings
(global-set-key (kbd "M-o") #'other-window)
(global-set-key (kbd "C-x C-b") #'buffer-menu)

;;; Git
(use-package magit
  :ensure t
  :bind (("C-x g" . magit-status)))

;;; EPUB reader
(use-package nov
  :ensure t
  :config
  (add-to-list 'auto-mode-alist '("\\.epub\\'" . nov-mode)))

;;; Org mode
(use-package hl-todo
  :ensure t)

(use-package org-modern
  :ensure t
  :custom
  (org-modern-hide-stars nil)
  (org-modern-table nil)
  (org-modern-list '(;; (?- . "-")
                     (?* . "•")
                     (?+ . "‣")))
  :hook
  (org-mode . org-modern-mode)
  (org-agenda-finalize . org-modern-agenda))

(use-package org-modern-indent
  :straight (org-modern-indent :type git :host github :repo "jdtsmith/org-modern-indent")
  :config
  (add-hook 'org-mode-hook #'org-modern-indent-mode 90))

;; Org settings
(setq
 ;; Display & Editing
 org-auto-align-tags nil
 org-tags-column 0
 org-catch-invisible-edits 'show-and-error
 org-special-ctrl-a/e t
 org-insert-heading-respect-content t
 org-hide-emphasis-markers t
 org-pretty-entities t
 org-ellipsis "..."
 org-startup-indented t
 org-blank-before-new-entry '((heading . nil) (plain-list-item . nil))

 ;; TODO states
 org-todo-keywords
 '((sequence "TODO(t)" "PLANNING(p)" "IN-PROGRESS(i@/!)" "VERIFYING(v!)" "BLOCKED(b@)"
            "|" "DONE(d!)" "RIP(r@/!)"))

 ;; Capture templates
 org-capture-templates
 '(("n" "Note" entry (file+headline "~/Documents/notes/random.org" "Random Thoughts")
    "** %?" :empty-lines 0)
   ("g" "General TODO" entry (file+headline "~/Documents/notes/todos.org" "General TODOs")
    "* TODO [#B] %?\n:Created: %T\n" :empty-lines 0)
   ("c" "Content-specific TODO" entry (file+headline "~/Documents/notes/todos.org" "Content-Specific TODOs")
    "* TODO [#B] %?\n:Created: %T\n%i\n%a\nCommentary: " :empty-lines 0)))

;;; Theme
(use-package catppuccin-theme
  :ensure t)

(set-face-attribute 'default nil :family "JuliaMono" :height 130 :weight 'light)
(setq catppuccin-flavor 'frappe)
(load-theme 'catppuccin :no-confirm)

;;; TRAMP performance tuning
(with-eval-after-load 'tramp
  (setq tramp-copy-size-limit (* 1024 1024)  ; 1 MB
        tramp-verbose 2
        tramp-use-scp-direct-remote-copying t
        remote-file-name-inhibit-locks t
        remote-file-name-inhibit-auto-save t)

  ;; Enable direct async processes where available (Emacs ≥29)
  (when (boundp 'tramp-direct-async-process)
    (connection-local-set-profile-variables
     'remote-direct-async-process
     '((tramp-direct-async-process . t)))

    (connection-local-set-profiles
     '(:application tramp :protocol "scp")
     'remote-direct-async-process))

  ;; Disable SSH control master options for compile (avoids hangs)
  (with-eval-after-load 'compile
    (remove-hook 'compilation-mode-hook #'tramp-compile-disable-ssh-controlmaster-options)))

(setq magit-tramp-pipe-stty-settings 'pty)

;;; Fullscreen on startup
(add-hook 'window-setup-hook #'toggle-frame-fullscreen)

;;; LLM / Ellama
(use-package ellama
  :ensure t
  :bind ("C-c e" . ellama)
  :hook (org-ctrl-c-ctrl-c-final . ellama-chat-send-last-message)
  :init
  (require 'llm-openai)
  (setopt ellama-user-nick "meatsack")
  (setopt ellama-assistant-nick "botto")
  (setopt ellama-keymap-prefix "C-c e")
  (setopt ellama-provider
          (make-llm-openai-compatible
           :url "http://smookerton.lan:8000/api/v1"
           :chat-model "Qwen3-Coder-Next-GGUF"
           :key "butts"
           :default-chat-non-standard-params '(("num_ctx" . 8192))))
  (setopt ellama-chat-display-action-function #'display-buffer-full-frame)
  (setopt ellama-instant-display-action-function #'display-buffer-at-bottom)
  :config
  (ellama-context-header-line-global-mode +1)
  (ellama-session-header-line-global-mode +1)

  ;; Scrolling fixes — guard against missing functions
  (when (boundp 'pixel-scroll-precision-mode)
    (advice-add 'pixel-scroll-precision :before #'ellama-disable-scroll))
  (advice-add 'end-of-buffer :after #'ellama-enable-scroll))