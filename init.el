;;-------------------------------------------------------------------
;; \file init.el
;; \brief 
;; \author Ning Zhou 
;; \date  <2016-06-06>
;;-------------------------------------------------------------------



;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

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
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(dired-recursive-copies (quote always))
 '(dired-recursive-deletes (quote always))
 '(package-selected-packages
   (quote
    (ox-gfm markdown-mode+ yaml-mode yagist writeroom-mode workgroups2 wgrep w3m unfill tidy textile-mode tagedit swiper smex simple-httpd session scss-mode scratch rvm robe rinari request regex-tool rainbow-delimiters quack pomodoro pointback paredit page-break-lines nvm neotree mwe-log-commands multiple-cursors multi-term move-text markdown-mode lua-mode link less-css-mode legalese js2-mode idomenu ido-completing-read+ ibuffer-vc hydra htmlize hl-sexp haskell-mode haml-mode groovy-mode gitignore-mode gitconfig-mode git-timemachine git-messenger git-link git-gutter ggtags fringe-helper flyspell-lazy flymake-ruby flymake-lua flymake-jslint flymake-css flymake-coffee flx-ido expand-region exec-path-from-shell erlang emmet-mode elpy dsvn dropdown-list dired+ diminish dictionary define-word cpputils-cmake connection company-c-headers color-theme coffee-mode cmake-mode cliphist buffer-move bookmark+ bbdb auto-compile ace-window)))
 '(w3m-command-arguments (quote ("-cookie" "-F")))
 '(w3m-default-display-inline-images t)
 '(w3m-fill-column 100)
 '(w3m-form-input-map-mode-hook (quote (flyspell-mode)))
 '(w3m-home-page "http://www.google.com/ncr")
 '(w3m-key-binding (quote info))
 '(w3m-session-load-crashed-sessions nil)
 '(w3m-tab-width 4)
 '(w3m-use-cookies t)
 '(w3m-use-title-buffer-name t)
 '(w3m-view-this-url-new-session-in-background t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
