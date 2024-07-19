# CURL
## 概念：
- curl 是常用的命令行工具，用来请求 Web 服务器。它的名字就是客户端（client）的 URL 工具的意思。
- 它的功能非常强大，命令行参数多达几十种。如果熟练的话，完全可以取代 Postman 这一类的图形界面工具。

使用方法：
- https://www.ruanyifeng.com/blog/2019/09/curl-reference.html

## 一些技巧：
### `从web页面复制curl后，放到shell界面执行`：
    - 1、F12找到对应接口
    - 2、copy-->copy as cURL(bash)
    - 3、将一些请求头删除掉以后，只留命令部分
    - 4、将请求地址改为127.0.0.1 ，执行curl命令

 
### `设备上需要发送http请求时，可以使用curl`:
    - curl是一个功能强大的命令行工具，用于与各种网络协议进行交互，包括HTTP协议。
    - (get)curl http://example.com
    - (post)curl -X POST -d 'data=example' http://example.com

### 当需要使用https请求时，可以加上-k参数：
    - curl -k "https://xxx.com" -o xxx   