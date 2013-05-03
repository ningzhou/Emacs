;;====================color-theme====================
;;(require 'color-theme)
;;(color-theme-dark-blue)
;;------------------------------------------------------------
;;almost monokai theme
;;(require 'color-theme-almost-monokai)
;;(color-theme-almost-monokai)
;;------------------------------------------------------------
;;monokai theme
;;(require 'color-theme-monokai)
;;(color-theme-monokai)
;;------------------------------------------------------------
;;monokai theme for emacs24
(load-file  (concat EMACS_VENDOR "/color-theme/monokai-theme.el"))
(load-theme 'monokai t)

;;=============rectangle mark====================
(load-file (concat EMACS_VENDOR "/rect-mark.el"))
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
(load-file (concat EMACS_VENDOR "/htmlize.el")) ;; htmlize package


;;; shell mode
(autoload 'ansi-color-for-comint-mode-on "ansi-color" nil t)
(setq ansi-color-names-vector ; better contrast colors
      ["black" "red4" "green4" "yellow4"
       "blue4" "magenta4" "cyan4" "white"])
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)
;;;turn off word wrap and to make the prompt read-only
(add-hook 'shell-mode-hook 
     '(lambda () (toggle-truncate-lines 1)))
(setq comint-prompt-read-only t)


;;;====================auto-insert mode====================
;;首先这句话设置一个目录，你的auto-insert 的模版文件会存放在这个目录中，
(setq-default auto-insert-directory (concat EMACS_DIR "/auto-insert/"))
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

