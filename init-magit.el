;;-------------------------------------------------------------------
;; @copyright 2013 Ning Zhou
;; File : init-magit.el
;; Author : Ning Zhou <nzhoun@gmail.com>
;; Description :
;; --
;; Created : <2013-05-10>
;; Updated: Time-stamp: <2015-06-26 15:33:49>
;;-------------------------------------------------------------------
;; File : init-magit.el ends

(require 'magit)
(global-set-key (kbd "C-x g") 'magit-status)
(setq magit-last-seen-setup-instructions "1.4.0")
;;; magit_conf.el ends here
