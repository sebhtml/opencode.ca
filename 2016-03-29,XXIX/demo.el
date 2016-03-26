(require 'cl)

; class document

(cl-defstruct document
  file-path
  content
  sequence
  )

(defun
    document-content-length (document)
  (length (document-content document)))

(defun
    document-sequence-length (document)
  (length (document-sequence document)))

(defun
    document-print (document)

  (message "File: %s"
           (document-file-path document-b)
           )
  (message "    Characters: %d"
           (document-content-length document-b)
           )
  (message "    Words: %d"
           (document-sequence-length document-b)
           )


  )

; stuff
(defun
    get-string-from-file (file-path)
  (with-temp-buffer
    (insert-file-contents file-path)
    (buffer-string)))

(defun
    load-document (file-path)

  (let*
      (
       (content (get-string-from-file file-path))
       (sequence (split-string content))
       )
    (make-document
     :file-path file-path
     :content content
     :sequence sequence
     )
       ))

(defun
    align-documents (document-a document-b)

  (message
   "------------------------------------------------------------------------------")
    (message
     "Alignment"
     )
    (message "")

    (message "Document A")
    (document-print document-a)
    (message "")

    (message "Document B")
    (document-print document-b)
    (message "")

    (message
     "End of alignment")
    (message "")
    ; TODO...
       )

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
     (align-documents spacemacs-github-page my-text)
     (align-documents spacemacs-twitter-page my-text)
  ))


(demo)
