;; Evaluate source

(require 'compile)

(defvar source-map nil)
(defvar buffer-select nil)
(defvar buffer-select-max 5)

(defvar source-mode-alist
  '(("\\.c\\'" . c-mode)
    ("\\.h\\'" . c-mode)
    ("\\.py\\'" . python-mode)
    ("\\.el\\'" . elisp-mode))
  "(REGEXP . MAJOR-MODE)")

(defun select-buffer ()
  (interactive)
  (if (>= (length buffer-select) buffer-select-max)
      (message "Out of range, %s, %d" buffer-select (length buffer-select))
    (let ((buffer (current-buffer)))
      (and (not (member buffer buffer-select))
	   (push buffer buffer-select)))))

(key-chord-define-global [?\;?s] 'select-buffer)

(defun make-source-map (&optional string)
  (if string (list 'smap string) (list 'smap)))

(defun smapp (object)
  (if (and (consp object) (listp (cdr object)) (eq (car object) 'smap)) t nil))

(defun smap-get-map (map key &optional testfn)
  (let (return)
    (and (smapp map)
	 (setq return
	       (let ((tail (cdr map)))
		 (catch 'done
		   (while (consp tail)
		     (and (consp (car tail))
			  (let* ((this-map (car tail)) (this-key (car this-map)))
			    (if (funcall (or testfn 'eq) this-key key) (throw 'done this-map))))
		     (setq tail (cdr tail)))))))
    return))

(defun smap-map (map key bind)
  (and (smapp map)
       (append map (list
		    (let* ((this-key (elt key 0))
			   (rest-key (seq-drop key 1))
			   (this-map (smap-get-map map this-key)))
		      (if (null this-map)
			  (cons this-key
				(if (> (length rest-key) 0)
				    (let ((map (make-source-map)))
				      (smap-map map rest-key bind))
				  bind))
			ELSE))))))

(defmacro define-source (map key bind)
  `(let ((let-map (smap-map ,map ,key ,bind)))
     (and let-map (setq map let-map) ,bind)))

(defun filter-source-map (&optional buffer-select)
  (when buffer-select
    (if (not (consp buffer-select))
      (error "Invalid arg type, %s" buffer-select))
    (if (> (length buffer-select) buffer-select-max)
      (error "Arg out of range, %d" (length buffer-select))))
  (let ((smap (make-source-map)))
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

(provide 'evalin)
