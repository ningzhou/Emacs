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
(defun shell-buffer-clear ()
  (interactive)
  (let ((comint-buffer-maximum-size 0))
    (comint-truncate-buffer)))

(defun my-shell-hook ()
      (local-set-key "\C-l" 'shell-buffer-clear))

(add-hook 'shell-mode-hook 'my-shell-hook)

;;; shellmode_config.el ends here
