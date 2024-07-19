- https://www.openwrt.pro/post-354.html
- https://openwrt.org/docs/guide-developer/procd-init-scripts
- https://blog.csdn.net/wdsfup/article/details/70770319

- https://blog.csdn.net/to_be_better_wen/article/details/130897305


## 进程挂掉后不限次数重新拉起：
```
procd_set_param respawn ${respawn_threshold:-3600} ${respawn_timeout:-5} ${respawn_retry:-0}
```