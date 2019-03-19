(add-hook 'emacs-startup-hook
	  (lambda ()
	    (let ((default-directory "~/sh/"))
	      (shell-command-to-string "./firefly &>/dev/null &"))
	    (shell-command-to-string "stardict &>/dev/null &")))

(add-hook 'kill-emacs-hook
	  (lambda () (kill "stardict" "firefly")))

;;  run shortcut

(defun dict()
  (interactive)
  (shell-command-to-string "stardict &>/dev/null &"))

(defun ff(dots)
  (interactive)
  (shell-command-to-string (format "firefox -P %s -no-remote &>/dev/null &" dots)))

(defun kill(&rest args)
  (interactive)
  (let ((pids (list-system-processes)) palist pname)
  (dolist (pid pids)
    (setq palist (process-attributes pid))
    (when palist
      (setq pname (alist-get 'comm palist))
      (dolist (arg args)
	(if (equal pname arg)
	    (signal-process pid 9)))))))

(define-key input-decode-map "\e\eOA" [(meta up)])
(define-key input-decode-map "\e\eOB" [(meta down)])
(define-key input-decode-map "\e\eOC" [(meta right)])
(define-key input-decode-map "\e\eOD" [(meta left)])

(global-set-key [(meta up)] (lambda () (interactive) (dict)))
(global-set-key [(meta down)] (lambda () (interactive) (ansi-term "/bin/bash")))
(global-set-key [(meta right)] (lambda () (interactive) (ff 'n)))
(global-set-key [(meta left)] (lambda () (interactive) (ff 'u)))

(provide 'init-stage)
