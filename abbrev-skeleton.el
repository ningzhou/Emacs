(setq default-abbrev-mode t)
(setq abbrev-file-name             ;; tell emacs where to read abbrev  
        "~/.emacs.d/abbrev_defs")  ;; definitions from...  
(setq save-abbrevs t)              ;; save abbrevs when files are saved  
                                   ;; you will be asked before the abbreviations are saved  
;Avoid errors if the abbrev-file is missing  
(if (file-exists-p abbrev-file-name)  
       (quietly-read-abbrev-file))  

;; setup skeleton
(define-skeleton skeleton-c-mode-main-func
  "generate int main(int argc, char * argc[]) automatic" nil
  "int main (int argc, char * argv[]) \n{\n"
  > _  "\n" > "return 0;"
  "\n}")

(define-abbrev-table 'c-mode-abbrev-table '(
    ("main" "" skeleton-c-mode-main-func 1)))

(define-abbrev-table 'c-mode-abbrev-table '(
     ("main" "" skeleton-c-mode-main-func 1))
)

(define-abbrev-table 'c++-mode-abbrev-table '(
     ("main" "" skeleton-c-mode-main-func 1))
)

(define-abbrev-table 'org-mode-abbrev-table '())


(define-skeleton 1exp
  "Input #+BEGIN_EXAMPLE #+END_EXAMPLE in org-mode"
""
"#+BEGIN_EXAMPLE\n"
 _ "\n"
"#+END_EXAMPLE"
) 
(define-abbrev org-mode-abbrev-table "iexp" "" '1exp)


(define-skeleton 1srclisp
  "Input #+begin_src #+end_src in org-mode"
""
"#+begin_src lisp \n"
 _ "\n"
"#+end_src"
) 
(define-abbrev org-mode-abbrev-table "isrc" "" '1srclisp)



(define-skeleton 1srcshell
  "Input #+begin_src #+end_src in org-mode"
""
"#+begin_src shell \n"
 _ "\n"
"#+end_src"
)
(define-abbrev org-mode-abbrev-table "isrcshell" "" '1srcshell)



(define-skeleton 1prop
  "Input :PROPERTIES: :END: in org-mode"
""
>":PROPERTIES:\n"
> _ "\n"
>":END:"
) 
(define-abbrev org-mode-abbrev-table "iprop" "" '1prop)

