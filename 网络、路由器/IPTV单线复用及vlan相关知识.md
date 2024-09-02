## 简单实现（下面的`lan和wan都是指逻辑网口`）：
- 方法：在设备侧`将lan口的vlan 45(lan.45) 和 wan口的 vlan 45(wan.45) 桥在一个新的bridge vlan_iptv`下：
    - 如果是`带45 tag的数据包`，从lan口进入后，发现带45 tag，则转入lan.45，即到了桥vlan_iptv，此时在这个桥中广播，数据包会到wan.45，即和上级对应的带vlan 45的网络做通信(比如电视网络)。`(lan.45 --> wan.45)`
    - 如果是`不带tag的数据包`，则正常从`lan --> wan`上网。

- 实例：
```
br-vlan_iptv		7fff.fcffff000003	no		lan.45
							                    wan.45

```

## trunk口和acces口(很清楚)：
- https://blog.csdn.net/weixin_42445065/article/details/130615889
- https://www.red-yellow.net/iptv%E5%8D%95%E7%BA%BF%E5%A4%8D%E7%94%A8.html

- https://chenjiehua.me/others/home-network-vlan.html
- https://www.txrjy.com/asktech/question.php?qid=10499
- https://blog.csdn.net/paulkg12/article/details/86622485