;;====================color-theme====================
;;(require 'color-theme)
;;(color-theme-dark-blue)
;;------------------------------------------------------------
;;almost monokai theme
;;(require 'color-theme-almost-monokai)
;;(color-theme-almost-monokai)
;;------------------------------------------------------------
;;monokai theme
;;(load-file "~/myemacs/color-theme/color-theme-monokai.el")
(require 'color-theme-monokai)
(color-theme-monokai)
;;==============set font size=======================
(set-face-attribute 'default nil :height 120)
;;====================htmlize package====================
;;(load-file "~/myemacs/htmlize.el")
(require 'htmlize)
;;====================share clipboard with outside programs========
(setq x-select-enable-clipboard t)
;;=============rectangle mark====================
;;(load-file "~/myemacs/rect-mark.el")
(require 'rect-mark)
(global-set-key (kbd "C-x r C-SPC") 'rm-set-mark)
(global-set-key (kbd "C-x r C-x") 'rm-exchange-point-and-mark)
(global-set-key (kbd "C-x r C-w") 'rm-kill-region)
(global-set-key (kbd "C-x r M-w") 'rm-kill-ring-save)
(autoload 'rm-set-mark "rect-mark"
  "Set mark for rectangle." t)
(autoload 'rm-exchange-point-and-mark "rect-mark"
  "Exchange point and mark for rectangle." t)
(autoload 'rm-kill-region "rect-mark"
  "Kill a rectangular region and save it in the kill ring." t)
(autoload 'rm-kill-ring-save "rect-mark"
  "Copy a rectangular region to the kill ring." t)
;;=============setup enhanced dired mode==============
; dispay the file sizes with MB or KB formats
(setq dired-listing-switches "-alh")
(require 'dired-single) ; using single buffer
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
(global-set-key (kbd "C-x d") 'joc-dired-magic-buffer)
;; jump to the directory of the file in the buffer
(global-set-key (kbd "C-x d")
                'joc-dired-magic-buffer)
(global-set-key (kbd "C-x 4 d")
                (lambda (directory)
                  (interactive "D")
                  (let ((win-list (window-list)))
                    (when (null (cdr win-list)) ; only one window
                      (split-window-vertically))
                    (other-window 1)
                    (joc-dired-magic-buffer directory))))
;;using i-search in dired mod
;(load-file "~/myemacs/dired-isearch.el")
(require 'dired-isearch)
(require 'dired)
(define-key dired-mode-map (kbd "C-s") 'dired-isearch-forward)
(define-key dired-mode-map (kbd "C-r") 'dired-isearch-backward)
(define-key dired-mode-map (kbd "M-C-s") 'dired-isearch-forward-regexp)
(define-key dired-mode-map (kbd "M-C-r") 'dired-isearch-backward-regexp)
;;====================miscs====================
(tool-bar-mode nil)
(scroll-bar-mode nil)
(show-paren-mode t)
(setq show-paren-style 'parentheses)
; maxmize the frame
(defun my-maximized ()
(interactive)
(x-send-client-message nil 0 nil "_NET_WM_STATE" 32
'(2 "_NET_WM_STATE_MAXIMIZED_HORZ" 0))
(x-send-client-message
nil 0 nil "_NET_WM_STATE" 32
'(2 "_NET_WM_STATE_MAXIMIZED_VERT" 0))
)
(my-maximized)
;;===================open very large file=================
;;(require 'vlf)
;;==========control the backup files=========
;; Put autosave files (ie #foo#) and backup files (ie foo~) in ~/.emacs.d/.
(custom-set-variables
  '(auto-save-file-name-transforms '((".*" "~/.emacs.d/autosaves/\\1" t)))
  '(backup-directory-alist '((".*" . "~/.emacs.d/backups/"))))

;; create the autosave dir if necessary, since emacs won't.
(make-directory "~/.emacs.d/autosaves/" t)

;;enable linum-mode automatically
(global-linum-mode 1)

;;enable lines soft wrapped at word boundary
(global-visual-line-mode 1)

;;; Shell mode
(autoload 'ansi-color-for-comint-mode-on "ansi-color" nil t)
(setq ansi-color-names-vector ; better contrast colors
      ["black" "red4" "green4" "yellow4"
       "blue4" "magenta4" "cyan4" "white"])
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)
;;;turn off word wrap and to make the prompt read-only
(add-hook 'shell-mode-hook 
     '(lambda () (toggle-truncate-lines 1)))
(setq comint-prompt-read-only t)
;; set the color, not really work
;;(setenv "PS1" "\\e[0;32m◆\\u@\\H \\D{%Y-%m-%d} \\A\\e[0;30m\\w\\n")

;;;====================yasnippet====================
(add-to-list 'load-path 
	     "~/myemacs/vendor/yasnippet")
(require 'yasnippet)
(yas/global-mode 1)

;;;====================auto-insert mode====================
;;首先这句话设置一个目录，你的auto-insert 的模版文件会存放在这个目录中，
(setq-default auto-insert-directory "~/myeamcs/auto-insert/")
(auto-insert-mode)  ;;; 启用auto-insert
;; 默认情况下插入模版前会循问你要不要自动插入，这里设置为不必询问，
;; 在新建一个org文件时，自动插入`auto-insert-directory'目录下的`org-auto-insert`文件中的内容
(setq auto-insert-query nil)
(define-auto-insert "\\.org" "org-auto-insert")
;;这个就是新建以.c 结尾的C文件时，会自动插入c-auto-insert文件中的内容
(define-auto-insert "\\.c" "c-auto-insert")
(define-auto-insert "\\.m" "m-auto-insert")
(defadvice auto-insert  (around yasnippet-expand-after-auto-insert activate)
  "expand auto-inserted content as yasnippet templete,
  so that we could use yasnippet in autoinsert mode"
  (let ((is-new-file (and (not buffer-read-only)
                          (or (eq this-command 'auto-insert)
                              (and auto-insert (bobp) (eobp))))))
    ad-do-it
    (let ((old-point-max (point-max)))
      (when is-new-file
        (goto-char old-point-max)
        (yas/expand-snippet (buffer-substring-no-properties (point-min) (point-max)))
        (delete-region (point-min) old-point-max)
        )
      )
    )  
)

;;display the full path of the buffer
(setq frame-title-format
      (list (format "%s %%S: %%j " (system-name))
        '(buffer-file-name "%f" (dired-directory dired-directory "%b"))))


;;set google chrome as the default brower
(setq browse-url-browser-function 'browse-url-generic
      browse-url-generic-program "google-chrome")


;;set the shell colors
(setq ansi-color-names-vector ; better contrast colors
      ["black" "red" "green1" "yellow1"
       "#1e90ff" "magenta1" "cyan1" "white"])
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)
;;;turn off word wrap and to make the prompt read-only
(add-hook 'shell-mode-hook 
     '(lambda () (toggle-truncate-lines 1)))
(setq comint-prompt-read-only t)

;;clear shell buffer
(defun my-clear ()
  (interactive)
  (let ((comint-buffer-maximum-size 0))
    (comint-truncate-buffer)))