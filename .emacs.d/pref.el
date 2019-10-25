;; Pref

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
      display-time-format "%d %m %Y %H:%M")
(setq user-full-name "ith yiel"
      user-mail-address "ithyiel@gmail.com")
(setq home-directory (getenv "HOME")
      source-directory (expand-file-name "source/emacs" home-directory))

(fset 'yes-or-no-p 'y-or-n-p)
(setenv "LC_CTYPE" "zh_CN.utf-8")

(add-hook 'comint-output-filter-functions 'comint-watch-for-password-prompt) 

(custom-set-variables
 '(blink-cursor-mode t)
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
 '(tooltip-mode nil)
 '(package-selected-packages (quote (key-chord))))

(custom-set-faces
 '(default ((t (:inherit nil :slant normal :weight normal :height 113 :width normal :foundry "Mono" :family "Arial"))))
 '(fixed-pitch ((t (:inherit default))))
 '(fixed-pitch-serif ((t (:inherit default))))
 '(variable-pitch ((t (:inherit default)))))

(provide 'pref)
