(:defpackage #:route
  (:use #:cl)
  (:import-from #:main #:*app*))
(in-package #:route)

(defmacro defroute (name (params &rest route-args) &body body)
  `(setf (ningle:route *app* ,name ,@route-args)
         (lambda (,params)
           (declare (ignorable ,params))
           ,@body)))

(defun dao->plist (dao)
  (list :|郵便番号| (table-zipcode dao)
        :|都道府県| (table-prefecture dao)
        :|市区町村| (table-city dao)
        :|町域| (table-town dao)
        :|都道府県（読み）| (table-prefecture-yomi dao)
	:|市区町村（読み）| (table-city-yomi dao)
        :|町域（読み）| (table-town-yomi dao)))

(defmacro with-protect-to-json (&body body)
  `(handler-case
       `(200 (:content-type "application/json")
             (,(jojo:to-json (progn ,@body))))
     (error (e)
       `(500 (:content-type "application/json")
             (,(jojo:to-json (list :|error| (format nil "~A" e))))))))

(defun asc (key alist)
  (cdr (assoc key alist :test #'string=)))

(defroute "/zipcode/:zipcode" (params :method :POST)
  (with-protect-to-json (dao->plist (mito:find-dao 'table :zipcode (asc :zipcode params)))))
