- 查看 Lua 的版本：lua -v
- 安装环境命令：
```
curl -R -O https://www.lua.org/ftp/lua-5.3.4.tar.gz
tar zxf lua-5.3.4.tar.gz
cd lua-5.3.4
make linux test
make install
```
- 遇到的问题：
    - lua.c:82:10: fatal error: readline/readline.h: 没有那个文件或目录#include <readline/readline.h>
    - 解决方法：
        - 安装readline-devel package：sudo apt-get install libreadline-dev



