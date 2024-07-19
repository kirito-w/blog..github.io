# openwrt下通过ubus和uloop在lua中注册ubus接口示例：
- https://github.com/mkschreder/openwrt-ubus/blob/master/lua/test.lua


- https://www.cnblogs.com/cxt-janson/p/11532158.html
- https://e-mailky.github.io/2017-08-14-ubus
- https://e-mailky.github.io/2017-08-14-ubus2

## 通过rpcd进程（常驻进程），注册ubus接口：https://openwrt.org/docs/techref/rpcd
- rpcd是使用shell实现ubus接口的，可以适当使用/usr/share/libubox/jshn.sh用来构造和解析json格式数据

- tcp_map的返回值必需要用这种形式：
```
	return nil, myerr.make(myerr.EXTERNAL_ERROR, "VERSION_WRONG")
```

- ubus作为一个消息总线，充当了`中间件`的角色。它`允许不同进程`之间进行`异步的消息传递`，实现了进程间的通信和协作。

- ubus还允许`一个进程调用另一个进程的函数`。

- ubus过程：
	- 初始化：在发送和接收消息之前，需要初始化ubus。这包括创建ubus实例和与总线进行连接。
	- `注册对象`：每个进程可以注册自己的对象，以便其他进程可以订阅或调用该对象的方法。注册对象涉及指定对象的名称、方法以及相应的回调函数。
	- `发布消息`：当一个进程需要向其他进程发送消息时，它可以使用ubus的发布机制。`在发布消息时，进程需要确定消息的类型和内容`。`其他订阅了该类型的消息的进程将会接收到这条消息`。
	- `订阅消息`：进程`可以选择订阅特定类型的消息`。当`有新消息发布`时，`订阅了该类型的进程将会接收到该消息`，并可以进行相应的处理。
	- `调用远程方法`：ubus还支持RPC（远程过程调用）的方式，`允许一个进程调用另一个进程的函数`。调用远程方法需要`指定目标对象、方法名称和相应的参数`。`被调用的方法`将`在远程进程`中`执行`，并`返回结果`。

- ubus -t 设置超时时间


## ubus总线
- https://blog.csdn.net/whstudio123/article/details/120811616


## ubus的应用场景和局限性
- https://blog.51cto.com/u_3078781/3291601