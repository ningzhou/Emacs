;(require 'cedet)
(add-to-list 'load-path (concat EMACS_DIR "/vendor/cedet-1.0pre7/cogre"))
(add-to-list 'load-path (concat EMACS_DIR "/vendor/cedet-1.0pre7/contrib"))
(add-to-list 'load-path (concat EMACS_DIR "/vendor/cedet-1.0pre7/ede"))
(add-to-list 'load-path (concat EMACS_DIR "/vendor/cedet-1.0pre7/eieio"))
(add-to-list 'load-path (concat EMACS_DIR "/vendor/cedet-1.0pre7/semantic"))
(add-to-list 'load-path (concat EMACS_DIR "/vendor/cedet-1.0pre7/speedbar"))
(add-to-list 'load-path (concat EMACS_DIR "/vendor/cedet-1.0pre7/srecode"))
(add-to-list 'load-path (concat EMACS_DIR "/vendor/cedet-1.0pre7/test"))
(load-file (concat EMACS_DIR "/vendor/cedet-1.0pre7/common/cedet.el"))
(global-ede-mode t)                    ; Enable the Project management system
(global-srecode-minor-mode 1)          ; Enable template insertion menu
(semantic-load-enable-code-helpers)    ; Enable prototype help and smart completion
