(require 'cl)

(setq max-specpdl-size 999999)
(setq max-lisp-eval-depth 999999)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; class document

(cl-defstruct document
  file-path
  content
  sequence
  )

(defun document-content-length (document)
  (length (document-content document)))

(defun document-sequence-length (document)
  (length (document-sequence document)))

(defun document-print (document)

  (message "File: %s"
           (document-file-path document)
           )
  (message "    Words %d"
   ;"    Characters: %d Words: %d"
           ;(document-content-length document)
           (document-sequence-length document)
           )
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; matrix

(defun make-matrix (row-count column-count)
  ;(message "make-matrix row-count %d column-count %d" row-count column-count)
  (let*
      (
       (row-list (make-list column-count 0))
       (row-vector (vconcat (vector) row-list))
       (rows (make-list row-count row-vector))
       (matrix (vconcat (vector) rows))
       )
    ;(message "row-list length %d" (length row-list))
    ;(message "row-vector length %d" (length row-vector))
    matrix
    )
  )

(defun matrix-row-count (matrix)
  (length matrix))

(defun matrix-column-count (matrix)
  (length (aref matrix 0))
  )

(defun matrix-get-cell (matrix row column)
  (aref (aref matrix row) column))

(defun matrix-print-row (matrix row)
  (message "Row %d" row)
  )

(defun matrix-print-rows (matrix row)
  (let*
      (
       (row-count (matrix-row-count matrix))
       )
    (if (< row row-count)
        (progn
          (matrix-print-row matrix row)
          (matrix-print-rows matrix (+ row 1))
          )
      nil
      )
    )
  )

(defun matrix-print (matrix)

  (message "Matrix rows: %d columns: %d"
           (matrix-row-count similarity-matrix)
           (matrix-column-count similarity-matrix)
           )

  (matrix-print-rows matrix 0)
  )

(defun make-similarity-matrix (document-a document-b)
  (let*
      (
       (row-count (document-sequence-length document-a))
       (column-count (document-sequence-length document-b))
       (matrix (make-matrix row-count column-count))
       )
    matrix
    )
  )


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; stuff

(defun get-string-from-file (file-path)
  (with-temp-buffer
    (insert-file-contents file-path)
    (buffer-string)))

(defun load-document (file-path)

  (let*
      (
       (content (get-string-from-file file-path))
       (sequence-list (split-string content))
       (sequence (vconcat (vector) sequence-list))
       )
    (make-document
     :file-path file-path
     :content content
     :sequence sequence
     )
       ))

(defun align-documents (document-a document-b)

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

                                        ; TODO...

    (let*
        (
         (similarity-matrix (make-similarity-matrix document-a document-b))
         )


      (matrix-print similarity-matrix)
      )

    (message
     "End of alignment")
    (message "")

       )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; main
(defun main()

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
     ;(align-documents spacemacs-github-page my-text)
     ;(align-documents spacemacs-twitter-page my-text)
  ))


(main)
