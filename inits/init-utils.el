;;-------------------------------------------------------------------
;; @copyright 2013 Ning Zhou
;; File : init-utils.el
;; Author : Ning Zhou <nzhoun@gmail.com>
;; Description :
;; --
;; Created : <2013-05-10>
;; Updated: Time-stamp: <2015-09-01 08:22:33>
;;-------------------------------------------------------------------
;; File : init-utils.el ends

(add-hook 'write-file-hooks 'auto-update-file-fields)
(defun auto-update-file-fields ()
  "Update fields in file, such as filename, time-stamp, etc
   Sample:
    - filename format:
    # File : init-utils.el"
  (interactive)
  (unless (member mode-name readonly-mode-list)
    (save-excursion
      (save-restriction
        (let ((file-name-regexp (concat "\\(File *\\: \\)\\([^" " " "
]*\\) *"))
              (max-lines 15)
              (beg (point-min)) end
              )
          (goto-char (point-min))
          (forward-line max-lines)
          (setq end (point))
          (narrow-to-region beg end)
          (goto-char (point-min))
          ;; Verify looking at a file name for this mode.
          (while (re-search-forward file-name-regexp nil t)
            (goto-char (match-beginning 2))
            (delete-region (match-beginning 2) (match-end 2))
            (insert (file-name-nondirectory (buffer-file-name)))
            ))
        )))
)

;;----------auto update time-stamp----------
(add-hook 'before-save-hook 'time-stamp)
(setq time-stamp-pattern "Time-stamp: <%04y-%02m-%02d %02H:%02M:%02S>")
(setq time-stamp-line-limit 20)

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

;;-----------open the direcotry associated with current buffer using explored----------
(defun open-folder-in-explorer ()
     "Call when editing a file in a buffer. Open windows explorer in the current directory"
     (interactive)
     (shell-command-to-string (concat "nautilus --browser " default-directory)))
(global-set-key [(control x)(control d)] 'open-folder-in-explorer)

;;-------------set grep-find-command ----------
;;which ask grep-find to filter out some files specified by filter-name-list
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

;;--------------------grep-find-with-querystring-quoted function--------------------
;;(global-set-key (kbd "C-.") 'grep-find-with-querystring-quoted)
(defalias 'grepq 'grep-find-with-querystring-quoted)
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

;; enhance by sync or async query, instead of stub sleep
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
(defalias 'ffpd 'my-find-file-in-parent-dir)
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


(defun vis-c-insert-include-guard()
  (interactive)
  (let ((guard-str
         (concat
          (replace-regexp-in-string "[.-]" "_"
                                    (upcase (file-name-sans-extension (buffer-name))))
          "_H")))
    (save-excursion
      (beginning-of-buffer)
      (insert (concat "#ifndef " guard-str "\n"))
      (insert (concat "#define " guard-str "\n"))
      (end-of-buffer)
      (insert "\n#endif\n"))))


(provide 'init-utils)