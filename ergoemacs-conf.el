;;-------------------------------------------------------------------
;; Copyright (C) 2013 Ning Zhou
;; File : ergoemacs-conf.el
;; Author : Ning Zhou <nzhoun@gmail.com>
;; Description :
;; --
;; Created : <2013-08-27>
;; Updated: Time-stamp: <2013-08-28 10:48:14>
;;-------------------------------------------------------------------
;; File : ergoemacs-conf.el ends

(add-to-list 'load-path (concat EMACS_VENDOR "/ergoemacs-mode"))
(setq ergoemacs-theme nil)
(setq ergoemacs-keyboard-layout "us")
(setq ergoemacs-ignore-prev-global nil)
(require 'ergoemacs-mode)
(ergoemacs-mode 1)

