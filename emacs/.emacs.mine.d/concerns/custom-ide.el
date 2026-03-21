;;; custom-ide.el --- LSP/IDE-type config -*- lexical-binding: t -*-

;;; Commentary:
;;
;; NOTE:
;;   https://www.gnu.org/software/emacs/manual/html_mono/eglot.html#Starting-Eglot
;;     Invoke eglot in expected buffers/projects, maybe in the future w/ major mode
;;     activation but this is called out in the manual as a gamble.
;; NOTE:
;;   https://go.dev/gopls/editor/emacs#configuring-eglot
;;   https://gitlab.com/magus/mes/-/blob/main/lisp/

(require 'project)
(defun project-find-go-module (dir)
  (when-let ((root (locate-dominating-file dir "go.mod")))
    (cons 'go-module root)))

(cl-defmethod project-root ((project (head go-module)))
  (cdr project))

(add-hook 'project-find-functions #'project-find-go-module)

;; Optional: packages to load before eglot for enabling eglot integration
(use-package company
  :ensure t
  :config
  (add-hook 'after-init-hook 'global-company-mode))
(use-package yasnippet
  :ensure t
  :init
  (yas-global-mode 1))

;; languages
(use-package go-ts-mode
  :ensure nil
  :after treesit
  :hook
  (go-ts-mode . eglot-ensure)
  (go-ts-mode . (lambda()
		  (add-hook 'before-save-hook #'eglot-format-buffer t t)
		  (add-hook 'before-save-hook #'eglot-code-action-organize-imports t t)))
  :init
  (add-to-list 'treesit-language-source-alist '(go "https://github.com/tree-sitter/tree-sitter-go"))
  (add-to-list 'treesit-language-source-alist '(gomod "https://github.com/camdencheek/tree-sitter-go-mod"))
  ;; (dolist (lang '(go gomod)) (treesit-install-language-grammar lang))
  (add-to-list 'auto-mode-alist '("\\.go\\'" . go-ts-mode))
  (add-to-list 'auto-mode-alist '("/go\\.mod\\'" . go-mod-ts-mode))
  :config
  (reformatter-define go-format
		      :program "goimports"
		      :args '("/dev/stdin")))

(use-package eglot
  :ensure t
  :custom
  (eglot-autoshutdown t))

(provide 'custom-ide)

;;; ide.el ends here

;;(require 'lsp-mode)
;;(use-package lsp-mode
;;  :ensure t
;;  :defer t
;;  :hook (
;;	 (go-mode . lsp)
;;	 (lsp-mode . lsp-enable-which-key-integration))
;;  :bind-keymap  ("C-c l" . lsp-command-map)
;;  :bind (:map lsp-mode-map)
;;  :commands lsp)
;;
;;;; optional LSP/IDE-type things
;;;; https://emacs-lsp.github.io/lsp-mode/page/installation/
;;(use-package yasnippet
;;  :ensure t
;;  :init
;;  (yas-global-mode 1))
;;(use-package lsp-ui
;;  :ensure t
;;  :commands lsp-ui-mode)
;;(use-package lsp-treemacs
;;  :ensure t
;;  :commands lsp-treemacs-errors-list)
;;(use-package company
;;  :ensure t
;;  :config
;;  (add-hook 'after-init-hook 'global-company-mode))
;;(use-package dap-mode
;;  :ensure t
;;  :config
;;  (require 'dap-dlv-go))
;;;;(use-package dap-dlv-go
;;;;  :ensure t)
;;(require 'dap-dlv-go)
;;(use-package flycheck
;;  :ensure t
;;  :config
;;  (add-hook 'after-init-hook #'global-flycheck-mode))
;;(use-package which-key
;;  :ensure t
;;  :config
;;  (which-key-mode))
;;
;;;; language-specific configs
;;;; golang (https://go.dev/gopls/editor/emacs)
;;(add-hook 'go-mode-hook #'lsp-deferred)
;;(defun lsp-go-install-save-hooks ()
;;  (add-hook 'before-save-hook #'lsp-format-buffer t t)
;;  (add-hook 'before-save-hook #'lsp-organize-imports t t))
;;(add-hook 'go-mode-hook #'lsp-go-install-save-hooks)
;;(lsp-register-custom-settings
;; '(("gopls.completeUnimported" t t)
;;   ("gopls.staticcheck" t t)))
