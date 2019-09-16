;;; pkg.el package initialize -*- lexical-binding: t -*-

(let ((miniver 24))
  (when (< emacs-major-version miniver)
    (error "As built-in `package', requires emacs %s or higher" miniver)))

(require 'package)
(add-to-list 'package-archives (cons "melpa" "https://melpa.org/packages/") t)

(package-initialize)

(provide 'pkg)

;;; pkg.el ends here
