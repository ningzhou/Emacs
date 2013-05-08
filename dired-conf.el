;; -*- coding: utf-8 -*-
;; File: dired-conf.el
;;
;; 
;; Updated: Time-stamp: <2013-05-08 11:07:58>
;;
;; --8<-------------------------- separator ------------------------>8--
;;(put 'dired-find-alternate-file 'disabled nil) ;;Dired reuse directory buffer
(setq dired-listing-switches "-alh") ;;dispay the file sizes with MB or KB formats

(load-file (concat EMACS_VENDOR "/dired/dired-single.el"))
;;jump to the directory of the file in the buffer
(global-set-key (kbd "C-x d") 'joc-dired-magic-buffer)  
(add-hook 'dired-mode-hook
          (lambda ()
          (define-key dired-mode-map (kbd "RET") 'joc-dired-single-buffer)
          (define-key dired-mode-map (kbd "<mouse-1>") 'joc-dired-single-buffer-mouse)
          (define-key dired-mode-map (kbd "^")
             (lambda ()
             (interactive)
             (joc-dired-single-buffer "..")))
          (setq joc-dired-use-magic-buffer t)
          (setq joc-dired-magic-buffer-name "*dired*")))
(global-set-key (kbd "C-x 4 d")
                (lambda (directory)
                  (interactive "D")
                  (let ((win-list (window-list)))
                    (when (null (cdr win-list)) ; only one window
                      (split-window-vertically))
                    (other-window 1)
                    (joc-dired-magic-buffer directory))))

;;-------------------------- separator -------------------------------------
;;using i-search in dired mod
(require 'dired)
(load-file (concat EMACS_VENDOR "/dired/dired-isearch.el"))
(define-key dired-mode-map (kbd "C-s") 'dired-isearch-forward)
(define-key dired-mode-map (kbd "C-r") 'dired-isearch-backward)
(define-key dired-mode-map (kbd "M-C-s") 'dired-isearch-forward-regexp)
(define-key dired-mode-map (kbd "M-C-r") 'dired-isearch-backward-regexp)

;; ;; --8<-------------------------- separator ------------------------>8--
;; Sort files in dired.
(defun dired-sort-size ()
  "Dired sort by size."
  (interactive)
  (dired-sort-other (concat dired-listing-switches "S")))

(defun dired-sort-extension ()
  "Dired sort by extension."
  (interactive)
  (dired-sort-other (concat dired-listing-switches "X")))

(defun dired-sort-name ()
  "Dired sort by name."
  (interactive)
  (dired-sort-other (concat dired-listing-switches "")))

(defun dired-sort-ctime ()
  "Dired sort by create time."
  (interactive)
  (dired-sort-other (concat dired-listing-switches "ct")))

(defun dired-sort-utime ()
  "Dired sort by access time."
  (interactive)
  (dired-sort-other (concat dired-listing-switches "ut")))

(defun dired-sort-time ()
  "Dired sort by time."
  (interactive)
  (dired-sort-other (concat dired-listing-switches "t")))

(defun dired-get-size ()
  "Get size of current file/directories at cursor point."
  (interactive)
  (let ((current-file (dired-get-filename t)))
    (with-temp-buffer
      (shell-command (format "/usr/bin/du -sch %s" current-file) t)
      (message "Size of %s: %s" current-file
               (progn
                 (goto-char (point-min))
                 (re-search-forward "\\(^[0-9.,]+[A-Za-z]+\\).*\\(total\\|总计\\)$")
                 (match-string 1))))))

(define-key dired-mode-map "\M-e" 'dired-sort-extension)
(define-key dired-mode-map "\M-c" 'dired-get-size)
;; --8<-------------------------- separator ------------------------>8--
;; adds a command('T') to dired-mode for creating and unpacking tar files.
(load-file (concat EMACS_VENDOR "/dired/dired-tar.el"))
(custom-set-variables
 ;; no confirmation for recursive operations in dired
 '(dired-recursive-copies (quote always))
 '(dired-recursive-deletes (quote always))
 )
;; --8<-------------------------- separator ------------------------>8--
;;(load-file (concat EMACS_VENDOR "/dired+/dired+.el"))
;;(require 'dired+)
(defface diredp-my-file-name
  '((t (:foreground "green4")))
  "*Face used for message display."
  :group 'Dired-Plus)
(setq diredp-file-name 'diredp-my-file-name)

(defface diredp-my-dir-heading
  '((t (:foreground "DarkGoldenrod4" :background "LightCyan1")))
  "*Face used for directory headings in dired buffers."
  :group 'Dired-Plus :group 'font-lock-highlighting-faces)
(setq diredp-dir-heading 'diredp-my-dir-heading)

(defface diredp-my-dir-priv
  '((t (:foreground "DarkRed" :background "LightCyan1")))
  "*Face used for directory privilege indicator (d) in dired buffers."
  :group 'Dired-Plus :group 'font-lock-highlighting-faces)
(defvar diredp-dir-priv 'diredp-my-dir-priv)

(defface diredp-my-exec-priv
  '((t (:background "LightCyan1")))
  "*Face used for execute privilege indicator (x) in dired buffers."
  :group 'Dired-Plus :group 'font-lock-highlighting-faces)
(defvar diredp-exec-priv 'diredp-my-exec-priv)

(defface diredp-my-other-priv
  '((t (:background "LightCyan1")))
  "*Face used for l,s,S,t,T privilege indicators in dired buffers."
  :group 'Dired-Plus :group 'font-lock-highlighting-faces)
(defvar diredp-other-priv 'diredp-my-other-priv)

(defface diredp-my-write-priv
  '((t (:background "LightCyan1")))
  "*Face used for write privilege indicator (w) in dired buffers."
  :group 'Dired-Plus :group 'font-lock-highlighting-faces)
(defvar diredp-write-priv 'diredp-my-write-priv)

(defface diredp-my-read-priv
  '((t (:background "LightCyan1")))
  "*Face used for read privilege indicator (w) in dired buffers."
  :group 'Dired-Plus :group 'font-lock-highlighting-faces)
(defvar diredp-read-priv 'diredp-my-read-priv)
;; ;; --8<-------------------------- separator ------------------------>8--
;; ;; File: dired-setting.el ends here
