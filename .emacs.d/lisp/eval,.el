;; Evaluate source

(require 'map\,)

(defvar source-map nil)
(defvar buffer-select nil)
(defvar buffer-select-max 5)

(defvar source-mode-alist
  '(("\\.c\\'" . c-mode)
    ("\\.h\\'" . c-mode)
    ("\\.py\\'" . python-mode)
    ("\\.el\\'" . elisp-mode))
  "(REGEXP . MAJOR-MODE)")

(defmacro make-sourcemap (&optional bind)
  `(make-map 'smap ,bind))

(defmacro define-sourcemap (map key bind)
  `(define-map ,map 'smap ,key ,bind))

(defun select-buffer ()
  (interactive)
  (if (>= (length buffer-select) buffer-select-max)
      (message "Out of range, %s, %d" buffer-select (length buffer-select))
    (let ((buffer (current-buffer)))
      (and (not (member buffer buffer-select))
	   (push buffer buffer-select)))))

(key-chord-define-global [?\;?s] 'select-buffer)

(defun filter-source-map (&optional buffer-select)
  (when buffer-select
    (if (not (consp buffer-select))
      (error "Invalid arg type, %s" buffer-select))
    (if (> (length buffer-select) buffer-select-max)
      (error "Arg out of range, %d" (length buffer-select))))
  (let ((smap (make-sourcemap)))
    (dolist (buffer (or buffer-select (buffer-list)))
      (when (buffer-live-p buffer)
	(with-current-buffer buffer
	  (let ((name (buffer-name))
		(file buffer-file-name)
		(mode major-mode))
	    (when (and (not (string-match-p "\\` " name))
		       (not buffer-read-only)
		       (and file
			    (file-readable-p file)
			    (file-writable-p file)
			    (file-regular-p file)
			    (not (file-directory-p file))))
	      ;; (push name files)
	      )))))
    ;; (setq source-map (nreverse files))
    ))

;; (filter-source-map)
;; ("evalin.el" "frame.c" "launch.el")
;; ("evalin.el" "lisp.h" "launch.el")
;; ("evalin.el" "frame.c" "terminal.c" "keymap.h" "keymap.c" "lread.c" "lisp.h" "launch.el" "layout.el")
;; ("terminal.c" "evalin.el" "keymap.h" "keymap.c" "lread.c" "lisp.h" "launch.el" "layout.el")

;; (apply 'compile
;;        (list "gcc -o lisp lisp.c"))

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

(provide 'eval\,)
