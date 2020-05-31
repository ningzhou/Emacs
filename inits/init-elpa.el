;;-------------------------------------------------------------------
;; \file init-elpa.el
;; \brief copied from https://github.com/redguardtoo/emacs.d
;; \author Ning Zhou 
;; \date  <2014-12-07>
;; \update Time-stamp: <2020-05-31 01:05:27>
;;-------------------------------------------------------------------

;;getting started guide from the official websit  
(require 'package)
(let* ((no-ssl (and (memq system-type '(windows-nt ms-dos))
                    (not (gnutls-available-p))))
       (proto (if no-ssl "http" "https")))
  (when no-ssl (warn "\
Your version of Emacs does not support SSL connections,
which is unsafe because it allows man-in-the-middle attacks.
There are two things you can do about this warning:
1. Install an Emacs version that does support SSL and be safe.
2. Remove this warning from your init file so you won't see it again."))
  (add-to-list 'package-archives (cons "melpa" (concat proto "://melpa.org/packages/")) t)
  ;; Comment/uncomment this line to enable MELPA Stable if desired.  See `package-archive-priorities`
  ;; and `package-pinned-packages`. Most users will not need or want to do this.
  ;;(add-to-list 'package-archives (cons "melpa-stable" (concat proto "://stable.melpa.org/packages/")) t)
  )
(package-initialize)


(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/") t)

(when (< emacs-major-version 24) ;; For important compatibility libraries like cl-lib
  (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))


(defun my-initialize-package ()
  (unless nil ;package--initialized
    ;; optimization, no need to activate all the packages so early
    (setq package-enable-at-startup nil)
    (package-initialize)))

;;(my-initialize-package)

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


;; On-demand installation of packages
(defun require-package (package &optional min-version no-refresh)
  "Ask elpa to install given PACKAGE."
  (cond
   ((package-installed-p package min-version)
    t)
   ((or (assoc package package-archive-contents) no-refresh)
    (package-install package))
   (t
    (package-refresh-contents)
    (require-package package min-version t))))



;; Make sure to have downloaded archive description. 
;; Or use package-archive-contents as suggested by Nicolas Dudebout
;;(or (file-exists-p package-user-dir)
    ;;(package-refresh-contents))


;;(ensure-package-installed 'iedit 'magit 'smart-mode-line 'smex 'highlight-symbol 'loccur 'color-moccur 'yasnippet 'exec-path-from-shell 'undo-tree 'company) 
;; => (nil nil) if iedit and magit are already installed
(require-package 'iedit)
(require-package 'magit)
(require-package 'smart-mode-line)
(require-package 'smex)
(require-package 'highlight-symbol)
(require-package 'loccur)
(require-package 'color-moccur)
(require-package 'cl)
(require-package 'yasnippet)
(require-package 'exec-path-from-shell)
(require-package 'company)
(require-package 'undo-tree)
(require-package 'flx-ido)
(require-package 'ido-completing-read+)
(require-package 'dockerfile-mode)
(require-package 'company-statistics)
(require-package 'google-c-style)
(require-package 'matlab-mode)

(require-package 'evil)
(require-package 'evil-escape)
(require-package 'evil-leader)
(require-package 'evil-exchange)
(require-package 'evil-find-char-pinyin)
(require-package 'evil-mark-replace)
(require-package 'evil-matchit)
(require-package 'evil-nerd-commenter)
(require-package 'evil-surround)
(require-package 'evil-visualstar)
(require-package 'evil-lion)
(require-package 'evil-args)
(require-package 'evil-textobj-syntax)

(provide 'init-elpa)
