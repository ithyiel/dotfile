;; Boot strap

(setq debug-on-error t)

(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))

(require 'package\,)
(progn (require 'key-chord) (key-chord-mode t))
(require 'map\,)
(require 'eval\,)
(require 'layout)
(require 'launch)

(setq custom-file (expand-file-name "prefs.el" user-emacs-directory))
(when (file-exists-p custom-file) (load custom-file))

(provide 'init)

