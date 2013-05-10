;;-------------------------------------------------------------------
;; @copyright 2013 Ning Zhou
;; File : utils.el
;; Author : Ning Zhou <nzhoun@gmail.com>
;; Description :
;; --
;; Created : <2013-05-10>
;; Updated: Time-stamp: <2013-05-10 01:04:01>
;;-------------------------------------------------------------------
;; File : utils.el ends


(add-hook 'write-file-hooks 'auto-update-file-fields)
(defun auto-update-file-fields ()
  "Update fields in file, such as filename, time-stamp, etc
   Sample:
    - filename format:
    # File : handyfunction-setting.el"
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

;; auto update time-stamp
(add-hook 'before-save-hook 'time-stamp)
(setq time-stamp-pattern "Time-stamp: <%04y-%02m-%02d %02H:%02M:%02S>")
(setq time-stamp-line-limit 20)
