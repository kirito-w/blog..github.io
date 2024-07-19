# IPV6
## 概念：
- IPv6（Internet Protocol version 6）是一种用于互联网的网络协议。它是IPv4（Internet Protocol version 4）的后继者。IPv4是当前广泛使用的网络协议，但由于`可用的IP地址数量有限`，IPv4已经开始面临地址枯竭问题。
- 为了解决这个问题，`IPv6`被设计出来以`提供更大的IP地址空间`。IPv6使用`128位地址`，相比之下，IPv4仅有32位地址。这意味着IPv6可以`支持更多的设备连接到互联网`，同时提供更多的网络扩展性。
- 除了更大的地址空间外，IPv6还引入了一些其他改进。其中包括更好的端到端连接、自动配置的地址分配、更好的安全性、支持多播和移动性等功能。
- 尽管IPv6已经存在一段时间，但在全球范围内的广泛部署仍然在进行中。逐渐过渡到IPv6的目标是确保互联网的可持续发展，并满足日益增长的连接需求。

## 地址构成：
- 地址长度：IPv6地址长度为128位，相比IPv4的32位更长。这种加长的地址长度使得IPv6拥有了更广阔的地址空间。
- 格式：IPv6地址使用十六进制表示，并通常以`八组四位十六进制数字`的形式书写，中间用冒号分隔。例如，一个IPv6地址可能是2001:0db8:85a3:0000:0000:8a2e:0370:7334。但为了简化，每组开头多余的0可以省略，连续的只包含0的组可以用双冒号(::)替代。例如，上述地址可以简写为2001:db8:85a3::8a2e:370:7334。
- 范围：IPv6地址有不同的范围，决定了它们的使用方式。例如，链路本地地址只能在单个网络链路内使用，而全局单播地址可用于跨网络通信。
- 类型：IPv6地址可以分为三种主要类型：`单播、组播和任播`。`单播`地址用于`标识单个网络接口`，`组播`地址可用于`向多个目的地同时发送数据包`，而`任播`地址用于`标识一组接口`，数据会被发送到最近的可用接口。

## 地址分类：
- 单播：
    - `全球可达单播地址`(Global Unicast Address)：如2001:1（类似于IPv4的单播）,类似v4中公网地址;范围：2000::/3，可在`公网范围内传输`
    - `链路本地地址`(Link-local address)：如FE80::1；范围：FE80::/10~~FEBF::/10，`本地局域网通信`。（`会在ipv6服务开启后自动生成！`）
    - `唯一本地地址`(Unique Local Address)：如FC00:1,`类似v4中私网`地址(如192.168.2.3),范围：FC00::/7~~FEFF::/7，`本地局域网通信`
    - `特殊单播地址`：
        - 全0地址，如::/128（类似于IPv4的0.0.0.0）
        - 环回地址，如::1/128（类似于IPv4的127.0.0.1）
	    - v4兼容地址: 0:0:0:0:0:0::/96 可用于v4/v6协议栈优先级顺序调整

- 组播：
    - 类似于IPv4的组播地址，FF00::/8（前8个比特是1的）,注意：ipv6的GUA地址是通过组播交互来获取的
- 任意播：
    - 任播地址是IPv6网络中用于`标识一组接口`的地址类型。当数据包被发送到一个任播地址时，它会被路由器`自动转发到距离最近的可用接口`。这种地址类型在多播地址的基础上扩展而来，但与单播地址有所不同。

## 地址获取：
- 1).只要`本地ipv6服务开启`，系统会自动生一个`fe80打头的Link-local address(ipv6链路本地地址)`，该地址`只能在本地局域网通信`，不能在公网中传输；(所以也`可根据接口该地址是否存在`判断`是否开启了ipv6服务`)；
- 2).ipv6取消了arp协议，转而`采用ndp(Neighbor Discovery Protocol)协议`,来`生成GUA（全球可达单播地址）地址`(有时还配合dhcpv6)，`通过GUA地址来访问internet中服务`。
- 3).`ipv6默认路由`根据`网关发送`过来`RA数据包的源地址生成`（同时`需要RA报文`中`Router lifetime不得为0`；若`为0不会生成默认路由`）

- 获取过程：
    - `odhcp6c进程`起来后，会主动`通过LLA(链路本地地址)地址`(link local address)发送`RS包`，`上级光猫器`收到后会送`RA包`，我们设备解析RA包，`根据RA包中相应字段决定生成自动生成GUA/ULA地址`，或通过dhcpv6方式去获取GUA/ULA地址完成地址配置

## 地址状态查询：
- Windows查询：`netsh interface ipv6 show addr`
- linux查询：`ip -6 addr`

## 邻居表项：
- windows：`netsh interface ipv6  show neighbors`
- linux：`ip -6 neigh`
### 状态机：  
![](img/%E5%9B%BE%E7%89%8755.png)  
- 1:incomplete。 初始时A,B双方未通过信，A先发送NS报文并生成缓存条目，此时A邻居状态变为incomplete。
- 2:reachable。 reachable状态则是已经收到了NA响应报文（30s内）
- 3:stale。 当设备处于reachable状态后30s内，如果没有收到其他报文，则邻居状态进入stale状态，表示“陈旧”。如果设备不需要向该邻居发送数据，则此状态会一直持续下去，要注意的是，stale状态是这些状态中唯一可以稳定持续存在的状态。
- 4:delay。 当设备处于stale状态后，有向该邻居发送数据的需求时，该设备会首先发送NS包检测对方是否在线，当NS包发送完毕后，设备处于delay状态。delay时间为5s，在这5s内，如果收到了对方的NA包，则会进入到reachable状态，如果没有收到，则会进入probe状态。
- 5:probe。 当设备进入probe状态后，会间隔1s发送NS报文，但是这里发送的NS报文为单播的NS报文（目的IP地址为该IPv6邻居的IP地址）。若3s内仍然收不到NA报文，则认定该IPv6邻居已经下线，接下来会在自己的IPv6邻居表中删除该邻居，邻居状态变为Empty。如果有应答则邻居状态变为Reachable。

## 相关进程:
- odhcp6c:负责从上级光猫拿地址，并配置在wan口及lan口上，随接口up/down事件而创立或停止
- odhcpd:负责给lan侧pc分配地址(dhcpv6方式)，相关地址在/tmp/hosts/odhcpd 中查询,随系统启动而启动
- netifd:负责接口ip、路由等相关数据配置、网络事件维护

### `odhcp6c增加调试后查看日志方法（odhcpd）`：
- 1）dhcpv6.sh中起odhcp6c地方增加 -v  ，如
                proto_run_command "$config" odhcp6c \
                -s /lib/netifd/dhcpv6.script \
                -v $opts $iface       
- 2）logread -f |grep dhcp (odhcpd进程日志也可在测查看)


## 从抓取的包中筛选RA包：
- icmpv6.type == 134  r icmpv6.type == 135

## 抓包分析dhcpv6数据包：https://cshihong.github.io/2018/02/01/DHCPv6%E5%9F%BA%E7%A1%80/


# ipv6常见指令 
- wireshark筛选ipv6包：icmpv6.type == 134 or icmpv6.type == 135 or dhcpv6
- linux抓取ipv6包：tcpdump -i ifname -v ip6


- lan侧分配地址模式：
    - slaac模式：无状态（无PD），M标记位为0，PD位为0
    - dhcpv6模式：有状态（有PD），M标记位为1，PD位为1

- linux下查看ipv6地址：ip -6 addr show ifname
- windows下查看ipv6地址：netsh interface ipv6 show address


# 博客
- https://blog.csdn.net/weixin_57469797/article/details/124205693
- https://cshihong.github.io/2018/01/29/IPv6%E9%82%BB%E5%B1%85%E5%8F%91%E7%8E%B0%E5%8D%8F%E8%AE%AE/
- https://zhuanlan.zhihu.com/p/653328689
- https://lwz322.github.io/2019/07/25/IPv6_Home.html