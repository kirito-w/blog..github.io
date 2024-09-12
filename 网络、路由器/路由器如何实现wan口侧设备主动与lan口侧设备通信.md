- https://www.zhihu.com/question/579697306/answer/3279152185?utm_campaign=shareopn&utm_medium=social&utm_psn=1815902430698795008&utm_source=wechat_session
- https://www.zhihu.com/question/579697306/answer/3280420871?utm_campaign=shareopn&utm_medium=social&utm_psn=1815903938102308864&utm_source=wechat_session
- https://www.zhihu.com/question/579697306/answer/2853403046?utm_campaign=shareopn&utm_medium=social&utm_psn=1815905059667599361&utm_source=wechat_session
- https://www.zhihu.com/question/579697306/answer/3280420871?utm_campaign=shareopn&utm_medium=social&utm_psn=1815905161706602496&utm_source=wechat_session

# 为什么默认情况下wan口侧无法访问到内网的设备：
- 一般情况下，`内网设备访问外网`，是由`内网`的设备`向外网`服务器`建立TCP连接`，外网服务器就会发送数据包给内网的设备，这个`数据包回传给内网设备的过程`就是`路由器的NAT转发`。
- `防火墙默认`情况下，是为了`保护内网`的，所以，`一般的策略`是`禁止外网访问内网`，`许可内网访问外网`。
- 如果是这种情况：`路由器的WAN侧的服务器（即外网），去ping一个路由器LAN侧的PC（即内网下挂设备）`。
    - 这种情况一般是无法ping通的，有以下原因：
        - 1、`通常的路由器`被设定为只做`内网到外网`的`NAT转发`。而`不负责将外网的IP包转发给内网设备`，这并不是路由器没有这个能力。而是`通常会出于安全考虑`而`拒绝外网的连接建立请求`。这就是为啥`内网的设备不能被公网直接访问到的原因`。
        - 2、如果路由器`没有设置`合适的`端口映射或NAT规则`来`处理这个数据包`，路由器`将会丢弃或拒绝这个数据包`

# 如果想要从wan口侧访问到内网的设备，有什么办法？
- 1、`关闭WAN口侧NAT`，`配置对应路由`，WAN口侧进来的数据包不再进行NAT，直接进行路由转发。
- 2、`DMZ主机`：将内网设备设为DMZ主机。（DMZ就是为了`让外网能访问内部的资源`，而`内网`呢，`也能访问这个服务器`，但这个`服务器是不能主动访问内网`的。）
- 3、`端口映射`：将内网设备映射到路由器的端口上，让路由器将外网请求转发到内网设备。

## 需要注意的是，`2和3的本质都是NAT的应用`，并且都无法直接在外网以内网设备本身的IP访问内网设备。`只有1可以直接以内网设备本身ip访问到内网设备`。