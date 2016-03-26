

(defun
    get-string-from-file (file-path)
  (with-temp-buffer
    (insert-file-contents file-path)
    (buffer-string)))

(defun
    load-document (file-path)

  (let
      ((content (get-string-from-file file-path))
       (cons file-path content)
       )))

(defun
    align-documents (document-a document-b)
  (let
      (
       (file-path-a (car document-a))
       (content-a (cdr document-a))
       (file-path-b (car document-b))
       (content-b (cdr document-b))
       )

       (message "aligning documents %s (%d bytes) and %s (%d bytes)\n" file-path-a file-path-b 0 0)
       ))

(defun
    demo ()

  (let
      (
       (gnu-emacs-wikipedia-page
        (load-document
        "Internet/https:-SLASH-SLASH-en.wikipedia.org-SLASH-wiki-SLASH-GNU_Emacs"))

       (spacemacs-github-page
        (load-document
        "Internet/https:-SLASH-SLASH-github.com-SLASH-syl20bnr-SLASH-spacemacs"))

       (spacemacs-twitter-page
        (load-document
        "Internet/https:-SLASH-SLASH-twitter.com-SLASH-spacemacs"))

       (my-text
        (load-document
        "my-text.txt"))
       )
     (align-documents gnu-emacs-wikipedia-page my-text)
  ))


(demo)
