# Yubin

## Usage
Web API to search an address from zipcode.  
For instance, if you want to know the address for zip code 640941 and type
```common lisp
(dex:post "http://localhost:5000/zipcode/640941")
```
in the REPL, you will get:
``` json
"{\"郵便番号\":640941,\"都道府県\":\"北海道\",\"市区町村\":\"札幌市中央区\",\"町域\":\"旭ケ丘\",\"都道府県（読み）\":\"ﾎｯｶｲﾄﾞｳ\",\"市区町村（読み）\":\"ｻｯﾎﾟﾛｼﾁｭｳｵｳｸ\",\"町域（読み）\":\"ｱｻﾋｶﾞｵｶ\"}"
```
## Installation
```
ros install EijiShitara/yubin
```
