;;-------------------------------------------------------------------
;; \file init-saveplace.el
;; \brief 
;; \author Ning Zhou 
;; \date  <2016-06-12>
;;-------------------------------------------------------------------

;; remember where you were in a file
(require 'saveplace)
(setq save-place-file "~/.emacs.d/saved-places")
(setq-default save-place t) ;; activate it for all buffers

(provide 'init-saveplace)
