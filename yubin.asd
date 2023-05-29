(defsystem "yubin"
  :version "0.1.0"
  :author ""
  :license ""
  :depends-on ("jonathan"
	       "ningle"
	       "clack"
	       "fare-csv"
	       "mito"
	       "dexador"
	       "cl-ppcre")
  :components ((:module "src"
		:components
		((:file "main")
                 (:file "table")
                 (:file "route" :depends-on ("table"))
                 (:file "insert-data")
                 (:file "seed" :depends-on ("insert-data")))))
  :description "App to search an address from zipcode"
  :in-order-to ((test-op (test-op "yubin/tests"))))

(defsystem "yubin/tests"
  :author ""
  :license ""
  :depends-on ("yubin"
	       "rove")
  :components ((:module "tests"
		:components
		((:file "main"))))
  :description "Test system for yubin"
  :perform (test-op (op c) (symbol-call :rove :run c)))
