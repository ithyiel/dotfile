;; boot strap

(setq debug-on-error t)

(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))

(defconst *spell-check-support-enabled* nil)

;; file loaded by each

(setq custom-file (expand-file-name "prefs.el" user-emacs-directory))
(require 'init-stage)
(require 'lisp-else)
(require 'elpa)

(when (file-exists-p custom-file)
  (load custom-file))

(provide 'init)
