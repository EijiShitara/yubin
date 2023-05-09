(defpackage #:main
  (:use #:cl)
  (:export #:*app*
           #:*handler*
           #:start
           #:stop
           #:connect-db))
(in-package #:main)

(defparameter *app* (make-instance 'ningle:app))
(defparameter *handler* nil)

;; start server
(defun start (&key (port 5000))
  (setf *handler*
        (clack:clackup *app*
                       :port port)))

;; stop server
(defun stop () (clack:stop *handler*))

;; connect to database
(defun connect-db ()
  (mito:connect-toplevel :postgres :database-name "example" :username "eijishitara"))


*app*

(start)

(connect-db)
