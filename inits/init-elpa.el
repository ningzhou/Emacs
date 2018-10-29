;;-------------------------------------------------------------------
;; \file init-elpa.el
;; \brief copied from https://github.com/redguardtoo/emacs.d
;; \author Ning Zhou 
;; \date  <2014-12-07>
;; \update Time-stamp: <2018-10-26 16:17:40>
;;-------------------------------------------------------------------

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

(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/") t)

(when (< emacs-major-version 24) ;; For important compatibility libraries like cl-lib
  (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))

;; Make sure to have downloaded archive description. 
;; Or use package-archive-contents as suggested by Nicolas Dudebout
(or (file-exists-p package-user-dir)
    (package-refresh-contents))

;; activate all the packages (in particular autoloads)
(package-initialize)

(ensure-package-installed 'iedit 'magit 'smart-mode-line 'smex 'highlight-symbol 'loccur 'color-moccur 'yasnippet 'exec-path-from-shell 'undo-tree 'company) 
;; => (nil nil) if iedit and magit are already installed

(provide 'init-elpa)
