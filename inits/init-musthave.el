;;-------------------------------------------------------------------
;; \file init-musthave.el
;; \brief 
;; \author Ning Zhou 
;; \date  <2013-05-10>
;; \update Time-stamp: <2016-06-07 22:48:12>
;;-------------------------------------------------------------------

;; ibuffer by default
(global-set-key (kbd "C-x C-b") 'ibuffer)
;; Ido mode with fuzzy matching
(require 'ido)
(ido-mode t)
;;(ido-everywhere t)
(setq ido-enable-flex-matching t) ;; enable fuzzy matching

;;--------------------show recent files--------------------
(require 'recentf)
(recentf-mode 1)
(setq recentf-max-saved-items 100)
;;(setq recentf-auto-cleanup 300)
(defun recentf-open-files-compl ()
  (interactive)
  (let* ((all-files recentf-list)
         (tocpl (mapcar (function
                         (lambda (x) (cons (file-name-nondirectory x) x))) all-files))
         (prompt (append '("File name: ") tocpl))
         (fname (completing-read (car prompt) (cdr prompt) nil nil)))
    (find-file (cdr (assoc-string fname tocpl)))))
(global-set-key [(control x)(control r)] 'recentf-open-files-compl)

;;--------------------remember where you were in a file--------------------
(require 'saveplace)
(setq save-place-file "~/.emacs.d/saved-places")
(setq-default save-place t) ;; activate it for all buffers

;;--------------------on duplicate filenames, show path names, not foo.x<2>, foo.x<3>, etc.
(require 'uniquify)
(setq uniquify-buffer-name-style 'reverse
      uniquify-separator " • "
      uniquify-after-kill-buffer-p t
      uniquify-ignore-buffers-re "^\\*")

;;--------------------hightlight symbol--------------------
;;(load-file (concat EMACS_VENDOR "/highlight-symbol/highlight-symbol.el"))
(require 'highlight-symbol)
(global-set-key (kbd "<C-f6>") 'highlight-symbol-at-point)
(global-set-key (kbd "<S-f6>") 'hightlight-symbol-prev)
(global-set-key (kbd "<M-f6>") 'highlight-symbol-next)

;; rect-mark 
(load-file (concat EMACS_VENDOR "/rect-mark/rect-mark.el"))
;;(require 'rect-mark)
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
(autoload 'rm-mouse-drag-region "rect-mark"
  "Drag out a rectangular region with the mouse." t)

;; htmlize package
;;(load-file (concat EMACS_VENDOR "/htmlize.el"))

;;--------------------loccur package--------------------
;; list occurs in current window
;; (load-file (concat EMACS_VENDOR "/loccur/loccur.el"))
(require 'loccur)
;; defines shortcut for loccur of the current word
(define-key global-map [(control meta o)] 'loccur-current)
(set-face-background 'isearch "#537182")
(set-face-foreground 'isearch "AntiqueWhite2")
(define-key global-map [(control meta u)] 'loccur-skeleton)
(defun loccur-skeleton ()
  "Call `loccur' for code skeleton with the same leading whitespace."
  (interactive)
  (let ((point-orig (point)) leading-str (whitespace-count 0))
    (save-excursion
      (move-beginning-of-line nil)
      (if (eq (point) point-orig)
          ;; pressing in the head of the line
          (loccur (format "^[^ %c]" 9))
        (progn
          (setq leading-str (buffer-substring-no-properties point-orig (point)))
          (dolist (ch (string-to-list leading-str))
            (if (eq ch 32)
                (setq whitespace-count (+ 1 whitespace-count))
              )))
        (if (eq 0 whitespace-count)
            (loccur (format "^[^ ]" whitespace-count))
          (loccur (format "^ \\{1,%d\\}[^ ]\\|^[^ ]" whitespace-count)))
        ))))

;;--------------------color-moccur mode----------------------
;;; Functions
;; moccur, dmoccur, dired-do-moccur, Buffer-menu-moccur,
;; grep-buffers, search-buffers, occur-by-moccur
;; isearch-moccur
;; moccur-grep, moccur-grep-find
(require 'color-moccur)

;;------------------------------hide region package------------------------------
;; (require 'hide-region)
;; (defun hide-region-settings ()
;;   "Settings for `hide-region'."
;;   (setq hide-region-before-string "[=============the region ")
;;   (setq hide-region-after-string "is hidden=============]\n"))
;; (eval-after-load 'hide-region '(hide-region-settings))
;; (global-set-key (kbd "C-x M-r") 'hide-region-hide)
;; (global-set-key (kbd "C-x M-R") 'hide-region-unhide)

;;------------------------------thumbs mode------------------------------
(require 'thumbs)
(auto-image-file-mode t)
(setq thumbs-geometry "80x80")
(setq thumbs-per-line 3)
(setq thumbs-max-image-number 8)

;;------------------------------elscreen mode------------------------------
;; (require 'elscreen)
;; (eval-after-load 'elscreen
;;   '(progn
;;      ;; Disable tab by default, try M-x elscreen-toggle-display-tab to show tab
;;      (setq elscreen-display-tab nil)
;;      ;; default prefix key(C-z), is hard to invoke
;;      (elscreen-set-prefix-key (kbd "C-e"))))
;; ;; create screen automatically when there is only one screen
;; (defmacro elscreen-create-automatically (ad-do-it)
;;   ` (if (not (elscreen-one-screen-p))
;;         ,ad-do-it
;;       (elscreen-create)
;;       (elscreen-notify-screen-modification 'force-immediately)
;;       (elscreen-message "New screen is automatically created")))

;; (defadvice elscreen-next (around elscreen-create-automatically activate)
;;   (elscreen-create-automatically ad-do-it))

;; (defadvice elscreen-previous (around elscreen-create-automatically activate)
;;   (elscreen-create-automatically ad-do-it))

;; (defadvice elscreen-toggle (around elscreen-create-automatically activate)
;;   (elscreen-create-automatically ad-do-it))
;; (elscreen-start) ;; start elscreen 
;; ;; each of screens to have independent buffer lists
;; ;; seems not work; maybe i configured incorrect
;; ;; (load-file (concat EMACS_VENDOR "/elscreen-buffer-list.el")) 

;; ;;------------------------------recent jump------------------------------
;; (load-file (concat EMACS_VENDOR "/recent-jump/recent-jump.el"))
;; (setq recent-jump-threshold 8) ;;the number of lines used to determin a big-jump or not
;; (setq recent-jump-ring-length 20) 
;; (global-set-key (kbd "C-c ,") 'recent-jump-jump-backward)
;; (global-set-key (kbd "C-c >") 'recent-jump-jump-forward) 

;;------------------------------yasnippet------------------------------
(require 'yasnippet)
;; (yas/load-directory (concat EMACS_DIR "/snippets"))
(setq yas-snippet-dirs (expand-file-name "snippets/" (concat EMACS_DIR "/")))
;;(yas--initialize)
(yas-load-directory yas-snippet-dirs nil)
(yas-global-mode 1)


;;---------------------------smex--------------
(require 'smex) ; Not needed if you use package.el
(smex-initialize) ; Can be omitted. This might cause a (minimal) delay
                  ; when Smex is auto-initialized on its first run.
(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "M-X") 'smex-major-mode-commands)
;; This is your old M-x.
(global-set-key (kbd "C-c C-c M-x") 'execute-extended-command)

(provide 'init-musthave)
