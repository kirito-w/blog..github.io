# 
- https://wangchujiang.com/linux-command/c/ip.html

# 配置静态ip示例：
- ip addr show 查看所有接口ip
- ip addr show br-lan查看lan口ip
- ip addr add 192.168.10.1/24 dev br-lan 给lan口配置静态ip
- 终端配置静态ip，ping lan口 可以ping通