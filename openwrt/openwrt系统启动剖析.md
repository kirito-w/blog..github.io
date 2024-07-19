## openwrt启动
- 跟其他unix系统一样,openwrt系统启动,首先是`boot加载kernel`,`kernel最终调用/etc/preinit`开始整个启动流程.

## openwrt启动流程：
- 1.bootloader -> 2.linux kernel -> 3./etc/preinit -> 4./sbin/init -> 5./etc/inittab -> 6./etc/init.d/rcS -> 7./etc/rc.d/S* 

## 各流程解析：
- 1、boot loader 加载 kernel
- 1、kernel 调用 /etc/preinit ———— `设置环境变量、挂载文件系统，最后会拉起/sbin/init `
- 2、/etc/preinit 执行 /sbin/init ———— 是由busybox编译出的`可执行程序`。init程序最终会`演变成init进程`, 这个过程中它`会解析/etc/inittab文件`,并`根据规则执行`inittab中预定的操作.
- 3、/etc/inittab ———— 负责设置init初始化程序需要执行的`初始化脚本在哪里`
- 5、按顺序执行/etc/rc.d下面的各个脚本(从小到大，99为最大)

## 相关文档
- https://blog.csdn.net/qq_24835087/article/details/127820396