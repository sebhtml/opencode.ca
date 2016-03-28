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

;; print    imprimer pour un ordinateur
;; princ    imprimer pour un humain
;; terpri   imprimer un saut de ligne
;; format   formater une chaîne

;; defun    Définir une fonction
;; let      définir des variables
;; let*     définir des variables avec inter-dépendance
;; setq     changer la valeur d'une variable


;; cons     créer une paire
;; car      obtenir l'élément de gauche d'une paire
;; cdr      obtenir l'élément de droite d'une paire

;; list     créer une liste

;; vector   créer un vecteur
;; aref     obtenir un élément d'un vecteur
;; aset     changer la valeur d'un élément d'un vecteur

;; if
;; while
;; =
;; <
;; <=
;; >
;; >=

(defun intro-pair ()
  (let*
      (
       (my-pair (cons 22 33))
       (left (car my-pair))
       (right (cdr my-pair))
       )
    (princ (format "Left: %d Right: %d" left right))
    (terpri)
    )
  )

(defun intro-list ()
  (let (
        (my-list (list "Mon" "processeur" "est" "rapide" "comme" "un" "Faucon" "pèlerin" "."))
        )
    (print my-list)
    (terpri)
    )
  )

(defun intro-vector ()
  (let (
        (my-vector (vector "Mon" "processeur" "est" "rapide" "comme" "un" "Faucon" "pèlerin" "."))
        )
    (print my-vector)
    (terpri)
    )
  )

(defun reverse-list (my-list)
  (defun reverse-list-2 (my-list my-new-list)
    (if (equal my-list nil)
        my-new-list
      (reverse-list-2 (cdr my-list) (cons (car my-list) my-new-list ))
      )
    )
  (reverse-list-2 my-list (list))
  )

(defun intro-recursion ()
  (let*
      (
       (my-list (list 20 21 22 23 24 25 26 27 28 29))
       (list2 (reverse-list my-list))
       )

    (princ my-list)
    (terpri)
    (princ list2)
    (terpri)
    )
  )

(defun main ()
  (intro-pair)
  (intro-list)
  (intro-vector)
  (intro-recursion)
  )



(main)
