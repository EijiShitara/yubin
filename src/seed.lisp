(defpackage #:seed
  (:use #:cl #:mito)
  (:import-from #:cl-dbi)
  (:import-from #:main #:connect-db)
  (:import-from #:insert-data #:insert-data)
  (:import-from #:table
                #:zipcode-address
                #:create-all-table)
  (:export #:register-data))

(in-package #:seed)

(defun register-data ()
  (connect-db)

  (mito:execute-sql "DROP TABLE IF EXISTS example;")

  (create-all-table)

  (insert-data (merge-pathnames #P"src/KEN_ALL.csv"
                                (asdf:system-source-directory :yubin)))

  (assert (> (mito:count-dao 'zipcode-address) 0)))
