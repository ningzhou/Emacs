;;set the directory of the configuration files
(defconst EMACS_DIR "~/myemacs")
(defconst EMACS_VENDOR "~/myemacs/vendor")
(defconst NZHOU_DATA "~/Dropbox/emacs_data")
;;load vendors
;;(add-to-list 'load-path (concat EMACS_DIR "/vendor"))
;; (let ((default-directory  ( concat EMACS_DIR "/vendor")))
;;       (normal-top-level-add-subdirs-to-load-path))
;;load different configuration files
(load-file (concat EMACS_DIR "/essential-conf.el"))
(load-file (concat EMACS_DIR "/musthave-pkgs-conf.el"))
(load-file (concat EMACS_DIR "/dired-conf.el"))
(load-file (concat EMACS_DIR "/auctex-conf.el"))
(load-file (concat EMACS_DIR "/shell-conf.el"))
(load-file (concat EMACS_DIR "/org-conf.el"))
;;(load-file (concat EMACS_DIR "/abbrev-skeleton.el"))
;;(load-file (concat EMACS_DIR "/cedet-conf.el"))
(load-file (concat EMACS_DIR "/programming-conf.el"))
(load-file (concat EMACS_DIR "/magit-conf.el"))
(load-file (concat EMACS_DIR "/web-conf.el"))


