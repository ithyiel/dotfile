;; prefs

(setq frame-resize-pixelwise t
      initial-frame-alist '((fullscreen . maximized))
      inhibit-startup-screen t)
(setq-default major-mode 'text-mode)
(setq initial-buffer-choice nil)
(setq auto-image-file-mode t)
(setq visible-bell t)
(setq make-backup-files nil)
(setq tab-width 4
      tab-stop-list()
      indent-tabs-mode nil
      c-basic-offset 4)
(setq display-time-day-and-date t
      display-time-24hr-format t
      display-time-format "%d %m %Y %H:%M:%S"
      display-time-interval 1)
(setq user-full-name "ith yiel"
      user-mail-address "ithyiel@gmail.com")

(fset 'yes-or-no-p 'y-or-n-p)
(setenv "LC_CTYPE" "zh_CN.utf-8")

(add-hook 'comint-output-filter-functions 'comint-watch-for-password-prompt) 

(custom-set-variables
 '(column-number-mode t)
 '(cua-mode t nil (cua-base))
 '(default-input-method "chinese-py")
 '(display-battery-mode t)
 '(display-time-mode t)
 '(fringe-mode 0 nil (fringe))
 '(menu-bar-mode nil)
 '(scroll-bar-mode nil)
 '(show-paren-mode t)
 '(size-indication-mode t)
 '(tool-bar-mode nil)
 '(tooltip-mode nil))

(custom-set-faces
 '(default ((t (:family "Ubuntu Condensed" :foundry "DAMA" :slant normal :weight normal :height 128 :width normal))))
 '(fixed-pitch ((t (:inherit default))))
 '(fixed-pitch-serif ((t (:inherit default))))
 '(variable-pitch ((t (:inherit default)))))

(provide 'prefs)
