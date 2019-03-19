;; prefs

(setq initial-frame-alist '((fullscreen . maximized)))
(setq inhibit-startup-screen t)
(setq tab-width 4
          tab-stop-list()
          indent-tabs-mode nil
	  c-basic-offset 4)
(setq initial-buffer-choice nil)
(setq default-directory "~/")
(setq visible-bell t)
(setq auto-image-file-mode t)
(setq make-backup-files nil)
(setq display-time-24hr-format t
          display-time-day-and-date t
          display-time-format "%d %m %Y %H:%M:%S"
          display-time-interval 1)
(setq user-full-name "ith yiel"
          user-mail-address "ithyiel@gmail.com")

(fset 'yes-or-no-p 'y-or-n-p)
(setenv "LC_CTYPE" "zh_CN.utf-8")

(add-hook 'comint-output-filter-functions 'comint-watch-for-password-prompt)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(column-number-mode t)
 '(cua-mode t nil (cua-base))
 '(default-input-method "chinese-py")
 '(display-battery-mode t)
 '(display-time-mode t)
 '(fringe-mode 0 nil (fringe))
 '(package-selected-packages (quote (fullframe)))
 '(scroll-bar-mode nil)
 '(show-paren-mode t)
 '(size-indication-mode t)
 '(tool-bar-mode nil)
 '(tooltip-mode nil))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Ubuntu Condensed" :foundry "DAMA" :slant normal :weight normal :height 128 :width normal))))
 '(fixed-pitch-serif ((t (:family "Ubuntu Condensed")))))

(provide 'prefs)
