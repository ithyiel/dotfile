;; map type

(defun make-map (type &optional bind)
  (and (symbolp type)
       (if bind (list type bind) (list type))))

(defun map? (map type)
  (and (listp map) (listp (cdr map))
       (and (symbolp type) (eq type (car map)))))

(defun map-get (map type key &optional test?)
  (let (return)
    (and (map? map type)
	 (setq return
	       (let ((tail (cdr map)))
		 (catch 'done
		   (while (consp tail)
		     (and (consp (car tail))
			  (let* ((this-map (car tail)) (this-key (car this-map)))
			    (if (funcall (or test? 'eq) this-key key) (throw 'done this-map))))
		     (setq tail (cdr tail)))))))
    return))

(defun map-get-before (map type key &optional test?)
  (let (return)
    (and (map? map type)
	 (let ((tail (cdr map)))
	   (catch 'break
	     (while (consp tail)
	       (and (consp (car tail))
		    (let* ((this-map (car tail)) (this-key (car this-map)))
		      (if (funcall (or test? 'eq) this-key key)
			  (throw 'break nil)
			(setq return (append return (list this-map))))))
	       (setq tail (cdr tail))))))
      return))

(defun map-get-after (map type key &optional test?)
  (let (return)
    (and (map? map type)
	 (let ((tail (cdr map)) found)
	   (while (consp tail)
	     (and (consp (car tail))
		  (let* ((this-map (car tail)) (this-key (car this-map)))
		    (if found (setq return (append return (list this-map))))
		    (if (funcall (or test? 'eq) this-key key) (setq found t))))
	     (setq tail (cdr tail)))))
    return))

(defun map-map (map type key bind)
  (and (map? map type)
       (append map (list
		    (let* ((this-key (elt key 0))
			   (rest-key (seq-drop key 1))
			   (this-map (map-get map type this-key)))
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

(provide 'map\,)
