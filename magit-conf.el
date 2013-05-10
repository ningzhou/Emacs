;;-------------------------------------------------------------------
;; @copyright 2013 Ning Zhou
;; File : magit-conf.el
;; Author : Ning Zhou <nzhoun@gmail.com>
;; Description :
;; --
;; Created : <2013-05-10>
;; Updated: Time-stamp: <2013-05-10 01:20:29>
;;-------------------------------------------------------------------
;; File : magit-conf.el ends


(add-to-list 'load-path (concat EMACS_VENDOR "/magit-1.2.0"))
(require 'magit)
(global-set-key (kbd "C-x g") 'magit-status)
;;; magit_conf.el ends here
