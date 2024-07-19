- openwrt官方使用patch的说明：https://oldwiki.archive.openwrt.org/doc/devel/patches?s[]=quilt

- https://www.cnblogs.com/adam-ma/p/17712940.html
- https://www.cnblogs.com/conscience-remain/p/17073933.html
- https://blog.51cto.com/linuxcgi/2059410

- https://blog.csdn.net/agave7/article/details/121029806


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
