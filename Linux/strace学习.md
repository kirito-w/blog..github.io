- strace -p 进程号 ---- 可在不中止进程的情况下查看进程的系统调用情况

- https://developer.aliyun.com/article/926673
- https://www.52coder.net/post/strace-example
- https://linuxtools-rst.readthedocs.io/zh-cn/latest/tool/strace.html
- https://wangchujiang.com/linux-command/c/strace.html


```
strace -tt -T -v -f -e trace=file -o /tmp/log/strace.log -s 1024 -p 23489

-tt 在每行输出的前面，显示毫秒级别的时间
-T 显示每次系统调用所花费的时间
-v 对于某些相关调用，把完整的环境变量，文件stat结构等打出来。
-f 跟踪目标进程，以及目标进程创建的所有子进程
-e 控制要跟踪的事件和跟踪行为,比如指定要跟踪的系统调用名称
-o 把strace的输出单独写到指定的文件
-s 当系统调用的某个参数是字符串时，最多输出指定长度的内容，默认是32个字节
-p 指定要跟踪的进程pid, 要同时跟踪多个pid, 重复多次-p选项即可。
```

# strace -f -t -p pid —— 跟踪线程的所有调用(显示线程pid) 