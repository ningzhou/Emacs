;;; online-search-conf.el --- 

;; Copyright (C) 2013  ning zhou

;; Author: ning zhou <ning@t5500>
;; Keywords: 

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary: shamelessly copied from Denny's setting

;; 

;;; Code:
;; -*- coding: utf-8 -*-
;; File: online-search-setting.el --- search internet for online dictionary, api reference, or search local index
;;
;; Author: Denny Zhang(markfilebat@126.com)
;; Created: 2008-10-01
;; Updated: Time-stamp: <2012-05-16 08:11:55>
;;
;; --8<-------------------------- separator ------------------------>8--
;;(setq browse-url-browser-function 'w3m-browse-url) ;; w3m
(setq browse-url-default-browser "/usr/bin/chromium-browser")
;; --8<-------------------------- separator ------------------------>8--
(load-file (concat DENNY_CONF "/emacs_conf/online-search/online-search.el"))
(global-set-key [(control c) (s)] 'online-search)
;; If current environment is windows, w3m may be probably not available.
;; In this case downgrade from w3m mode to plaintext mode.
(if (eq system-type 'windows-nt)
    (setq is-plaintext-enable 't))
;; --8<-------------------------- separator ------------------------>8--
;; search python document
(setq pylookup-dir (concat EMACS_VENDOR "/pylookup"))
(add-to-list 'load-path pylookup-dir)
;; load pylookup when compile time
(eval-when-compile (require 'pylookup))

;; set executable file and db file
(setq pylookup-program (concat pylookup-dir "/pylookup.py"))
(setq pylookup-db-file (concat pylookup-dir "/pylookup.db"))

;; to speedup, just load it on demand
(autoload 'pylookup-lookup "pylookup"
  "Lookup SEARCH-TERM in the Python HTML indexes." t)
(autoload 'pylookup-update "pylookup"
  "Run pylookup-update and create the database at `pylookup-db-file'." t)
;; --8<-------------------------- separator ------------------------>8--
;;search c/c++ document
(setq cclookup-dir (concat EMACS_VENDOR "/cclookup"))
(add-to-list 'load-path cclookup-dir)
;; load cclookup when compile time
(eval-when-compile (require 'cclookup))

;; set executable file and db file
(setq cclookup-program (concat cclookup-dir "/cclookup.py"))
(setq cclookup-db-file (concat cclookup-dir "/cclookup.db"))

;; to speedup, just load it on demand
(autoload 'cclookup-lookup "cclookup"
  "Lookup SEARCH-TERM in the C++ Reference indexes." t)
(autoload 'cclookup-update "cclookup"
  "Run cclookup-update and create the database at `cclookup-db-file'." t)
;; --8<-------------------------- separator ------------------------>8--
;; File: online-search-setting.el ends here


;;; online-search-conf.el ends here
