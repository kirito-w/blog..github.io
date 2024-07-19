# GDB
## 概念
- GDB (GNU Debugger) 是一个功能强大的调试器，用于查找程序中的错误，进行追踪和调试。可以在代码中设置断点，单步执行代码，查看和改变变量的值，以及检查程序的堆栈等。
- 通过使用 GDB，开发人员可以深入程序内部，分析和解决程序中出现的问题。

## 使用方法:
[GDB文档]https://www.elinux.org/GDB
https://cs.baylor.edu/~donahoo/tools/gdb/tutorial.html
https://linux.die.net/man/1/gdb
https://e-mailky.github.io/2017-01-14-gdb-intreduce
https://blog.csdn.net/Luckiers/article/details/124568399

## gdb调试core文件：
-https://e-mailky.github.io/2017-05-14-gdb_coredump

- https://blog.csdn.net/mayue_web/article/details/114377847
- https://www.cnblogs.com/yaozhongxiao/p/5242341.html
- https://blog.csdn.net/qq_42570601/article/details/114842320
- https://www.cnblogs.com/black/archive/2012/10/05/2711869.html

- `gdb查看使用的动态链接库是哪些`：
    - info sharedlibrary 

- 符号链接问题：
- 首先全局开启-g选项重新编译，然后可以进入到编译好的staging路径下的root路径，找到builddir路径下的gdb打开core文件，然后：
    - set solib-search-path
    - bt

## openwrt全局开启-g选项：
https://blog.csdn.net/ypbsyy/article/details/80585000
