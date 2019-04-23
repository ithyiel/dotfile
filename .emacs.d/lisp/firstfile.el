;;

(defvar file-map
  (let ((map '((("firefly") . ag)
	       (("stardict") . dic)
	       ((ansi-term "/bin/bash") . sh)
	       (("firefox" "-P" "n" "--no-remote") . ww)
	       (("firefox" "-P" "u" "--no-remote") . wwa)))
	(symbol-valid (lambda (arg)
			(if (symbolp arg)
			    (or (fboundp arg)
				(and (boundp arg)
				     (or (functionp (symbol-value arg))
					 (macrop (symbol-value arg)))))
			  (functionp arg)))))
   (mapc (lambda (arg)
	    (let ((sym (cdr arg)) (any (caar arg)))
	      (put sym 'symbol-association (funcall symbol-valid any))))
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

(defun launch (aliases &optional action)
  (interactive (launch-interactive-args "launch: "))
  (let ((exec-path (cons (expand-file-name "sh" (getenv "HOME")) exec-path))
	(symbols aliases) symbol)
    (while (prog1
	       (and (setq symbol (pop symbols)) symbols)
	     (let* ((pair (rassq symbol file-map))
		    (key (cdr pair)) (value (car pair)))
	       (catch 'done
		 (and pair (consp value)
		      (let ((program (car value)) (args (cdr value)))
			(if (get key 'symbol-association)
			    (apply program args)
			  (and (executable-find program)
			       (apply 'start-process
				      program nil program args)))
			(throw 'done t)))
		 (message "No assocation matching symbol %s" symbol)))))))

(add-hook 'emacs-startup-hook
	  (lambda ()
	    (launch '(ag dic))))

(defun dict ()
  (interactive)
  (apply 'start-process
	 '("stardict" nil "stardict")))

(defun browser (profile)
  (interactive)
  (apply 'start-process
	 `("firefox" nil "firefox" "-P" ,profile "-no-remote")))


(global-set-key [?\C-,] 'buffer-menu)
(global-set-key [M-up] (lambda () (interactive) (dict)))
(global-set-key [M-down] (lambda () (interactive) (ansi-term "/bin/bash")))
(global-set-key [M-right] (lambda () (interactive) (browser "n")))
(global-set-key [M-left] (lambda () (interactive) (browser "u")))

(provide 'firstfile)
