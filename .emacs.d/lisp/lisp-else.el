;;; Set load path

(eval-when-compile (require 'cl))
(defun add-subdirs-to-load-path (parent-dir)
  "Adds every non-hidden subdir of PARENT-DIR to `load-path'."
  (let* ((default-directory parent-dir))
    (progn
      (setq load-path
            (append
             (remove-if-not
              (lambda (dir) (file-directory-p dir))
              (directory-files (expand-file-name parent-dir) t "^[^\\.]"))
             load-path)))))

(add-subdirs-to-load-path
 (expand-file-name "lisp-else/" user-emacs-directory))

;;; Utilities for grabbing upstream libs

(defun lisp-else-dir-for (name)
  (expand-file-name (format "lisp-else/%s" name) user-emacs-directory))

(defun lisp-else-library-el-path (name)
  (expand-file-name (format "%s.el" name) (lisp-else-dir-for name)))

(defun download-lisp-else-module (name url)
  (let ((dir (lisp-else-dir-for name)))
    (message "Downloading %s from %s" name url)
    (unless (file-directory-p dir)
      (make-directory dir t))
    (add-to-list 'load-path dir)
    (let ((el-file (lisp-else-library-el-path name)))
      (url-copy-file url el-file t nil)
      el-file)))

(defun ensure-lib-from-url (name url)
  (unless (lisp-else-library-loadable-p name)
    (byte-compile-file (download-lisp-else-module name url))))

(defun lisp-else-library-loadable-p (name)
  "Return whether or not the library `name' can be loaded from a
source file under ~/.emacs.d/lisp-else/name/"
  (let ((f (locate-library (symbol-name name))))
    (and f (string-prefix-p (file-name-as-directory (lisp-else-dir-for name)) f))))

(provide 'lisp-else)
