;;; ~/.doom.d/lisp/cae-keyboard.el -*- lexical-binding: t; -*-

;;; Remap keys

(define-key key-translation-map (kbd "C-x t )") (kbd "C-x t 0"))
(define-key key-translation-map (kbd "C-x t !") (kbd "C-x t !"))
(define-key key-translation-map (kbd "C-x t @") (kbd "C-x t 2"))
(define-key key-translation-map (kbd "C-c w !") (kbd "C-c w 1"))
(define-key key-translation-map (kbd "C-c w @") (kbd "C-c w 2"))
(define-key key-translation-map (kbd "C-c w ;") (kbd "C-c w 3"))
(define-key key-translation-map (kbd "C-c w =") (kbd "C-c w 4"))
(define-key key-translation-map (kbd "C-c w +") (kbd "C-c w 5"))
(define-key key-translation-map (kbd "C-c w $") (kbd "C-c w 6"))
(define-key key-translation-map (kbd "C-c w &") (kbd "C-c w 7"))
(define-key key-translation-map (kbd "C-c w *") (kbd "C-c w 8"))
(define-key key-translation-map (kbd "C-c w (") (kbd "C-c w 9"))
(define-key key-translation-map (kbd "C-c w )") (kbd "C-c w 0"))

;;; Universal argument

(defvar home-row-numbers-qwerty
  '(?r ?a ?e ?n ?s ?d ?o ?t ?i ?h)
  "list of the qwerty home row keys")

(defvar home-row-numbers-qwerty-numpad
  '(?c ?x ?\. ?o ?t ?i ?w ?l ?y ?\ )
  "keys forming a numpad under the right hand in qwerty")

(defvar home-row-numbers-norm
  '(?1 ?2 ?3 ?4 ?5 ?6 ?7 ?8 ?9 ?0)
  "list of the numbers on the keyboard in normal order")

(defvar home-row-numbers nil)

(home-row-numbers)

(map! :map universal-argument-map
      "l" #'cae-keyboard-insert-current-prefix)
