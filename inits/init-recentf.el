;;-------------------------------------------------------------------
;; \file init-recentf.el
;; \brief show recent files
;; \author Ning Zhou 
;; \date  <2016-06-12>
;;-------------------------------------------------------------------

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


(provide 'init-recentf)
