(defpackage yubin/tests/main
  (:use :cl
        :yubin
        :rove
        :dexador))
(in-package :yubin/tests/main)

;; NOTE: To run this test file, execute `(asdf:test-system :yubin)' in your Lisp.

(deftest test-target-1
  (testing "should (string= "{\"郵便番号\":640941,\"都道府県\":\"北海道\",\"市区町村\":\"札幌市中央区\",\"町域\":\"旭ケ丘\",\"都道府県（読み）\":\"ﾎｯｶｲﾄﾞｳ\",\"市区町村（読み）\
\":\"ｻｯﾎﾟﾛｼﾁｭｳｵｳｸ\",\"町域（読み）\":\"ｱｻﾋｶﾞｵｶ\"}" (dex:post "http://localhost:5000/zipcode/640941")) be true"
    (ok (string= "{\"郵便番号\":640941,\"都道府県\":\"北海道\",\"市区町村\":\"札幌市中央区\",\"町域\":\"旭ケ丘\",\"都道府県（読み）\":\"ﾎｯｶｲﾄﾞｳ\",\"市区町村（読み）\":\"ｻｯﾎﾟﾛｼ\
ﾁｭｳｵｳｸ\",\"町域（読み）\":\"ｱｻﾋｶﾞｵｶ\"}" (dex:post "http://localhost:5000/zipcode/640941")))))
