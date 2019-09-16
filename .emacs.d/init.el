;;; init.el boot strap -*- lexical-binding: t -*-

(setq debug-on-error t)

(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))

(require 'pkg)
(require 'macrolv)
(progn (require 'key-chord) (key-chord-mode t))
(require 'kb)
(require 'launch)

(setq custom-file (expand-file-name "pref.el" user-emacs-directory))
(when (file-exists-p custom-file) (load custom-file))

(provide 'init)

;;; init.el ends here
