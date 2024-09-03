;; MELPA
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
;; Comment/uncomment this line to enable MELPA Stable if desired.  See `package-archive-priorities`
;; and `package-pinned-packages`. Most users will not need or want to do this.
;;(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(package-initialize)

;; Use ibuffer
(global-set-key [remap list-buffers] 'ibuffer)
;; bind C-x o to M-o
(global-set-key (kbd "M-o") 'other-window)


;; File type associations w/ mode
;; https://depp.brause.cc/nov.el/
(add-to-list 'auto-mode-alist '("\\.epub\\'" . nov-mode))

;; https://emacs-lsp.github.io/lsp-mode/page/installation/
(require 'lsp-mode)
(add-hook 'go-mode-hook #'lsp-deferred)


(defun lsp-go-install-save-hooks ()
  (add-hook 'before-save-hook #'lsp-format-buffer t t)
  (add-hook 'before-save-hook #'lsp-organize-imports t t))
(add-hook 'go-mode-hook #'lsp-go-install-save-hooks)
(add-hook 'go-mode-hook #'yas-minor-mode)

;; https://www.gnu.org/software/emacs/manual/html_node/emacs/Saving-Customizations.html
(setq custom-file (concat user-emacs-directory "custom.el"))
(load custom-file 'noerror)
