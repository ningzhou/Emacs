;;-------------------------------------------------------------------
;; \file init-uniquify.el
;; \brief 
;; \author Ning Zhou 
;; \date  <2016-06-12>
;;-------------------------------------------------------------------

;; on duplicate filenames, show path names, not foo.x<2>, foo.x<3>, etc.
(require 'uniquify)
(setq uniquify-buffer-name-style 'reverse
      uniquify-separator " • "
      uniquify-after-kill-buffer-p t
      uniquify-ignore-buffers-re "^\\*")


(provide 'init-uniquify)
