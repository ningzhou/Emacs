;;-------------------------------------------------------------------
;; Copyright (C) 2013 Ning Zhou
;; File : init-osx.el
;; Author : Ning Zhou <nzhoun@gmail.com>
;; Description :
;; --
;; Created : <2014-05-12>
;; Updated: Time-stamp: <2017-12-05 17:43:53>
;;-------------------------------------------------------------------
;; File : init-osx.el ends
(setq mac-option-modifier-is-meta nil
      mac-command-key-is-meta t
      mac-command-modifier 'meta
      mac-right-option-modifier 'control)

(setq ring-bell-function 'ignore)
;;(setq mouse-wheel-scroll-amount '(0.001))

;;(setq exec-path (append exec-path '("/usr/local/bin")))

(provide 'init-osx)
