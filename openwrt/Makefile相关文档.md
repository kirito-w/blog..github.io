- https://openwrt.org/docs/guide-developer/packages

## postinst的用法：
- postinst是写在Makefile里的，针对当前的软件包，在`当前软件包执行完install之后`，会执行postinst内的shell脚本。
- 可以在这里面做一些特化的处理

## 保留配置升级时，需要保留配置的文件目录
配置文件列表。`安装时，如果配置文件已存在，则不会被覆盖。卸载时，如果配置文件被修改过，则不会被删除。`
- 升级的时候会先把这里面写的文件和目录备份下来，升级完后再解压还原
- [升级时保留文件/备份时备份文件 一个文件一行]
```
define Package/$(PKG_NAME)/conffiles
/etc/pptp-route/
/etc/data/
endef
```