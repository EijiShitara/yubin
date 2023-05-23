(defpackage yubin/tests/main
  (:use :cl
        :yubin
        :rove
   	:dexador)
  (:import-from #:route #:invalid-parameters)
  (:import-from #:route #:not-found))
(in-package :yubin/tests/main)

;; NOTE: To run this test file, execute `(asdf:test-system :yubin)' in your Lisp.

(deftest test-target-1 ;; 正常系の確認
  (testing "(string= \"{\"郵便番号\":640941,\"都道府県\":\"北海道\",\"市区町村\":\"札幌市中央区\",\"町域\":\"旭ケ丘\",\"都道府県（読み）\":\"ﾎｯｶｲﾄﾞｳ\",\"市区町村（読み）\":\"ｻｯﾎﾟﾛｼﾁｭｳｵｳｸ\",\"町域（読み）\":\"ｱｻﾋｶﾞｵｶ\"}\" (dex:post \"http://localhost:5000/zipcode/640941\")) should be true"
    (ok (string= "{\"郵便番号\":640941,\"都道府県\":\"北海道\",\"市区町村\":\"札幌市中央区\",\"町域\":\"旭ケ丘\",\"都道府県（読み）\":\"ﾎｯｶｲﾄﾞｳ\",\"市区町村（読み）\":\"ｻｯﾎﾟﾛｼﾁｭｳｵｳｸ\",\"町域（読み）\":\"ｱｻﾋｶﾞｵｶ\"}" (dex:post "http://localhost:5000/zipcode/640941"))))

  (testing "(string= \"{\"郵便番号\":9071801,\"都道府県\":\"沖縄県\",\"市区町村\":\"八重山郡与那国町\",\"町域\":\"与那国\",\"都道府県（読み）\":\"ｵｷﾅﾜｹﾝ\",\"市区町村（読み）\":\"ﾔｴﾔﾏｸﾞﾝﾖﾅｸﾞﾆﾁｮｳ\",\"町域（読み）\":\"ﾖﾅｸﾞﾆ\"}" (dex:post \"http://localhost:5000/zipcode/9071801\")) should be true"
    (ok (string= "{\"郵便番号\":9071801,\"都道府県\":\"沖縄県\",\"市区町村\":\"八重山郡与那国町\",\"町域\":\"与那国\",\"都道府県（読み）\":\"ｵｷﾅﾜｹﾝ\",\"市区町村（読み）\":\"ﾔｴﾔﾏｸﾞﾝﾖﾅｸﾞﾆﾁｮｳ\",\"町域（読み）\":\"ﾖﾅｸﾞﾆ\"}" (dex:post "http://localhost:5000/zipcode/9071801")))))


(deftest test-target-2 ;; 異常系(not-found)の確認
  (testing "(dex:post \"http://localhost:5000/zipcode/1234567\")) should return not-found"
    (ok  (handler-case  (dex:post "http://localhost:5000/zipcode/1234567")
	   (error (not-found) t)))))


(deftest test-target-3 ;; 異常系(invalid-parameters)の確認
  (testing "(dex:post \"http://localhost:5000/zipcode/12345\") should return invalid-parameters error" ;; 郵便番号の桁不足
    (ok  (handler-case  (dex:post "http://localhost:5000/zipcode/12345")
	   (error (invalid-parameters) t))))
  (testing "(dex:post \"http://localhost:5000/zipcode/12345678\") should return invalid-parameters error" ;; 郵便番号の過剰桁数
    (ok  (handler-case  (dex:post "http://localhost:5000/zipcode/12345678")
	   (error (invalid-parameters) t))))
  (testing "(dex:post \"http://localhost:5000/zipcode/abcdefg\") should return invalid-parameters error" ;; 数字以外の文字列が含まれた郵便番号
    (ok  (handler-case  (dex:post "http://localhost:5000/zipcode/abcdefg")
	   (error (invalid-parameters) t))))
  (testing "(dex:post \"http://localhost:5000/zipcode/640-941\") should return invalid-parameters error" ;; 数字以外の文字列が含まれた郵便番号
    (ok  (handler-case  (dex:post "http://localhost:5000/zipcode/640-941")
	   (error (invalid-parameters) t)))))
