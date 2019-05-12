;; Evaluate source

(require 'compile)

(defvar source-list nil)

(defvar source-mode-alist
  '(("\\.c\\'" . c-mode)
    ("\\.h\\'" . c-mode)
    ("\\.py\\'" . python-mode)
    ("\\.el\\'" . elisp-mode))
  "Alist of source file patterns with corresponding major mode.
Each has form of (REGEXP . MODE).")

(defun filter-source-list (&optional buffer-list)
  (let (files)
    (dolist (buffer (or buffer-list (buffer-list)))
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

;; buffer-file-name
;; "/home/iy/.emacs.d/lisp/eval-easy.el"
;; default-directory
;; "/home/iy/.emacs.d/lisp/"
;; (buffer-name)
;; "eval-easy.el"

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

(provide 'eval-source)
