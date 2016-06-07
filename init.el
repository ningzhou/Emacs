;;-------------------------------------------------------------------
;; \file init.el
;; \brief 
;; \author Ning Zhou 
;; \date  <2016-06-06>
;;-------------------------------------------------------------------

(defconst EMACS_DIR "~/.emacs.d")
(defconst EMACS_VENDOR "~/.emacs.d/vendor")
(defconst NZHOU_DATA "~/emacs_data")
(setq emacs-start-time (current-time))
(when (< emacs-major-version 22)
  (error "This configuration requires a later version of Emacs 22.0"))

;;load different configuration fileinit.el
(add-to-list 'load-path (expand-file-name (concat EMACS_DIR "/inits")))
(require 'init-elpa)
;; if system is OS X 
(when (eq system-type 'darwin)
  (require 'init-osx))
(require 'init-color-theme)
(require 'init-fonts)
(require 'init-essential)
(require 'init-musthave)
(require 'init-clipboard)
(require 'init-dired)
(require 'init-shell)
(require 'init-magit)
(require 'init-buffer)
(require 'init-evil)
(require 'init-utils)
(require 'init-program)
;;(require 'init-company)
;;(require 'init-auctex)
;;(require 'init-cedet)

(when (require 'time-date nil t)
  (message "Emacs takes %d seconds to start!"
           (time-to-seconds (time-since emacs-start-time))))
