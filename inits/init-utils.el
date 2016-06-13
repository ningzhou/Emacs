;;-------------------------------------------------------------------
;; @copyright 2013 Ning Zhou
;; \file init-utils.el
;; \author Ning Zhou 
;; \date  <2013-05-10>
;;-------------------------------------------------------------------

;;----------------------------------------------------------------------------
;; String utilities missing from core emacs
;;----------------------------------------------------------------------------
(defun string-all-matches (regex str &optional group)
  "Find all matches for `REGEX' within `STR', returning the full match string or group `GROUP'."
  (let ((result nil)
        (pos 0)
        (group (or group 0)))
    (while (string-match regex str pos)
      (push (match-string group str) result)
      (setq pos (match-end group)))
    result))

(defun string-rtrim (str)
  "Remove trailing whitespace from `STR'."
  (replace-regexp-in-string "[ \t\n]*$" "" str))


;;----------------------------------------------------------------------------
;; Find the directory containing a given library
;;----------------------------------------------------------------------------
(autoload 'find-library-name "find-func")
(defun directory-of-library (library-name)
  "Return the directory in which the `LIBRARY-NAME' load file is found."
  (file-name-as-directory (file-name-directory (find-library-name library-name))))


;;----------------------------------------------------------------------------
;; Delete the current file
;;----------------------------------------------------------------------------
(defun delete-this-file ()
  "Delete the current file, and kill the buffer."
  (interactive)
  (or (buffer-file-name) (error "No file is currently being edited"))
  (when (yes-or-no-p (format "Really delete '%s'?"
                             (file-name-nondirectory buffer-file-name)))
    (delete-file (buffer-file-name))
    (kill-this-buffer)))


;;----------------------------------------------------------------------------
;; Rename the current file
;;----------------------------------------------------------------------------
(defun rename-this-file-and-buffer (new-name)
  "Renames both current buffer and file it's visiting to NEW-NAME."
  (interactive "sNew name: ")
  (let ((name (buffer-name))
        (filename (buffer-file-name)))
    (unless filename
      (error "Buffer '%s' is not visiting a file!" name))
    (if (get-buffer new-name)
        (message "A buffer named '%s' already exists!" new-name)
      (progn
        (rename-file filename new-name 1)
        (rename-buffer new-name)
        (set-visited-file-name new-name)
        (set-buffer-modified-p nil)))))

;;----------------------------------------------------------------------------
;; automatically update file header
;;----------------------------------------------------------------------------
(add-hook 'write-file-hooks 'auto-update-file-fields)
(defun auto-update-file-fields ()
  "Update fields in file, such as filename, etc
   Sample:
    - filename format:
    # \file init-utils.el
   "
  (interactive)
  (unless (member mode-name readonly-mode-list)
    (save-excursion
      (save-restriction
        (let ((file-name-regexp (concat "\\(\\\\file *\\)\\([^" " " "
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
;;(global-set-key (kbd "C-c .") 'my-find-file-in-parent-dir)
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


;; {{ find-file-in-project (ffip)
(autoload 'find-file-in-project "find-file-in-project" "" t)
(autoload 'find-file-in-project-by-selected "find-file-in-project" "" t)
(autoload 'ffip-get-project-root-directory "find-file-in-project" "" t)
(setq ffip-match-path-instead-of-filename t)

(defun neotree-project-dir ()
  "Open NeoTree using the git root."
  (interactive)
  (let ((project-dir (ffip-get-project-root-directory))
        (file-name (buffer-file-name)))
    (if project-dir
        (progn
          (neotree-dir project-dir)
          (neotree-find file-name))
      (message "Could not find git project root."))))

(defvar my-grep-extra-opts
  "--exclude-dir=.git --exclude-dir=.bzr --exclude-dir=.svn"
  "Extra grep options passed to `my-grep'")

(defun my-grep ()
  "Grep file at project root directory or current directory"
  (interactive)
  (let ((keyword (if (region-active-p)
                     (buffer-substring-no-properties (region-beginning) (region-end))
                   (read-string "Enter grep pattern: ")))
        cmd collection val 1st root)

    (let ((default-directory (setq root (or (and (fboundp 'ffip-get-project-root-directory)
                                                 (ffip-get-project-root-directory))
                                            default-directory))))
      (setq cmd (format "%s -rsn %s \"%s\" *"
                        grep-program my-grep-extra-opts keyword))
      (when (and (setq collection (split-string
                                   (shell-command-to-string cmd)
                                   "\n"
                                   t))
                 (setq val (ivy-read (format "matching \"%s\" at %s:" keyword root) collection))))
      (setq lst (split-string val ":"))
      (find-file (car lst))
      (goto-char (point-min))
      (forward-line (1- (string-to-number (cadr lst)))))))
;; }}


(provide 'init-utils)
