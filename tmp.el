;;-------------------------------------------------------------------
;; @copyright 2013 Ning Zhou
;; File : tmp.el
;; Author : Ning Zhou <nzhoun@gmail.com>
;; Description :
;; --
;; Created : <2013-05-11>
;; Updated: Time-stamp: <2013-08-26 00:07:55>
;;-------------------------------------------------------------------
;; File : tmp.el ends

;; try using ergoemac mode by 
(add-to-list 'load-path (concat EMACS_VENDOR "/ergoemacs-mode"))
(require 'ergoemacs-mode)
(setq ergoemacs-theme "lvl3")
(setq ergoemacs-keyboard-layout "us")
(ergoemacs-mode 1)
