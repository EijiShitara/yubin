(defpackage yubin/tests/main
  (:use :cl
        :yubin
        :rove
   :dexador)
  (:import-from #:route #:invalid-parameters)
  (:import-from #:route #:not-found))
(in-package :yubin/tests/main)

;; NOTE: To run this test file, execute `(asdf:test-system :yubin)' in your Lisp.

(deftest test-target-1
  (testing "(string= \"{\"郵便番号\":640941,\"都道府県\":\"北海道\",\"市区町村\":\"札幌市中央区\",\"町域\":\"旭ケ丘\",\"都道府県（読み）\":\"ﾎｯｶｲﾄﾞｳ\",\"市区町村（読み）\
\":\"ｻｯﾎﾟﾛｼﾁｭｳｵｳｸ\",\"町域（読み）\":\"ｱｻﾋｶﾞｵｶ\"}\" (dex:post \"http://localhost:5000/zipcode/640941\")) should be true"
    (ok (string= "{\"郵便番号\":640941,\"都道府県\":\"北海道\",\"市区町村\":\"札幌市中央区\",\"町域\":\"旭ケ丘\",\"都道府県（読み）\":\"ﾎｯｶｲﾄﾞｳ\",\"市区町村（読み）\":\"ｻｯﾎﾟﾛｼ\
ﾁｭｳｵｳｸ\",\"町域（読み）\":\"ｱｻﾋｶﾞｵｶ\"}" (dex:post "http://localhost:5000/zipcode/640941"))))
  (testing "(dex:post \"http://localhost:5000/zipcode/1234567\")) should return not-found"
    (ok  (handler-case  (dex:post "http://localhost:5000/zipcode/1234567")
	   (error (not-found) t))))
  (testing "(dex:post \"http://localhost:5000/zipcode/12345\") should return invalid-parameters error"
    (ok  (handler-case  (dex:post "http://localhost:5000/zipcode/12345")
	   (error (invalid-parameters) t))))
  (testing "(dex:post \"http://localhost:5000/zipcode/12345678\") should return invalid-parameters error"
    (ok  (handler-case  (dex:post "http://localhost:5000/zipcode/12345678")
	   (error (invalid-parameters) t))))
  (testing "(dex:post \"http://localhost:5000/zipcode/12345678\") should return invalid-parameters error"
    (ok  (handler-case  (dex:post "http://localhost:5000/zipcode/12345678")
	   (error (invalid-parameters) t))))
  (testing "(dex:post \"http://localhost:5000/zipcode/12345678\") should return invalid-parameters error"
    (ok  (handler-case  (dex:post "http://localhost:5000/zipcode/abcdefg")
	   (error (invalid-parameters) t)))))
