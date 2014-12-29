;;-------------------------------------------------------------------
;; Copyright (C) 2013 Ning Zhou
;; File : ergoemacs-conf.el
;; Author : Ning Zhou <nzhoun@gmail.com>
;; Description :
;; --
;; Created : <2013-08-27>
;; Updated: Time-stamp: <2014-12-28 22:33:08>
;;-------------------------------------------------------------------
;; File : ergoemacs-conf.el ends

(add-to-list 'load-path (concat EMACS_VENDOR "/ergoemacs-mode"))
;;package from elpa seems not working very well
(require 'ergoemacs-mode) 
(setq ergoemacs-theme nil)
(setq ergoemacs-keyboard-layout "us")
(setq ergoemacs-ignore-prev-global nil)
;;(require 'ergoemacs-mode)
(ergoemacs-mode 1)

;; bind some global keys for convenience
(ergoemacs-key "C-l" 'recenter "recenter")
(ergoemacs-key "M-g" 'goto-line "goto-line")
(ergoemacs-key "C-k" 'kill-visual-line "kill-visual-line")
(ergoemacs-key "C-j" 'webjump)
