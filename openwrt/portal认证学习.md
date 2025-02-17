## 概念：
- Portal认证通常也称为Web认证，一般将Portal认证网站称为门户网站。用户上网时，必须在门户网站进行认证，只有认证通过后才可以使用网络资源。
- 用户可以`主动访问已知的Portal认证网站`，输入用户名和密码进行认证，这种开始Portal认证的方式称作`主动认证`。反之，如果用户`试图通过HTTP访问其他外网`，将被`强制访问Portal认证网站`，从而开始Portal认证过程，这种方式称作`强制认证`。

## Portal认证方式：
- 不同的组网方式下，可采用的Portal认证方式不同。按照网络中实施Portal认证的网络层次来分，Portal认证方式分为两种：`二层认证方式`和`三层认证方式`。
    - 二层认证方式
        - `客户端与接入设备直连`（或之间只有二层设备存在），`设备能够学习到用户的MAC地址并可以利用IP和MAC地址来识别用户`，此时可配置Portal认证为二层认证方式。
        - 二层认证方式`支持MAC优先的Portal认证`，设备学习到用户的MAC地址后，`将MAC地址封装到RADIUS属性中发送给RADIUS服务器`，认证成功后，`RADIUS服务器会将用户的MAC地址写入缓存和数据库`。
        - 二层认证流程简单，安全性高，但由于`限制了用户只能与接入设备处于同一网段`，降低了组网的灵活性。

    - 三层认证方式
        - 当设备部署在汇聚层或核心层时，在`认证客户端和设备之间存在三层转发设备`，此时`设备不一定能获取到认证客户端的MAC地址`，所以将`以IP地址唯一标识用户`，此时需要将Portal认证配置为三层认证方式。
        - 三层认证跟二层认证的`认证流程完全一致`。三层认证组网灵活，容易实现远程控制，但`由于只有IP可以用来标识一个用户，所以安全性不高`。

## Portal认证特点：
- 不需要安装客户端，`直接使用Web页面认证`，使用方便，减少客户端的维护工作量。
- 便于运营，可以在Portal页面上开展业务拓展，如广告推送、责任公告、企业宣传等。
- 技术成熟，被广泛应用于运营商、连锁快餐、酒店、学校等网络。


## portal认证流程：
![](img/%E4%BC%81%E4%B8%9A%E5%BE%AE%E4%BF%A1%E6%88%AA%E5%9B%BE_17199073364143.png)


## Portal认证页面弹出原理(`一般在内核拦截重定向，https不行，需要重定向到用户态进行SSL握手`):
- Portal重定向有两种方式：`HTTP 200 OK`和`HTTP 302 Moved`方式。
    - HTTP 200 OK方式:
        - TCP建立完成后，`终端发出HTTP GET`报文，`设备拦截后回应HTTP 200 OK`报文。其中HTTP 200 OK报文`携带了Portal认证页面的地址`，终端收到此报文后就会访问Portal认证页面。
    - HTTP 302 Moved方式：
        - 设备拦截后回应的是HTTP 302 Moved Temporarily报文，`重定向认证页面的地址在该报文中携带`。


## 如何实现终端上自动弹出Portal认证页面(http自动探测):
- 自动弹出Portal认证页面实现原理：终端`关联到SSID`后，主动发出HTTP的`探测请求`报文，`检测目的地址是否可达`，以及`回应的内容是否符合预期`，以此来`判断接入的网络是否需要进行Portal认证`。目的地址一般是固定的网址，各终端或APP应用存在差异。如果`目的地址不可达`或`回应内容不符合预期`，那么终端会调用浏览器`再次发出HTTP请求`，设备拦截到此请求`进行重定向`，实现自动弹出Portal认证页面的功能。
- `所有的网络探测，基本都是以dns请求的形式，只不过请求的域名不同，比如IOS设备是captive.apple.com，Windows是微软的地址`

## 访问HTTPS网页报安全告警的原因（正常现象）
- 从Portal重定向原理可知，终端访问HTTPS网页时，`设备拦截HTTPS（默认443端口）TCP固定端口的流量`，`仿冒`成终端`要访问的目的地址`和终端`建立TCP连接`，TCP建链完成后`进行SSL握手`，SSL握手`使用的是设备内置的自签名证书`，设备内置自签名证书并`不是合法机构颁发的证书`，因此**`能否重定向成功取决于终端浏览器的安全策略`**，部分终端浏览器校验服务器证书时会产生告警，点击信任继续后，可以正常重定向到Portal页面。也有部分浏览器没有该提示页面，直接中断访问。


## iphone手机连接wifi后，不会立即自动弹出认证页面的原因及解决方案 —— 对IOS自身探测重定向（captive.apple.com验证连通性）：
- 可能性1：iOS终端设备CNA探测失败可能导致iOS终端的`WiFi信号无法点亮`。
    - 解决方案：可以通过重定向配置，将`第一次`探测请求captive.apple.com`重定向到Portal认证页面`，后续的探测请求`伪造回应Success`，即可解决。
- 可能性2：iOS在认证过程中，`首先需要去captive.apple.com验证连通性`，正常情况下，连通性验证通过才可以触发Portal重定向推送认证页面。如果使用的DNS服务器解析域名的延迟时间非常长，对Portal认证页面的弹出速度也会有影响。
    - 解决方案：可以使用IP地址为`114.114.114.114`的DNS服务器来解析captive.apple.com。
- https://bbs.sundray.com.cn/forum.php?mod=viewthread&tid=1030
- https://blog.csdn.net/Illina/article/details/77650586
- https://support.huawei.com/enterprise/zh/doc/EDOC1100247698/c61ffc0a
- https://bbs.sangfor.com.cn/forum.php?mod=viewthread&tid=132985
- https://blog.csdn.net/sinat_20184565/article/details/80308010
- https://zhiliao.h3c.com/questions/dispcont/2338

# 相关文档
- https://support.huawei.com/enterprise/zh/doc/EDOC1000079675/4476c6b8
- https://support.huawei.com/enterprise/zh/doc/EDOC1000079675/3371f62e#ZH-CN_TOPIC_0000001174793344
- https://support.huawei.com/enterprise/zh/doc/EDOC1000075592/8b1ed535
- https://support.huawei.com/enterprise/zh/doc/EDOC1000075592/f1785a2
- https://www.h3c.com/cn/d_202203/1560963_30005_0.htm#_Toc96731770
- https://cxd2014.github.io/2017/05/21/portal-auth/
- https://cshihong.github.io/2019/05/30/Portal%E8%AE%A4%E8%AF%81%E5%8E%9F%E7%90%86/
- https://support.huawei.com/enterprise/zh/doc/EDOC1000075592/6db5c7cf
https://blog.csdn.net/limengshi138392/article/details/139372365

# 不同终端的认证行为：
- https://captivebehavior.wballiance.com/

# ios终端认证行为：
- https://gmd20.github.io/blog/iPhone%E8%BF%9E%E6%8E%A5wifi%E7%83%AD%E7%82%B9%E8%B7%B3%E8%BD%ACcaptive-portal%E9%A1%B5%E9%9D%A2%E5%8E%9F%E7%90%86%E4%BB%A5%E5%8F%8A%E9%A1%B5%E9%9D%A2%E8%B7%B3%E8%BD%AC%E6%85%A2%E5%8E%9F%E5%9B%A0%E5%88%86%E6%9E%90/

# DHCP 114 option
- https://developer.android.com/about/versions/11/features/captive-portal?hl=zh-cn
