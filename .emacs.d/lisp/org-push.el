(require 'ox-publish)

(defun data-from (file)
  (with-temp-buffer
    (insert-file-contents file)
    (buffer-string)))

(defun jw/html-escape-attribute (value)
  "Entity-escape VALUE and wrap it in quotes."
  ;; http://www.w3.org/TR/2009/WD-html5-20090212/serializing-html-fragments.html
  ;;
  ;; "Escaping a string... consists of replacing any occurrences of
  ;; the "&" character by the string "&amp;", any occurrences of the
  ;; U+00A0 NO-BREAK SPACE character by the string "&nbsp;", and, if
  ;; the algorithm was invoked in the attribute mode, any occurrences
  ;; of the """ character by the string "&quot;"..."
  (let* ((value (replace-regexp-in-string "&" "&amp;" value))
         (value (replace-regexp-in-string "\u00a0" "&nbsp;" value))
         (value (replace-regexp-in-string "\"" "&quot;" value)))
    value))

(eval-after-load "org"
  '(org-add-link-type
    "span" #'ignore ; not an 'openable' link
    #'(lambda (class desc format)
        (pcase format
          (`html (format "<span class=\"%s\">%s</span>"
                         (jw/html-escape-attribute class)
                         (or desc "")))
          (_ (or desc ""))))))

;; https://orgmode.org/manual/Publishing-options.html
(setq org-export-with-sub-superscripts nil
      org-export-headline-levels 3
      org-export-with-timestamps nil
      org-export-with-clocks nil
      org-export-with-author nil
      org-export-with-creator nil
      org-export-with-date nil
      org-export-with-email nil
      org-export-with-toc nil
      org-export-with-section-numbers nil
      org-export-with-smart-quotes t
      org-export-with-tasks nil)

(setq org-html-preamble nil
      org-html-postamble nil
      org-html-viewport t
      org-html-indent t
      org-html-head t
      org-html-head-include-default-style nil
      org-html-head-include-scripts nil
      org-html-metadata-timestamp-format "%d %m %Y")

(setq org-html-doctype "<!DOCTYPE html>")

(setq org-html-head
      (concat
       (data-from "~/org/css/layout.css")
       (data-from "~/org/js/fun.js")
     ))

;; https://orgmode.org/worg/org-tutorials/org-publish-html-tutorial.html
(setq org-publish-project-alist
      '(("pages"
	:components ("resume"))
	("resume"
	:base-directory		"~/org/page/"
	:base-extension		"org"
	:exclude	"[^(resume.org)]"
	:recursive	t
	:publishing-directory	"~/html/"
	:publishing-function	org-html-publish-to-html)))

(org-publish-project "pages" 'force)
