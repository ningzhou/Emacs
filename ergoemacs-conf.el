;;-------------------------------------------------------------------
;; Copyright (C) 2013 Ning Zhou
;; File : ergoemacs-conf.el
;; Author : Ning Zhou <nzhoun@gmail.com>
;; Description :
;; --
;; Created : <2013-08-27>
;; Updated: Time-stamp: <2014-01-04 11:35:04>
;;-------------------------------------------------------------------
;; File : ergoemacs-conf.el ends

(add-to-list 'load-path (concat EMACS_VENDOR "/ergoemacs-mode"))
(setq ergoemacs-theme nil)
(setq ergoemacs-keyboard-layout "us")
(setq ergoemacs-ignore-prev-global nil)
(require 'ergoemacs-mode)
(ergoemacs-mode 1)

;; bind some global keys for convenience
;; (global-set-key (kbd "C-l") 'recenter)
(ergoemacs-key "C-l" 'recenter "recenter")

