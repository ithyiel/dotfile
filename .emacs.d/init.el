;; boot strap

(setq debug-on-error t)

(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))

(require 'packag)
(progn (require 'key-chord) (key-chord-mode t))
(require 'layout)
(require 'launch)

(setq custom-file (expand-file-name "prefs.el" user-emacs-directory))
(when (file-exists-p custom-file) (load custom-file))

(provide 'init)
