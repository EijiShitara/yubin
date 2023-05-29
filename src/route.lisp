(defpackage #:route
  (:use #:cl
	#:jonathan
	#:clack
	#:ningle
        #:table)
  (:import-from #:cl-ppcre #:scan)
  (:import-from #:main #:*app*)
  (:export #:invalid-parameter
	   #:not-found))
(in-package #:route)

(defmacro defroute (name (params &rest route-args) &body body)
  `(setf (ningle:route *app* ,name ,@route-args)
         (lambda (,params)
           (declare (ignorable ,params))
           ,@body)))

(defun dao->plist (dao)
  (list :|郵便番号| (zipcode-address-zipcode dao)
        :|都道府県| (zipcode-address-prefecture dao)
        :|市区町村| (zipcode-address-city dao)
        :|町域| (zipcode-address-town dao)
        :|都道府県（読み）| (zipcode-address-prefecture-yomi dao)
	:|市区町村（読み）| (zipcode-address-city-yomi dao)
        :|町域（読み）| (zipcode-address-town-yomi dao)))

(defmacro with-protect-to-json (&body body)
  `(handler-case
       `(200 (:content-type "application/json")
             (,(jojo:to-json (progn ,@body))))
     (invalid-parameters (e) 
       `(400 (:content-type "application/json")
	     (,(jojo:to-json (list :|error| (format nil "Invalid Parameters: ~A" (message-of e)))))))
     (not-found (e)
       `(404 (:content-type "application/json")
	     (,(jojo:to-json (list :|error| (format nil "Not Found"))))))
     (error (e)
       `(500 (:content-type "application/json")
             (,(jojo:to-json (list :|error| (format nil "~A" e))))))))

(defroute "/zipcode/:zipcode" (params :method :POST)
  (with-protect-to-json (let ((zipcode (asc :zipcode params)))
			  (when (or (cl-ppcre:scan "[^0-9]" zipcode)
				    (< (length zipcode) 5)
				    (> (length zipcode) 7)) ; paramsが期待しているものと違うかチェック
			    (error 'invalid-parameters :message "wrong zipcode"))
			  (let ((address (mito:find-dao 'zipcode-address :zipcode zipcode)))
			    (unless address ; DBに情報が登録されていなければ
			      (error 'not-found))
			    (dao->plist address)))))

(define-condition invalid-parameters (error) ((message :initarg :message :reader message-of)))
(define-condition not-found (error) ())


(defun asc (key alist)
  (cdr (assoc key alist :test #'string=)))

(defroute "/zipcode/:zipcode" (params :method :POST)
  (with-protect-to-json (dao->plist (mito:find-dao 'zipcode-address :zipcode (asc :zipcode params)))))
