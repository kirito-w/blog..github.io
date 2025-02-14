# openwort

## 概念：

- OpenWRT 是一个`高度模块化、高度自动化的嵌入式Linux系统`。
- Openwrt 是一款开源的路由器软件,它是一个`高度定制化`的`专门用于管理路由器`的`Linux发行版`。

==========================================================================================

## bin 文件和 img 文件：

- 编译完成后首先编译出的文件是 img 文件，这也是主要的镜像文件，可以用来升级后台。但是根据前端页面的不同，会封装成不同的 bin 文件（相当于加了密码的 img 文件）。bin 文件同样可以通过工具解析来变成 img 文件：
- openssl aes-256-cbc -d -salt -in $fw -out /tmp/decrypt.img -k "QiLunSmartWL"

============================================================================================

## 编译程序包：

- 1、在 package/feeds/puppies 下加入符号链接 ln -s ../../../feeds/puppies/cudit cudit
- 2、make package/feeds/puppies/cudit/compile V=s

---

## 取动态库文件：

- ~/openwrt-mt7981/build_dir/target-aarch64_cortex-a53_musl/cudit-1.1.1/libculink 这个地方

---

## 很大一部分编译报错是由于 makefile 文件引起的，如果 makefile 文件没有问题，那么可以重新装一下 rom！！！

---

## 编译时头文件解析不了的问题：

```
在makefile文件中修改以下信息：

LIBS_PATH += -L./libculink/ -L./libinformgetdata/ -linformgetdata -lcjson -lsqlite3 -lculinkzero  (添加的内容)

ifndef CROSS_COMPILE
    LIBS_PATH += -Wl,-rpath=$(shell pwd)/libinformgetdata/
    LIBS_PATH += -Wl,-rpath=$(shell pwd)/libculink/ (添加的内容)
endif

$(BASE_OBJ): %.o: %.c ./libculink/culinkzero.h
	$(CC) $(CFLAGS) $(DEFLAGS) -I./libculink/ -c -o $@ $<

```

---

## 动态库链接依赖缺少问题：

```
报错：Package cudit is missing dependencies for the following libraries:libculinkzero.so

解决：
修改cudit的makefile文件：

define Package/$(PKG_NAME)/Default
	SECTION:=Applications
	CATEGORY:=Puppies
	DEPENDS:=+libcjson +libsqlite3 +libculinkzero (添加的内容)
endef

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/etc/
	$(INSTALL_DIR) $(1)/usr/sbin/
	$(INSTALL_DIR) $(1)/usr/lib/
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/$(PKG_NAME) $(1)/usr/sbin/
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/wan_speed $(1)/usr/sbin/
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/unicom.sh $(1)/usr/sbin/
	$(CP) $(PKG_BUILD_DIR)/libinformgetdata/libinformgetdata.so $(1)/usr/lib/
	$(CP) $(PKG_BUILD_DIR)/libculink/libculinkzero.so $(1)/usr/lib/ (添加的内容)
endef
```

---

## 编译 C 可执行文件到 openwrt 路由器上执行:

- 在.c 同级下的 makefile 中加入

```
$(CC) culink.c $(DEFLAGS) -o culink -static
```

- 编译完成后到 build_dir 对应目录下 copy 可执行文件，移植到路由器后台
- chmod +x 文件名 赋予可执行文件的执行权限
- ./文件名

---

## install: cannot stat 'cuLinkZeroConfigRouter/cuLink/zeroConf/conf/\*': No such file or directory

- 如果确认路径是正确的，那么很有可能是 conf 文件夹中一个文件都没有造成的。

---

## locate libc.so.6 ：确定本地是否存在依赖库

---

## 遇到的问题：

- 1、`编译时不能用root账号`，需要用其他账号，但是此时对文件的权限又不够，所以需要用`chmod 777 -R 文件夹/.` 更改文件夹及里边嵌套的文件的使用权限(`-R表示递归`)。（`测试发现可以直接使用root账号!!`）

- 2、当`安装依赖的软件时`遇到：

```
E: 无法获得锁 /var/lib/dpkg/lock-frontend - open (11: 资源暂时不可用)
E: Unable to acquire the dpkg frontend lock (/var/lib/dpkg/lock-frontend), is another process using it?

解决方法：
- ①ps -e|grep apt-get，找到对应进程并kill
- ②rm /var/cache/apt/archives/lock， rm /var/lib/dpkg/lock 强制解锁
```

- 3、根据报错信息，`安装缺少的依赖包`。
- 4、`make -j1 V=sc` ：这将以单线程的形式运行编译，并输出更详细的日志信息，有助于定位问题
- 5、`./scripts/feeds update -a`更新软件包源码时，git 库权限不足问题。解决：开放权限（`这里还需要修改vi feeds.conf.default，将puppies库的路径修改成对应的`）。
- 6、make -j4：四线程编译（`不建议使用`）。
- 7、不同的路由器版型配置可以通过找类似 feeds/puppies/rom/1.0/WR3000K/config 的路径来加载配置解决
- 8、配置完成后，运行 `make defconfig` 命令，用于`生成 .config 文件`。
- 9、安装依赖的软件时遇到如下报错：

```
正在读取软件包列表... 完成
正在分析软件包的依赖关系树
正在读取状态信息... 完成
E: 无法定位软件包 libwpactrl-dev
```

- 解决方法：
  - https://blog.csdn.net/m0_45805756/article/details/126310136（换源）
  - 1.sudo apt-get update //(更新目录)
  - 2.sudo apt-get upgrade //（更新文件）
  - 3.sudo apt-get dist-upgrade //（更新依赖关系）
- 10、指定路由器型号编译：`feeds/puppies/rom/scripts/make.sh  WR3000K-UNICOM make -j20`（尽量用 root 权限运行）
- 11、遇到如下问题,编译 fstools 软件包时出错了：

```
make[3]: *** [/home/tuo123/openwrt_mt7981/openwrt-mt7981/bin/targets/mediatek/mt7981/packages/fstools_2021-01-04-c53b1882-1_aarch64_cortex-a53.ipk] Error 1
make[3]: Leaving directory '/home/tuo123/openwrt_mt7981/openwrt-mt7981/package/system/fstools'
time: package/system/fstools/compile#0.24#0.12#0.48
    ERROR: package/system/fstools failed to build.
package/Makefile:115: recipe for target 'package/system/fstools/compile' failed
make[2]: *** [package/system/fstools/compile] Error 1
make[2]: Leaving directory '/home/tuo123/openwrt_mt7981/openwrt-mt7981'
package/Makefile:111: recipe for target '/home/tuo123/openwrt_mt7981/openwrt-mt7981/staging_dir/target-aarch64_cortex-a53_musl/stamp/.package_compile' failed
make[1]: *** [/home/tuo123/openwrt_mt7981/openwrt-mt7981/staging_dir/target-aarch64_cortex-a53_musl/stamp/.package_compile] Error 2
make[1]: Leaving directory '/home/tuo123/openwrt_mt7981/openwrt-mt7981'
/home/tuo123/openwrt_mt7981/openwrt-mt7981/include/toplevel.mk:228: recipe for target 'world' failed
make: *** [world] Error 2
fail 2
```

- 解决办法：

  - 先 `make package/system/fstools/compile V=s单独编译此模块`，明确报错原因，编译运行后报错配置不统一：
    - ① make deconfig 将编译环境中的配置还原为默认值。它会将配置文件重置为初始状态，以便重新配置项目。
    - ② feeds/puppies/rom/scripts/make.sh WR3000K make V=s 重新编译项目。

- 12、遇到 dl 文件夹中的软件包缺少问题。
- 解决方法：
  - 预下载编译软件包命令：feeds/puppies/rom/scripts/make.sh WR3000K make download -j8 V=s
- 13、`编译时间过长`解决方法：

  - 编译之前，找到`openwrt-mt7981/feeds/puppies/rom/1.0/WR3000K-UNICOM/oem `—— 对应的 oem 文件，将除要编译的机器外的型号都删除，缩短编译时间

- 14、遇到报错：

```
Package fstools is missing dependencies for the following libraries:
libfstools-bootparam.so
Makefile:149: recipe for target '/home/tuo123/openwrt_mt7981/openwrt-mt7981/bin/targets/mediatek/mt7981/packages/fstools_2021-01-04-c53b1882-1_aarch64_cortex-a53.ipk' failed
make[2]: *** [/home/tuo123/openwrt_mt7981/openwrt-mt7981/bin/targets/mediatek/mt7981/packages/fstools_2021-01-04-c53b1882-1_aarch64_cortex-a53.ipk] Error 1
make[2]: Leaving directory '/home/tuo123/openwrt_mt7981/openwrt-mt7981/package/system/fstools'
time: package/system/fstools/compile#0.21#0.11#0.32
    ERROR: package/system/fstools failed to build.
package/Makefile:115: recipe for target 'package/system/fstools/compile' failed
make[1]: *** [package/system/fstools/compile] Error 1
make[1]: Leaving directory '/home/tuo123/openwrt_mt7981/openwrt-mt7981'
/home/tuo123/openwrt_mt7981/openwrt-mt7981/include/toplevel.mk:228: recipe for target 'package/system/fstools/compile' failed
make: *** [package/system/fstools/compile] Error 2
```

- 解决方法：

  - 第一行表示缺少依赖：找到主仓库中的 README.md，将依赖按文档安装一遍！

- 15、编译前需要配置.config 文件：cp feeds/puppies/rom/1.0/WR3000K/config .config(`不需要，在脚本文件feeds/puppies/rom/scripts/make.sh里已经做完了，加上型号之后就可以解决`)

---

## 什么是 Makefile 文件？

- Makefile 是一个文本文件，它包含了`构建`和`编译`软件项目所需的`指令`和`依赖`关系。Makefile 文件通常`用于自动化构建过程`，可以`根据规则和目标`来`生成目标文件、可执行文件或其他类型的输出文件`。
- Makefile 文件中定义了一系列规则，每个规则包含一个目标、依赖项和指令。通过执行规则中定义的指令，可以生成目标文件或执行特定的操作。
- Makefile 的作用包括：
  - 自动化软件项目的构建和编译过程：通过定义目标、依赖项和指令，Makefile 可以自动化执行编译器、链接器和其他工具来生成目标文件和可执行文件。
  - 管理源代码和依赖项：Makefile 中的规则可以指定源代码文件的编译顺序和依赖关系，确保在构建过程中正确处理源代码和依赖项。
  - 配置编译选项和参数：Makefile 中可以定义编译器和链接器的选项和参数，以控制编译过程中使用的功能和行为。
  - 管理项目目录结构：Makefile 可以定义目标文件和其他输出文件的存储位置，帮助管理项目的目录结构。
- 通过`在终端中运行 make 命令`，可以`根据 Makefile 中的规则和目标执行构建`过程。Makefile 的语法相对简单且可扩展，因此在嵌入式开发和软件项目中广泛使用。

# 打包的时候只留 3000A，其他都删了！！

```
make package/mtk/applications/mapd/compile V=s


collect2: error: ld returned 1 exit status
Makefile:312: recipe for target 'mapd' failed
make[3]: *** [mapd] Error 1
make[3]: Leaving directory '/home/tuo123/openwrt_mt7981/openwrt-mt7981/build_dir/target-aarch64_cortex-a53_musl/mapd'
Makefile:68: recipe for target '/home/tuo123/openwrt_mt7981/openwrt-mt7981/build_dir/target-aarch64_cortex-a53_musl/mapd/.built' failed
make[2]: *** [/home/tuo123/openwrt_mt7981/openwrt-mt7981/build_dir/target-aarch64_cortex-a53_musl/mapd/.built] Error 2
make[2]: Leaving directory '/home/tuo123/openwrt_mt7981/openwrt-mt7981/package/mtk/applications/mapd'
time: package/mtk/applications/mapd/compile#16.68#2.06#18.39
    ERROR: package/mtk/applications/mapd failed to build.
package/Makefile:115: recipe for target 'package/mtk/applications/mapd/compile' failed
make[1]: *** [package/mtk/applications/mapd/compile] Error 1
make[1]: Leaving directory '/home/tuo123/openwrt_mt7981/openwrt-mt7981'
/home/tuo123/openwrt_mt7981/openwrt-mt7981/include/toplevel.mk:228: recipe for target 'package/mtk/applications/mapd/compile' failed
make: *** [package/mtk/applications/mapd/compile] Error 2


```

# SDK 和 MTK：

- SDK（Software Development Kit）：即`软件开发工具包`。SDK 是一组开发工具、库和文档，`使开发人员能够创建、测试和部署软件应用程序`。对于 OpenWrt 来说，SDK 是一个包含了交叉编译器、库文件以及构建和部署工具的软件包，用于为特定的硬件平台生成定制固件。
- MTK：MTK 代表"MediaTek"，是一家台湾的半导体设计公司。MTK 是知名的芯片制造商，在智能手机、物联网设备和网络设备等领域有广泛应用。在 OpenWrt 中，`MTK通常用于指代基于MediaTek芯片的设备和驱动程序`，因为 OpenWrt 支持许多不同的硬件平台。

# openwrt 编译的时候，编译后会以 ipk 的形式安装到 `build_dir` 文件（不同的框架后缀名不同）下，然后在`build_dir/target-aarch64_cortex-a53_musl/root-mediatek/`下建立一个`临时文件系统`（和最终在设备上展示的一样），将所有 ipk 中的文件放到对应的文件夹下，最后`将这个临时系统文件打包成镜像文件`，也就是我们的`img固件包`。

- 在`build_dir`目录下，软件包会被安装到与其相关的目录中，通常`是一个由软件包名称和版本组成的目录结构`。软件包的源代码和构建结果（二进制文件、库文件等）通常会存在于该目录中。
- `staging_dir`目录：这个目录包含了在`编译过程中生成的一些工具、库文件和头文件`。它位于 OpenWrt 源代码根目录的子目录中，例如：/path/to/openwrt/staging_dir。您可以在这个目录中找到一些与目标设备相关的文件。
- `feeds install`的过程是`创建package中的软连接`

## 编译的时候安装的时候一个文件只允许一个软件包提供，如果有两个软件包提供同名的文件，会报错，不会覆盖

## 如何解决 config 导致的依赖缺失的问题：

1、首先将目前要编译的型号的 config 文件 copy 到.config 下
2、使用 make menuconfig，然后按 ESC 保存
3、确认有报错的 Makefile 文件中的 DEPENDS 项的名称，例如+openssl-util
4、再次使用 make menuconfig，按'/'输入对应名称，搜索到之后，选中并且退出
5、比对.config 和目标 config 的差异，找到对应的差异并更改
6、重新编译。

## 如何解决没有编译规则的问题？

1、./scripts/feeds update -a
2、./scripts/feeds install -a

## openwrt 编译时，生成的固件包名称的命名规则：

```
生成的固件包名称：$(CONFIG_VERSION_DIST)-$(CONFIG_VERSION_NUMBER)-$(CONFIG_VERSION_CODE)-$(EXTRA_IMAGE_NAME)-$(CONFIG_TARGET_BOARD)-$(CONFIG_TARGET_SUBTARGET)-$(CONFIG_TARGET_PROFILE)
```

- 主要涉及以上几个配置项，没有配置的话就是为空，包括后面的-没有。`所有的配置项都是在config文件中获取的`。
- EXTRA_IMAGE_NAM 这个一般没有 ，可以不用关注。
- CONFIG_VERSION_NUMBER 这个有没有要看 CONFIG_VERSION_FILENAMES 是否配置。
- CONFIG_VERSION_CODE 看 CONFIG_VERSION_CODE_FILENAMES 有没有配置。
- 所有的变量，都会去掉双引号，然后把空格和下滑线转为- , 最后都是转为小写，按照上面的顺序拼接起来

============================================================================================================

# 遇到编不过的问题，首先试试 clean 之后再编一次！！！！！！！！！！！！！！！！！！！！！

## 某个模块编译报错了， 可以先试试 clean 掉这个模块，然后再单独编译

============================================================================================================

## `遇到找不到编译规则(rule)的解决方法`：

- 1、首先确认 package/feed/下有没有对应的软链接，没有的话需要添加
- 2、如果软链接存在仍然报错时，也可以使用 clean 的方法尝试解决！！

## package 下同名的软链接只能存在一个！！例如如果已经在 puppies 里，创建过了一个 A 的软链接，那么即使 feeds 下有 A，也不会创建了

- make menuconfig 的选项是根据 Makefile 文件生成的

## 缺少 ssh 主机密钥：

```
root@DESKTOP-N9TTV9V:~# /etc/init.d/ssh restart
sshd: no hostkeys available -- exiting.
```

- ssh-keygen -A

# opkg files xxxx ----> 可以看到此 opkg 包内包含的文件，这些文件会安装到设备中的对应位置！

## 遇到下载某个 libxxxx 失败的情况，可以手动从软件源下载需要的压缩包，并放到/dl 目录下。

# rm -rf ./tmp —— 清除编译缓存

# nand flash 和 nor flash 的区别:

# rootfs jffs2 Hotplug

- jffs2:https://blog.csdn.net/weixin_41294460/article/details/103952311

## install 过程缺少依赖报错：

```
Collected errors:
 * satisfy_dependencies_for: Cannot satisfy the following dependencies for wimqtt:
```

- make clean 后重新编译可解决

## 重编内核： make target clean/compile

# staging_dir 和 build_str 详细：

- https://openwrt.org/docs/guide-developer/toolchain/buildsystem_essentials
- https://stackoverflow.com/questions/26030670/openwrt-buildroot-build-dir-and-staging-dir
- https://blog.csdn.net/u014436243/article/details/105999980

# 在 puppies 下新增一个 package：

- ./scripts/feeds install -a —— 是根据 feeds/puppies.index 的内容来安装的，这个文件是./scripts/feeds update -a 时更新的，`如果只是本地改了puppies仓库，可以通过修改feeds/puppies.index来install我们新增的package`。

# 移植 mt7981 x-wrt sdk 过程：

- 1 拉取对应 sdk 代码
- 2 修改 feeds.default 中的对应仓库
- 3 ./scripts/feeds update -a && ./scripts/feeds install -a
- 4 ./feeds/puppies/rom/scripts/make.sh xxx 开始编译

## 遇到的一些问题：

### 1、target/linux 编译报错

```
make[2]: 'conf' is up to date.
make[2]: Leaving directory '/root/wqj/AC_2210E/x-wrt/scripts/config'
Makefile:24: .mk: No such file or directory
make[6]: *** No rule to make target '.mk'.  Stop.
Makefile:17: recipe for target 'image-prereq' failed
make[5]: *** [image-prereq] Error 2
Makefile:11: recipe for target 'prereq' failed
make[4]: *** [prereq] Error 2
time: target/linux/prereq#0.13#0.01#0.13
    ERROR: target/linux failed to build.
target/Makefile:28: recipe for target 'target/linux/prereq' failed
make[3]: *** [target/linux/prereq] Error 1
target/Makefile:22: recipe for target '/root/wqj/AC_2210E/x-wrt/staging_dir/target-aarch64_cortex-a53_musl/stamp/.target_prereq' failed
make[2]: *** [/root/wqj/AC_2210E/x-wrt/staging_dir/target-aarch64_cortex-a53_musl/stamp/.target_prereq] Error 2
/root/wqj/AC_2210E/x-wrt/include/toplevel.mk:209: recipe for target 'prereq' failed
make[1]: *** [prereq] Error 2
/root/wqj/AC_2210E/x-wrt/include/toplevel.mk:229: recipe for target 'world' failed
make: *** [world] Error 2
fail 2
root@DESKTOP-N9TTV9V:~/wqj/AC_2210E/x-wrt# make menuconfif
^C/root/wqj/AC_2210E/x-wrt/include/toplevel.mk:229: recipe for target 'menuconfif' failed
make: *** [menuconfif] Interrupt

```

- 此种报错可能是由于想要编译的.config 文件中，选择的 target（内核）在编译环境中找不到引起的，可以按以下方法解决：
  - 首先可以使用 cp ./feeds/puppies/rom/xxx/xxx/config .config，然后使用 make menuconfig 确认是不是 target 没有选中成功，如果确实没有选中，可按下面的步骤进行：
  - 1、进入 feeds/mtk_openwrt_feed/target/linux/ 目录下，找到想要编译的对应内核，这里举例 mediatek/mt7981
  - 2、复制此文件到 target/linux/mediatek 目录下，同时修改 target/linux 目录下的 Makefile，在其中加入自己要编译的 target 的名称，与文件名对应
  - 3、./scripts/feeds install -a
  - 4、使用 make menuconfig 确认可以找到自己想要编译的 target
  - 5、重新进行./feeds/puppies/rom/scripts/make.sh xxx 编译

### 2、root 用户导致的编译不过问题：

```
| #include <sys/stat.h>
|              #include <unistd.h>
|
|              /* Copied from root-uid.h.  FIXME: Just use root-uid.h.  */
|              #ifdef __TANDEM
|              # define ROOT_UID 65535
|              #else
|              # define ROOT_UID 0
|              #endif
|
| int
| main ()
| {
| /* Indeterminate for super-user, assume no.  Why are you running
|          configure as root, anyway?  */
|       if (geteuid () == ROOT_UID) return 99;
|       if (mknod ("conftest.fifo", S_IFIFO | 0600, 0)) return 2;
|   ;
|   return 0;
| }
configure:29497: error: in `/root/wqj/AC_2210E/x-wrt/build_dir/host/tar-1.34':
configure:29499: error: you should not run configure as root (set FORCE_UNSAFE_CONFIGURE=1 in environment to bypass this check)
See `config.log' for more details

```

- 解决：export FORCE_UNSAFE_CONFIGURE=1; make tools/tar/compile V=s

### 3、GCC 版本不正确导致工具链编译不过的问题：

```
| int
| main ()
| {
|
|   ;
|   return 0;
| }
configure:3705: error: in `/root/wqj/AC_2210E/new_sdk/build_dir/toolchain-aarch64_cortex-a53_gcc-8.4.0_musl/gcc-8.4.0-initial/aarch64-openwrt-linux-musl/libgcc':
configure:3708: error: cannot compute suffix of object files: cannot compile
See `config.log' for more details.
```

- 解决：暂时清空.config，不手动选择 GCC 版本，只选择内核等基础信息。然后开始编译。

### 4、xxx.ko 模块缺失依赖的问题：

```
例如：
Package kmod-ipt-conntrack-extra is missing dependencies for the following libraries:
nf_conncount.ko
```

- 解决：进入 make kernel_menuconfig，查找 nf_conncount 或者 conncount、nf 等关键字，找到对应模块。查看哪些模块是被依赖，且为 N 的，记录下来，在 make kernel_menuconfig 中将其勾选上

### 5、xxx.so 缺失依赖的问题

```
编译 package/xxx/xxx 报错：
缺少xxx.so的依赖
```

- 解决：找到 package/xxx/xxx/Makefile 在 DEPENDS 下添加 : +xxx(一般为.so 的名称)

### 6、libmariadb CMake 报错：

```
CMake Error at cmake/ConnectorName.cmake:30 (ENDMACRO):
  Flow control statements are not properly nested.
Call Stack (most recent call first):
  CMakeLists.txt:423 (INCLUDE)
```

- 解决：
  - https://github.com/coolsnowwolf/lede/issues/8065
  - https://github.com/coolsnowwolf/packages/pull/257

### 7、openssl 依赖缺失报错：

```
Package luasec2 is missing dependencies for the following libraries:
libcrypto.so.3
libssl.so.3
Makefile:62: recipe for target '/root/wqj/AC_2210E/x-wrt/bin/packages/aarch64_cortex-a53/puppies/luasec2_1.0.1-1_aarch64_cortex-a53.ipk' failed
make[3]: *** [/root/wqj/AC_2210E/x-wrt/bin/packages/aarch64_cortex-a53/puppies/luasec2_1.0.1-1_aarch64_cortex-a53.ipk] Error 1
make[3]: Leaving directory '/root/wqj/AC_2210E/puppies/openwrt-ac-puppies/apps/luasec2'
time: package/feeds/puppies/luasec2/compile#1.61#0.18#1.80
    ERROR: package/feeds/puppies/luasec2 failed to build.

```

- 问题原因：依赖的 openssl 包名称错误
- 解决（`libcrypto和libssl缺失依赖都可以通过此方法解决`）：

```
进入package/feeds/puppies/luasec2/Makefile中：
1、将 DEPENDS:=+lua +openssl -util  改为 DEPENDS:=+lua +libopenssl -util
2、将$(eval $(call BuildPackage,$(PKG_NAME),+libz)) 改为 $(eval $(call BuildPackage,$(PKG_NAME),+libz,+libopenssl))
```

### 8、depends 下已经添加了 libc++，但是仍然报找不到 libstdc++.so.6 依赖的错误：

```
Package mcproxy is missing dependencies for the following libraries:
libstdc++.so.6
```

- 解决：
- https://developer.aliyun.com/article/33292

```
在对应模块Makefile中的install下加入：

    $(INSTALL_DIR) $(1)/usr/lib
    $(INSTALL_DATA) $(TOOLCHAIN_DIR)/lib/libstdc++.so.6 $(1)/usr/lib

```

### 9、编译 nginx-util 模块时遇到如下报错：

```
[1/4] Building CXX object CMakeFiles/nginx-ssl-util.dir/nginx-util.cpp.o
FAILED: CMakeFiles/nginx-ssl-util.dir/nginx-util.cpp.o

/root/wqj/AC_2210E/x-wrt/build_dir/target-aarch64_cortex-a53_musl/nginx-util-1.6/nginx-ssl-util.hpp:214:35: error: this statement may fall through [-Werror=implicit-fallthrough=]
  214 |                     case '^': ret += '\\'; [[fallthrough]];
      |                               ~~~~^~~~~~~
/root/wqj/AC_2210E/x-wrt/build_dir/target-aarch64_cortex-a53_musl/nginx-util-1.6/nginx-ssl-util.hpp:215:21: note: here
  215 |                     case '_': [[fallthrough]];
      |                     ^~~~
/root/wqj/AC_2210E/x-wrt/build_dir/target-aarch64_cortex-a53_musl/nginx-util-1.6/nginx-ssl-util.hpp: In lambda function:
/root/wqj/AC_2210E/x-wrt/build_dir/target-aarch64_cortex-a53_musl/nginx-util-1.6/nginx-ssl-util.hpp:214:35: error: this statement may fall through [-Werror=implicit-fallthrough=]
  214 |                     case '^': ret += '\\'; [[fallthrough]];
      |                               ~~~~^~~~~~~
/root/wqj/AC_2210E/x-wrt/build_dir/target-aarch64_cortex-a53_musl/nginx-util-1.6/nginx-ssl-util.hpp:215:21: note: here
  215 |                     case '_': [[fallthrough]];
      |                     ^~~~
/root/wqj/AC_2210E/x-wrt/build_dir/target-aarch64_cortex-a53_musl/nginx-util-1.6/nginx-ssl-util.hpp: In lambda function:
/root/wqj/AC_2210E/x-wrt/build_dir/target-aarch64_cortex-a53_musl/nginx-util-1.6/nginx-ssl-util.hpp:214:35: error: this statement may fall through [-Werror=implicit-fallthrough=]
  214 |                     case '^': ret += '\\'; [[fallthrough]];
      |                               ~~~~^~~~~~~
/root/wqj/AC_2210E/x-wrt/build_dir/target-aarch64_cortex-a53_musl/nginx-util-1.6/nginx-ssl-util.hpp:215:21: note: here
  215 |                     case '_': [[fallthrough]];
      |                     ^~~~
/root/wqj/AC_2210E/x-wrt/build_dir/target-aarch64_cortex-a53_musl/nginx-util-1.6/nginx-ssl-util.hpp: In lambda function:
/root/wqj/AC_2210E/x-wrt/build_dir/target-aarch64_cortex-a53_musl/nginx-util-1.6/nginx-ssl-util.hpp:214:35: error: this statement may fall through [-Werror=implicit-fallthrough=]
  214 |                     case '^': ret += '\\'; [[fallthrough]];
      |                               ~~~~^~~~~~~
/root/wqj/AC_2210E/x-wrt/build_dir/target-aarch64_cortex-a53_musl/nginx-util-1.6/nginx-ssl-util.hpp:215:21: note: here
  215 |                     case '_': [[fallthrough]];
      |                     ^~~~
/root/wqj/AC_2210E/x-wrt/build_dir/target-aarch64_cortex-a53_musl/nginx-util-1.6/nginx-ssl-util.hpp: In lambda function:
/root/wqj/AC_2210E/x-wrt/build_dir/target-aarch64_cortex-a53_musl/nginx-util-1.6/nginx-ssl-util.hpp:214:35: error: this statement may fall through [-Werror=implicit-fallthrough=]
  214 |                     case '^': ret += '\\'; [[fallthrough]];
      |                               ~~~~^~~~~~~
/root/wqj/AC_2210E/x-wrt/build_dir/target-aarch64_cortex-a53_musl/nginx-util-1.6/nginx-ssl-util.hpp:215:21: note: here
  215 |                     case '_': [[fallthrough]];
      |                     ^~~~
/root/wqj/AC_2210E/x-wrt/build_dir/target-aarch64_cortex-a53_musl/nginx-util-1.6/nginx-ssl-util.hpp: In lambda function:
/root/wqj/AC_2210E/x-wrt/build_dir/target-aarch64_cortex-a53_musl/nginx-util-1.6/nginx-ssl-util.hpp:214:35: error: this statement may fall through [-Werror=implicit-fallthrough=]

```

- 原因：编译时将警告当作了报错，不继续执行。
- 解决：在 nginx-util 目录下搜索 -Werror 关键字，将此关键字去除，重新编译可解决
- https://blog.csdn.net/changyana/article/details/123453443

---

### 10、install 时缺失依赖：

```
* pkg_hash_check_unresolved: cannot find dependency kmod-fixed-phy for kmod-of-mdio
 * pkg_hash_fetch_best_installation_candidate: Packages for kmod-of-mdio found, but incompatible with the architectures configured
 * opkg_install_cmd: Cannot install package kmod-of-mdio.
 * pkg_hash_check_unresolved: cannot find dependency kmod-lib-crc32c for kmod-nft-core
 * pkg_hash_fetch_best_installation_candidate: Packages for kmod-nft-core found, but incompatible with the architectures configured
 * opkg_install_cmd: Cannot install package kmod-nft-core.
 * satisfy_dependencies_for: Cannot satisfy the following dependencies for kmod-nft-nat:
 * 	kmod-lib-crc32c
```

- 这种一般是 Makefile 中加了依赖，但 config 文件中未选中导致的。
- 解决方法：在 config 文件中搜索关键字，找到后勾选即可

---

### 11、make target/linux/install V=s 报错：

```
cc1: fatal error: /root/wqj/AC_2210E/x-wrt/build_dir/target-aarch64_cortex-a53_musl/linux-mediatek_mt7981/linux-5.15.102/arch/arm64/boot/dts/mediatek/mt7981-spim-nor-rfb.dts: No such file or directory
```

- 原因：找不到 makefile 中对应的 dts 文件
- 解决方法：
  - 1、找到 target/linux/mediatek/files-xx/arch/arm64/boot/dts/mediatek(报错中对应的)
  - 2、将旧环境中对应的 dts 文件 cp 到新环境下的 target/linux/mediatek/files-xx/arch/arm64/boot/dts/mediatek 中

---

### 12、 multiple definition of xxx 问题：

```
/root/wqj/AC_2210E/x-wrt/staging_dir/toolchain-aarch64_cortex-a53_gcc-12.3.0_musl/lib/gcc/aarch64-openwrt-linux-musl/12.3.0/../../../../aarch64-openwrt-linux-musl/bin/ld: /root/wqj/AC_2210E/x-wrt/tmp/cc0DQclo.o:/root/wqj/AC_2210E/x-wrt/build_dir/target-aarch64_cortex-a53_musl/radius/uma_inner.h:97: multiple definition of `rt2'; /root/wqj/AC_2210E/x-wrt/tmp/ccPZqzNp.o:/root/wqj/AC_2210E/x-wrt/build_dir/target-aarch64_cortex-a53_musl/radius/uma_inner.h:97: first defined here

```

- 解决：
  - https://www.cnblogs.com/senior-engineer/p/9335795.html
  - https://blog.csdn.net/mantis_1984/article/details/53571758

## openwrt 论坛：

- https://forum.openwrt.org/latest
- https://github.com/ntop/n2n/labels/question

## op sdk 软件包下载地址：

- https://git.openwrt.org/?p=project/libnl-tiny.git;

## openwrt 文件系统分析：

- https://www.jianshu.com/p/21e2e403da76
- https://www.cnblogs.com/linhaostudy/p/17534948.html

## json 解析：

- jshn : https://openwrt.org/docs/guide-developer/jshn
- jsonfilter: https://www.cnblogs.com/lsgxeva/p/17335057.html

## openwrt 启动过程：

- https://e-mailky.github.io/2019-01-14-initialize

## 当 openwrt 设备上没有 sz rz 时，可以通过下面的方式解决：

```
opkg update
opkg install lrzsz
```

## openwrt 中的 dhcp 相关进程：

- https://kysonlok.gitbook.io/blog/openwrt/how_does_udhcpc_work

## openwrt 添加驱动模块：

- https://b31jsc.github.io/2018/07/04/OpenWRT%E4%B8%AD%E6%B7%BB%E5%8A%A0%E9%A9%B1%E5%8A%A8%E6%A8%A1%E5%9D%97/
