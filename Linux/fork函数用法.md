## fork函数用法：
- https://www.cnblogs.com/outsider0606/p/16559584.html
- https://xiaoxiami.gitbook.io/linux-server/duo-jin-cheng-bian-cheng/forkhan-shu

## waitpid 检测子进程状态的函数：
- https://blog.csdn.net/Roland_Sun/article/details/32084825

## 一个程序完成父进程监控子进程的状态
```
pid_t opennds_pid = -1;

    while(1) {
        opennds_pid = fork();
        if (0 == opennds_pid) {   // 如果是子进程
            execl("/usr/bin/opennds", "/usr/bin/opennds", "-f", NULL);
        } else {                  // 如果是父进程
            while (opennds_pid != waitpid(opennds_pid, NULL, WNOHANG)) {
                heartbeat_run();
                sleep(2);
            }
            opennds_pid = -1;
        }

        sleep(5);
    }
```