- 1、首先，搜索功能对应的关键字：
```
grep -nr save ./
```
- 2、发现文件 skynet/lualib/op/wireless.lua 是我们要的文件

- 3、lua查看调用栈（放置在对应文件的对应函数里）: 
```    
    local file = io.open("/tmp/wqj.txt", "a+")
    file:write(debug.traceback())
    file:close()
```
		



- 6、web端执行操作！
