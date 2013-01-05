;;set the directory of the configuration files
(setq EMACS_DIR "~/myemacs")
;;load vendors
(add-to-list 'load-path (concat EMACS_DIR "/vendor"))
(let ((default-directory  ( concat EMACS_DIR "/vendor")))
      (normal-top-level-add-subdirs-to-load-path))
;;load different configuration files
(load-file (concat EMACS_DIR "/shell-conf.el"))
(load-file (concat EMACS_DIR "/essential-conf.el"))
(load-file (concat EMACS_DIR "/auctex-conf.el"))
(load-file (concat EMACS_DIR "/matlab-conf.el"))
(load-file (concat EMACS_DIR "/globalkey-conf.el"))
(load-file (concat EMACS_DIR "/org-conf.el"))
(load-file (concat EMACS_DIR "/abbrev-skeleton.el"))
(load-file (concat EMACS_DIR "/cedet-conf.el"))
(load-file (concat EMACS_DIR "/coding-conf.el"))

