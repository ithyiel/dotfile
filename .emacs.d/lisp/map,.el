;; map type

(defun make-map (type)
  (if (symbolp type)
      (progn
	(if (and (not (eq type 'map)) (not (map-type? type)))
	    (or (and (null (cdr map-built)) (setf (cdr map-built) (list type)))
		(push-refs type (cdr map-built))))
	(list type))))

(defvar map-built (make-map 'map))

(defun map-type? (type)
  (if (symbolp type)
      (or (eq type 'map)
	  (let ((tail (cdr map-built)) return)
	    (for-each-tail (per tail return)
	      (if (eq per type)  (setq return t)))))))

(defun map? (map &optional type)
  (and (listp map) (listp (cdr map))
       (if type (eq (car map) type)
	 (or (eq (car map) 'map)
	     (map-type? (car map))))))

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
       (let* ((this-key (elt key 0))
	      (rest-key (seq-drop key 1))
	      (this-map (map-get map type this-key)))
	 (if (null this-map)
	     (append map (list
			  (cons this-key
				(if (> (length rest-key) 0)
				    (let ((map (make-map type)))
				      (map-map map type rest-key bind))
				  bind))))
	   (let* ((map-type (car map))
		  (this-map-before (map-get-before map map-type this-key))
		  (this-map (cons this-key
				  (if (> (length rest-key) 0)
				      (map-map (let* ((this-map-bind (cdr this-map))
						      (map (if (and (consp this-map-bind)
								    (map? this-map-bind (car this-map-bind)))
							       this-map-bind
							     (make-map map-type))))
						 map)
					       map-type rest-key bind)
				    bind)))
		  (this-map-after (map-get-after map map-type this-key)))
	     (append (list map-type) this-map-before (list this-map) this-map-after))))))

(defun set-map-inherit (map inherit)
  (if (map? map)
      (cond
       (inherit
	(if (map? inherit)
	    (progn
	      (if (map-member? map inherit)
		  (error "Cycles map inheritance"))
	      (let ((member (map-member? inherit map)))
		(if member (pop-refs member)))
	      (setf (cdr (last map)) (list inherit)))))
       ((null inherit)
	;; fix inherit nil
	))))

;; (defun unset-map-inherit (map inherit)
;;   )

(defun map-member? (member map)
  (let ((tail (cdr map)) return)
    (for-each-tail (per tail return)
      (if (eq per member) (setq return tail)))))

(defmacro push-refs (elt place)
  (declare (debug t))
  `(car-safe
   (prog1 ,place
     (setf (cdr ,place) (cons (car ,place) (cdr ,place))
	   (car ,place) ,elt))))

(defmacro pop-refs (place)
  (declare (debug t))
  `(car-safe
    (prog1 (copy-sequence ,place)
      (setf (car ,place) (car (cdr ,place))
	    (cdr ,place) (cdr (cdr ,place))))))

(defmacro for-each-tail (spec &rest body)
  (declare (indent 1) (debug ((symbolp form &optional form) body)))
  (unless (consp spec)
    (signal 'wrong-type-argument `(consp ,spec)))
  (unless (<= 2 (length spec) 3)
    (signal 'wrong-number-of-arguments `(,spec ,(length spec))))
  ;; fix lexical binding
  `(let ((tail ,(nth 1 spec))
	 (,(car spec)))
     (while
	 ;; fix function-object predicate on return
	 ,(if (cdr (cdr spec))
	      `(and (consp tail) (null ,@(cdr (cdr spec))))
	    `(consp tail))
       (setq ,(car spec) (car tail))
       ,@body
       (setq tail (cdr tail)))
     ,@(if (cdr (cdr spec)) (cdr (cdr spec)))))

(defmacro define-map (map type key bind)
  (declare (debug t))
  `(let ((macro-map (map-map ,map ,type ,key ,bind)))
     (and macro-map (setq ,map macro-map) ,bind)))

(provide 'map\,)
