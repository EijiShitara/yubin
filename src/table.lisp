(:defpackage #:table
  (:use #:cl))
(in-package #:table)

;; define table
(defmacro deftable (table-name superclass-list &body column-type-pairs)
  `(defclass ,table-name (,@superclass-list)
     ,(mapcar (lambda (col)
                (let* ((col-symbol (if (listp col) (car col) col))
                       (col-name (symbol-name col-symbol))
		       (col-type (if (listp col) (cadr col)))
                       (col-primary (if (find :primary-key col) t nil)))
                  (list col-symbol
                        :accessor (intern (concatenate 'string (symbol-name table-name) "-" col-name))
                        :initarg (intern col-name :keyword)
                        :col-type col-type
                        :primary-key col-primary)))
       column-type-pairs)
     (:metaclass mito:dao-table-class)))

(deftable table ()
  (zipcode :integer) ;; 郵便番号
  (prefecture :text) ;; 都道府県
  (city :text) ;; 市区町村
  (town :text) ;; 町域
  (prefecture-yomi :text) ;; 都道府県（読み）
  (city-yomi :text) ;; 市区町村（読み）
  (town-yomi :text)) ;; 町域（読み）

(defparameter *table-list*
  '(table))

(defun create-all-table ()
  (dolist (table *table-list*)
    (mito:execute-sql (car (mito:table-definition table)))))

(create-all-table)
