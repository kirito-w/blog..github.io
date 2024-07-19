# 四表五链
## 四表
- 1.filter 表:控制数据包是否允许`进出及转发`，可以控制的链路有 `INPUT、FORWARD 和 OUTPUT`。
- 2.nat 表:控制数据包中`地址转换`，可以控制的链路有 `PREROUTING、INPUT、OUTPUT和 POSTROUTING`。
- 3.mangle 表:修改数据包中的`原数据`，可以控制的链路有 `PREROUTING、INPUT、OUTPUT、FORWARD 和 POSTROUTING`。
- 4.raw 表:控制 nat 表中`连接追踪机制的启用状况`，可以控制的链路有 `PREROUTING、OUTPUT`。


## 五链
![](img/%E4%BC%81%E4%B8%9A%E5%BE%AE%E4%BF%A1%E6%88%AA%E5%9B%BE_17198917647214.png)
- “五链”是指内核中控制网络的 NetFiter定义的5个规则链，每个规则表中包含多个数据链:
    - INPUT(入站数据过滤)
    - OUTPUT(出站数据过滤)
    - FORWARD(转发数据过滤)
    - PREROUTING(路由前过滤)
    - POSTROUTING(路由后过滤)

**`数据包过滤流程是：数据包先到PREROUTING(可能会做NAT处理) --> 路由决策 --> 根据路由决定数据包由FORWARD还是INPUT处理 --> FORWARD或者INPUT处理完成后，都将到POSTROUTING(可能做NAT处理)`**

### 数据包一般可以分为以下情况：
- 1、外部数据包是发送给其他设备，本机只负责做路由转发 ———— PREROUTING->FORWARD->POSTROUTING
- 2、外部数据包是发送给本机的 ———— PREROUTING->INPUT
- 3、本机发送数据包到外部主机 ———— OUTPUT->POSTROUTING

## 案例：
- 1、根据MAC地址实现指定时间段上网功能：
    - iptables -I FORWARD -m mac --mac-source 00:00:00:00:00:00 -m time --timestart 15:20 --timestop 16:00 --weekdays Mon,Fri --monthdays 2,3,5 -j DROP

- 2、将10.0.0.7(本机网关)的9000端口映射到172.16.1.8(内网服务器)的22端口
    - iptables -t nat -A PREROUTING -d 10.0.0.7 -i eth0 -p tcp --dport 9000 -j DNAT --to-destination 172.16.1.8:22


## 一些常识：
- iptables -L 命令`默认只显示 filter 表的规则`，要查看 nat 表中的规则：iptables -t nat -L --line-numbers

# 相关博客
- https://blog.51cto.com/u_15169172/2710200
- https://www.cnblogs.com/meizy/p/iptables.html
