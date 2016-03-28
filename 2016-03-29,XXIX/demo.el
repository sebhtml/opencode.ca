(require 'cl)

; This is required in order for Emacs Lisp to not crash.
(setq max-specpdl-size 999999)
(setq max-lisp-eval-depth 999999)

; The gap scoring model is simple: there is no opening cost, and the gap extension cost is SCORE-GAP
(setq SCORE-GAP -3)
(setq SCORE-MATCH +1)
(setq SCORE-MISMATCH -1)

(setq DIRECTION-NONE 0)
(setq DIRECTION-LEFT 1)
(setq DIRECTION-UP 2)
(setq DIRECTION-LEFT-UP 3)

(defun print-similarity-value (value)
  (if (> value 0)
      (princ "#")
    (princ ".")))

(defun print-value (value)
  ;(if (> value 0)
      (princ (format "%4d" value)))
    ;(princ (format "%4s" "."))))


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
  (princ (format "File: %s"
                 (document-file-path document)))
  (terpri)

  (princ (format "    Words %d"
   ;"    Characters: %d Words: %d"
           ;(document-content-length document)
                 (document-sequence-length document)))
  (terpri)
  )

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
  ;(print (format "matrix-set-cell %d %d %d" row column value))
  ;(print (format "data length %d" (length (matrix-data matrix))))
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
  (print (format "Row %d" row))
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

  (princ (format "Matrix rows: %d columns: %d"
           (matrix-row-count similarity-matrix)
           (matrix-column-count similarity-matrix)
           ))
  (terpri)

  ;(matrix-print-rows matrix 0)

  (let*
      (
       (row 0)
       (column 0)
       (row-count (matrix-row-count matrix))
       (column-count (matrix-column-count matrix))
       )

    (while (< row row-count)
      ;(print (format "DEBUG row %d" row))
      (while (< column column-count)
        (let*
            (
             (value (matrix-get-cell matrix row column))
             ;(value 0)
             )
          (print-value value)
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
      ;(print (format "Row %d" row))
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
                          SCORE-MATCH SCORE-MISMATCH
                          )
                          )
               ;(match 1)
               )

            ;(print (format "word-a %s word-b %s match %d" word-a word-b match))
            (matrix-set-cell matrix row column match)
              )
          ;(print (format "Column %d" column))
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
; DP code

(defun run-dynamic-programming-code
    (document-a document-b similarity-matrix dynamic-programming-matrix direction-matrix)

  (let*
      (
       (row-count (matrix-row-count similarity-matrix))
       (column-count (matrix-column-count similarity-matrix))
       )
    (let*
        (
         (row 0))
      (while (< row row-count)
        (let*
            (
             (column 0)
             )
          (while (< column column-count)
            (let*
                (
                 (current-similarity-score (matrix-get-cell similarity-matrix row column))
                 (max-dynamic-programming-score 0)
                 (max-direction DIRECTION-NONE)
                 (previous-row (- row 1))
                 (previous-column (- column 1))
                 )
              ; check diagonal
                                        ; https://en.wikipedia.org/wiki/Smith%E2%80%93Waterman_algorithm
              (if (and (>= previous-row 0) (>= previous-column 0) (> current-similarity-score 0))
                  (let*
                      ((previous-dynamic-programming-score (matrix-get-cell dynamic-programming-matrix previous-row previous-column))
                       (dynamic-programming-score (+ previous-dynamic-programming-score current-similarity-score))
                       )
                    (if (> dynamic-programming-score max-dynamic-programming-score)
                        (progn
                          (setq max-dynamic-programming-score dynamic-programming-score)
                          (setq max-direction DIRECTION-LEFT-UP)
                          )
                      nil)
                    )
                                        ; Check gap score with row
                (if (>= previous-row 0)
                    (let*
                        (
                         (previous-dynamic-programming-score (matrix-get-cell dynamic-programming-matrix previous-row column))
                         (dynamic-programming-score (+ previous-dynamic-programming-score SCORE-GAP))
                         )
                      (if (> dynamic-programming-score max-dynamic-programming-score)
                          (progn
                            (setq max-dynamic-programming-score dynamic-programming-score)
                            (setq max-direction DIRECTION-UP))
                        nil)
                      )
                                        ; check gap score with column
                  (if (>= previous-column 0)
                      (let*
                          (
                           (previous-dynamic-programming-score (matrix-get-cell dynamic-programming-matrix row previous-column))
                           (dynamic-programming-score (+ previous-dynamic-programming-score SCORE-GAP))
                           )
                        (if (> dynamic-programming-score max-dynamic-programming-score)
                            (progn
                              (setq max-dynamic-programming-score dynamic-programming-score)
                              (setq max-direction DIRECTION-LEFT))
                          nil))
                    nil
                    )
                  )
                )
              (matrix-set-cell dynamic-programming-matrix row column max-dynamic-programming-score)
              (matrix-set-cell direction-matrix row column max-direction)
              )
            (setq column (+ column 1))
            )
          )
        (setq row (+ row 1))
        )
      )
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

  (princ (format "------------------------------------------------------------------------------"))
  (terpri)
    (princ "Alignment"
           )
    (terpri)

    (princ "Document A")
    (terpri)
    (document-print document-a)
    (terpri)

    (princ "Document B")
    (document-print document-b)
    (terpri)

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

      (princ "Similarity matrix")
      (terpri)
      (matrix-print similarity-matrix)

      (run-dynamic-programming-code document-a document-b similarity-matrix dynamic-programming-matrix direction-matrix)

      (princ "Dynamic programming matrix")
      (terpri)
      (matrix-print dynamic-programming-matrix)

      (princ "Direction matrix")
      (terpri)
      (matrix-print direction-matrix)
      )

    (princ
     "End of alignment")
    (terpri)

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
