# 自転車在庫管理API


## 1. 自転車登録 API  

URL(ローカル):     http://localhost:3000/bikes/  
URL(AWS):        http://18.177.128.29:3000/bikes
メソッド:   POST  
パラメータ： brand_name (ブランド名)、serial_number (車体番号)  
レスポンス：
成功時 ステータスコード 201 と以下を返す (自転車登録成功)  
{  
　"status": 201,  
　"message": "[brand_name] ([serial_number])  Successfully registered!!"  
}  
  
失敗時(バリデーションエラー) ステータスコード 422 を返す  
{  
　"status": 422,  
　"error": [  
　　"Serial number has already been taken"  
　　 もしくは、"serial_number cannot be blank", "Brand Name cannot be blank"  
　]  
}  
  
## 2. 自転車情報取得 API    

URL(ローカル):    http://localhost:3000/bikes/  
URL(AWS):        http://18.177.128.29:3000/bikes
メソッド：  GET  
パラメータ：brand_name (ブランド名)  
レスポンス:　  
成功時 ステータスコード200と以下を返す  
{  
　"data": [  
　　{  
　　　"id": 1,  
　　　"serial_number": "hoge",  
　　　"sold_at": null  
　　　},  
　　　{  
　　　"id": 30,  
　　　"serial_number": "huga",  
　　　"sold_at": "2020年3月31日 21時16分"  
 　　},  
　　]  
}  
失敗時　ステータスコード404と以下を返す  
{  
　"status": 404,  
　"error": "Brand cannot be found"  
}  
  
## 3. 自転車売却API  
URL(ローカル):    http://localhost:3000/bikes/ **[serial_number]**  
URL(AWS):        http://18.177.128.29:3000/bikes/ **[serial_number]**  
メソッド：  PATCH  
パラメータ： **URLに付加**  
レスポンス:　  
成功時　ステータスコード200と以下を返す   
{  
　"status": 200,  
　"message": "Congratulations! Hoge is sold"  
}  
  
売り切れ時　ステータスコード422と以下を返す  
{  
　"status": 422,  
　"message": "[brand_name] ([serial_number]) already sold out!"  
}  
  
失敗時　ステータスコード404と以下を返す  
{  
　"status": 404,  
　"error": "Bike cannot be found"  
}  

