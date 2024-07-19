# 如果有两个feeds，都会有叫做natflow(举例子)的模块的话，install的时候会按feeds.conf的先后顺序去安装：
- 比如：
```
src-git pre-puppies xxxxx
src-git aft-puppies xxxxx
```
- `那么实际上只会install pre-puppies 的natflow模块，aft-puppies的不会再安装，因为openwrt不允许安装同名模块！！！`