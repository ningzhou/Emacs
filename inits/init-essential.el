;;-------------------------------------------------------------------
;; @copyright 2013 Ning Zhou
;; File : init-essential.el
;; Author : Ning Zhou <nzhoun@gmail.com>
;; Description :
;; --
;; Created : <2013-05-10>
;; Updated: Time-stamp: <2016-06-06 19:02:29>
;;-------------------------------------------------------------------
;; File : init-essential.el ends

;;--------------------set font and font size--------------------
;;(set-default-font "DejaVu Sans Mono")
;;(set-face-attribute 'default nil :height 130)

;; line numbering
(setq linum-format "%4d")
(global-linum-mode 1)
(global-visual-line-mode 1)   ;;enable lines soft wrapped at word boundary

;;------------------------------get a clean-look emacs------------------------------
(defun emacs-clean-look ()
  ;; let's have a clean world
  (interactive)
  ;;(set-scroll-bar-mode 'right) ;;scroll bar ;; TODO denny
  (if (fboundp 'tool-bar-mode) (tool-bar-mode -1)) ;; Hide toolbar
  (if (fboundp 'menu-bar-mode) (menu-bar-mode -1)) ;;Hide menubar
  (if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
  (setq inhibit-startup-message t
        ;; prevent showing initial information in draft buffer
        initial-scratch-message nil
        visible-bell t ;;no bell when error
        initial-scratch-message
        (purecopy "\ ;; In sandbox "))
  ;;(set-frame-parameter nil 'scroll-bar-width 10)
)
(emacs-clean-look) ;; evaluate the function above

;;----------------------------------------------------------------------------
;; Less GC, more memor
;;----------------------------------------------------------------------------
;; By default Emacs will initiate GC every 0.76 MB allocated
;; (gc-cons-threshold == 800000).
;; we increase this to 1GB (gc-cons-threshold == 100000000)
;; @see http://www.gnu.org/software/emacs/manual/html_node/elisp/Garbage-Collection.html
(setq-default gc-cons-threshold 100000000
              gc-cons-percentage 0.5)

;;------------------------------other settings------------------------------
(desktop-save-mode 1)
;;(setq debug-on-error t)
(set-language-environment 'utf-8)
(setq major-mode 'text-mode) ;;Text-mode is default mode
(setq tab-width 4) ;;tab take 4 space
(setq-default indent-tabs-mode nil) ;;force Emacs to indent with spaces, never with TABs
(global-font-lock-mode t) ;;highlight synatx
;;(setq x-select-enable-clipboard t) ;;support copy/paste among emacs and other programs
(setq x-select-enable-clipboard nil) ;;use the registers in evil mode
(show-paren-mode t) 
(setq show-paren-style 'parentheses)
(setq-default fill-column 70)
(setq default-major-mode 'text-mode
      column-number-mode t ;;show column number
      line-number-mode 1   ;;show line number in mode line
      save-abbrevs nil
      line-spacing 0.2
      indicate-empty-lines t)

;;---------------------generic-mode ----------------------------
;; add syntax highlighting for batch files, ini files, command files, registry files, 
;; apache files, samba files, resource files, fvwm files, etc
(require 'generic-x) 

;;--------------------display the full path of the buffer -----------------------
(setq frame-title-format
      (list (format "%s %%S: %%j " (system-name))
        '(buffer-file-name "%f" (dired-directory dired-directory "%b"))))

;;--------------------make Emacs your choice of image viewer--------------------
(autoload 'thumbs "thumbs" "Preview images in a directory." t)
;;if split-width-threshold is smaller than the window's width, the split puts the new window on the right. 
;;(set-default 'split-width-threshold 165)
(set-default 'text-scale-mode-step 1.1) ;;set the zoom rate
;;(iswitchb-mode 1)      ;;interactive buffer switching
;;(setq iswitchb-buffer-ignore '("^\\*")) ;;ignore some bufers
;;(setq undo-limit 200000) ;;Increase number of undo
;;(setq undo-strong-limit 300000) ;;Increase number of undo
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
;;(setq-default ispell-program-name "aspell")

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
(global-set-key [M-f12] 'comment-or-uncomment-region) ;;comment region
(global-set-key [f12] 'c-indent-line-or-region)
(setq outline-minor-mode-prefix (kbd "C-o")) 
(global-set-key (kbd "C-M-SPC") 'set-mark-command);;set Ctrl+Alt+space to set-mark
(global-set-key [(meta p)(c)] 'count-lines-region)

;;;--------------------highlight--------------------
(setq search-highlight t         ; highlight when searching...
      query-replace-highlight t) ; and replacing


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

;;--------------------------------------------------------------------------------
(defun shift-text (distance)
  (if (use-region-p)
      (let ((mark (mark)))
        (save-excursion
          (indent-rigidly (region-beginning)
                          (region-end)
                          distance)
          (push-mark mark t t)
          (setq deactivate-mark nil)))
    (indent-rigidly (line-beginning-position)
                    (line-end-position)
                    distance)))

(defun shift-right (count)
  (interactive "p")
  (shift-text count))

(defun shift-left (count)
  (interactive "p")
  (shift-text (- count)))

;;---------------------------exec-path-from-shell------------------------------
;; ensure environment variables inside Emacs look the same as in the user's shell.
(when (memq window-system '(mac ns))
  (exec-path-from-shell-initialize))

(provide 'init-essential)
;;; init-essential.el ends here
