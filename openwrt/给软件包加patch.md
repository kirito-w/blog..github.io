- openwrt官方使用patch的说明：https://oldwiki.archive.openwrt.org/doc/devel/patches?s[]=quilt

- https://www.cnblogs.com/adam-ma/p/17712940.html
- https://www.cnblogs.com/conscience-remain/p/17073933.html
- https://blog.51cto.com/linuxcgi/2059410

- https://blog.csdn.net/agave7/article/details/121029806


# 普通软件包补丁：
## 通过quilt指令（`更安全，推荐`）：
预处理：`make package/feeds/packages/netopeer2/{clean,prepare} V=s QUILT=1`

- 1.编译后进入到build_dir下：`cd /build_dir/target-aarch64_cortex-a53_musl/netopeer2-2.1.71`
- 2.`quilt push -a`（如果原先有patch，需要先打上, 如果没有，日志为：No series file found）
- 3.新建一个patch，编号基于现有的patch最大编号再+1————`quilt new 001-app-dd-mark.patch` 
- 4.编辑想要改动的源文件：`quilt edit ./src/main.c`
- 5.查看修改：`quilt diff`
- 6.更新改动到patch文件：`quilt refresh`
- 7.把生成的patch文件更新到package包的patches目录：`make package/feeds/packages/netopeer2/update V=s`
- 8.重新编译：`make package/feeds/packages/netopeer2/{clean,compile} package/index V=s`

## 通过diff指令（更简便）：
- 1.拷贝两份初始文件夹，一份作为old，一份作为new
- 2.vim修改完所有文件后保存
- 3.diff -uNr dir_old dir_new  > package/xxxxx/patches/001-app-dd-mark.patch` 可以对比整个目录差异
- 4.重新编译

================================================================
# 内核文件补丁：
## https://www.openwrt.pro/post-95.html
## https://blog.csdn.net/wind0419/article/details/82996738
## 预处理：
- 1、make target/linux/clean —— 清除编译
- 2、` make target/linux/prepare V=s QUILT=1` —— 准备全新的源码
- 3.切换到kernel目录 —— cd build_dir/target-mipsel_24kec+dsp_uClibc-0.9.33.2/linux-ramips_mt7688/linux-3.18.44
- 4.`quilt push -a`（如果原先有patch，需要先打上, 如果没有，日志为：No series file found）
- 5.查看最大的patch编号 —— quilt top
- 6.新建一个patch，编号基于现有的patch最大编号再+1————`quilt new 001-app-dd-mark.patch` 
- 7.编辑想要改动的源文件：`quilt edit ./src/main.c`
- 8.查看修改：`quilt diff`
- 9.更新改动到patch文件：`quilt refresh`
- 10.回到根目录：`make target/linux/update package/index V=s`
- 11.如果10没有成功将patch放到target/linux/xxxx/patches-4.4/下，可以手动修改patch中的from和to 为a和b，并且删除index，然后手动移动到patches-4.4/下，重新清空编译内核即可

## 实例见9999-705-hnat-ipv6-debug.patch

================================================================