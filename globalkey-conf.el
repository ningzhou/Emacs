(defun open-folder-in-explorer ()
"Call when editing a file in a buffer. Open windows explorer in the current directory"
(interactive)
(shell-command-to-string (concat "nautilus --browser " default-directory)))
(global-set-key [(control x)(control d)] 'open-folder-in-explorer)
;;
(global-set-key [f9] 'c-indent-line-or-region)
(global-set-key (kbd "C-c C-c") 'comment-region)

;; shortcut to magit-status
(global-set-key (kbd "C-x g") 'magit-status)
;; define key binding to traverse windows
;; (define-prefix-command 'tmux-map)
;; (global-set-key (kbd "C-.") 'tmux-map)
;; (global-set-key (kbd "C-. h") 'windmove-left)
;; (global-set-key (kbd "C-. j") 'windmove-up)
;; (global-set-key (kbd "C-. k") 'windmove-down)
;; (global-set-key (kbd "C-. l") 'windmove-right)