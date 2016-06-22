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

;;load different configuration files
(add-to-list 'load-path (expand-file-name (concat EMACS_DIR "/inits")))
(require 'init-elpa)

;; if system is OS X 
(when (eq system-type 'darwin)
  (require 'init-osx))

(require 'init-essential)
(require 'init-modeline)
(require 'init-linum-mode)
(require 'init-evil)
(require 'init-color-theme)
(require 'init-ido)
(require 'init-ibuffer)
(require 'init-fonts)
(require 'init-highlight-symbol)
(require 'init-saveplace)
(require 'init-recentf)
(require 'init-uniquify)
(require 'init-smex)
;;(require 'init-musthave)
(require 'init-clipboard)
(require 'init-dired)
(require 'init-shell)
(require 'init-utils)
(require 'init-yasnippet)
(require 'init-web)
(require 'init-exec-path)
(require 'init-company)
(require 'init-flymake)
(require 'init-programming)
;;(require 'init-magit)
;;(require 'init-buffer)
;;(require 'init-auctex)
;;(require 'init-cedet)

(when (require 'time-date nil t)
  (message "Emacs takes %d seconds to start!"
           (time-to-seconds (time-since emacs-start-time))))
