;; -----------------------define the "main" skeleton------------------------------
;; (define-skeleton skeleton-c-mode-main-func
;;   "generate int main(int argc, char * argv[]) automatic" nil
;;   "int main (int argc, char * argv[]) \n{\n"
;;   > _  "\n" > "return 0;"
;;   "\n}")

;; (define-abbrev-table 'c-mode-abbrev-table '(
;;     ("main" "" skeleton-c-mode-main-func 1)))

;; (define-abbrev-table 'c-mode-abbrev-table '(
;;      ("main" "" skeleton-c-mode-main-func 1))
;; )

;; (define-abbrev-table 'c++-mode-abbrev-table '(
;;      ("main" "" skeleton-c-mode-main-func 1))
;; )



;; ---------------------auto pair-----------------------------
(defun my-auto-pair ()
  (interactive)
  (make-local-variable 'skeleton-pair-alist)
  (setq skeleton-pair-alist '(
                              (?\( _ ")")
                              (?\[ _ "]")
                              (?\" _ "\"")
                              (?\' _ "\'")
                              (?{ \n > _ \n ?} >)))
  (setq skeleton-pair t)
  (local-set-key (kbd "(") 'skeleton-pair-insert-maybe)
  (local-set-key (kbd "[") 'skeleton-pair-insert-maybe)
  (local-set-key (kbd "\"") 'skeleton-pair-insert-maybe)
  (local-set-key (kbd "\'") 'skeleton-pair-insert-maybe)
  (local-set-key (kbd "{") 'skeleton-pair-insert-maybe))

;;--------------------show current function name--------------------
(defun enable-which-function()
  (unless (string= (current-buffer-name-extension) "org")
    (which-function-mode t)))

;; add the hook 
(dolist (hook programming-hook-list)
  (add-hook hook 'my-auto-pair)
  (add-hook hook 'hs-minor-mode)
  ;; (add-hook hook 'subword-mode) ;; TODO
  ;; (add-hook hook 'enable-which-function)
  )
;;--------------------c-mode configuration--------------------
(require 'cc-mode)
(setq-default c-basic-offset 4 c-default-style "linux")
(setq-default tab-width 4 indent-tabs-mode t)
(define-key c-mode-base-map (kbd "RET") 'newline-and-indent)

;;------------------switch between .h <--> .cpp/.m/.cxx--------------------
(defun switch-head2source-file ()
  "if current file is a header file, then open the corresponding source file or vice versa."
  (interactive)
  (let ((f (buffer-file-name))
        (headers '("h" "hpp" "hxx"))
        (sources '("c" "cxx" "cpp" "cc" "m")))
    (if f
        (let* ((b (file-name-sans-extension f))
               (x (file-name-extension f))
               (s (cond
                   ((member x headers) sources)
                   ((member x sources) headers)
                   (t nil)))
               (return-value nil))
          (while s
            (let ((try-file (concat b "." (car s))))
              (cond
               ((find-buffer-visiting try-file)
                (switch-to-buffer (find-buffer-visiting
                                   try-file))
                (setq s nil
                      return-value t))
               ((file-readable-p try-file)
                (find-file try-file)
                (setq s nil
                      return-value t))
               (t (setq s (cdr s))))))
          return-value))))
(global-set-key [(control c) (control t)] 'switch-head2source-file)

;;-------------get etags file intelligently-----------------
(add-to-list 'load-path (concat EMACS_VENDOR "/etags-extend/"))
(require 'etags-select)
(require 'etags-table)
(setq etags-table-search-up-depth 10)
;; create tags for the files in a directory
(defun create-tags (directory)
  "Create tags file."
  (interactive "DDirectory: ")
  (let ((code-file-extension-list '("*.py" "*.sh" "*.rb" "*.pl"
                                    "*.h" "*.cpp" "*.c" "*.cxx"
                                    "*.erl" "*.java" "*.el")))
    (dolist (code-file code-file-extension-list)
      (shell-command (format "find %s -name \"%s\" | etags -a -"
                             directory code-file)))))

;;--------------------python ide provided by Gabriele Lanaro --------------------
;;;1. install the dependencies
;;; $ sudo apt-get install pymacs pyflakes
;;;2. get the package emacs-for-python and put somewhere
;;; side effects: yasnippet, eshell and auto-complete configurations
(add-to-list 'load-path (concat EMACS_VENDOR "/emacs-for-python/") ;; tell where to load the various files
(require 'epy-setup)      ;; It will setup other loads, it is required!
(require 'epy-python)     ;; If you want the python facilities [optional]
(require 'epy-completion) ;; If you want the autocompletion settings [optional]
(require 'epy-editing)    ;; For configurations related to editing [optional]
(require 'epy-bindings)   ;; For my suggested keybindings [optional]
(require 'epy-nose)       ;; For nose integration


;;(setq skeleton-pair nil)
;; Python Hook
;; (add-hook 'python-mode-hook
;;           (function (lambda ()
;;                       (setq indent-tabs-mode nil
;;                             tab-width 4))))


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


;;--------------------define smart compile behavior --------------------
(global-set-key (kbd "<f8>") 'smart-compile)
(defun smart-compile()
  "If makefile exists, compile with it. Otherwise build compile instructions"
  (interactive)
  (let ((candidate-make-file-name '("makefile" "Makefile" "GNUmakefile"))
        (command nil))
    (if (not (null
              (find t candidate-make-file-name :key
                    #'(lambda (f) (file-readable-p f)))))
        (setq command "make -k ")
      ;; Makefile doesn't exist
      (if (null (buffer-file-name (current-buffer)))
          (message "Buffer not attached to a file, won't compile!")
        (if (eq major-mode 'c-mode)
            (setq command
                  (concat "gcc -Wall -o "
                          (file-name-sans-extension
                           (file-name-nondirectory buffer-file-name))
                          " "
                          (file-name-nondirectory buffer-file-name)
                          " -g -lm "))
          (if (eq major-mode 'c++-mode)
              (setq command
                    (concat "g++ -Wall -o "
                            (file-name-sans-extension
                             (file-name-nondirectory buffer-file-name))
                            " "
                            (file-name-nondirectory buffer-file-name)
                            " -g -lm "))
            (message "Unknow mode, won't compile!")))))
    (if (not (null command))
        (let ((command (read-from-minibuffer "Compile command: " command)))
          (compile command)))))

;;------------matlab-emacs mode--------------------
;;To enable emacsclient in your emacs
(server-start)
;;setup the matlab-emacs mode
(add-to-list 'load-path (concat EMACS_VENDOR "/matlab-emacs/matlab-emacs/"))
(load-library "matlab-load")

;;--------------------gdb configuration--------------------
(setq gdb-many-windows t)
(defun show-debugger ()
  (interactive)
  (let ((gud-buf
         (catch 'found
           (dolist (buf (buffer-list))
             (if (string-match "\\*gud-" (buffer-name buf))
                 (throw 'found buf))))))
    (if gud-buf
        (switch-to-buffer-other-window gud-buf)
      (call-interactively 'gdb))))
;; --8<-------------------------- separator ------------------------>8--
(eval-after-load "gdb-ui"
  '(defun gdb-display-buffer (buf dedicated &optional frame)
     (let ((answer (get-buffer-window buf (or frame 0))))
       (if answer
           (display-buffer buf t (or frame 0)) ;Deiconify the frame if necessary.
         (let ((window (get-lru-window)))
           (if (memq (buffer-local-value 'gud-minor-mode (window-buffer window))
                     '(gdba gdbmi))
               (let* ((largest (get-largest-window))
                      (cur-size (window-height largest)))
                 (setq answer (split-window largest))
                 (set-window-buffer answer buf)
                 (set-window-dedicated-p answer dedicated)
                 answer)
             (set-window-buffer window buf)
             window))))))

;;--------------------enable webjump in c++ mode
(define-key c-mode-base-map [(meta j)] 'webjump)
