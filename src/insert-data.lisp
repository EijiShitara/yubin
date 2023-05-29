(defpackage #:insert-data
  (:use #:cl #:mito)
  (:import-from #:cl-dbi)
  (:import-from #:table #:zipcode-address)
  (:import-from #:fare-csv #:read-csv-file)
  (:export #:insert-data))
(in-package #:insert-data)

(defun insert-data (file-path)
  (let ((address-list (cdr (read-csv-file file-path))))
    (dbi:with-transaction mito:*connection*
      (dolist (address address-list)
        (mito:create-dao 'zipcode-address
                         :zipcode (parse-integer (first address))
		         :prefecture (second address)
                         :city (third address)
                         :town (fourth address)
                         :prefecture-yomi (fifth address)
                         :city-yomi (sixth address)
                         :town-yomi (seventh address))))))
