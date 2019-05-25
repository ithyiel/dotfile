;; map type

(defun make-map (type &optional bind)
  (and (symbolp type)
       (if bind (list type bind) (list type))))

(defun mapp/ (map type)
  (and (listp map) (listp (cdr map))
       (and (symbolp type) (eq type (car map)))))

(defun map-get-map (map type key &optional testfn)
  (let (return)
    (and (mapp/ map type)
	 (setq return
	       (let ((tail (cdr map)))
		 (catch 'done
		   (while (consp tail)
		     ;; alist map
		     (and (consp (car tail))
			  (let* ((this-map (car tail)) (this-key (car this-map)))
			    (if (funcall (or testfn 'eq) this-key key) (throw 'done this-map))))
		     (setq tail (cdr tail)))))))
    return))

(defun map-map (map type key bind)
  (and (mapp/ map type)
       (append map (list
		    (let* ((this-key (elt key 0))
			   (rest-key (seq-drop key 1))
			   (this-map (map-get-map map type this-key)))
		      (if (null this-map)
			  (cons this-key
				(if (> (length rest-key) 0)
				    (let ((map (make-map type)))
				      (map-map map type rest-key bind))
				  bind))
			ELSE))))))

(defmacro define-map (map type key bind)
  `(let ((let-map (map-map ,map ,type ,key ,bind)))
     (and let-map (setq map let-map) ,bind)))

(provide 'maps)
