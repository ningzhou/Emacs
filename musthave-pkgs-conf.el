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

;;--------------------monokai theme for emacs24--------------------
(load-file  (concat EMACS_VENDOR "/color-theme/monokai-theme.el"))
(load-theme 'monokai t)

;; ibuffer by default
(global-set-key (kbd "C-x C-b") 'ibuffer)
;; Ido mode with fuzzy matching
(require 'ido)
(ido-mode t)
(ido-everywhere t)
(setq ido-enable-flex-matching t) ;; enable fuzzy matching


;;--------------------show recent files--------------------
(require 'recentf)
(recentf-mode 1)
(setq recentf-max-saved-items 100)
;; (setq recentf-auto-cleanup 300)
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
(setq save-place-file (concat NZHOU_DATA "emacs_data/nzhou.saveplace"))
(setq-default save-place t) ;; activate it for all buffers

;; on duplicate filenames, show path names, not foo.x<2>, foo.x<3>, etc.
(require 'uniquify)
(setq uniquify-buffer-name-style 'reverse
      uniquify-separator " • "
      uniquify-after-kill-buffer-p t
      uniquify-ignore-buffers-re "^\\*")


;; TODO: frame configuration
;; (add-to-list 'load-path (concat EMACS_VENDOR "/frame"))
;; (load-file (concat EMACS_VENDOR "/frame/frame-fns.el"))
;; (load-file (concat EMACS_VENDOR "/frame/frame-cmds.el"))
;; (global-set-key [(control up)] 'move-frame-up)
;; (global-set-key [(control down)] 'move-frame-down)
;; (global-set-key [(control left)] 'move-frame-left)
;; (global-set-key [(control right)] 'move-frame-right)

;; hightlight symbol
(load-file (concat EMACS_VENDOR "/highlight-symbol/highlight-symbol.el"))
(global-set-key (kbd "<C-f5>") 'highlight-symbol-at-point)
(global-set-key (kbd "<f5>") 'hightlight-symbol-next)
(global-set-key (kbd "<S-f5>") 'highlight-symbol-prev)

;; rect-mark 
(load-file (concat EMACS_VENDOR "/rect-mark/rect-mark.el"))
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

;; loccur package
(load-file (concat EMACS_VENDOR "/loccur/loccur.el"))
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

;; color-moccur mode
(load-file (concat EMACS_VENDOR "/color-moccur/color-moccur.el"))

;; cursor change package
(load-file (concat EMACS_VENDOR "/cursor-change/cursor-chg.el"))
(change-cursor-mode 1) ; On for overwrite/read-only/input mode
(toggle-cursor-type-when-idle 1) ; On when idle
(setq curchg-default-cursor-color "green")

;; hide region package
(load-file (concat EMACS_VENDOR "/hide-region/hide-region.el"))
(defun hide-region-settings ()
  "Settings for `hide-region'."
  (setq hide-region-before-string "[=============the region ")
  (setq hide-region-after-string "is hidden=============]\n"))
(eval-after-load 'hide-region '(hide-region-settings))
(global-set-key (kbd "C-x M-r") 'hide-region-hide)
(global-set-key (kbd "C-x M-R") 'hide-region-unhide)


;; abbrev mode
;; (setq default-abbrev-mode t)
;; (setq abbrev-file-name                     ;; tell emacs where to read abbrev  
;;       (concat EMACS_DATA "/nzhou.abbrev"))  ;; definitions file
;; (setq save-abbrevs t)              ;; save abbrevs when files are saved  
;;                                    ;; you will be asked before the abbreviations are saved  
;; ;avoid errors if the abbrev-file is missing  
;; (if (file-exists-p abbrev-file-name)  
;;        (quietly-read-abbrev-file))

;; thumbs mode
(require 'thumbs)
(auto-image-file-mode t)
(setq thumbs-geometry "80x80")
(setq thumbs-per-line 3)
(setq thumbs-max-image-number 8)

;; elscreen mode
(add-to-list 'load-path (concat EMACS_VENDOR "/elscreen/elscreen-1.4.6/elscreen.el"))
(eval-after-load 'elscreen
  '(progn
     ;; Disable tab by default, try M-x elscreen-toggle-display-tab to show tab
     (setq elscreen-display-tab nil)
     ;; default prefix key(C-z), is hard to invoke
     (elscreen-set-prefix-key (kbd "M-s"))))
;; create screen automatically when there is only one screen
(defmacro elscreen-create-automatically (ad-do-it)
  ` (if (not (elscreen-one-screen-p))
        ,ad-do-it
      (elscreen-create)
      (elscreen-notify-screen-modification 'force-immediately)
      (elscreen-message "New screen is automatically created")))

(defadvice elscreen-next (around elscreen-create-automatically activate)
  (elscreen-create-automatically ad-do-it))

(defadvice elscreen-previous (around elscreen-create-automatically activate)
  (elscreen-create-automatically ad-do-it))

(defadvice elscreen-toggle (around elscreen-create-automatically activate)
  (elscreen-create-automatically ad-do-it))

;; recent jump 
(load-file (concat EMACS_VENDOR "/recent-jump/recent-jump.el"))
(setq recent-jump-threshold 8) ;;the number of lines used to determin a big-jump or not
(setq recent-jump-ring-length 20) 
(global-set-key (kbd "C-,") 'recent-jump-jump-backward)
(global-set-key (kbd "M-.") 'recent-jump-jump-forward)

;; TODO: hide and show comments in code
;; (load-file (concat EMACS_VENDOR "/hide-comnt/hide-comnt.el"))
;; (require 'newcomment nil t)
;; (require 'hide-comnt)
;; (global-set-key [(meta p)(t)] 'hide/show-comments-toggle)


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
