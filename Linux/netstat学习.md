# Netstat
## 简介：
- Netstat是一款命令行工具，可用于`列出系统上所有的网络套接字连接情况，包括tcp，udp以及unix套接字`，另外它还能列出处于监听状态（即等待接入请求）的套接字。

## 简单使用：
- 列出所有连接 
    - netstat -a
- 只列出TCP连接
    - netstat -t
- 只列出UDP连接
    - netstat -u
- 只列出监听中的连接
    - netstat -l
- 获取进程名、进程号以及用户ID
    - netstat -p
- 禁用反向域名解析：`默认`情况下netstat会通过反向域名解析技术`查找每个IP地址对应的主机名`。这`会降低查找速度`，如果你觉得IP地址已经足够，而`没有必要知道主机名`，就使用 -n 选项`禁用域名解析`功能。
    - netstat -n
- 打印统计数据：netstat可以`打印出网络统计数据，包括某个协议下的收发包数量`，下面列出所有网络包的统计情况： 
    - netstat -s
- 显示`内核路由`信息(与route -n作用一样)
    - netstat -rn

## 相关文档：
- http://jockchou.github.io/blog/2015/09/06/netstat.html