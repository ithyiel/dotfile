;; File launching for frequency use

(defvar file-map
  (let ((map '((("firefly") . ff)
	       (("u") . u)
	       (("stardict") . dic)
	       ((ansi-term "/bin/bash") . sh)
	       (("firefox" "-P" "origin" "--no-remote") . ww)
	       (("firefox" "-P" "u" "--no-remote") . wwu)
	       (("firefox" "-P" "firefly" "--no-remote") . wwf)))
	(symbol-valid (lambda (arg)
			(if (symbolp arg)
			    (or (fboundp arg)
				(and (boundp arg)
				     (or (functionp (symbol-value arg))
					 (macrop (symbol-value arg)))))
			  (functionp arg)))))
   (mapc (lambda (arg)
	    (let ((sym (cdr arg)) (any (caar arg)))
	      (put sym 'bind-eval-form (funcall symbol-valid any))))
	  map))
 "((program args) . alias)")

(defun kill-system-process (&rest args)
  "Kill system-wide process."
  (declare (obsolete "temporarily obsoleted." 26.1))
  (interactive)
  (let ((pids (list-system-processes))
	palist pname)
    (dolist (pid pids)
      (setq palist (process-attributes pid))
      (when palist
	(setq pname (alist-get 'comm palist))
	(dolist (arg args)
	  (if (equal pname arg)
	      (signal-process pid 9)))))))

(defun launch-interactive-args (prompt)
  (let ((input (read-string prompt)))
    (list (mapcar 'intern (split-string input)))))

(defun launch (alias &optional action)
  (interactive (launch-interactive-args "alias: "))
  (let ((exec-path (cons (expand-file-name "sh"
					     (or home-directory
						 (getenv "HOME")))
			   exec-path))
	(symbols alias) symbol)
    (while (prog1
	       (and (setq symbol (pop symbols)) symbols)
	     (let* ((pair (rassq symbol file-map))
		    (key (cdr pair)) (value (car pair)))
	       (catch 'done
		 (when (and pair (consp value))
		      (let ((program (car value)) (args (cdr value)))
			(if (get key 'bind-eval-form)
			    (apply program args)
			  (and (executable-find program)
			       (apply 'start-process program nil program args)))
			(throw 'done t)))
		 (message "No assocation matching symbol %s" symbol)))))))

(add-hook 'emacs-startup-hook
	  (lambda ()
	    (launch '(u dic))))

(key-chord-define-global [?,?l] 'launch)

(provide 'launch)
