# 四表五链
## 一、四表
- 1.filter 表:控制数据包是否允许`进出及转发`, `专门设计`被用来`过滤数据包`，可以控制的链路有 `INPUT、FORWARD 和 OUTPUT`。
- 2.nat 表:控制数据包中`地址转换`，可以控制的链路有 `PREROUTING、INPUT、OUTPUT和 POSTROUTING`。
- 3.mangle 表:修改数据包中的`原数据`， 一般用来`对数据包进行伪装`。可以控制的链路有 `PREROUTING、INPUT、OUTPUT、FORWARD 和 POSTROUTING`。
- 4.raw 表:一般用来控制`连接跟踪机制的启用状况`, 通过在数据包上`设置标志`，使得其`不会被连接跟踪系统(connection tracking system)所处理`，可以控制的链路有 `PREROUTING、OUTPUT`。

### `表的优先级次序（由高到低）：raw -> mangle -> nat -> filter`

-----------------------------------------

## 二、五链
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

-----------------------------------------

## 三、表链关系  
![](img/%E8%A1%A8%E5%92%8C%E9%93%BE%E7%9A%84%E5%85%B3%E7%B3%BB.png)
- `一张链中可以有多张表`，但是不一定拥有全部的表。
- `数据包的处理`是`根据链来进行`的（即`处理时，是Netfiter里的五个钩子，即五个链来做的`），但是`实际的使用`过程中，是`通过表来作为操作入口`，来`对规则进行定义`的（即`用户层使用IPTables时，添加规则时是根据表作为入口进行的`）。

-----------------------------------------

## 四、表、链、规则之间的关系
- 1、首先IPTables里有四张表`raw、mangle、nat、filter`
- 2、然后`每张表`里会`有各自能控制的链`（见上图）
- 3、接着`每条链`上，可以配置`对应的规则`（如对`满足条件匹配的数据包`进行`允许、拒绝、丢弃`等操作）

-----------------------------------------

## 五、IPTables基本语法
- iptables [-t 表名] 命令选项 ［链名］ ［条件匹配］ ［-j 目标动作或跳转］
    - 说明：表名、链名用于指定 iptables命令所操作的表和链，命令选项用于指定管理iptables规则的方式（比如：插入、增加、删除、查看等；条件匹配用于指定对符合什么样 条件的数据包进行处理；目标动作或跳转用于指定数据包的处理方式（比如允许通过、拒绝、丢弃、跳转（Jump）给其它链处理。

-----------------------------------------

## 六、防火墙处理数据包的四种方式
- ACCEPT `允许`数据包`通过`
- DROP `直接丢弃数据包`，`不给任何回应`信息
- REJECT `拒绝`数据包`通过`，`必要时`会`给数据发送端`一个`响应`的信息。
- LOG `在/var/log/messages文件中记录日志`信息，然后`将数据包传递给下一条规则`

-----------------------------------------
## 七、案例：
- 1、根据MAC地址实现指定时间段上网功能：
    - iptables -I FORWARD -m mac --mac-source 00:00:00:00:00:00 -m time --timestart 15:20 --timestop 16:00 --weekdays Mon,Fri --monthdays 2,3,5 -j DROP

- 2、将10.0.0.7(本机网关)的9000端口映射到172.16.1.8(内网服务器)的22端口
    - iptables -t nat -A PREROUTING -d 10.0.0.7 -i eth0 -p tcp --dport 9000 -j DNAT --to-destination 172.16.1.8:22

-----------------------------------------

## 八、一些常识：
- iptables -L 命令`默认只显示 filter 表的规则`，要查看 nat 表中的规则：iptables -t nat -L --line-numbers

# 相关博客
- https://blog.51cto.com/u_15169172/2710200
- https://www.cnblogs.com/meizy/p/iptables.html
- https://blog.csdn.net/weixin_44736359/article/details/107065327
- https://www.cnblogs.com/sunsky303/p/12327863.html
