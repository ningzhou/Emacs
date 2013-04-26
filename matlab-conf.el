;;To enable emacsclient in your emacs
(server-start)
;;setup the matlab-emacs mode
(add-to-list 'load-path (concat EMACS_VENDOR "/matlab-emacs/matlab-emacs/"))
(load-library "matlab-load")
