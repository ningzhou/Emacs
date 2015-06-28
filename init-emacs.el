;;set the directory of the configuration files
(defconst EMACS_DIR "~/myemacs")
(defconst EMACS_VENDOR "~/myemacs/vendor")
(defconst NZHOU_DATA "~/emacs_data")
(setq emacs-start-time (current-time))
(when (< emacs-major-version 22)
  (error "This configuration requires a later version of Emacs 22.0"))

;;load different configuration files
(load-file (concat EMACS_DIR "/init-elpa.el"))
;; if system is OS X 
(when (eq system-type 'darwin)
  (load-file (concat EMACS_DIR "/init-osx.el")))

(load-file (concat EMACS_DIR "/init-essential.el"))
(load-file (concat EMACS_DIR "/init-musthave.el"))
(load-file (concat EMACS_DIR "/init-org.el"))
(load-file (concat EMACS_DIR "/init-web.el"))
(load-file (concat EMACS_DIR "/init-dired.el"))
(load-file (concat EMACS_DIR "/init-shell.el"))
(load-file (concat EMACS_DIR "/init-program.el"))
(load-file (concat EMACS_DIR "/init-magit.el"))
(load-file (concat EMACS_DIR "/init-buffer.el"))
(load-file (concat EMACS_DIR "/init-utils.el"))
(load-file (concat EMACS_DIR "/init-evil.el"))
;;(load-file (concat EMACS_DIR "/init-company.el"))
;;(load-file (concat EMACS_DIR "/init-auctex.el"))
;;(load-file (concat EMACS_DIR "/abbrev-skeleton.el"))
;;(load-file (concat EMACS_DIR "/init-cedet.el"))
;;(load-file (concat EMACS_DIR "/init-ergoemacs.el"))

(when (require 'time-date nil t)
  (message "Emacs takes %d seconds to start!"
           (time-to-seconds (time-since emacs-start-time))))
