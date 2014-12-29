;;-------------------------------------------------------------------
;; Copyright (C) 2013 Ning Zhou
;; File : packages-conf.el
;; Author : Ning Zhou <nzhoun@gmail.com>
;; Description :
;; --
;; Created : <2014-12-27>
;; Updated: Time-stamp: <2014-12-29 00:11:05>
;;-------------------------------------------------------------------
;; File : packages-conf.el ends
(require 'package)

(defun ensure-package-installed (&rest packages)
  "Make sure that very package is installed; ask for installation if not.
   Return a list of installed packages or nil for every skipped package"
  (mapcar 
   (lambda (pkg)
     (if (package-installed-p pkg)
         nil
       (package-install pkg)
       ))
   packages))

(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t)
(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/") t)
(when (< emacs-major-version 24) ;; For important compatibility libraries like cl-lib
  (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))


;; make sure to have downloaded archive description. 
;; Or use package-archive-contents as suggested by Nicolas Dudebout
(or (file-exists-p package-user-dir)
    (package-refresh-contents))

;; activate all the packages (in particular autoloads)
(package-initialize)

(ensure-package-installed 'iedit 'magit 'zenburn-theme 'highlight-symbol 'loccur 'color-moccur 'hide-region 'elscreen 'google-c-style 'hide-region 'winpoint 'yasnippet) 
;; => (nil nil) if iedit and magit are already installed

;; File: packages-conf.el ends here
