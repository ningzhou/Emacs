;;-------------------------------------------------------------------
;; File : init-dired.el
;; Author : Ning Zhou 
;; Description :
;; --
;; Created : <2013-05-10>
;; Updated: Time-stamp: <2016-06-08 15:52:52>
;;-------------------------------------------------------------------

(require 'dired)
(put 'dired-find-alternate-file 'disabled nil) ;;Dired reuse directory buffer
(setq dired-listing-switches "-alh") ;;dispay the file sizes with MB or KB formats

;; define movement keys which are equivelant to evil mode
(define-key dired-mode-map "j" 'dired-next-line)
(define-key dired-mode-map "k" 'dired-previous-line)
(define-key dired-mode-map "/" 'dired-isearch-filenames)
(define-key dired-mode-map ":" 'execute-extended-command)

;;----------------------Sort files in dired.----------------------------
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

;; -------------------------------------------------
;; adds a command('T') to dired-mode for creating and unpacking tar files.
(load-file (concat EMACS_VENDOR "/dired/dired-tar.el"))
(custom-set-variables
 ;; no confirmation for recursive operations in dired
 '(dired-recursive-copies (quote always))
 '(dired-recursive-deletes (quote always))
 )

(remove-hook 'dired-mode-hook
	  (function
	   (lambda ()
	     (define-key dired-mode-map "T" 'dired-tar-pack-unpack))))

(add-hook 'dired-mode-hook
	  (function
	   (lambda ()
	     (define-key dired-mode-map "T" 'my-dired-tar-pack-unpack))))

(defun my-dired-tar-pack-unpack (prefix-arg)
  ""
  (interactive "P")
  (let (tar_command
        (marked-files (dired-get-marked-files t nil)))
    (if (= 1 (length marked-files))
        (dired-tar-pack-unpack prefix-arg)
      (progn
        (setq tar_command (format "tar cvf - %s | gzip --best --stdout > file.tar.gz"
                                  (mapconcat 'identity (dired-get-marked-files t nil) " ")))
        (shell-command tar_command)
        )
    )
  )
)

;; -------------------------- separator ------------------------
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


(provide 'init-dired)
;; File: init-dired.el ends here
