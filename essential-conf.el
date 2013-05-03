;;; essential-conf.el --- The essential configuration for my emacs without using any third-party packages

;; Copyright (C) 2013  ning

;; Author: ning <ning@laptop>
;; Keywords: 

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; 

;;; Code:

;;--------------------set font and font size--------------------
(set-default-font "DejaVu Sans Mono")
(set-face-attribute 'default nil :height 108)

(setq x-select-enable-clipboard t) ;;support copy/paste among emacs and other programs
(tool-bar-mode -1)  ;; get rid of the tool bar
(scroll-bar-mode -1) ;;get rid of the scroll bar
(show-paren-mode t) 
(setq show-paren-style 'parentheses)
(setq scroll-margin 3
      scroll-conservatively 10000)
(setq-default fill-column 70)
(setq default-major-mode 'text-mode
      column-number-mode t ;;show column number
      line-number-mode 1   ;;show line number in mode line
      save-abbrevs nil
      line-spacing 0.2
      indicate-empty-lines t
      )
;;(global-visual-line-mode 1)   ;;enable lines soft wrapped at word boundary

;;---------------------generic-mode ----------------------------
(require 'generic-x)
(transient-mark-mode t)
;;--------------------display the full path of the buffer -----------------------
(setq frame-title-format
      (list (format "%s %%S: %%j " (system-name))
        '(buffer-file-name "%f" (dired-directory dired-directory "%b"))))
;;--------------------maximize the frame when get started-----------------------
(defun my-maximized ()
      (interactive)
      (x-send-client-message nil 0 nil "_NET_WM_STATE" 32
     '(2 "_NET_WM_STATE_MAXIMIZED_HORZ" 0))
      (x-send-client-message
       nil 0 nil "_NET_WM_STATE" 32
      '(2 "_NET_WM_STATE_MAXIMIZED_VERT" 0)))
;; call the function
(my-maximized)

;;--------------------open the direcotry associated with current buffer using explored----------
(defun open-folder-in-explorer ()
     "Call when editing a file in a buffer. Open windows explorer in the current directory"
     (interactive)
     (shell-command-to-string (concat "nautilus --browser " default-directory)))
(global-set-key [(control x)(control d)] 'open-folder-in-explorer)

;;--------------------make Emacs your choice of image viewer--------------------
(autoload 'thumbs "thumbs" "Preview images in a directory." t)
;;if split-width-threshold is smaller than the window's width, the split puts the new window on the right. 
(set-default 'split-width-threshold 165)
(set-default 'text-scale-mode-step 1.1) ;;set the zoom rate
(iswitchb-mode 1)      ;;interactive buffer switching
(setq undo-limit 1000) ;;Increase number of undo
(setq kill-do-not-save-duplicates t)
;;(blink-cursor-mode 0)  ;;prevent cursor blinking
(size-indication-mode t)
(setq redisplay-dont-pause t)
(setq tooltip-use-echo-area t)
(setq byte-compile-dynamic t)
;; adjust emacs behaviour with normal editor, if selecting region then type
(delete-selection-mode t)
(put 'delete-char 'delete-selection 'kill) ;; TODO: what's effect? 
;; --------------------enable fancy features of emacs--------------------
(put 'narrow-to-region 'disabled nil);;enable narraow editing
(put 'upcase-region 'disabled nil) 
(put 'downcase-region 'disabled nil)
(put 'eval-expression 'disabled nil)
;;--------------------specify coding system when creating a new file----------
(set-default-coding-systems 'utf-8-unix)
(set-face-attribute 'mode-line nil :height 0.9) ;;Make the mode-line a little lower
(setq display-time-interval 60) ;;update of time in the mode line
(auto-compression-mode 1) ;; auto depress, when opening archived files
(setq enable-recursive-minibuffers t) ;;allow minibuffer commands while in the minibuffer
;;If resize-mini-windows is t, the window is always resized to fit the size of the text it displays. 
(setq resize-mini-windows t) 
(setq isearch-allow-scroll t) ;;enable scrolling during incremental search
(setq-default ispell-program-name "aspell")
;; TODO: set up the personal dictionary 
;; (setq ispell-personal-dictionary
;;       (concat DENNY_CONF "emacs_data/filebat.ispell_english"))
;;--------------------enable Emacs to open graphic files such as JPEG or PNG format files----------
(auto-image-file-mode t)
(defvar readonly-mode-list '("Image[jpeg]" "Image[gif]"))
(setq message-log-max 8192) ;; Set the *Message* log to something higher
(when (fboundp 'winner-mode) (winner-mode 1)) ;;restore old window configurations
(setq trash-directory "~/trash"
      ;; When deletion in emacs, uses system’s trash
      delete-by-moving-to-trash t)
;;--------------------define alias------------------------------
(defalias 'qrr 'query-replace-regexp);;regexp query and replace
(defalias 'rr 'replace-regexp)
(defalias 'yes-or-no-p 'y-or-n-p)

;;--------------------never hide by mistake--------------------
(global-set-key [(control x) (control z)]
                (function
                 (lambda () (interactive)
                   (cond ((y-or-n-p "Hide editor? ")
                          (iconify-or-deiconify-frame))))))
;;--------------------bind global keys--------------------
(global-set-key [f1] 'describe-function) ;;elisp help
;;(global-set-key [f6] 'calc);;calc
(global-set-key [C-f12] 'comment-or-uncomment-region);comment region
(global-set-key [f12] 'c-indent-line-or-region)
(setq outline-minor-mode-prefix (kbd "C-o")) 
;;(global-set-key (kbd "C-SPC") 'nil);;set control+space to nill
(global-set-key (kbd "C-M-SPC") 'set-mark-command);;set Ctrl+Alt+space to set-mark
(global-set-key [(meta p)(c)] 'count-lines-region)
(global-set-key [(control = )] 'text-scale-increase);;zoom out/in font
(global-set-key [(control -)] 'text-scale-decrease)

;; --------------------set time-stamp-format, when auto saving--------------------
(setq time-stamp-format "%:y-%02m-%02d %02H:%02M:%02S")
;; hook emacs behaviour, before saving
(add-hook 'before-save-hook
          '(lambda ()
             ;; If the file path doesn't exist, create it, including any parent directories.
             (or (file-exists-p (file-name-directory buffer-file-name))
                 (make-directory (file-name-directory buffer-file-name) t))
             ;; ;; Remove trailing whitespace  ;; TODO
             ;; (unless (member mode-name readonly-mode-list)
             ;;   (delete-trailing-whitespace))
             ;; Auto update timestamp for some specific files
             (unless (member (file-name-extension (buffer-name)) '("org"))
               (time-stamp))))


;;-------------set grep-find-command, which ask grep-find to filter out some files specified by filter-name-list
(let (filter-name-list)
  (setq filter-name-list '(".git" ".svn" "*~" "#*#" "*.elc" "*.pyc" "worklog.org"))
  (setq grep-find-command "find .")
  (dolist (filter-file-name filter-name-list)
    (setq grep-find-command
          (format "%s -name \"%s\" -prune -o" grep-find-command filter-file-name)))
  (setq grep-find-command
        (cond
         ((eq system-type 'darwin)
          (concat grep-find-command " -type f -print0 | xargs -0 grep -inH -e "))
         (t
          (concat grep-find-command " -type f -print0 | xargs -0 -e grep -inH -e "))
          )))

;;-------------------- bind the key for my-occur function--------------------
(global-set-key [(super .)] 'my-occur)
(defun my-occur (invokeoccur)
  "Invoke super-. to perform occur.
  Invoke C-u super-. to perform dmoccur of color-moccur.el package"
  (interactive "P")
  (let (occur-regexp)
    (if invokeoccur
        (progn
          (setq occur-regexp
                (read-regexp "List lines matching regexp in current directory"
                             (car regexp-history)))
          (setq dmoccur-mask-internal dmoccur-mask)
          (dmoccur default-directory occur-regexp current-prefix-arg))
      (setq occur-regexp (read-regexp "List lines matching regexp" (car regexp-history)))
      (occur-1 occur-regexp list-matching-lines-default-context-lines	       
               (list (current-buffer))))))

;;-------------------- bind the key for grep-find-with-querystring-quoted function--------------------
(global-set-key (kbd "C-.") 'grep-find-with-querystring-quoted)
;; C-u C-.: grep-find with current word as the default search key
(defun grep-find-with-querystring-quoted (obtain-current-word)
  "Enhance grep-find by the following points
 - auto quoting query string
 - preventing show the lengthy grep-find-command in minibuffer
 - set the word at cursor as the default search keyword"
  (interactive "P")
  (let (command-args search-keyword (initial-conent nil)
                     (bounds (bounds-of-thing-at-point 'word)))
    (if (and obtain-current-word bounds)
        (setq initial-conent (buffer-substring-no-properties (car bounds) (cdr bounds))))
    (setq search-keyword (read-shell-command "Run find in current directory: "
                                             initial-conent 'grep-find-history))
    ;; ;; escape \" in the search keyword
    (setq search-keyword (replace-regexp-in-string "\\\"" "\\\\\"" search-keyword))
    ;; quote search-keyword with ""
    (setq command-args (concat grep-find-command "\"" search-keyword "\""))
    (grep command-args)))

;; TODO, enhance by sync or async query, instead of stub sleep
;; show how many matches, when grep-find
(defadvice grep-find (after show-grep())
  (let ((sleep_interval 2))
    (set-buffer "*grep*")
    (sleep-for sleep_interval)
    (message
     "%d matches found"
     (- (count-lines (point-min) (point-max)) 6))))
(ad-activate 'grep-find) ;;

;;-------------------------- separator ------------------------
(global-set-key (kbd "C-c .") 'my-find-file-in-parent-dir)
(defun my-find-file-in-parent-dir ()
  (interactive)
  (let (filename (bounds (bounds-of-thing-at-point 'word)))
    (setq filename (buffer-substring-no-properties
                    (car bounds) (cdr bounds)))
    (setq filename (read-shell-command
                    "Run find in parent directory: "
                    filename 'grep-find-history))
    (find-file-in-parent-dir filename)))

(defun find-file-in-parent-dir (file-regexp)
  "Find files by a given regexp in the parent directory"
  (interactive)
  (let ((sleep_interval 2)
        find-output line-count)
    (find-dired "../" (format "-name %s " file-regexp))
    (sleep-for sleep_interval)
    (switch-to-buffer "*Find*")
    (setq line-count (count-lines (point-min) (point-max)))
    (if (eq line-count 5)
        ;; if only exactly one match, open the file
        (progn
          (move-end-of-line 1)
          (find-file-existing (dired-file-name-at-point))
          )
      (message
       (format "Matched count of file is not 1. Line count is %d not 5" line-count)))))

;;---------------------separator -----------------------
(defvar programming-mode-list (list
                               'c-mode 'c++-mode
                               'emacs-lisp-mode 'lisp-mode
                               'shel-mode
                               ;;'ruby-mode
                               'java-mode
                               'perl-mode
                               'php-mode
                               'sgml-mode
                               'erlang-mode
                               ))
(defvar programming-mode-name-list (list
                                    "C/l" "C++/l"
                                    "Emacs-Lisp" "Lisp"
                                    "Shell"
                                    "Python"
                                    ;;"Ruby"
                                    "Java/l"
                                    "Perl"
                                    "PHP"
                                    '(sgml-xml-mode "XML" "SGML")
                                    "Erlang"
                                    ))
(defvar programming-hook-list (list
                               'c-mode-hook 'c++-mode-hook
                               'emacs-lisp-mode-hook 'lisp-mode-hook
                               'shel-mode-hook
                               'python-mode-hook
                               ;;'ruby-mode-hook
                               'java-mode-hook
                               'perl-mode-hook
                               'php-mode-hook
                               'erlang-mode-hook
                               ))
(defvar readonly-mode-list '("Image[jpeg]" "Image[gif]"))

;;;--------------------highlight--------------------
(setq search-highlight t         ; highlight when searching...
      query-replace-highlight t) ; and replacing

;;;--------------------configuration of view-mode--------------------
(dolist (hook programming-hook-list)
  (unless (member hook '(c-mode-hook c++-mode-hook lisp-mode-hook python-mode-hook
                                     emacs-lisp-mode-hook erlang-mode-hook))
    (add-hook hook '(lambda () (view-mode 1)))))

(defun global-view-on ()
  (interactive)
  (add-hook 'find-file-hook 'enable-view-for-programmer))

(defun global-view-off ()
  (interactive)
  (remove-hook 'find-file-hook 'enable-view-for-programmer))

(defun enable-view-for-programmer ()
  (if (member mode-name programming-mode-name-list)
      (view-mode t)))

(define-key global-map (kbd "M-p RET") 'my-view-mode)
(defun my-view-mode (globalp)
  "Invoke, enable view-mode.
   Invoke with C-u, enable view-mode for global wise"
  (interactive "P")
  (if globalp
      (progn
        (global-view-on)
        (view-mode))
    (view-mode)))
;;------------------------control the backup files-----------------------------
(setq auto-save-default nil) ;; disable auto save, like files of #XXX#
(setq kept-old-versions 2)   ;; 
(setq kept-new-versions 3)
(setq delete-old-versions t)
;; Put backup files (ie foo~) in one place
(let ((backup-directory-var "~/.emacs.d/backups/"))
  ;; make backup directory, if it doesn't exist
  (unless (file-exists-p backup-directory-var)
    (make-directory backup-directory-var t))
  ;; set backup location
  (setq backup-directory-alist (list (cons "." backup-directory-var))))


;;; essential-conf.el ends here
