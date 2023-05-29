(defpackage #:main
  (:use #:cl
        #:clack
        #:ningle
        #:mito)
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
(defun connect-db (&key (database-name "example") (username "eijishitara"))
  (mito:connect-toplevel :postgres :database-name database-name :username username))
