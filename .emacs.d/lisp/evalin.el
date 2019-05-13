;; Evaluate source

(require 'compile)

(defvar source-list nil)
(defvar buffer-select nil)

(defvar source-mode-alist
  '(("\\.c\\'" . c-mode)
    ("\\.h\\'" . c-mode)
    ("\\.py\\'" . python-mode)
    ("\\.el\\'" . elisp-mode))
  "(REGEXP . MAJOR-MODE).")

(defun select-buffer ()
  (interactive))

(defun filter-source-list (&optional buffer-select)
  (let (files)
    (dolist (buffer (or buffer-select (buffer-list)))
      (when (buffer-live-p buffer)
	(with-current-buffer buffer
	  (let ((name (buffer-name))
		(file buffer-file-name))
	    (when (and (not (string-match-p "\\` " name))
		       (not buffer-read-only)
		       (and file
			    (file-readable-p file)
			    (file-writable-p file)
			    (file-regular-p file)))
	      (push name files))))))
    (setq source-list (nreverse files))))

(filter-source-list)
("evalin.el" "frame.c" "terminal.c" "keymap.h" "keymap.c" "lread.c" "lisp.h" "launch.el" "layout.el")
("evalin.el" "frame.c" "terminal.c" "keymap.h" "keymap.c" "lread.c" "lisp.h" "launch.el" "layout.el")
("evalin.el" "terminal.c" "keymap.h" "keymap.c" "lread.c" "lisp.h" "launch.el" "layout.el")
("evalin.el" "terminal.c" "keymap.h" "keymap.c" "lread.c" "lisp.h" "launch.el" "layout.el")
("terminal.c" "evalin.el" "keymap.h" "keymap.c" "lread.c" "lisp.h" "launch.el" "layout.el")

;; (abbreviate-file-name buffer-file-name)
;; "~/.emacs.d/lisp/evalin.el"
;; (abbreviate-file-name default-directory)
;; "~/.emacs.d/lisp/"
;; (buffer-name)
;; "evalin.el"

;; (cond
;;  ((eq major-mode 'emacs-lisp-mode) BODY)
;;  ((eq major-mode 'c-mode) BODY)
;;  ((eq major-mode 'python-mode) BODY)
;;  (t BODY))

;; (apply 'compile
;;        (list "gcc -o lisp lisp.c"))

;; (buffer-list)
;; (#<buffer eval-source.el> #<buffer  *Minibuf-1*> #<buffer *Help*> #<buffer *Buffer List*> #<buffer buff-menu.el.gz> #<buffer *scratch*> #<buffer *ansi-term*> #<buffer  *Minibuf-2*> #<buffer files.el.gz> #<buffer cc-mode.el.gz> #<buffer lisp.h> #<buffer compile.el.gz> #<buffer *Messages*> #<buffer lread.c> #<buffer  *Minibuf-0*> #<buffer  *code-conversion-work*> #<buffer  *server*> #<buffer  *Echo Area 0*> #<buffer  *Echo Area 1*> #<buffer  *DOC*> #<buffer *Backtrace*> #<buffer *Completions*>)

;; (defvar gcc-option nil
;;   "GCC option

;; object
;;     gcc -c src/source.c -o bin/source.o
;;     gcc -c src/source1.c -o bin/source1.o
;;     gcc -c src/source2.c -o bin/source2.o
;; object for shared library
;;     gcc -fpic -c src/test1.c src/test2.c
;;     gcc -fpic -c src/test1.c -o bin/shared/test1.o
;;     gcc -fpic -c src/test2.c -o bin/shared/test2.o
;; object for static library
;;     gcc -c src/test1.c src/test2.c
;;     gcc -c src/test1.c -o bin/static/test1.o
;;     gcc -c src/test2.c -o bin/static/test2.o
;; shared library
;;     gcc -shared bin/shared/test1.o bin/shared/test2.o -o bin/shared/libtest.so
;; static library
;;     ar rcs bin/static/libtest.a bin/static/test1.o bin/static/test2.o
;; link
;;     gcc bin/source1.o bin/source2.o -o bin/source
;; link with shared or static library
;;     gcc bin/source.o -Lbin/shared -ltest -o bin/source-shared
;;     gcc bin/source.o -Lbin/static -ltest -o bin/source-static
;; compile and link
;;     gcc src/source.c -o bin/source
;;     gcc src/source1.c src/source2.c -o bin/source")

(provide 'evalin)
