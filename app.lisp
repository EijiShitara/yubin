(ql:quickload '(:ningle :clack :cl-csv :dexador :jonathan :mito))
(defparameter *app* (make-instance 'ningle:app))
(defparameter *handler* nil)

;; start server
(defun start (&key (port 5000))
  (setf *handler*
	(clack:clackup *app*)))

;; stop server
(defun stop () (clack:stop *handler*))

;; connect database
(defun connect-db ()
  (mito:connect-toplevel :postgres :database-name "example" :username "eijishitara")
  ;; (mito:disconnect-toplevel) to diconnect db
  )

;; add function to *app* routing table
(defmacro defroute (name (params &rest route-args) &body body)
  `(setf (ningle:route *app* ,name ,@route-args)
         (lambda (,params)
           (declare (ignorable ,params))
           ,@body)))

(defmacro with-protect-to-json (&body body)
  `(handler-case
       `(200 (:content-type "application/json")
             (,(jojo:to-json (progn ,@body))))
     (error (e)
       `(500 (:content-type "application/json")
             (,(jojo:to-json (list :|error| (format nil "~A" e))))))))

(defun asc (key alist)
  (cdr (assoc key alist :test #'string=)))

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
;; (create-all-table)



(defun split-by-space (seq)
  (split-sequence:SPLIT-SEQUENCE #\Space seq))

(defparameter address-list
  (let ((data (cdr (with-open-file (in "KEN_ALL.csv")
		     (loop for line = (read-line in nil nil)
			   while line
			   collect (concatenate 'string
						(substitute #\space #\,
							    (string-right-trim '(#\return)
							     line))))))))
    (mapcar #'split-by-space data)))

(dolist (address address-list)
  (let ((new-instance (make-instance 'table
				     :zipcode (parse-integer (first address))
				     :prefecture (second address)
				     :city (third address)
				     :town (fourth address)
				     :prefecture-yomi (fifth address)
				     :city-yomi (sixth address)
				     :town-yomi (seventh address))))
    (mito:insert-dao new-instance)))

(defun dao->plist (dao)
  (list :|郵便番号| (table-zipcode dao)
        :|都道府県| (table-prefecture dao)
        :|市区町村| (table-city dao)
        :|町域| (table-town dao)
	:|都道府県（読み）| (table-prefecture-yomi dao)
	:|市区町村（読み）| (table-city-yomi dao)
	:|町域（読み）| (table-town-yomi dao)))


(defroute "/zipcode/:zipcode" (params :method :POST)
  (with-protect-to-json (dao->plist (mito:find-dao 'table :zipcode (asc :zipcode params)))))

