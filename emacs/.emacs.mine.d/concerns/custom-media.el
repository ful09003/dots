;;; custom-media.el --- Packages+config for media -*- lexical-binding: t -*-

;;; Commentary:
;;
;; https://github.com/isamert/empv.el

(use-package empv
  :ensure t
  :bind-keymap ("C-x m" . empv-map)
  :custom
  (empv-radio-channels
	  '(("Eden Radio" . "https://www.edenofthewest.com/public/eden-radio/playlist.pls")
	    ("SomaFM - Groove Salad" . "http://www.somafm.com/groovesalad.pls")
 ("SomaFM - Drone Zone" . "http://www.somafm.com/dronezone.pls")
 ("SomaFM - Sonic Universe" . "https://somafm.com/sonicuniverse.pls")
 ("SomaFM - Metal" . "https://somafm.com/metal.pls")
 ("SomaFM - Vaporwaves" . "https://somafm.com/vaporwaves.pls")
	    )))

(provide 'custom-media)
