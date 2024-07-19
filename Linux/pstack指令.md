# pstack
## 概念:
- pstack 是一个用于诊断运行中的进程的工具。它可以打印出指定进程的堆栈信息，包括每个线程的调用堆栈。这对于查找进程中的死锁和阻塞问题非常有用，可以帮助定位程序中的问题点。
- 通过运行 pstack <pid> 命令，可以输出指定pid进程的堆栈信息。

- `注意：pstack所追踪的是用户态调用栈`

## pstack相关:
- `pstack`是一个`shell脚本`，用于`打印正在运行的进程的栈跟踪信息`，它实际上是gstack的一个链接，而gstack本身是基于gdb封装的shell脚本.。
- 此命令可显示每个进程的栈跟踪。pstack 命令必须由相应进程的属主或 root 运行。
- 可以使用 pstack 来确定进程挂起的位置。`此命令允许使用的唯一选项是要检查的进程的 PID`。

- 与jstack功相比, 它能对潜在的死锁予以提示, 而pstack只提供了线索, 需要gdb进一步的确定。

- `pstack是gdb的一部分`，如果系统没有pstack命令，使用yum搜索安装gdb即可。

- `这个命令在排查进程问题时非常有用，比如我们发现一个服务一直处于work状态（如假死状态，好似死循环），使用这个命令就能轻松定位问题所在；可以在一段时间内，多执行几次pstack，若发现代码栈总是停在同一个位置，那个位置就需要重点关注，很可能就是出问题的地方`

### 使用方法:
- ps aux | grep xxx 找到pid
- top -H -p <pid> 查看进程中包含的线程基本信息
- pstack <pid>

## 使用实例:
```
使用pstree或者ps找到对应进程的pid:

pstree -p work | grep ad
sshd(22669)---bash(22670)---ad_preprocess(4551)-+-{ad_preprocess}(4552)
                                                |-{ad_preprocess}(4553)
                                                |-{ad_preprocess}(4554)
                                                |-{ad_preprocess}(4555)
                                                |-{ad_preprocess}(4556)
                                                `-{ad_preprocess}(4557)

进程的栈跟踪(下面的例子中有七个线程):

pstack 4551
Thread 7 (Thread 1084229984 (LWP 4552)):
#0  0x000000302afc63dc in epoll_wait () from /lib64/tls/libc.so.6
#1  0x00000000006f0730 in ub::EPollEx::poll ()
#2  0x00000000006f172a in ub::NetReactor::callback ()
#3  0x00000000006fbbbb in ub::UBTask::CALLBACK ()
#4  0x000000302b80610a in start_thread () from /lib64/tls/libpthread.so.0
#5  0x000000302afc6003 in clone () from /lib64/tls/libc.so.6
#6  0x0000000000000000 in ?? ()
Thread 6 (Thread 1094719840 (LWP 4553)):
#0  0x000000302afc63dc in epoll_wait () from /lib64/tls/libc.so.6
#1  0x00000000006f0730 in ub::EPollEx::poll ()
#2  0x00000000006f172a in ub::NetReactor::callback ()
#3  0x00000000006fbbbb in ub::UBTask::CALLBACK ()
#4  0x000000302b80610a in start_thread () from /lib64/tls/libpthread.so.0
#5  0x000000302afc6003 in clone () from /lib64/tls/libc.so.6
#6  0x0000000000000000 in ?? ()
Thread 5 (Thread 1105209696 (LWP 4554)):
#0  0x000000302b80baa5 in __nanosleep_nocancel ()
#1  0x000000000079e758 in comcm::ms_sleep ()
#2  0x00000000006c8581 in ub::UbClientManager::healthyCheck ()
#3  0x00000000006c8471 in ub::UbClientManager::start_healthy_check ()
#4  0x000000302b80610a in start_thread () from /lib64/tls/libpthread.so.0
#5  0x000000302afc6003 in clone () from /lib64/tls/libc.so.6
#6  0x0000000000000000 in ?? ()
Thread 4 (Thread 1115699552 (LWP 4555)):
#0  0x000000302b80baa5 in __nanosleep_nocancel ()
#1  0x0000000000482b0e in armor::armor_check_thread ()
#2  0x000000302b80610a in start_thread () from /lib64/tls/libpthread.so.0
#3  0x000000302afc6003 in clone () from /lib64/tls/libc.so.6
#4  0x0000000000000000 in ?? ()
Thread 3 (Thread 1126189408 (LWP 4556)):
#0  0x000000302af8f1a5 in __nanosleep_nocancel () from /lib64/tls/libc.so.6
#1  0x000000302af8f010 in sleep () from /lib64/tls/libc.so.6
#2  0x000000000044c972 in Business_config_manager::run ()
#3  0x0000000000457b83 in Thread::run_thread ()
#4  0x000000302b80610a in start_thread () from /lib64/tls/libpthread.so.0
#5  0x000000302afc6003 in clone () from /lib64/tls/libc.so.6
#6  0x0000000000000000 in ?? ()
Thread 2 (Thread 1136679264 (LWP 4557)):
#0  0x000000302af8f1a5 in __nanosleep_nocancel () from /lib64/tls/libc.so.6
#1  0x000000302af8f010 in sleep () from /lib64/tls/libc.so.6
#2  0x00000000004524bb in Process_thread::sleep_period ()
#3  0x0000000000452641 in Process_thread::run ()
#4  0x0000000000457b83 in Thread::run_thread ()
#5  0x000000302b80610a in start_thread () from /lib64/tls/libpthread.so.0
#6  0x000000302afc6003 in clone () from /lib64/tls/libc.so.6
#7  0x0000000000000000 in ?? ()
Thread 1 (Thread 182894129792 (LWP 4551)):
#0  0x000000302af8f1a5 in __nanosleep_nocancel () from /lib64/tls/libc.so.6
#1  0x000000302af8f010 in sleep () from /lib64/tls/libc.so.6
#2  0x0000000000420d79 in Ad_preprocess::run ()
#3  0x0000000000450ad0 in main ()
```

## 相关文档:
https://blog.csdn.net/www_dong/article/details/131026044\

## linux中pid 和 tid的关系:
- `线程进程都会有自己的ID，这个ID就叫做PID，PID是不特指进程ID，线程ID也可以叫做PID`。
- 创建一个新的进程会给一个新的`PID和TGID`，并且`2个值相同`，当创建一个新的`线程`的时候，会给你一个`新的PID`，并且`TGID和之前开始的进程一致`。
- https://blog.csdn.net/u012398613/article/details/52183708
- Linux通过进程查看线程的方法 
    - 1).htop 按t(显示进程线程嵌套关系)和H(显示线程) ，然后F4过滤进程名。
    - 2).ps -eLf | grep java(快照，带线程命令，e是显示全部进程，L是显示线程，f全格式输出) 
    - 3).pstree -p <pid> (显示进程树，不加pid显示所有) 
    - 4).top -Hp <pid> (实时) 
    - 5).ps -T -p <pid> (快照)

