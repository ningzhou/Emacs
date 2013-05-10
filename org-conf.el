;;-------------------------------------------------------------------
;; @copyright 2013 Ning Zhou
;; File : org-conf.el
;; Author : Ning Zhou <nzhoun@gmail.com>
;; Description :
;; --
;; Created : <2013-05-10>
;; Updated: Time-stamp: <2013-05-10 01:20:53>
;;-------------------------------------------------------------------
;; File : org-conf.el ends

(require 'org-install)
(require 'org)
(add-to-list 'auto-mode-alist '("\\.org$" . org-mode))
;;setup the global key 
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-cc" 'org-capture)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cb" 'org-iswitchb)
(global-set-key (kbd "<f8> p") 'org-publish)
;;===========add timestamp====================
(setq org-log-done t)
;; add org-agenda files
;;(add-to-list 'org-agenda-files "~/test.org")
(dolist (org-agenda-file-var (list
                              (concat NZHOU_DATA "/org_data/current.org")
                              (concat NZHOU_DATA "/org_data/wish.org")
                              (concat NZHOU_DATA "/org_data/learn.org")
                              (concat NZHOU_DATA "/org_data/research.org")
                              ))
(add-to-list 'org-agenda-files org-agenda-file-var))
;;write diary in org-mode
;;(setq org-agenda-diary-file (concat NZHOU_DATA "/org_data/diary"))

(setq diary-file (concat NZHOU_DATA "/nzhou.diary"))
;;to include entries from the Emacs diary into Org mode's agenda, customize the variable
(setq org-agenda-include-diary t) 
