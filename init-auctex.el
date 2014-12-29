;;(add-to-list 'load-path (concat EMACS_VENDOR "/auctex-11.87"))
(load "auctex.el" nil t t)
(load "preview-latex.el" nil t t)
(add-hook 'LaTeX-mode-hook 'LaTeX-install-toolbar)
(add-hook 'LaTeX-mode-hook 'turn-on-reftex) ; with AUCTeX LaTeX mode
(add-hook 'latex-mode-hook 'turn-on-reftex) ; with Emacs latex mode
(setq TeX-auto-save t)
(setq TeX-parse-self t)

(setenv "PATH" (concat  "/usr/local/texlive/2013/bin/x86_64-linux:" (getenv "PATH")))

;;Let RefTeX finds my bibliography
(setq reftex-default-bibliography '("~/Dropbox/my_papers/bibliography/nzhou_bibdatabase_v1.3.bib"))
(setq reftex-default-bibliography '("~/Dropbox/my_papers/dissertation/dissertation_draft/nzhou_bibdatabase_v1.4.bib"))
;; Let RefTeX also recognizes \addbibresource. Note that you
;; can't use $HOME in path for \addbibresource but that "~"
;; works.
(setq reftex-bibliography-commands '("bibliography" "nobibliography" "addbibresource"))
