;;-------------------------------------------------------------------
;; \file init-programming.el
;; \brief 
;; \author Ning Zhou 
;; \date  <2016-06-14>
;;-------------------------------------------------------------------

(defvar programming-mode-list (list
                               'c-mode 'c++-mode
                               'emacs-lisp-mode 'lisp-mode
                               'shel-mode
                               ;;'ruby-mode
                               'java-mode
                               'perl-mode
                               'php-mode
                               'sgml-mode
                               'erlang-mode
                               ))
(defvar programming-mode-name-list (list
                                    "C/l" "C++/l"
                                    "Emacs-Lisp" "Lisp"
                                    "Shell"
                                    "Python"
                                    ;;"Ruby"
                                    "Java/l"
                                    "Perl"
                                    "PHP"
                                    '(sgml-xml-mode "XML" "SGML")
                                    "Erlang"
                                    ))
(defvar programming-hook-list (list
                               'c-mode-hook 'c++-mode-hook
                               'emacs-lisp-mode-hook 'lisp-mode-hook
                               'shel-mode-hook
                               'python-mode-hook
                               ;;'ruby-mode-hook
                               'java-mode-hook
                               'perl-mode-hook
                               'php-mode-hook
                               'erlang-mode-hook
                               ))

;; ---------------------auto pair-----------------------------
(defun my-auto-pair ()
  (interactive)
  (make-local-variable 'skeleton-pair-alist)
  (setq skeleton-pair-alist '(
;;                              (?\( _ ")")
;;                              (?\[ _ "]")
;;                              (?\" _ "\"")
;;                              (?\' _ "\'")
                              (?{ \n > _ \n ?} >)))
  (setq skeleton-pair t)
;;  (local-set-key (kbd "(") 'skeleton-pair-insert-maybe)
;;  (local-set-key (kbd "[") 'skeleton-pair-insert-maybe)
;;  (local-set-key (kbd "\"") 'skeleton-pair-insert-maybe)
;;  (local-set-key (kbd "\'") 'skeleton-pair-insert-maybe)
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
  (add-hook hook 'enable-which-function)
  )

;;--------------------cc-mode configuration--------------------
;;(setq-default c-basic-offset 2 c-default-style "linux")
;;(define-key c-mode-base-map (kbd "RET") 'newline-and-indent)
;;(setq-default tab-width 4 indent-tabs-mode -1) ;;already defined in essentioal-conf.el
(require 'cc-mode)
(add-to-list 'load-path (concat EMACS_VENDOR "/google")) ;;indention have changed to 4
(require 'google-c-style)
(add-hook 'c-mode-common-hook 'google-set-c-style)
(add-hook 'c++-mode-common-hook 'google-set-c-style)
(add-hook 'c-mode-common-hook 'google-make-newline-indent)
(add-hook 'c++-mode-common-hook 'google-make-newline-indent)


(defun my-build-tab-stop-list (width)
  (let ((num-tab-stops (/ 80 width))
		(counter 1)
		(ls nil))
	(while (<= counter num-tab-stops)
      (setq ls (cons (* width counter) ls))
      (setq counter (1+ counter)))
    (set (make-local-variable 'tab-stop-list) (nreverse ls))))

(defun my-c-mode-common-hook ()
  ;;(c-set-style "google")
  (setq tab-width 4) ;; change this 
  (my-build-tab-stop-list tab-width)
  (setq c-basic-offset tab-width)
  (setq indent-tabs-mode nil) ;; force only spaces for indentation
  (c-set-offset 'substatement-open 0)
)

;;(add-hook 'c-mode-common-hook 'my-c-mode-common-hook)
;;(add-hook 'c++-mode-common-hook 'my-c-mode-common-hook)

;; treat .h files as c++ files
(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))

;; google cpplint for format check
(defun cpplint ()
  "check source code format according to Google Style Guide"
  (interactive)
  (compilation-start (concat "python ~/bin/cpplint.py " (buffer-file-name))))

;;(add-hook 'c-mode-common-hook 'google-set-c-style)

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


(defun vis-c-insert-include-guard()
  (interactive)
  (let ((guard-str
         (concat
          (replace-regexp-in-string "[.-]" "_"
                                    (upcase (file-name-sans-extension (buffer-name))))
          "_H")))
    (save-excursion
      (beginning-of-buffer)
      (insert (concat "#ifndef " guard-str "\n"))
      (insert (concat "#define " guard-str "\n"))
      (end-of-buffer)
      (insert "\n#endif\n"))))


;;-------------get etags file intelligently-----------------
;;(add-to-list 'load-path (concat EMACS_VENDOR "/etags-extend/"))
;;(require 'etags-select)
;;(require 'etags-table)
;;(setq etags-table-search-up-depth 10)
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

;;--------------------python ide by Gabriele Lanaro --------------------
;;;1. install the dependencies
;;; $ sudo apt-get install pymacs pyflakes
;;;2. get the package emacs-for-python and put somewhere
;;; side effects: yasnippet, eshell and auto-complete configurations
;; tell where to load the various files
;; side effects are way too much 
;; (add-to-list 'load-path (concat EMACS_VENDOR "/emacs-for-python/"))
;; (require 'epy-setup)      ;; It will setup other loads, it is required!
;; (require 'epy-python)     ;; If you want the python facilities [optional]
;; (require 'epy-completion) ;; If you want the autocompletion settings [optional]
;; (require 'epy-editing)    ;; For configurations related to editing [optional]
;; (require 'epy-bindings)   ;; For my suggested keybindings [optional]
;; (require 'epy-nose)       ;; For nose integration
(add-hook 'python-mode-hook 'my-python-hook)
(defun my-python-hook ()
  (define-key python-mode-map (kbd "RET") 'newline-and-indent))

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
                    (concat "g++ -Wall -gdwarf-3 -std=c++11 -o "
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

;;--------------------enable webjump in cc, java mode--------------------
(define-key c-mode-base-map [(ctrl j)] 'webjump)
(define-key java-mode-map [(ctrl j)] 'webjump)
(define-key c++-mode-map [(ctrl j)] 'webjump)
;;(define-key python-mode-map [(meta j)] 'webjump)

(provide 'init-programming)

