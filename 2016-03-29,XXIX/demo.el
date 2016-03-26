

(defun
    get-string-from-file (file-path)
  (with-temp-buffer
    (insert-file-contents file-path)
    (buffer-string)))

(defun
    load-document (file-path)

  (let
      ((content (get-string-from-file file-path))
       )
       (cons file-path content)
       ))

(defun
    align-documents (document-a document-b)
  (let
      (
       (document-a-file-path (car document-a))
       (document-a-content (cdr document-a))
       (document-b-file-path (car document-b))
       (document-b-content (cdr document-b))
       )

    (message
     "Alignment of %s (%d characters, %d words) and %s (%d characters, %d words)\n"
     document-a-file-path 0 0
     document-b-file-path 0 0
     )
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
