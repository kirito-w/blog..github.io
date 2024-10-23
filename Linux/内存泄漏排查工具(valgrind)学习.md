valgrind :
https://blog.csdn.net/qq_20553613/article/details/106503929

可视化分析程序内存占用和 cpu 占用：
https://github.com/wizardforcel/lcthw-zh/blob/master/ex41.md

# cpu 占用率变高的一种原因：在使用 socket 通信时，使用了非阻塞 IO。此时如果读写操作频繁，就会导致 CPU 占用高。

- 解决方案：改为使用 IO 多路复用，select、poll、epoll
