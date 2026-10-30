;;; custom-media.el --- Packages+config for media -*- lexical-binding: t -*-

;;; Commentary:
;;
;; https://github.com/isamert/empv.el

(use-package empv
  :ensure t
  :bind-keymap ("C-x m" . empv-map)
  :custom
  (empv-radio-channels
	  '(("313.FM - Detroit" . "http://icecast.ofdoom.com:8000/burst.mp3")
	    ("KEXP - Seattle" . "https://kexp.streamguys1.com/kexp160.aac")
	    ("SomaFM - Drone Zone" . "http://www.somafm.com/dronezone.pls")
	    ("SomaFM - Fluid" . "https://somafm.com/fluid.pls")
	    ("SomaFM - Groove Salad" . "http://www.somafm.com/groovesalad.pls")
	    ("SomaFM - Metal" . "https://somafm.com/metal.pls")
	    ("SomaFM - Sonic Universe" . "https://somafm.com/sonicuniverse.pls")
	    ("SomaFM - Vaporwaves" . "https://somafm.com/vaporwaves.pls")
	    ("SomaFM - n5md" . "https://somafm.com/n5md.pls")
	    ("nightride -  HORRORSYNTH FM" . "https://stream.nightride.fm/horrorsynth.mp3")
	    ("nightride - CHILLSYNTH FM" . "https://stream.nightride.fm/chillsynth.mp3")
	    ("nightride - DATAWAVE FM" . "https://stream.nightride.fm/datawave.mp3")
	    ("nts.live" . "https://stream-relay-geo.ntslive.net/stream?client=direct")
	    ("Eden Radio" . "https://www.edenofthewest.com/public/eden-radio/playlist.pls"))))

(provide 'custom-media)
