## 防火墙规则：
- 在firewall.include文件添加
- iptables -t nat -L -n：列出所有的NAT规则



# firewall文件中的masq选项:
- firewall文件中的masq选项用于`配置NAT转换规则`。当路由器接收来自内部网络的数据包，然后转发到外部网络时，masq选项可以`将源IP地址和端口号修改为路由器的IP地址和一个随机端口号`，以便隐藏内部网络的真实IP地址。