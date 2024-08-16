## openwrt目录结构及其作用
- include —— 存放 *.mk 文件。这里的文件上是`在Makefile里被include`的
- dl —— 目录是'download'的缩写, 在 `编译前期`，需要`从网络下载的软件包`都会放在这个目录下。`编译时，会将软件包解压到build_dir目录下。`
- package  ——  会将feeds目录下的软件源描述的`软件包的配置文件`安装在package目录。包含`针对各个软件包的Makefile`。
- feeds  ——  记录`软件源的目录`，由 ./scripts/feeds update进行软件源更新，存放在feeds目录
- toolchain  —— `交叉编译工具链`脚本规则
- tools ——  `其他协助编译工具`的脚本规则
- target  ——  `各平台`在这个目录里`定义了firmware和kernel的编译过程`(`不同平台的内核文件和硬件的dts文件等`)。
- build_dir/  —— 目录下进行软件包`解压`，然后在此`编译和打补丁`等（像一个`临时中转站`）。
- staging_dir/  —— `生成最终文件系统之前的临时安装目录。`。`tools, toolchain`被安装到这里，`rootfs`也会放到这里。
- bin  —— 编译完成之后，`firmware和各ipk`会放到此目录下。
- tmp  —— 记录`make menuconfig的配置规则`，清空此目录，重新make menuconfig，则会重新检查编译规则


## 参考文章：
- https://www.cnblogs.com/arnoldlu/p/18306851