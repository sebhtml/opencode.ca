;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;;
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

(require 'cl)

;; This is required in order for Emacs Lisp to not crash.
(setq max-specpdl-size 999999)
(setq max-lisp-eval-depth 999999)

(setq OPTION-PRINT-MATRIX nil)

;; The gap scoring model is simple: there is no opening cost, and the gap extension cost is SCORE-DELETION or SCORE-INSERTION
(setq SCORE-DELETION -1)
(setq SCORE-INSERTION -1)
(setq SCORE-MATCH +2)
(setq SCORE-MISMATCH -1)

(setq TYPE-MATCH 0)
(setq TYPE-MISMATCH 1)
(setq TYPE-DELETION 2)
(setq TYPE-INSERTION 3)

(setq DIRECTION-NONE 0)
(setq DIRECTION-LEFT 1)
(setq DIRECTION-UP 2)
(setq DIRECTION-LEFT-UP 3)

(defun print-similarity-value (value)
  (if (> value 0)
      (princ "#")
    (princ ".")))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; class pair

(cl-defstruct pair
  index-a
  index-b
  type
  )

(defun pair-type-string (this)
  (let
      (
       (type (pair-type this))
       )
    (if (= type TYPE-MATCH)
        "Match"
      (if (= type TYPE-MISMATCH)
          "Mismatch"
        (if (= type TYPE-INSERTION)
            "Insertion"
          (if (= type TYPE-DELETION)
              "Deletion")
          )

))
    ))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
             ;; class alignment

(cl-defstruct alignment
  document-a
  document-b
  dynamic-programming-score
  match-count
  indices)

(defun format-string (word)
  (format " %16s " word)
  )

(defun format-integer (word)
  (format " %16d " word)
  )

(defun print-value (value)
  ;;(if (> value 0)
  (princ (format " %10d" value)))
;;(princ (format "%4s" "."))))



(defun alignment-print (this)
  ;;)

  (princ (format "Alignment"))
  (terpri)

  (if (> (length (alignment-indices this)) 0)
;;(defun foo (this)
  (let*
      (
       (print-indices true)
       (indices (alignment-indices this))
       (the-length (length indices))
       (last-index (- the-length 1))
       (last-pair (aref indices last-index))
       (row (pair-index-a last-pair))
       (column (pair-index-b last-pair))
       (dynamic-programming-score (alignment-dynamic-programming-score this))
       (match-count (alignment-match-count this))
       (document-a (alignment-document-a this))
       (document-b (alignment-document-b this))
       (sequence-a (document-sequence document-a))
       (sequence-b (document-sequence document-b))
       )
    (princ (format "row %d column %d score %d match-count %d length %d"
                   row column dynamic-programming-score match-count the-length))
    (terpri)
    (princ "Indices ")
    (terpri)
    ;;(princ indices)


    ;; Print indices of pairs
    (if print-indices (progn
    (princ (format-string "Pair"))
    (let
        (
         (i 0)
         )
      (while (< i the-length)
        (let*
            (
             (pair (aref indices i))
             (index-a (pair-index-a pair))
             (word (aref sequence-a index-a))
             (type (pair-type pair))
             )
          (princ (format-integer i))
          )
        (setq i (+ i 1))
        )
      (terpri)
      )

    ) nil )

    ;; Print types
    (if print-indices (progn
    (princ (format-string "Types"))
    (let
        (
         (i 0)
         )
      (while (< i the-length)
        (let*
            (
             (pair (aref indices i))
             (type-string (pair-type-string pair))
             )
          (princ (format-string type-string))
          )
        (setq i (+ i 1))
        )
      (terpri)
      )
    ) nil )


    ;; Print indices of words in document-a
    (if print-indices (progn
    (princ (format-string "Index A"))
    (let
        (
         (i 0)
         )
      (while (< i the-length)
        (let*
            (
             (pair (aref indices i))
             (index-a (pair-index-a pair))
             (type (pair-type pair))
             )
          (princ (format-integer index-a))
          )
        (setq i (+ i 1))
        )
      (terpri)
      )
    ) nil )


    ;; Print document-a
    (princ (format-string "Sequence A"))
    (let
        (
         (i 0)
         )
      (while (< i the-length)
        (let*
            (
              (pair (aref indices i))
              (index-a (pair-index-a pair))
              (word (aref sequence-a index-a))
              (type (pair-type pair))
              )
          (if (= type TYPE-INSERTION)
              (princ (format-string ""))
            (princ (format-string word)))
          )
        (setq i (+ i 1))
        )
      (terpri)
      )

    ;; Word B

    ;; Print indices of words in document-b
    (if print-indices (progn
    (princ (format-string "Index B"))
    (let
        (
         (i 0)
         )
      (while (< i the-length)
        (let*
            (
             (pair (aref indices i))
             (index-b (pair-index-b pair))
             )
          (princ (format-integer index-b))
          )
        (setq i (+ i 1))
        )
      (terpri)
      )
    ) nil )

    ;; Print document-b
    (princ (format-string "Sequence B"))
    (let
        (
         (i 0)
         )
      (while (< i the-length)
        (let*
            (
             (pair (aref indices i))
             (index-b (pair-index-b pair))
             (word (aref sequence-b index-b))
             (type (pair-type pair))
             )
          (if (= type TYPE-DELETION)
              (princ (format-string ""))
            (princ (format-string word)))
          )
        (setq i (+ i 1))
        )
      (terpri)
      )


    ;; Print a new line
    (terpri)
    )
  nil
  )
  )

(defun get-match-count (indices)
  (let
      (
       (i 0)
       (match-count 0)
       (the-length (length indices))
       )
    (while (< i the-length)
      (if
          (= (pair-type (aref indices i)) TYPE-MATCH)
          (setq match-count (+ match-count 1))
        nil
        )
      (setq i (+ i  1))
      )
    match-count
    ))

(defun alignment-generate-indices (similarity-matrix dynamic-programming-matrix direction-matrix row column)
  (let*
      (
       (similarity-score (matrix-get-cell similarity-matrix row column))
       (direction (matrix-get-cell direction-matrix row column))
       (pair (make-pair :index-a row :index-b column :type (if (> similarity-score 0) TYPE-MATCH TYPE-MISMATCH)))
       )
    ;; LEFT UP
    (if (= direction DIRECTION-LEFT-UP)
        (let*
            (
             (previous-row (- row 1))
             (previous-column (- column 1))
             (previous-indices (alignment-generate-indices dynamic-programming-matrix direction-matrix previous-row previous-column))
             )
          ;;(princ pair)
          ;;(terpri)
          (cons pair previous-indices)
          )

      ;; LEFT
      (if (= direction DIRECTION-LEFT)
          (let*
              (
               (previous-row row)
               (previous-column (- column 1))
               (previous-indices (alignment-generate-indices dynamic-programming-matrix direction-matrix previous-row previous-column))
               )
            (cons pair previous-indices)
            )
                                        ;; UP
        (if (= direction DIRECTION-UP)
            (let*
                (
                 (previous-row (- row 1))
                 (previous-column column)
                 (previous-indices (alignment-generate-indices dynamic-programming-matrix direction-matrix previous-row previous-column))
                 )
              (cons pair previous-indices)
              )

                                        ;; direction: NONE
          (if (= direction DIRECTION-NONE)
              (list pair)
            nil)))
      )
  ))



(defun get-alignment (document-a document-b dynamic-programming-score dynamic-programming-matrix direction-matrix row column)
  ;(princ "get-alignment")
  ;(terpri)
  (let*
      (
       (last-pair (make-pair :index-a row :index-b column :type TYPE-MATCH))
       (my-list (reverse (alignment-generate-indices dynamic-programming-matrix direction-matrix row column)))
       (indices (vconcat (vector) my-list))
    (match-count (get-match-count indices))
    ;;(match-count 0)
       )
  (make-alignment
   :document-a document-a
   :document-b document-b
   :dynamic-programming-score dynamic-programming-score
   :match-count match-count
   :indices indices
   )
  ))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; class document

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
   ;;"    Characters: %d Words: %d"
           ;;(document-content-length document)
                 (document-sequence-length document)))
  (terpri)
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; matrix

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

;;(defun matrix-row-count (matrix)
  ;;(length matrix))

;;(defun matrix-column-count (matrix)
  ;;(length (aref matrix 0))
  ;;)

(defun matrix-set-cell (matrix row column value)
  ;;(print (format "matrix-set-cell %d %d %d" row column value))
  ;;(print (format "data length %d" (length (matrix-data matrix))))
  (let*
      (
       (data (matrix-data matrix))
       ;;(row-vector (aref data row))
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

(defun matrix-print (document-a document-b matrix)

  (princ (format "Matrix rows: %d columns: %d"
           (matrix-row-count similarity-matrix)
           (matrix-column-count similarity-matrix)
           ))
  (terpri)

  ;;(matrix-print-rows matrix 0)

  (princ (format-string ""))
  (let
      (
       (i 0)
       )
    (while (< i (length (document-sequence document-a)))
      (princ (format-string (aref (document-sequence document-b) i)))
      (setq i (+ i 1))
      ))
  (terpri)

  (let*
      (
       (row 0)
       (column 0)
       (row-count (matrix-row-count matrix))
       (column-count (matrix-column-count matrix))
       )

    (while (< row row-count)
      (princ (format-string (aref (document-sequence document-a) row)))
      ;;(print (format "DEBUG row %d" row))
      (while (< column column-count)
        (let*
            (
             (value (matrix-get-cell matrix row column))
             ;;(value 0)
             )
          (princ (format-integer value))
          )

        (setq column (+ column 1))
        )
      (princ "\n")
      (setq row (+ row 1))
      (setq column 0)
      )
    )
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; similarity matrix

(defun populate-similarity-matrix-row-column (document-a document-b matrix row column)
  (let*
      (
       (sequence-a (document-sequence document-a))
       (sequence-b (document-sequence document-b))
       (word-a (aref sequence-a row))
       (word-b (aref sequence-b column))
       ;;(match (if (= word-a word-b) 1 0))
       )
    ;;(matrix-set-cell matrix row column match)
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
      ;;(print (format "Row %d" row))
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
               ;;(match 1)
               )

            ;;(print (format "word-a %s word-b %s match %d" word-a word-b match))
            (matrix-set-cell matrix row column match)
              )
          ;;(print (format "Column %d" column))
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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; DP code

(defun run-dynamic-programming-code
    (document-a document-b similarity-matrix dynamic-programming-matrix direction-matrix)

  (let*
      (
       (row-count (matrix-row-count similarity-matrix))
       (column-count (matrix-column-count similarity-matrix))
       )
    (let*
        (
         (row 0)
         )
      (while (< row row-count)
        (let*
            (
             (column 0)
             )
          (while (< column column-count)
            ;;(princ (format "DP row %d column %d" row column))
            ;;(terpri)
            (let*
                (
                 (current-similarity-score (matrix-get-cell similarity-matrix row column))
                 (max-dynamic-programming-score 0)
                 (max-direction DIRECTION-NONE)
                 (previous-row (- row 1))
                 (previous-column (- column 1))
                 )
              ;; check diagonal
                                        ;; https://en.wikipedia.org/wiki/Smith%E2%80%93Waterman_algorithm
              (if (and (>= previous-row 0) (>= previous-column 0)
                       ;;(> current-similarity-score 0)
                       )
                  (let*
                      ((previous-dynamic-programming-score (matrix-get-cell dynamic-programming-matrix previous-row previous-column))
                       (dynamic-programming-score (+ previous-dynamic-programming-score current-similarity-score))
                       )
                    ;;(princ (format "  DP row %d column %d DP-score %d" previous-row previous-column  previous-dynamic-programming-score))
                    ;;(terpri)
                    (if (> dynamic-programming-score max-dynamic-programming-score)
                        (progn
                          (setq max-dynamic-programming-score dynamic-programming-score)
                          (setq max-direction DIRECTION-LEFT-UP)
                          )
                      nil)
                    )
                nil
                )
                                        ;; Check gap score with row
              (if (>= previous-row 0)
                  (let*
                        (
                                        ;;    4 5
                                        ;; 3  x
                                        ;; 4  x

                         (previous-dynamic-programming-score (matrix-get-cell dynamic-programming-matrix previous-row column))
                         (dynamic-programming-score (+ previous-dynamic-programming-score SCORE-DELETION))
                         )
                      (if (> dynamic-programming-score max-dynamic-programming-score)
                          (progn
                            (setq max-dynamic-programming-score dynamic-programming-score)
                            (setq max-direction DIRECTION-UP))
                        nil)
                      )
                nil
                  )
                                        ;; check gap score with column
              (if (>= previous-column 0)
                      (let*
                          (
                                        ;;    5 6
                                        ;; 5
                                        ;; 6  x x

                           (previous-dynamic-programming-score (matrix-get-cell dynamic-programming-matrix row previous-column))
                           (dynamic-programming-score (+ previous-dynamic-programming-score SCORE-INSERTION))
                           )
                        (if (> dynamic-programming-score max-dynamic-programming-score)
                            (progn
                              (setq max-dynamic-programming-score dynamic-programming-score)
                              (setq max-direction DIRECTION-LEFT))
                          nil))
                    nil
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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; stuff

(defun get-string-from-file (file-path)
  (with-temp-buffer
    (insert-file-contents file-path)
    (buffer-string)))

(defun load-document (file-path)


  (let*
      (
       (content-1 (get-string-from-file file-path))
       (content-2 (replace-regexp-in-string "!" " ! " content-1))
       (content-3 (replace-regexp-in-string "--" " -- " content-2))
       (content-4 (replace-regexp-in-string "," " , " content-3))
       (content-5 (replace-regexp-in-string "\\." " . " content-4))
       (content-6 (replace-regexp-in-string "?" " ? " content-5))
       (sequence-list (split-string content-6))
       (sequence (vconcat (vector) sequence-list))
       )
    (make-document
     :file-path file-path
     :content content-1
     :sequence sequence
     )
       ))

(defun print-alignment (alignment document-a document-b)
  (princ "This is an alignment.")
  (terpri)
  )

(defun get-alignments (document-a document-b similarity-matrix dynamic-programming-matrix direction-matrix)
  (let*
      (
       (row 0)
       (row-count (matrix-row-count dynamic-programming-matrix))
       (column-count (matrix-column-count dynamic-programming-matrix))
       (alignments (list))
       )
    (while (< row row-count)
      (let*
          (
           (column 0)
           )
        (while (< column column-count)
          (let*
              (
               (similarity-score (matrix-get-cell similarity-matrix row column))
               (dynamic-programming-score (matrix-get-cell dynamic-programming-matrix row column))
               )
            (if (and (> dynamic-programming-score 0) (> similarity-score 0))
                (progn
                  (let (
                        (my-alignment (get-alignment document-a document-b dynamic-programming-score dynamic-programming-matrix direction-matrix row column))
                        )
                    (setq alignments (cons my-alignment alignments))
                    )
                  )
              nil)
            )
          (setq column (+ column 1))
          )
        )
      (setq row (+ row 1)))

    alignments
    )
  )

(defun checkhash (key my-hash)
  (if (equal (gethash key my-hash) nil)
      nil
    t
    ))

(defun filter-redundant-alignments (alignments)
  ;alignments
  ;)

;(defun filter-redundant-alignments-2 (alignments)
  (let

      ;; build a hash for every alignment
      (
       (my-hash (make-hash-table :test 'equal))
       )
    (mapcar (lambda (alignment)
              (let*
                  (
                   (indices (alignment-indices alignment))
                   (first-pair (aref indices 0))
                   (index-a (pair-index-a first-pair))
                   (index-b (pair-index-b first-pair))
                   (key (cons index-a index-b))
                   (value (length indices))
                   )

                ;; key is already used, check if this new value is better
                (if (checkhash key my-hash)
                    (if (> value (gethash key my-hash))
                        (puthash key value my-hash)
                      )
                    (puthash key value my-hash)
                    )
                )
              )
            alignments
            )

    (defun filter-redundant-alignments-internal (alignments)
      (if (equal alignments nil)
          alignments
        (let*
            (
             (first (car alignments))
             (rest (cdr alignments))
             (filtered-rest (filter-redundant-alignments-internal rest))
             (indices (alignment-indices first))
             (first-pair (aref indices 0))
             (index-a (pair-index-a first-pair))
             (index-b (pair-index-b first-pair))
             (key (cons index-a index-b))
             (value (length indices))
             (best-value (gethash key my-hash))
             (keep-first (= value best-value))
             )
          (if keep-first
              (cons first filtered-rest)
            filtered-rest)
          )
        )
      )

    (filter-redundant-alignments-internal alignments)
    )
  )

(defun filter-alignments-with-minimum-match-count (alignments minimum-match-count)
  ;;)
  ;;(princ (format "Input: %d" (length alignments)))
  ;;(terpri)

  (if (equal alignments nil)
      alignments

    (let*
        (
         (first-item (car alignments))
         (other-items (cdr alignments))
         (other-filtered-items (filter-alignments-with-minimum-match-count other-items minimum-match-count))
         (match-count (alignment-match-count first-item))
         (keep-first (>= match-count minimum-match-count))
         )
      (if keep-first
          (cons first-item other-filtered-items)
        other-filtered-items)
    )
    )
  )


(defun align-documents (document-a document-b)

  (princ (format "------------------------------------------------------------------------------"))
  (terpri)
    (princ "Alignments"
           )
    (terpri)
    (terpri)

    (princ "Document A")
    (terpri)
    (document-print document-a)
    (terpri)

    (princ "Document B")
    (document-print document-b)
    (terpri)

                                        ;; TODO...

    (let*
        (
         (row-count (document-sequence-length document-a))
         (column-count (document-sequence-length document-b))
         (similarity-matrix (create-matrix row-count column-count))
         (dynamic-programming-matrix (create-matrix row-count column-count))
         (direction-matrix (create-matrix row-count column-count))
         ;;(similarity-matrix (make-similarity-matrix document-a document-b))
         )

      (populate-similarity-matrix document-a document-b similarity-matrix)

      (run-dynamic-programming-code document-a document-b similarity-matrix dynamic-programming-matrix direction-matrix)

      (if OPTION-PRINT-MATRIX
          (progn
            (princ "Similarity matrix")
            (terpri)
            (matrix-print document-a document-b similarity-matrix)


            (princ "Dynamic programming matrix")
            (terpri)
            (matrix-print document-a document-b dynamic-programming-matrix)

            (princ "Direction matrix")
            (terpri)
            (matrix-print document-a document-b direction-matrix)
            )
        )

      (let*
          (
           (minimum-match-count 3)
           (raw-alignments (get-alignments document-a document-b similarity-matrix dynamic-programming-matrix direction-matrix))
           (alignments-2 (filter-alignments-with-minimum-match-count raw-alignments minimum-match-count))
           (alignments (filter-redundant-alignments alignments-2))
           )
        (princ (format "Alignments: %d" (length alignments)))
        (terpri)
        (terpri)

        (mapcar (lambda (alignment)
                  (alignment-print alignment)
                  )
                alignments)
        )
      )

    (princ
     "End of alignments")
    (terpri)

       )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; main
(defun main()

  (let*
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

       (ref (load-document "ref-text.txt"))
       (text-a (load-document "text-a.txt"))
       )

    (align-documents ref text-a)
    ;;(align-documents ref my-text)
    ;;(align-documents hello hello)
    ;;(align-documents my-text my-text)
     ;;(align-documents gnu-emacs-wikipedia-page my-text)
     ;;(align-documents spacemacs-github-page my-text)
     ;;(align-documents spacemacs-twitter-page my-text)
  ))


(main)
