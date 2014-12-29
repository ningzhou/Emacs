;;set the directory of the configuration files
(defconst EMACS_DIR "~/myemacs")
(defconst EMACS_VENDOR "~/myemacs/vendor")
(defconst NZHOU_DATA "~/Dropbox/emacs_data")
(setq emacs-start-time (current-time))
(when (< emacs-major-version 22)
  (error "This configuration requires a later version of Emacs 22.0"))

;;load different configuration files
(load-file (concat EMACS_DIR "/packages-conf.el"))
;; if system is OS X 
(when (eq system-type 'darwin)
  (load-file (concat EMACS_DIR "/mac-conf.el")))

(load-file (concat EMACS_DIR "/essential-conf.el"))
(load-file (concat EMACS_DIR "/musthave-pkgs-conf.el"))
(load-file (concat EMACS_DIR "/org-conf.el"))
(load-file (concat EMACS_DIR "/web-conf.el"))
(load-file (concat EMACS_DIR "/dired-conf.el"))
;;(load-file (concat EMACS_DIR "/auctex-conf.el"))
;;(load-file (concat EMACS_DIR "/abbrev-skeleton.el"))
;;(load-file (concat EMACS_DIR "/cedet-conf.el"))
(load-file (concat EMACS_DIR "/shell-conf.el"))
(load-file (concat EMACS_DIR "/programming-conf.el"))
(load-file (concat EMACS_DIR "/magit-conf.el"))
(load-file (concat EMACS_DIR "/buffer-conf.el"))
(load-file (concat EMACS_DIR "/utils.el"))
(load-file (concat EMACS_DIR "/ergoemacs-conf.el"))

(when (require 'time-date nil t)
  (message "Emacs takes %d seconds to start!"
           (time-to-seconds (time-since emacs-start-time))))
