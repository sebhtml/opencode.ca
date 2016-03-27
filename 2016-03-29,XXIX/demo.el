(require 'cl)

(setq max-specpdl-size 999999)
(setq max-lisp-eval-depth 999999)

(setq DIRECTION-NONE -1)
(setq DIRECTION-LEFT 0)
(setq DIRECTION-UP 1)
(setq DIRECTION-LEFT-UP 2)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; class document

(cl-defstruct document
  file-path
  content
  sequence)

(defun document-content-length (document)
  (length (document-content document)))

(defun document-sequence-length (document)
  (length (document-sequence document)))

(defun document-print (document)
  (message "File: %s"
           (document-file-path document))
  (message "    Words %d"
   ;"    Characters: %d Words: %d"
           ;(document-content-length document)
           (document-sequence-length document)
           ))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; matrix

(cl-defstruct matrix
  row-count
  column-count
  data)



(defun create-matrix (row-count column-count)
  (let*
      (
       (size (* row-count column-count))
       (my-list (make-list size 0))
       (data (vconcat (vector) my-list))
       )
    (make-matrix
     :row-count row-count
     :column-count column-count
     :data data)))

;(defun matrix-row-count (matrix)
  ;(length matrix))

;(defun matrix-column-count (matrix)
  ;(length (aref matrix 0))
  ;)

(defun matrix-set-cell (matrix row column value)
  ;(message "matrix-set-cell %d %d %d" row column value)
  ;(message "data length %d" (length (matrix-data matrix)))
  (let*
      (
       (data (matrix-data matrix))
       ;(row-vector (aref data row))
       (column-count (matrix-column-count matrix) )
       (i (+ (* row column-count) column))
       )
    (aset data i value)))

(defun matrix-get-cell (matrix row column)
  (aref (matrix-data matrix) (+ (* row (matrix-column-count matrix)) column)))

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

  ;(matrix-print-rows matrix 0)

  (let*
      (
       (row 0)
       (column 0)
       (row-count (matrix-row-count matrix))
       (column-count (matrix-column-count matrix))
       )

    (while (< row row-count)
      (while (< column column-count)
        (let*
            (
             (value (matrix-get-cell matrix row column))
             ;(value 0)
             )
          (princ (format " %d" value))
          )

        (setq column (+ column 1))
        )
      (princ "\n")
      (setq row (+ row 1))
      (setq column 0)
      )
    )
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; similarity matrix

(defun populate-similarity-matrix-row-column (document-a document-b matrix row column)
  (let*
      (
       (sequence-a (document-sequence document-a))
       (sequence-b (document-sequence document-b))
       (word-a (aref sequence-a row))
       (word-b (aref sequence-b column))
       ;(match (if (= word-a word-b) 1 0))
       )
    ;(matrix-set-cell matrix row column match)
    )
  )

(defun populate-similarity-matrix-row-columns (document-a document-b matrix row column)
  (if (< column (matrix-column-count matrix))
      (progn
        (populate-similarity-matrix-row-column document-a document-b matrix row column)
        (populate-similarity-matrix-row-columns document-a document-b matrix row (+ column 1)))
    ))

(defun populate-similarity-matrix-row (document-a document-b matrix row)
  (populate-similarity-matrix-row-columns document-a document-b matrix row 0)
  )

(defun populate-similarity-matrix-rows (document-a document-b matrix row)
  (if (< row (matrix-row-count matrix))
      (progn
        (populate-similarity-matrix-row document-a document-b matrix row)
        (populate-similarity-matrix-rows document-a document-b matrix (+ row 1)))))

(defun populate-similarity-matrix-slow (document-a document-b matrix)
  (populate-similarity-matrix-rows document-a document-b matrix 0))

(defun populate-similarity-matrix (document-a document-b matrix)
  (let*
      (
       (row 0)
       (row-count (matrix-row-count matrix))
       )
    (while (< row row-count)
      ;(message "Row %d" row)
      (let*
          (
           (column 0)
           (column-count (matrix-column-count matrix))
           )
        (while (< column column-count)
          (let*
              (
               (sequence-a (document-sequence document-a))
               (sequence-b (document-sequence document-b))
               (word-a (aref sequence-a row))
               (word-b (aref sequence-b column))
               (match (if
                          (equal word-a word-b)
                          1 0
                          )
                          )
               ;(match 1)
               )

            ;(message "word-a %s word-b %s match %d" word-a word-b match)
            (matrix-set-cell matrix row column match)
              )
          ;(message "Column %d" column)
          (setq column (+ column 1))
          )
        )
      (setq row (+ row 1))
      )

    )
  )

(defun make-similarity-matrix (document-a document-b)
  (let*
      (
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
         (row-count (document-sequence-length document-a))
         (column-count (document-sequence-length document-b))
         (similarity-matrix (create-matrix row-count column-count))
         (dynamic-programming-matrix (create-matrix row-count column-count))
         (direction-matrix (create-matrix row-count column-count))
         ;(similarity-matrix (make-similarity-matrix document-a document-b))
         )

      (populate-similarity-matrix document-a document-b similarity-matrix)

      (message "Similarity matrix")
      (matrix-print similarity-matrix)

      (message "Dynamic programming matrix")
      (matrix-print dynamic-programming-matrix)

      (message "Direction matrix")
      (matrix-print direction-matrix)
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

       (hello (load-document "hello-world.txt"))
       )

    ;(align-documents hello hello)
    ;(align-documents my-text my-text)
     (align-documents gnu-emacs-wikipedia-page my-text)
     ;(align-documents spacemacs-github-page my-text)
     ;(align-documents spacemacs-twitter-page my-text)
  ))


(main)
