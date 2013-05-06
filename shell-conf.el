;;; shellmode_config.el --- configuration for emacs shell-mode

;; Copyright (C) 2013  Ning Zhou

;; Author: Ning Zhou <nzhou@manb02>
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
;;; Shell mode
;; (setq ansi-color-names-vector ; better contrast colors
;;       ["black" "red" "green1" "yellow1"
;;        "#1e90ff" "magenta1" "cyan1" "white"])
;; (add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)
;; ;;;turn off word wrap and to make the prompt read-only
;; (add-hook 'shell-mode-hook 
;;      '(lambda () (toggle-truncate-lines 1)))
;; (setq comint-prompt-read-only t)
;;;=====================================================================
;;(autoload 'ansi-color-for-comint-mode-on "ansi-color" nil t)
;;(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)
;;; function to clear the buffer
(setq shell-file-name "/bin/bash")

;; When killing a file, also kill related shell buffer
;;(add-hook 'kill-buffer-hook 'kill-shell-buffer)
(defun kill-shell-buffer()
  "When killing a file, also kill related shell buffer."
  (let* ((file-name (buffer-name)) shell-buffer-name prefix current-hostname)
    (with-temp-buffer
      (shell-command "hostname" (current-buffer))
      (setq current-hostname (replace-regexp-in-string "\n" "" (buffer-string))))
    (setq prefix (format "*shell*-%s-" current-hostname))
    (setq shell-buffer-name (concat prefix file-name))
    (if (get-buffer shell-buffer-name)
        (kill-buffer shell-buffer-name))))

;; clear the shell buffer
(defun shell-buffer-clear ()
  (interactive)
  (let ((comint-buffer-maximum-size 0))
    (comint-truncate-buffer)))

(defun clear-shell ()
  "Remove content of shell/eshell, with the prompt lines reserved"
  (interactive)
  (cond
   ((string-equal mode-name "Shell")
    ;; In shell buffer, leverage comint
    (let ((comint-buffer-maximum-size 0))
      (comint-truncate-buffer)))
   ((string-equal mode-name "EShell")
    ;; In eshell buffer, simply delete content of region
    (let ((inhibit-read-only t))
      (goto-char (point-min))
      (forward-line 2)
      (eval-after-load 'eshell
        '(eshell-bol))
      (kill-region (point) (point-max))))))

(defun open-shell-of-current-file ()
  "If current file doesn't open a shell, generate one. Otherwise, switch to related shell."
  (interactive)
  (let* ((file-name (buffer-name)) 
	 shell-buffer-name 
	 current-hostname 
	 prefix-regexp 
	 prefix)
    (with-temp-buffer
      (shell-command "hostname" (current-buffer))
      (setq current-hostname
            (replace-regexp-in-string "\n" "" (buffer-string))))
    (setq prefix-regexp (format "\\*shell\\*-%s-" current-hostname))
    (setq prefix (format "*shell*-%s-" current-hostname))
    (if (equal mode-name "Shell")
        ;; if current buffer is a shell, switch to related file
        (pop-to-buffer (replace-regexp-in-string prefix-regexp "" file-name))
      ;; if current buffer is not a shell, create a related shell buffer
      (setq shell-buffer-name (concat prefix file-name))
      (shell shell-buffer-name))))

(defun open-shell-of-current-directory ()
  "If any file of current directory already have a related shell, switch to it "
  (interactive)
  (let* ((file-name (buffer-name)) shell-buffer-name
         current-hostname prefix-regexp prefix
         (directory-name default-directory))
    (with-temp-buffer
      (shell-command "hostname" (current-buffer))
      (setq current-hostname
            (replace-regexp-in-string "\n" "" (buffer-string))))
    (setq prefix-regexp (format "\\*shell\\*-%s-" current-hostname))
    (setq prefix (format "*shell*-%s-" current-hostname))
    (setq shell-buffer-name (concat prefix file-name))
    (if (equal mode-name "Shell")
        ;; if current buffer is a shell, switch to related file
        (pop-to-buffer (replace-regexp-in-string prefix-regexp "" file-name))
      ;; if current buffer is not a shell, check
      ;; whether there is any shell opened by files in the directory
      (unless (get-buffer shell-buffer-name)
        (dolist (file-var (directory-files default-directory))
          (if (get-buffer (concat prefix file-var))
              (setq shell-buffer-name (concat prefix file-var))
            )))
      (if (get-buffer shell-buffer-name)
          (pop-to-buffer shell-buffer-name)
        (shell shell-buffer-name)
        (insert " ")))))

(defun open-related-shell(&optional arg)
  "By default, if current file doesn't open a shell, generate one. 
   Otherwise, switch to related shell. If arg is given, only open a shell for one directory. "
  (interactive "P")
  (if (null arg) (open-shell-of-current-directory)
    (open-shell-of-current-file)))

;;--------------------------shell and term mode------------------
(require 'shell)
(require 'term)
(define-key term-raw-map (kbd "C-j") 'term-switch-to-shell-mode)
(defun term-switch-to-shell-mode ()
  (interactive)
  (if (equal major-mode 'term-mode)
      (progn
        (shell-mode)
        (set-process-filter
         (get-buffer-process (current-buffer)) 'comint-output-filter )
        (local-set-key (kbd "C-j") 'term-switch-to-shell-mode)
        (compilation-shell-minor-mode 1)
        (comint-send-input))
    (progn
      (compilation-shell-minor-mode -1)
      (font-lock-mode -1)
      (set-process-filter
       (get-buffer-process (current-buffer)) 'term-emulate-terminal)
      (term-mode)
      (term-char-mode)
      (term-send-raw-string (kbd "C-l"))
      )))

;; --8<-------------------------- separator ------------------------>8--
;;set the shell colors
;; (setq ansi-color-names-vector ; better contrast colors
;;       ["black" "red" "green1" "yellow1"
;;        "#1e90ff" "magenta1" "cyan1" "white"]
;; --8<-------------------------- separator ------------------------>8--
;;;turn off word wrap and to make the prompt read-only
(add-hook 'shell-mode-hook 
     '(lambda () (toggle-truncate-lines 1)))
(setq comint-prompt-read-only t)
;; add the hooks 
(add-hook 'shell-mode-hook
	  (lambda ()
	    (local-set-key "\C-l" 'clear-shell)
            (local-set-key (kbd "<up>") 'previous-line)
            (local-set-key (kbd "<down>") 'next-line)))
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)
;; key bindings
(global-set-key [f9] 'open-related-shell)

;; colors 
(autoload 'ansi-color-for-comint-mode-on "ansi-color" nil t)
(setq ansi-color-names-vector ; better contrast colors
      ["black" "red4" "green4" "yellow4"
       "blue4" "magenta4" "cyan4" "white"])
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)

;;; shellmode_conf.el ends here
