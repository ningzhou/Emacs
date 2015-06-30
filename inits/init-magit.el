;;-------------------------------------------------------------------
;; @copyright 2013 Ning Zhou
;; File : init-magit.el
;; Author : Ning Zhou <nzhoun@gmail.com>
;; Description :
;; --
;; Created : <2013-05-10>
;; Updated: Time-stamp: <2015-06-28 22:26:21>
;;-------------------------------------------------------------------
;; File : init-magit.el ends

(require 'magit)
(global-set-key (kbd "C-x g") 'magit-status)
(setq magit-last-seen-setup-instructions "1.4.0")

(provide 'init-magit)
;;; init-magit.el ends here
