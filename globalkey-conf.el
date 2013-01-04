(defun open-folder-in-explorer ()
"Call when editing a file in a buffer. Open windows explorer in the current directory"
(interactive)
(shell-command-to-string (concat "nautilus --browser " default-directory)))
(global-set-key [(control x)(control d)] 'open-folder-in-explorer)
;;
(global-set-key [f9] 'c-indent-line-or-region)
(global-set-key (kbd "C-c C-c") 'comment-region)