;; Prefs

(setq frame-resize-pixelwise t
      initial-frame-alist '((fullscreen . maximized))
      inhibit-startup-screen t)
(setq initial-buffer-choice nil)
(setq-default major-mode 'text-mode)
(setq visible-bell t)
(setq make-backup-files nil)
(setq auto-image-file-mode t)
(setq tab-width 4
      tab-stop-list()
      indent-tabs-mode nil)
(setq display-time-day-and-date t
      display-time-24hr-format t
      display-time-format "%d %m %Y %H:%M:%S"
      display-time-interval 1)
(setq user-full-name "ith yiel"
      user-mail-address "ithyiel@gmail.com")
(setq home-directory (getenv "HOME")
      source-directory (expand-file-name "source/emacs-26.2" home-directory))

(fset 'yes-or-no-p 'y-or-n-p)
(setenv "LC_CTYPE" "zh_CN.utf-8")

(add-hook 'comint-output-filter-functions 'comint-watch-for-password-prompt) 

(custom-set-variables
 '(menu-bar-mode nil)
 '(tool-bar-mode nil)
 '(tooltip-mode nil)
 '(fringe-mode 0 nil (fringe))
 '(scroll-bar-mode nil)
 '(column-number-mode t)
 '(display-battery-mode t)
 '(display-time-mode t)
 '(show-paren-mode t)
 '(cua-mode t nil (cua-base))
 '(size-indication-mode t)
 '(default-input-method "chinese-py"))

(custom-set-faces
 '(default ((t (:inherit nil :slant normal :weight normal :height 120 :width normal :foundry "UKWN" :family "Cuprum"))))
 '(fixed-pitch ((t (:inherit default))))
 '(fixed-pitch-serif ((t (:inherit default))))
 '(variable-pitch ((t (:inherit default)))))

(provide 'prefs)
