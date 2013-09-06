(load "auctex.el" nil t t)
(load "preview-latex.el" nil t t)
(add-hook 'LaTeX-mode-hook 'LaTeX-install-toolbar)
(add-hook 'LaTeX-mode-hook 'turn-on-reftex) ; with AUCTeX LaTeX mode
(add-hook 'latex-mode-hook 'turn-on-reftex) ; with Emacs latex mode
(setq TeX-auto-save t)
(setq TeX-parse-self t)


;;Let RefTeX finds my bibliography
(setq reftex-default-bibliography '("~/Dropbox/my_papers/uncc_tr_2012/nzhou_bibdatabase_v1.2.bib"))

;; Let RefTeX also recognizes \addbibresource. Note that you
;; can't use $HOME in path for \addbibresource but that "~"
;; works.
(setq reftex-bibliography-commands '("bibliography" "nobibliography" "addbibresource"))
