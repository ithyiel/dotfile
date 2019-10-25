;;; kb.el key binding
;; (read-kbd-macro SEQ)

(global-set-key [f1] 'eval-last-sexp)
(global-set-key [f2]	(lambda () (interactive)
			  (let ((current-prefix-arg '(4)))
			    (call-interactively #'eval-last-sexp))))

(global-set-key (kbd "C-,") 'buffer-menu)
(global-set-key (kbd "C-;") 'kill-buffer)
(global-set-key (kbd "C-'") 'delete-window)

(key-chord-define-global ",o" 'find-file)
(key-chord-define-global ",f" 'find-function)
(key-chord-define-global "?f" 'describe-function)
(key-chord-define-global ",L" 'find-library)
(key-chord-define-global ",v" 'find-variable)
(key-chord-define-global "?v" 'describe-variable)
(key-chord-define-global "?s" 'info-lookup-symbol)
(key-chord-define-global "?k" 'describe-key)

(key-chord-define-global ",d" 'other-window)
(key-chord-define-global "/d" 'split-window-right)
(key-chord-define-global "/s" 'split-window-below)

(key-chord-define-global ".a" 'previous-buffer)
(key-chord-define-global ".d" 'next-buffer)

(provide 'kb)

;;; kb.el ends here
