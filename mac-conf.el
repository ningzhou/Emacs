;;-------------------------------------------------------------------
;; Copyright (C) 2013 Ning Zhou
;; File : mac-conf.el
;; Author : Ning Zhou <nzhoun@gmail.com>
;; Description :
;; --
;; Created : <2014-05-12>
;; Updated: Time-stamp: <2014-05-26 13:59:57>
;;-------------------------------------------------------------------
;; File : mac-conf.el ends
(setq mac-option-modifier-is-meta nil
      mac-command-key-is-meta t
      mac-command-modifier 'meta
      mac-right-option-modifier 'control)

;;(setq mac-command-modifier 'meta) 
;; (setq mac-left-option-modifier 'super)
;; (setq mac-right-option-modifier 'control)
;; Enable mouse support
;; (unless window-system
;;   (require 'mouse)
;;   (xterm-mouse-mode t)
;;   (global-set-key [mouse-4] '(lambda ()
;;                               (interactive)
;;                               (scroll-down 1)))
;;   (global-set-key [mouse-5] '(lambda ()
;;                               (interactive)
;;                               (scroll-up 1)))
;;   (defun track-mouse (e))
;;   (setq mouse-sel-mode t)
;; )
;;(global-set-key [wheel-up] 'previous-line)
;;(global-set-key [wheel-down] 'next-line)
(setq ring-bell-function 'ignore)

