;; layout

(global-set-key [?\C-o] 'find-file)
(global-set-key [?\C-,] 'buffer-menu)
(global-set-key [?\C-\;] 'kill-buffer)
(global-set-key [?\C-'] 'delete-window)

(global-set-key [f1] 'eval-last-sexp)
(global-set-key [f2]
		(lambda ()
		  (interactive)
		  (let ((current-prefix-arg '(4)))
		    (call-interactively #'eval-last-sexp))))

(key-chord-define-global [?,?d] 'other-window)
(key-chord-define-global [?/?d] 'split-window-right)
(key-chord-define-global [?/?s] 'split-window-below)

(key-chord-define-global [?.?a] 'previous-buffer)
(key-chord-define-global [?.?d] 'next-buffer)

(provide 'layout)
