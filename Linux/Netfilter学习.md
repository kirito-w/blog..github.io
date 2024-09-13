- https://ivanzz1001.github.io/records/post/linuxops/2018/10/16/linux-netfilter
- https://www.huamp.com/post/ogH2kVtw

## iptables和netfilter的关系
- https://cloud.tencent.com/developer/article/1726023
- https://mbd.baidu.com/ug_share/mbox/4a83aa9e65/share?product=smartapp&tk=13d60bb481e4087c2287692554c9ea65&share_url=https%3A%2F%2Fyebd1h.smartapps.cn%2Fpages%2Fblog%2Findex%3FblogId%3D127162358%26_swebfr%3D1%26_swebFromHost%3Dbaiduboxapp&domain=mbd.baidu.com
- https://www.thebyte.com.cn/content/chapter1/netfilter.html#iptables

# Netfilter
## 简介
- Linux Netfilter`是Linux内核中的一部分`，是位于`网卡和内核协议栈之间的一堵墙`，其主要功能是`网络数据包过滤`，即`Linux内核的防火墙`。
- Netfilter提供了一个强大、灵活的框架来`管理和控制Linux系统上的网络通信`。
- 这种管理和控制主要是`通过一系列的钩子（hooks）实现`的，这些钩子位于`网络协议栈的各个关键位置`。

## Netfilter工作原理
- Netfilter通过在`内核网络协议栈中的五个预定义点设置钩子`来工作。
- 这五个预定义点是：`PREROUTING，INPUT，FORWARD，OUTPUT，POSTROUTING。`
- `数据包在这些点上被捕获`，然后`根据`一系列`预定义的规则进行处理`。

## Netfilter数据流图
![](img/Netfilter%E6%95%B0%E6%8D%AE%E6%B5%81.png)

## Netfilter与IPTables的关系
- Iptables是`用户空间的命令行工具`，工作在用户空间，用来`编写规则`，`写好的规则被送往Netfilter`，告诉`内核`如何去`处理信息包`。
- Iptables允许管理员定义过滤规则，这些规则可以基于许多不同的参数，如来源IP地址，目标IP地址，数据包类型等。

