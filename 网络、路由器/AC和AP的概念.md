# 概念：
## AC（接入控制器）
- AC是`无线网络的集中管理设备`，它负责管理和控制多个`AP和下挂设备的接入`。
- AC允许网络管理员`对整个无线网络`进行`集中管理、配置和控制`。
- AC通常具有以下功能：`身份验证和授权、流量管理和控制、Wi-Fi频谱管理、设备漫游和无缝切换的协调、安全策略和防火墙`等。
- AC使网络管理员能够实施更高级的管理策略和安全措施，并`提供`对`无线网络的更好可见性和控制性`。
- `AC带有路由功能`。
- `AC一定是路由器，路由器不一定是AC`。 
## AP（接入点）
- AP是`信号发射器和接收器`，它负责`将无线设备的数据转换为适当的信号`，并将其`传输`到`有线网络或其他AP`。
- AP是无线网络中的设备，它`使无线设备`（如笔记本电脑、智能手机和平板电脑等）可以`连接到有线网络或互联网`。
- 也就是说，`无线设备是通过AP访问到互联网的!!!`, 但是同时`AC可以控制某个下挂设备是否可以访问互联网!!!`。
- 在企业或大型网络环境中，通常会有`多个AP来提供无线网络覆盖范围`。

------------------------------------------------------------------------------------------------------------------------

## 为何AP的下挂设备访问互联网需要通过AC？
有以下几个原因：
- `认证和授权`：AC通常用于`集中管理和控制AP和下挂设备的接入`。在上网之前，`下挂设备`通常`需要进行认证和授权`，以`确保`只有`经过验证的设备可以访问网络资源`。`AC负责对设备进行身份验证和授权`，以确保网络的安全性和合规性。
- `流量控制和管理`： AC`可以对AP和下挂设备之间的流量进行管理和控制`。它可以实施各种策略，如`流量限制`、`QoS（服务质量）控制`和`流量分类`，以确保网络资源的合理使用和公平分配。
- `漫游和无缝切换`： 当下挂`设备在AP之间进行漫游`（roaming）或进行无缝切换（seamless handoff）时，`AC`可以`起到协调作用`。AC会`跟踪设备的位置和状态`，并`确保设备在切换AP时`保持`网络连接的连续性和稳定性`。
- `集中管理`： AC允许网络管理员集中管理和配置所有的AP和下挂设备。通过AC，管理员可以轻松地进行配置更改、更新软件和固件、监控网络性能等操作，同时提供了更精细的网络管理和故障排除工具。

=======================================================================================

# AP的分类：
- AP就是`传统有线网络中的无线交换机`，也是`组建小型无线局域网`时最常用的设备。AP`相当于`一个`连接有线网和无线网的桥梁`，其主要作用是`将各个无线网络客户端连接到一起`，然后`将无线网络接入以太网`，从而达到`网络无线覆盖`的目的。
## AP分为胖AP和瘦AP
- 瘦AP（FIT AP）：
    - 也称无线网桥、无线网关，也就是所谓的“瘦”AP。此无线设备的传输机制相当于有线网络中的集线器，在无线局域网中不停地接收和传送数据；任何一台装有无线网卡的PC或者移动终端均可通过AP来使用有线局域网络甚至广域网络的资源。
    - 理论上，当网络中增加一个无线AP之后，即可成倍地扩展网络覆盖直径；还可使网络中容纳更多的网络设备。`每个无线AP基本上都拥有一个以太网接口，用于实现无线与有线的连接`。
    - `瘦AP本身并不能进行配置`，`需要`一台`专门的设备AC`（无线控制器）进行`集中控制管理配置`。
    - 瘦AP需要`通过AC的路由功能`实现访问互联网，`本身没有路由功能`。
    - `“控制器+瘦AP+路由器架构”很常见 一般用于无线网覆盖`，下面的实例就是这种情况。
- 胖AP（FAT AP）：
    - 业界所谓的胖AP，也有人称之为`无线路由器`。
    - 无线路由器与纯AP不同，`除无线接入功能外，一般具备WAN、LAN两个接口，支持地址转换（NAT）功能，多支持DHCP服务器、DNS，以及VPN接入、防火墙等安全功能`。
    - 有些胖AP，`可以自行管理`，不用额外的控制器。
    - 有的AP很高级，自带AC功能。

=======================================================================================

# 实例(控制器+瘦AP+路由器架构)：
- 我们用3个ap 分别用网线连一个poe交换机 能供电的那种, 交换机再连ac, ac有线连一台主机  
![](img/%E5%9B%BE%E7%89%8756.png)

- 我们输入ac上的ip地址 登录上就能管理这三个ap了
- 有何作用呢？
    - 从一个ap所在的楼层 到另一个ap所在的楼层，你`不用再换wifi`了 这`ap*3+ac等东西他们是一体`的，`是一个wifi`

=======================================================================================

# 总结:
## AP是`无线网络的入口点`，负责`将无线设备连接到网络`。
## 而AC是负责`集中管理和控制多个AP和下挂设备`的设备，提供更高级的网络管理功能和安全性。在大型网络环境中，AC和多个AP的结合可以提供稳定、安全且可管理的无线网络覆盖。
## AC-AP的主要作用是`提高路由器覆盖范围！！！`
## AC-AP属于`星型网络拓扑结构`


## 常见问题：
- `如果当elinkc有问题但是不确定什么地方，就手动lua 拉起 elinkc下的main.lua。其他进程也是一样`
- adaptor如果怀疑有问题，可以手动拉起adaptor下的skynet config


=======================================================================================

## AP的注册流程：
- AP工作在`瘦模式`时，需要注册到AC上，`成功注册后才能接受AC的统一管理`，这个过程`也叫AP的上线`。
- AP的注册方式有两种：
    - 1、AC发现AP
        - ①二层模式（Layer 2 Mode）
            - 在二层模式下，AC和AP必须在同一二层网络中，即在同一个VLAN或二层子网中。AP在启动时会发送Discovery Request消息，该消息会被二层网络中的AC接收并回复Discovery Response消息。AP通过收到的Response消息，获得AC的MAC地址，并尝试与AC建立控制通道连接。连接建立后，AP会向AC发送注册请求，并提供自身的标识信息（如MAC地址）。一旦AC确认AP的身份和注册请求，AP将被标记为在线状态，并开始接受AC的管理。
        - ②三层模式（Layer 3 Mode）
            - 在三层模式下，AC和AP可以处于不同的网络子网中，它们可以通过路由器互连。AP在启动时会使用预先配置好的AC列表或在DHCP消息中获取AC的IP地址列表（通过option 43选项）。AP尝试与列表中的AC建立TCP/IP连接，直到成功连接到一个可用的AC。连接建立后，AP会向AC发送注册请求，AC会验证AP的身份并进行相应的配置。一旦AP通过验证和配置，就会被标记为在线状态，并接受AC的统一管理。

    - 2、AP发现AC
        - ①Option 43发现
            - `在AP发现AC的过程中，DHCP Option 43是常用的方式之一`。DHCP服务器可以通过在DHCP应答报文的option 43字段中提供AC的IP地址信息（或其他标识信息）。当AP启动时，它会发送DHCP请求，并在请求中包含option 43字段。DHCP服务器根据option 43字段内容回复DHCP应答报文，其中包含了AC的IP地址信息。AP收到DHCP应答后，连接到AC并完成注册过程。
        - ②AP上静态指定AC列表
            - 当AP上静态指定AC列表时，AP会在配置中预先指定一个或多个AC的IP地址。在AP启动时，它会尝试与列表中的AC之一建立TCP/IP连接。AP会逐个尝试连接列表中的AC，直到成功连接到一个可用的AC。连接建立后，AP会向AC发送注册请求，并提供自身的标识信息（如MAC地址）。AC会验证AP的身份并进行相应的配置。一旦AP通过验证和配置，就会被标记为在线状态，并接受AC的统一管理。


------------------------------------------------------------------------------------------------

### 无论使用哪种方式，AP上线的整个详细过程如下：
- AP启动：AP打开电源并开始自检过程。
- AP连接网络：`AP连接到局域网中`，可以通过有线（如以太网）或无线（如Wi-Fi）方式连接。
- AP发现AC（或者AC发现AP）：AP通过自动发现、手动配置或DHCP Option等方式发现AC的存在，并获取AC的地址信息。
- AP注册：`AP`使用获取到的AC地址信息，`尝试与AC建立TCP/IP连接`。
- AP认证：`AP`向AC`发送注册请求`，并`提供自身的标识信息`，`如MAC地址`等。
- AC验证和配置：AC接收AP的注册请求后，会`验证AP的身份`，并`进行相应的配置`。这可以`包括给AP分配IP地址、分配网络参数、分配无线配置`等。
- AP上线：`一旦AP通过验证和配置阶段，AC会确认AP的在线状态，并开始将其纳入网络管理中。`


### AC+AP 是如何做到 AC只给认证过的AP分配地址的？
- 是通过dhcp包中的option标记位实现的
    - DHCP请求包的option 60是用来指明客户端设备的标识符，通常用于特定厂商的设备在DHCP请求时识别和筛选下挂设备。
    - 通过识别option 60中的特定标识符，DHCP服务器可以根据厂商或设备类型将客户端设备分配到特定的IP地址池或应用特定的配置信息，从而实现对下挂设备的筛选和管理。
    - 这种机制可以帮助网络管理员更有效地管理和配置网络中的不同类型的设备。


### CAPWAP协议：

## 相关文档
- https://blog.csdn.net/weixin_40228200/article/details/120317715
- https://support.huawei.com/enterprise/zh/doc/EDOC1100155254