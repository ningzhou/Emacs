;;-------------------------------------------------------------------
;; Copyright (C) 2013 Ning Zhou
;; File : mac-conf.el
;; Author : Ning Zhou <nzhoun@gmail.com>
;; Description :
;; --
;; Created : <2014-05-12>
;; Updated: Time-stamp: <2014-12-29 01:00:57>
;;-------------------------------------------------------------------
;; File : mac-conf.el ends
(setq mac-option-modifier-is-meta nil
      mac-command-key-is-meta t
      mac-command-modifier 'meta
      mac-right-option-modifier 'control)

(setq ring-bell-function 'ignore)

;;(setq exec-path (append exec-path '("/usr/local/bin")))
(when (memq window-system '(mac ns))
  (exec-path-from-shell-initialize))

