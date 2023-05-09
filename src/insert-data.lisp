(:defpackage #:insert-data
  (:use #:cl)
  (:import-from #:fare-csv #:read-csv-file))
(in-package #:insert-data)

(defun insert-data (filename)
  (let ((address-list (cdr (read-csv-file filename))))
    (dolist (address address-list)
      (let ((new-instance (make-instance 'table
                                         :zipcode (parse-integer (first address))
		                         :prefecture (second address)
                                         :city (third address)
                                         :town (fourth address)
                                         :prefecture-yomi (fifth address)
                                         :city-yomi (sixth address)
                                         :town-yomi (seventh address))))
        (mito:insert-dao new-instance)))))

(insert-data "KEN_ALL.csv")
