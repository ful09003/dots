;;; ide.el --- LSP/IDE-type config -*- lexical-binding: t -*-

;;; Commentary:
;;
;;  - https://emacs-lsp.github.io/lsp-mode/page/installation/ attempt to use
;; 	Eglot instead.


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
