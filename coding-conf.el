;;;; CC-mode配置  http://cc-mode.sourceforge.net/
(require 'cc-mode)
(c-set-offset 'inline-open 0)
(c-set-offset 'friend '-)
(c-set-offset 'substatement-open 0)


;;;;我的C/C++语言编辑策略
(defun my-c-mode-common-hook()
  (setq tab-width 4 indent-tabs-mode nil)
  ;;; hungry-delete and auto-newline
  ;;(c-toggle-auto-hungry-state 0)
  ;;按键定义
  (define-key c-mode-base-map [(control \`)] 'hs-toggle-hiding)
  (define-key c-mode-base-map [(return)] 'newline-and-indent)
  (define-key c-mode-base-map [(f7)] 'compile)
  (define-key c-mode-base-map [(meta \`)] 'c-indent-command)
  ;;  (define-key c-mode-base-map [(tab)] 'hippie-expand)
  ;;(define-key c-mode-base-map [(tab)] 'my-indent-or-complete)
  (define-key c-mode-base-map [(meta /?)] 'semantic-ia-complete-symbol-menu)

  ;;预处理设置
  (setq c-macro-shrink-window-flag t)
  (setq c-macro-preprocessor "cpp")
  (setq c-macro-cppflags " ")
  (setq c-macro-prompt-flag t)
  (setq hs-minor-mode t)
  (setq abbrev-mode t)
)

(add-hook 'c-mode-common-hook 'my-c-mode-common-hook)

;;;;我的C++语言编辑策略
(defun my-c++-mode-hook()
(setq tab-width 4 indent-tabs-mode nil)
(c-set-style "stroustrup")
;;  (define-key c++-mode-map [f3] 'replace-regexp)
)

;;(add-to-list 'load-path "~/myemacs/3rd-pkgs/cedet-1.0pre7/eieio")
;;(load-file "~/myemacs/3rd-pkgs/cedet-1.0pre7/common/cedet.el")
;;;配置Semantic的检索范围:
(setq semanticdb-project-roots 
(list
(expand-file-name "/")))
;;;自定义自动补齐命令，这部分是抄hhuu的，如果在单词中间就补齐，否则就是tab
(defun my-indent-or-complete ()
  (interactive)
  (if (looking-at "\\>")
      (hippie-expand nil)
    (indent-for-tab-command))
  )
 
(global-set-key [(control tab)] 'my-indent-or-complete)
(global-set-key (kbd "C-c C-c") 'comment-region)
;;(global-set-key (kbd "C-c C-u") 'uncomment-region)
;;'(compile-command "make")

;;;hippie的自动补齐策略，优先调用了senator的分析结果
(autoload 'senator-try-expand-semantic "senator")
(setq hippie-expand-try-functions-list
      '(
        senator-try-expand-semantic
        try-expand-dabbrev
        try-expand-dabbrev-visible
        try-expand-dabbrev-all-buffers
        try-expand-dabbrev-from-kill
        try-expand-list
        try-expand-list-all-buffers
        try-expand-line
        try-expand-line-all-buffers
        try-complete-file-name-partially
        try-complete-file-name
        try-expand-whole-kill
        ))

;; (add-to-list 'load-path "/usr/share/emacs/site-lisp")
;; (require 'xcscope)
;; (setq cscope-do-not-update-database t)
;cscope-index-file           索引文件名称( cscope.files )
;cscope-database-file        数据库文件名称( cscope.out )
;cscope-use-relative-paths   文件列表生成索引时使用相对路径
;cscope-index-recursively    生成文件列表时递归搜索
;cscope-indexing-script      cscope索引脚本 ( cscope-indexer )
;cscope-symbol-chars         cscope符号字符
;cscope-filename-chars       cscope文件名称字符
;cscope-minor-mode-hooks     cscope模式钩子
;cscope-options-args         cscope命令可选参数
;cscope-list-entry-hook      cscope模式钩子


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;python ide provided by Gabriele Lanaro;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;1. install the dependencies
;;; $ sudo apt-get install pymacs pyflakes
;;;2. get the package emacs-for-python and put somewhere
(load-file (concat EMACS_DIR "/vendor/emacs-for-python/epy-init.el"))
(setq skeleton-pair nil)
;;(epy-setup-checker "pyflakes %f")


;; (defun flymake-create-temp-in-system-tempdir (filename prefix)
;;   (make-temp-file (or prefix "flymake")))
;; (when (load "flymake" t)
;;   (defun flymake-pyflakes-init ()
;;     (let* ((temp-file (flymake-init-create-temp-buffer-copy
;;                        'flymake-create-temp-in-system-tempdir))
;;            (local-file (file-relative-name
;;                         temp-file
;;                         (file-name-directory buffer-file-name))))
;;       (list "pyflakes" (list local-file))))
;;   (add-to-list 'flymake-allowed-file-name-masks
;;                '("\\.py\\'" flymake-pyflakes-init)))
;; (add-hook 'python-mode-hook 'flymake-mode)

;; (setq temporary-file-directory "~/.emacs.d/tmp")
;; (setq backup-directory-alist
;;       `((".*" . ,temporary-file-directory)))
;; (setq auto-save-file-name-transforms
;;       `((".*" ,temporary-file-directory t))