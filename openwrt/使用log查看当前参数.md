# lua日志调试：
- 1、首先在想要查看的地方使用log:error(内容)，例如：log.error("r.network: %s", `js.encode`(r))
- 2、重启服务
- 3、进行操作
- 4、进入/var/log/log.current
- 5、找到对应的输出

# 一直导出日志比较麻烦，可以重新开启一个窗口，使用 tail -f /var/log/log.current 来监听