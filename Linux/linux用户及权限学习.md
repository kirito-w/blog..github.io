- Linux 将用户账号、密码等相关的信息分别存储在四个文件夹下：
    - /etc/passwd —— 管理用户UID/GID重要参数
      - 示例：sam:x:200:50:Sam san:/home/sam:/bin/sh
      - 用户名:口令:用户标识号:组标识号:注释性描述:主目录:登录Shell
    - /etc/shadow —— 管理用户密码
    - /etc/group —— 管理用户组相关信息


- 相关文章：
用户添加：
- https://www.runoob.com/linux/linux-user-manage.html
- https://zhuanlan.zhihu.com/p/105482468

文件权限：
- https://cloud.tencent.com/developer/article/1511107


### 实例：(在ipk包中通过postinst添加一个新用户，并带有root权限)
```
include $(TOPDIR)/rules.mk

PKG_NAME:=obc-monitor
PKG_VERSION:=1.0.1
PKG_RELEASE:=1

include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)
  SECTION:=Applications
  CATEGORY:=Puppies
  TITLE:=obc agent daemon
  DEPENDS:=+libcurl +libssh +sudo
endef

define Package/$(PKG_NAME)/description
obc agent daemon
endef

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) ./files/obc-monitor $(1)/usr/bin/obc-monitor

	$(INSTALL_DIR) $(1)/etc/obc-monitor
	$(INSTALL_DATA) ./files/dev.toml $(1)/etc/obc-monitor/dev.toml

	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./files/obc-monitor.init $(1)/etc/init.d/obc-monitor

	$(INSTALL_DIR) $(1)/etc/sudoers.d
	$(INSTALL_BIN) ./files/obc.sudo $(1)/etc/sudoers.d/obc
endef

define Package/$(PKG_NAME)/postinst
#!/bin/sh

uname=obc
user_exists "$$uname" || {
    # user_add是 /lib/functions.sh中的函数
	user_add "$$uname" "" "0" "" "/tmp" "/bin/ash"
	sed -i -E "s/($$uname):[^:]+:(.+)/\1:\$$1\$$wCUUAeK6\$$OXahC1JmDYz37U6Cj50nT\/:\2/" $$IPKG_INSTROOT/etc/shadow
}

endef

define Build/Configure
  true
endef

define Build/Prepare
  true
endef

define Build/Compile
  true
endef

$(eval $(call BuildPackage,$(PKG_NAME)))


===================================================================

obc.sudo文件  可以限制无密码使用root执行的指令

obc ALL=(ALL) NOPASSWD: /bin/ping, /sbin/ifconfig

```

## /etc/shadow中 用户的密码加密后的值怎么算
- openssl passwd -1 $PASSWD