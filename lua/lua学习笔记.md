# lua学习：
# lua手册 https://www.lua.org/

## 交互式编程：
- Lua 提供了交互式编程模式。我们可以在命令行中输入程序并立即查看效果。
- Lua 交互式编程模式可以通过命令 lua -i 或 lua 来启用：  
![](img/%E5%9B%BE%E7%89%8745.png)

======================================================================

## 脚本式编程：
- 我们可以将 Lua 程序代码保存到一个以 lua 结尾的文件，并执行，该模式称为脚本式编程，如我们将如下代码存储在名为 hello.lua 的脚本文件中：  
![](img/%E5%9B%BE%E7%89%8746.png)

======================================================================

## 注释:
- 单行注释:   
```
--
```
- 多行注释:
```
--[[
 多行注释
 多行注释
 --]]
```
======================================================================

## 标示符:
- Lua 标示符`用于定义一个变量`，函数获取其他用户定义的项。标示符`以一个字母` A 到 Z `或` a 到 z 或`下划线` _ `开头`后`加`上 0 个或多个`字母，下划线，数字`（0 到 9）。
- Lua `不允许`使用`特殊字符`如 @, $, 和 % 来定义标示符。 Lua 是一个`区分大小写`的编程语言。因此在 Lua 中 Runoob 与 runoob 是两个不同的标示符。
- 最好`不要使用下划线加大写字母`的标示符，因为`Lua的保留字`也是这样的。
- 正确的标识符例子：
```
mohd         zara      abc     move_name    a_123
myname50     _temp     j       a23b9        retVal
```

======================================================================

## 关键词:
- 以下列出了 Lua 的保留关键词。`保留关键字不能`作为`常量`或`变量`或其他`用户自定义标示符`：
```
and	| break | do | else
elseif | end | false | for
function | if | in | local
nil | not | or | repeat
return | then | true | until
while | goto		
```
- 一般约定，`以下划线开头连接一串大写字母`的名字（比如 _VERSION）`被保留用于 Lua 内部全局变量`。

======================================================================
## 全局变量:
- 在`默认`情况下，变量`总是`认为是`全局`的。
- `全局变量不需要声明`，给一个变量`赋值`后即`创建`了这个`全局变量`，`访问`一个`没有初始化的全局变量`也不会出错，只不过`得到`的结果是：`nil`。
- 如果你想`删除一个全局变量`，只需要将变量`赋值为nil`。

======================================================================

## 数据类型：
- Lua 中有 `8 个基本类型`分别为：nil、boolean、number、string、userdata、function、thread 和 table。
    - nil：这个最简单，只有值nil属于该类，`表示一个无效值`（在条件表达式中相当于false）；
    - boolean：包含两个值：`false和true`；
    - number：表示`双精度`类型的`实浮点数`；
    - string：字符串由`一对双引号`或`单引号`来表示；
    - function：由 `C 或 Lua` 编写的`函数`；
    - userdata：表示`任意`存储在变量中的`C数据结构`；
    - thread：表示`执行的独立线路`，用于`执行协同程序`；
    - table：Lua 中的表（table）其实是一个`"关联数组"`（associative arrays），数组的`索引`可以是`数字、字符串或表类型`。在 Lua 里，table 的`创建`是`通过"构造表达式"`来`完成`，最简单构造表达式是`{}`，用来`创建一个空表`。

----------------------------------------------------------------

### `nil`：
- nil 作比较时应该加上双引号 `"`，例如：type(X)=="nil"
- 对于全局变量和 table，nil 还有一个"删除"作用，给全局变量或者 table 表里的变量赋一个 nil 值，等同于把它们删掉。
```
tab1 = { key1 = "val1", key2 = "val2", "val3" }
for k, v in pairs(tab1) do
    print(k .. " - " .. v)
end
 
tab1.key1 = nil
for k, v in pairs(tab1) do
    print(k .. " - " .. v)
end
```

----------------------------------------------------------------

### `boolean`：
- Lua 把 `false 和 nil` 看作是 `false`，`其他`的都为 `true`，数字 0 也是 true。  
![](img/%E5%9B%BE%E7%89%8747.png)

----------------------------------------------------------------

### `number（数字）`:
- Lua `默认只有一种 number 类型` -- double（双精度）类型（默认类型可以修改 luaconf.h 里的定义），以下几种写法都被看作是 number 类型：
```
print(type(2))
print(type(2.2))
print(type(0.2))
print(type(2e+1))
print(type(0.2e-1))
print(type(7.8263692594256e-06))
```

----------------------------------------------------------------

### `string（字符串）`：
- 字符串由一对双引号或单引号来表示:
```
string1 = "this is string1"
string2 = 'this is string2'
```
- 也可以用 2 个方括号 `"[[]]"` 来表示`"一块"字符串`。
```
test = [[
zxkcjlkzxjckljqwlkr
&*$#&Q!*&#
hahhahah
哈哈哈
]]
print(test)
```
执行结果：  
![](img/%E5%9B%BE%E7%89%8748.png)
- 在对一个数字字符串上进行算术操作时，Lua 会`尝试`将这个数字`字符串转成一个数字`:
```
> print("2" + 6)
8.0
> print("2" + "6")
8.0
> print("2 + 6")
2 + 6
> print("-2e2" * "6")
-1200.0
```
- `字符串连接`使用的是 `..`(尽量用来连接两个字符串变量！):
```
print("test = " .. test)
``` 

----------------------------------------------------------------

### `table（表）`:
#### 注意，#只能获取数组类型table的长度，即索引是连续的。不能用来获取键值对table的长度

-  在 Lua 中，你可以用`任意类型`的值来作数组的`索引`，但这个值`不能是nil`。
- 在 Lua 里，table 的创建是通过"构造表达式"来完成，最简单构造表达式是{}，用来创建一个空表。也可以在表里添加一些数据，直接初始化表:

- table初始化：
    - 第一，所有元素之间，`总是`用逗号 "，" 隔开；
    - 第二，所有`索引值`都需要用 `"["和"]"` 括起来；如果是字符串，还可以去掉引号和中括号； 即如果`没有[]括起`，则`认为是字符串索引。`
    - 第三，如果`不写索引`，则索引就会被`认为是数字`，并`按顺序`自动`从1往后`编；
```
tab = {}
tab["key"] = "value"
tab[1] = 1
tab[1.3] = "shishu"
tab["false"] = 1

a = {[tab] = "table", key = 4, [0.12] = "yes"}
```

- 不同于其他语言的数组把 0 作为数组的初始索引，在 `Lua 里表的默认初始索引一般以 1 开始`。

- table `不会固定长度大小`，有新数据添加时 table 长度会`自动增长`，`没初始的 table 都是 nil`。
```
a3 = {}
for i = 1, 10 do
    a3[i] = i
end
a3["key"] = "val"
print(a3["key"])
print(a3["none"])
```
结果：
```
val
nil
```

- `为什么value不能为boolean?`

----------------------------------------------------------------

### `function（函数）`:
- 在 Lua 中，函数是被看作是`"第一类值（First-Class Value）"`，函数`可以存在变量`里:
```
function factorial1(n)
    if n == 0 then
        return 1
    else
        return n * factorial1(n - 1)
    end
end
print(factorial1(5))
factorial2 = factorial1
print(factorial2(5))
```
执行结果为：
```
120
120
```
- function 可以以`匿名函数`（anonymous function）的方式通过`参数形式传递`:
```
function testFun(tab,fun)
        for k ,v in pairs(tab) do
                print(fun(k,v));
        end
end


tab={key1="val1",key2="val2"};
testFun(tab,
function(key,val)--匿名函数
        return key.."="..val;
end
);
```
执行结果为：
```
key1=val1
key2=val2
```

----------------------------------------------------------------

### `thread（线程）`：
- 在 Lua 里，`最主要的线程是协同程序（coroutine）`。它跟线程（thread）差不多，`拥有`自己`独立`的`栈、局部变量和指令指针`，可以`跟其他协同程序共享全局变量和其他大部分东西`。
- 线程跟协程的区别：`线程可以同时多个运行`，而`协程任意时刻只能运行一个`，并且处于运行状态的协程`只有被挂起（suspend）时才会暂停`。

----------------------------------------------------------------

### `userdata（自定义类型）`：
- userdata 是一种用户自定义数据，用于表示一种`由应用程序或 C/C++ 语言库所创建的类型`，可以将任意 C/C++ 的任意数据类型的数据（通常是 struct 和 指针）存储到 Lua 变量中调用。


======================================================================

## 变量：
### Lua 变量基础：
- 变量在`使用前`，需要在代码中进行`声明`，即创建该变量。
- 编译程序执行代码之前编译器需要知道如何给语句变量开辟存储区，用于存储变量的值。
- Lua 变量有三种类型：`全局变量、局部变量、表中的域`。
- Lua 中的变量`全是全局变量`，`哪怕`是`语句块或是函数`里，`除非用 local 显式声明`为`局部变量`。
- `局部变量`的`作用域`为从`声明位置开始到所在语句块`结束。
- 变量的`默认值均为 nil`。
```
a = 5               -- 全局变量
local b = 5         -- 局部变量

function joke()
    c = 5           -- 全局变量
    local d = 6     -- 局部变量
end

joke()
print(c,d)          --> 5 nil

do
    local a = 6     -- 局部变量
    b = 6           -- 对局部变量重新赋值
    print(a,b);     --> 6 6
end

print(a,b)      --> 5 6
```

----------------------------------------------------------------

### 赋值语句
- Lua 可以对`多个变量同时赋值`，变量列表和值列表的各个元素`用逗号分开`，赋值语句右边的值会`依次赋给`左边的变量。
```
a, b = 10, 2*x       <-->       a=10; b=2*x
```
- 遇到赋值语句Lua会`先计算右边所有的值`然后`再执行赋值`操作，所以我们可以这样进行`交换变量的值`：
```
x, y = y, x                     -- swap 'x' for 'y'
a[i], a[j] = a[j], a[i]         -- swap 'a[i]' for 'a[j]'
```

- 当`变量个数和值的个数不一致`时，Lua会一直`以变量个数为基础`采取以下策略：
    - a. 变量个数 > 值的个数             按变量个数`补足nil`
    - b. 变量个数 < 值的个数             `多余`的值会被`忽略`
```
a, b, c = 0, 1
print(a,b,c)             --> 0   1   nil
 
a, b = a+1, b+1, b+2     -- value of b+2 is ignored
print(a,b)               --> 1   2
 
a, b, c = 0
print(a,b,c)             --> 0   nil   nil
```
- 上面最后一个例子是一个常见的错误情况，注意：`如果要对多个变量赋值必须依次对每个变量赋值`。
```
a, b, c = 0, 0, 0
print(a,b,c)             --> 0   0   0
```

- 多值赋值经常用来`交换变量`，或将`函数调用返回给变量`：
```
a, b = f()   -- f()返回两个值，第一个赋给a，第二个赋给b。
```

- 应该`尽可能的使用局部变量`，有两个好处：
    - 1、`避免`命名`冲突`。
    - 2、`访问`局部变量的`速度`比全局变量`更快`。

----------------------------------------------------------------


### 索引
- 对 table 的索引使用方括号 []。Lua 也提供了 . 操作。
```
t[i]
t.i                 -- 当索引为字符串类型时的一种简化写法
gettable_event(t,i) -- 采用索引访问本质上是一个类似这样的函数调用
```
- `只有索引为字符串时，才能用.访问（？？？？存疑）`。

======================================================================

## 循环:
### 概念：
- 循环语句是由`循环体及循环的终止条件`两部分组成的。

### pairs 和 ipairs的区别：
- ipairs：用于遍历`数组`
- pairs：用于遍历`键-值对`

----------------------------------------------------------------

### 几种循环处理方式：
#### 1、while 循环：
```
while(condition)
do
   statements
end
```
- statements(循环体语句) 可以是一条或多条语句，condition(条件) 可以是`任意表达式`，在 condition(条件) 为 true 时执行循环体语句。

----------------------------------------------------------------

####  2、for 循环
- Lua 编程语言中 for语句有两大类：
    - 数值for循环
    - 泛型for循环

- `数值for循环`：
    - var `从 exp1 变化到 exp2`，每次变化`以 exp3 为步长递增` var，并执行一次 "执行体"。exp3 是可选的，如果不指定，默认为1。
    - exp1,exp2,exp3都可以是`表达式`。
    - for的三个表达式`在循环开始前一次性求值`，以后`不再`进行`求值`。
```
for var=exp1,exp2,exp3 do  
    <执行体>  
end

-- 输出1到10的奇数
for i = 1, 10, 2 do
	print(i .. "\n")  
end

```
- `泛型for循环`：
    - 泛型 for 循环通过一个`迭代器函数`来遍历所有值。
    - `i`是数组`索引值`，`v`是对应索引的数组`元素值`。`ipairs`是Lua提供的一个`迭代器函数`，用来迭代数组。
```
--打印数组a的所有值  
a = {"one", "two", "three"}
for i, v in ipairs(a) do
    print(i, v)
end 
```

----------------------------------------------------------------

#### 3、repeat...until 循环:
- Lua 编程语言中 repeat...until 循环语句不同于 `for 和 while`循环，for 和 while 循环的条件语句在当前`循环执行开始时`判断，而 `repeat...until` 循环的条件语句在当前`循环结束后`判断。
```
repeat
   statements
until( condition )
```
- 我们注意到循环条件判断语句（condition）在循环体末尾部分，所以`在条件进行判断前循环体都会执行一次`。
- 如果条件判断语句（condition）为 `false`，循环会`重新开始执行`，直到条件判断语句（condition）为 `true` 才会`停止执行`。
- 可以理解为——`直到...就跳出循环`。

```
-- 从10到1输出
a = 10
repeat
	print(a)
	a = a - 1
until(a <= 0)

```

----------------------------------------------------------------

### 循环嵌套：
- Lua 编程语言中允许循环中嵌入循环。
- 可以使用不同的循环类型来嵌套，如 for 循环体中嵌套 while 循环。

----------------------------------------------------------------

### 循环控制语句：
- 循环控制语句用于`控制程序的流程`， 以实现程序的各种结构方式。  

`Lua 支持以下循环控制语句`：
#### 1、break 语句：
-  break 语句插入在循环体中，用于`退出当前循环或语句`，并开始脚本执行紧接着的语句。
- 以下实例执行 while 循环，在变量 a 小于 20 时输出 a 的值，并在 a 大于 15 时终止执行循环：
```
-- 输出10-15
--[ 定义变量 --]
a = 10

while( a < 20 )
do
   print("a 的值为:", a)
   a=a+1
   if( a > 15)
   then
      break
   end
end
```

----------------------------------------------------------------

#### 2、goto 语句（需要Lua 5.2以上）：
- goto 语句允许将控制流程`无条件地转到被标记的语句处`。
- 语法格式:
```
goto Label

--Label格式：
:: Label ::
```
- 有了 goto，我们可以`实现 continue `的功能：：
```
--输出1-10的所有奇数
for var = 1, 10 do
	if(var % 2 == 0) then
		goto continue
	end
	print(var)
	::continue::
end

```
----------------------------------------------------------------
### 无限循环：
- 在循环体中如果条件永远为 true 循环语句就会永远执行下去，以下以 while 循环为例：
```
while( true )
do
   print("循环将永远执行下去")
end
```
======================================================================

## 流程控制:
### 概念：
- Lua 编程语言流程控制语句通过程序设定`一个或多个条件语句来设定`。在条件为 `true` 时执行`指定程序代码`，在条件为 `false `时执行`其他指定代码`。
- 控制结构的`条件表达式结果可以是任何值`，Lua认为`false和nil`为`假`，`true和非nil`为`真`。
- 要注意的是Lua中 0 为 true：
```
--[ 0 为 true ]
if(0)
then
    print("0 为 true")
end
```

----------------------------------------------------------------

### Lua 提供了以下控制结构语句：
#### 1、if...else 语句：
- Lua if 语句可以与 else 语句搭配使用, 在 if 条件表达式为 false 时执行 else 语句代码块。
```
if(布尔表达式)
then
   --[ 布尔表达式为 true 时执行该语句块 --]
else
   --[ 布尔表达式为 false 时执行该语句块 --]
end
```
- 实例：
```
--[ 定义变量 --]
a = 100;
--[ 检查条件 --]
if( a < 20 )
then
   --[ if 条件为 true 时执行该语句块 --]
   print("a 小于 20" )
else
   --[ if 条件为 false 时执行该语句块 --]
   print("a 大于 20" )
end
print("a 的值为 :", a)
```

----------------------------------------------------------------

#### 2、if...elseif...else 语句：
- Lua if 语句可以与 elseif...else 语句搭配使用, 在 if 条件表达式为 false 时执行 elseif...else 语句代码块，用于检测多个条件语句。
```
if( 布尔表达式 1)
then
   --[ 在布尔表达式 1 为 true 时执行该语句块 --]

elseif( 布尔表达式 2)
then
   --[ 在布尔表达式 2 为 true 时执行该语句块 --]

elseif( 布尔表达式 3)
then
   --[ 在布尔表达式 3 为 true 时执行该语句块 --]
else 
   --[ 如果以上布尔表达式都不为 true 则执行该语句块 --]
end
```
----------------------------------------------------------------

#### 3、Lua if 语句允许嵌套。

======================================================================

##  函数:
- 在Lua中，函数是`对语句和表达式进行抽象的主要方法`。既可以用来处理一些特殊的工作，也可以用来计算一些值。
- Lua 提供了许多的`内建函数`，你可以很方便的在程序中调用它们，`如print()`函数可以将传入的参数打印在控制台上。
- Lua 函数主要有两种用途：
    - 1、`完成指定的任务`，这种情况下函数`作为调用语句`使用；
    - 2、`计算并返回值`，这种情况下函数`作为赋值语句的表达式`使用。

----------------------------------------------------------------

### 函数定义：
- Lua 编程语言函数定义格式如下：
```
optional_function_scope function function_name( argument1, argument2, argument3..., argumentn)
    function_body
    return result_params_comma_separated
end
```
- 解析：
    - `optional_function_scope`: 该参数是`可选的`, 指定函数是全局函数还是局部函数，未设置该参数`默认为全局函数`，如果你需要设置函数为`局部函数`需要使用关键字 `local`。
    - `function_name`: 指定函数名称。
    - `argument1, argument2, argument3..., argumentn`: 函数参数，多个参数`以逗号隔开`，函数也`可以不带参数`。
    - `function_body`: 函数体，函数中需要执行的代码语句块。
    - `result_params_comma_separated`: 函数返回值，Lua语言函数`可以返回多个值`，每个值`以逗号隔开`。

- 实例：
```
function sum(a, b, c, d)
	local sum1 = a + b
	local sum2 = c + d
	return sum1, sum2
end

local i = 1
local j = 2
local k = 3
local l = 4
local temp1, temp2 = sum(i, j, k, l)
print(temp1 .. " and " .. temp2)
```

- Lua 中我们可以将`函数作为参数`传递给函数，如下实例：
```
myprint = function(param)
   print("这是打印函数 -   ##",param,"##")
end

function add(num1,num2,functionPrint)
   result = num1 + num2
   -- 调用传递的函数参数
   functionPrint(result)
end
myprint(10)
-- myprint 函数作为参数传递
add(2,5,myprint)
```

----------------------------------------------------------------

### 多返回值:
- Lua函数可以返回多个结果值，比如`string.find`，其返回匹配串"开始和结束的下标"（如果不存在匹配串返回nil）。
```
s, e = string.find("www.runoob.com", "runoob")
print(s, e)
```

----------------------------------------------------------------

### 可变参数：
- Lua 函数可以`接受可变数目的参数`，和 C 语言类似，在函数参数列表中`使用三点 ... `表示函数有可变的参数
- 实例：
```
function multi(...)
	local sum = 1
	for i, v in ipairs{...} do   --> {...} 表示一个由所有变长参数构成的数组
		sum = sum * v
	end
return sum
end

print(multi(1, 2, 3))
```
----------------------------------------------------------------

- 我们也可以通过` select("#",...) `来获取`可变参数的数量`:
```
function multi(...)
	local arg={...}    --> arg 为一个表，局部变量
	print(#arg)   --> #arg 为可变参数的数量
	print(select("#",...))   --> select("#",...) 为可变参数的数量
end

print(multi(1, 2, 3,4,5))
```

----------------------------------------------------------------

- 有时候我们可能需要`几个固定参数加上可变参数`，固定参数必须`放在变长参数之前`:
- 实例：
```
function fwrite(fmt, ...)  ---> 固定的参数fmt
    return io.write(string.format(fmt, ...))    
end

fwrite("runoob\n")       --->fmt = "runoob", 没有变长参数。  
fwrite("%d%d\n", 1, 2)   --->fmt = "%d%d", 变长参数为 1 和 2
```

----------------------------------------------------------------

- 通常在遍历变长参数的时候只需要使用 {…}，然而变长参数`可能会包含一些 nil`，那么就可以用 select 函数来访问变长参数了：`select('#', …) 或者 select(n, …)`

- `select('#', …)`：返回`可变参数的长度`。
- `select(n, …)`：用于返回`从起点 n 开始`到`结束`位置的`所有参数`列表。
- 实例：
```
do  
    function foo(...)  
        for i = 1, select('#', ...) do  -->获取参数总数
            local arg = select(i, ...); -->读取参数，arg 对应的是从i开始到结束的第一个参数
            print("arg", arg);  
        end  
    end  
 
    foo(1, 2, 3, 4);  
end
```
- 结果：
```
arg    1
arg    2
arg    3
arg    4
```

================================================================

## 运算符
### 运算符是一个特殊的符号，用于告诉解释器执行特定的数学或逻辑运算。Lua提供了以下几种运算符类型：
### 1、算术运算符：
下表列出了 Lua 语言中的常用算术运算符，设定 A 的值为10，B 的值为 20：
```
操作符	描述	实例
+	    加法	A + B 输出结果 30
-	    减法	A - B 输出结果 -10
*	    乘法	A * B 输出结果 200
/	    除法	B / A 输出结果 2
%	    取余	B % A 输出结果 0
^	    乘幂	A^2 输出结果 100
-	    负号	-A 输出结果 -10
//	整除运算符(>=lua5.3)	5//2 输出结果 2
```

### 2、关系运算符：
下表列出了 Lua 语言中的常用关系运算符，设定 A 的值为10，B 的值为 20：
```

操作符	            描述	                              
==	    等于，检测两个值是否相等，相等返回 true，否则返回 false	
~=	    不等于，检测两个值是否相等，不相等返回 true，否则返回 false	
>	    大于，如果左边的值大于右边的值，返回 true，否则返回 false	
<	    小于，如果左边的值大于右边的值，返回 false，否则返回 true	
>=	    大于等于，如果左边的值大于等于右边的值，返回 true，否则返回 false	
<=	    小于等于， 如果左边的值小于等于右边的值，返回 true，否则返回 false	
```

### 3、逻辑运算符:
下表列出了 Lua 语言中的常用逻辑运算符，设定 A 的值为 true，B 的值为 false：
```

操作符	                        描述	                                            实例
and	        逻辑与操作符。 若 A 为 false，则返回 A，否则返回 B。	            (A and B) 为 false。
or	        逻辑或操作符。 若 A 为 true，则返回 A，否则返回 B。	            (A or B) 为 true。
not	        逻辑非操作符。与逻辑运算结果相反，如果条件为 true，逻辑非为 false。 	not(A and B) 为 true。
```

### 4、其他运算符：
下表列出了 Lua 语言中的连接运算符与计算表或字符串长度的运算符：：
```
操作符	        描述	                   实例
..	   连接两个字符串	            a..b ，其中 a 为 "Hello " ， b 为 "World", 输出结果为 "Hello World"。
#	   一元运算符，返回字符串或表的长度。	    #"Hello" 返回 5
```

### 5、运算符优先级：
- 从`高到低`的顺序：:
```
^
not    - (unary)
*      /       %
+      -
..
<      >      <=     >=     ~=     ==
and
or
```

================================================================

## 字符串：
### 概念：
- 字符串或串(String)是由数字、字母、下划线组成的一串字符。
- Lua 语言中字符串可以使用以下三种方式来表示：
    - 单引号间的一串字符。
    - 双引号间的一串字符。
    - [[ 与 ]] 间的一串字符。

### 转义字符：
- 转义字符用于表示不能直接显示的字符，比如后退键，回车键，等。如在字符串转换双引号可以使用 "\""。
- 所有的转义字符和所对应的意义：  
![](img/%E5%9B%BE%E7%89%8749.png)

### 字符串操作：
#### Lua 提供了很多的方法来支持字符串的操作：
- `string.upper(argument)`：字符串全部转为大写字母。
- `string.lower(argument)`：字符串全部转为小写字母。
- `string.gsub(mainString`,findString,replaceString,num)：
在字符串中替换。
    - mainString 为要操作的字符串， findString 为被替换的字符，replaceString 要替换的字符，num 替换次数（可以忽略，则全部替换），如：
```
string.gsub("aaaa","a","z",3);
zzza    3
```
- `string.find (str, substr, [init, [plain]])`：在一个指定的目标字符串 str 中搜索指定的内容 substr，如果找到了一个匹配的子串，就会返回这个子串的起始索引和结束索引，不存在则返回 nil。
    - init 指定了搜索的起始位置，默认为 1。也可以是一个负数，表示从后往前数的字符个数。  
    - plain 表示是否使用简单模式，默认为 false，true 只做简单的查找子串的操作，false 表示使用使用正则模式匹配。
```
> string.find("Hello Lua user", "Lua", 1) 
7    9
```
- `string.reverse(arg)`：字符串反转
- `string.format(...)`：返回一个类似printf的格式化字符串
```
> string.format("the value is:%d",4)
the value is:4
```
- `string.char(arg) `和` string.byte(arg[,int])`：char 将`整型数字转成字符并连接`， byte `转换字符为整数值`(可以指定某个字符，`默认第一个字符`)。
```
> string.char(97,98,99,100)
abcd
> string.byte("ABCD",4)
68
> string.byte("ABCD")
65
```
- `string.len(arg)`：计算字符串长度。
- `string.rep(string, n)`：返回字符串string的n个拷贝
- `..`：链接两个字符串
- `string.gmatch(str, pattern)`：返回一个迭代器函数，每一次调用这个函数，返回一个在字符串 str 找到的下一个符合 pattern 描述的子串。如果参数 pattern 描述的字符串没有找到，迭代函数返回nil。
```
> for word in string.gmatch("Hello Lua user", "%a+") do print(word) end
Hello
Lua
user
```
- `string.match(str, pattern, init)`：string.match()只寻找源字串str中的`第一个配对`. 参数init可选, 指定搜寻过程的`起点, 默认为1`。
在成功配对时, 函数将返回配对表达式中的所有捕获结果; 如果没有设置捕获标记, 则返回整个配对字符串。当没有成功的配对时, 返回nil。
```
> = string.match("I have 2 questions for you.", "%d+ %a+")
2 questions

> = string.format("%d, %q", string.match("I have 2 questions for you.", "(%d+) (%a+)"))
2, "questions"
```

------------------------------------------------------------------------------------------------

### 字符串截取：
- `string.sub()` 用于截取字符串，原型为：
```
string.sub(s, i [, j])
```
- 参数说明：
    - s：要截取的字符串。
    - i：截取开始位置。
    - j：截取结束位置，默认为 -1，最后一个字符。

- 实例：
```
local sourcestr = "prefix--runoobgoogletaobao--suffix"
local first_sub = string.sub(sourcestr, 2, 6)
local second_sub = string.sub(sourcestr, 7)  -->结尾默认为最后一个字符
local third_sub = string.sub(sourcestr, -10) -->当i为负数时，代表从后往前的第|i|个位置开始
print("str = " .. sourcestr)
print("first = " .. first_sub .. "\n" .. "second = " .. second_sub .. "\n" .. "third = " .. third_sub .. "\n" )

```

------------------------------------------------------------------------------------------------

### 字符串格式化：
- Lua 提供了 `string.format()` 函数来生成具有特定格式的字符串, 函数的第一个参数是格式 , 之后是对应格式中每个代号的各种数据。

- 由于格式字符串的存在, 使得产生的长字符串可读性大大提高了。这个函数的格式`很像 C 语言中的 printf()`。

- 以下实例演示了如何对字符串进行格式化操作：

- 格式字符串可能包含以下的转义码:
    - %c - 接受一个数字, 并将其转化为ASCII码表中对应的字符
    - %d, %i - 接受一个数字并将其转化为有符号的整数格式
    - %o - 接受一个数字并将其转化为八进制数格式
    - %u - 接受一个数字并将其转化为无符号整数格式
    - %x - 接受一个数字并将其转化为十六进制数格式, 使用小写字母
    - %X - 接受一个数字并将其转化为十六进制数格式, 使用大写字母
    - %e - 接受一个数字并将其转化为科学记数法格式, 使用小写字母e
    - %E - 接受一个数字并将其转化为科学记数法格式, 使用大写字母E
    - %f - 接受一个数字并将其转化为浮点数格式
    - %g(%G) - 接受一个数字并将其转化为%e(%E, 对应%G)及%f中较短的一种格式
    - %q - 接受一个字符串并将其转化为可安全被Lua编译器读入的格式
    - %s - 接受一个字符串并按照给定的参数格式化该字符串
- 为进一步细化格式, 可以在%号后添加参数. 参数将以如下的顺序读入:
    - (1) 符号: 一个+号表示其后的数字转义符将让正数显示正号. 默认情况下只有负数显示符号.
    - (2) 占位符: 一个0, 在后面指定了字串宽度时占位用. 不填时的默认占位符是空格.
    - (3) 对齐标识: 在指定了字串宽度时, 默认为右对齐, 增加-号可以改为左对齐.
    - (4) 宽度数值
    - (5) 小数位数/字串裁切: 在宽度数值后增加的小数部分n, 若后接f(浮点数转义符, 如%6.3f)则设定该浮点数的小数只保留n位, 若后接s(字符串转义符, 如%5.3s)则设定该字符串只显示前n位.

- 实例：
```
local sourcestr = "prefix--runoobgoogletaobao--suffix"
local first_sub = string.sub(sourcestr, 2, 6)
local second_sub = string.sub(sourcestr, 7)  -->结尾默认为最后一个字符
local third_sub = string.sub(sourcestr, -10) -->当i为负数时，代表从后往前的第|i|个位置开始
print(string.format("firts = %s, secon = %s, third = %s\n", first_sub, second_sub, third_sub))
```

------------------------------------------------------------------------------------------------

### 匹配模式：
- Lua 中的匹配模式直接用常规的字符串来描述。 它用于模式匹配函数 `string.find, string.gmatch, string.gsub, string.match`。
- 你还可以在`模式串`中`使用字符类`。
- `字符类`指`可以匹配一个特定字符集合内任何字符的模式项`。比如，字符类 %d 匹配任意数字。所以你可以使用模式串 %d%d/%d%d/%d%d%d%d 搜索 dd/mm/yyyy 格式的日期：

- 实例：
```
s = "Deadline is 30/05/1999, firm"
date = "%d%d/%d%d/%d%d%d%d"
print(string.sub(s, string.find(s, date)))    --> 30/05/1999
```

- 下面的表列出了`Lua支持的所有字符类(重要)`：
    - 单个字符(除 ^$()%.[]*+-? 外): 与该字符自身配对
    - .(点): 与任何字符配对
    - %a: 与任何字母配对
    - %c: 与任何控制符配对(例如\n)
    - %d: 与任何数字配对
    - %l: 与任何小写字母配对
    - %p: 与任何标点(punctuation)配对
    - %s: 与空白字符配对
    - %u: 与任何大写字母配对
    - %w: 与任何字母/数字配对
    - %x: 与任何十六进制数配对
    - %z: 与任何代表0的字符配对
    - %x(此处x是非字母非数字字符): 与字符x配对. 主要用来处理表达式中有功能的字符(^$()%.[]*+-?)的配对问题, 例如%%与%配对
    [数个字符类]: 与任何[]中包含的字符类配对. 例如[%w_]与任何字母/数字, 或下划线符号(_)配对
    [^数个字符类]: 与任何不包含在[]中的字符类配对. 例如[^%s]与任何非空白字符配对
- 当上述的字符类用`大写书写`时, 表示与`非此字符类的任何字符`配对

================================================================================================

## 数组:
- 数组，就是`相同数据类型`的元素按一定顺序排列的集合，可以是一维数组和多维数组。
- Lua 数组的`索引`键值（`从1开始`）可以使用整数表示，数组的`大小不是固定的`。

### 一维数组:
```
array = {"Lua", "Tutorial"}

for i= 0, 2 do
   print(array[i])
end
```
输出为：
```
nil
Lua
Tutorial
```

- 除此外我们还可以以负数为数组索引值：
```
array = {}

for i= -2, 2 do
   array[i] = i *2
end

for i = -2,2 do
   print(array[i])
end
```
输出为：
```
-4
-2
0
2
4
```

### 多维数组:
- 多维数组即数组中包含数组或`一维数组的索引键对应一个数组`。

```
-- 初始化数组
array = {}
for i=1,3 do
   array[i] = {}
      for j=1,3 do
         array[i][j] = i*j
      end
end

-- 访问数组
for i=1,3 do
   for j=1,3 do
      print(array[i][j])
   end
end
```
输出：
```
1
2
3
2
4
6
3
6
9
```

================================================================================================

## 迭代器:
- 迭代器（iterator）是`一种对象`，它能够用来`遍历`标准模板库容器中的部分或全部元素，`每个迭代器对象代表`容器中的`确定的地址`。

- 在 Lua 中迭代器是一种`支持指针类型的结构`，它`可以遍历集合的每一个元素`。

--------------------------------------------------------------------------------

### 泛型 for 迭代器:
- 泛型 for `在`自己`内部保存迭代函数`，实际上它保存三个值：迭代函数、状态常量、控制变量。
- 泛型 for 迭代器提供了集合的 key/value 对，语法格式如下：
```
array = {"Google", "Runoob"}

for key,value in ipairs(array)
do
   print(key, value)
end
```
输出为：
```
Google
Runoob
```

- 以上实例中我们使用了 Lua `默认提供的迭代函数 ipairs`。

--------------------------------------------------------------------------------

### 泛型 for 的执行过程：
- 首先，初始化，`计算 in 后面表达式的值`，`表达式`应该`返回`泛型 for 需要的三个值：`迭代函数、状态常量、控制变量`；与多值赋值一样，如果`表达式返回的结果个数不足三个`会`自动用 nil 补足`，多出部分会被忽略。
- 第二，将状态常量和控制变量作为参数调用迭代函数（注意：对于 for 结构来说，`状态常量`没有用处，仅仅在`初始化时获取他的值`并`传递给迭代函数`）。
- 第三，将迭代函数返回的值赋给变量列表。
- 第四，如果返`回的第一个值为nil循环结束`，否则执行循环体。
- 第五，回到第二步`再次调用迭代函数`

--------------------------------------------------------------------------------

### 迭代器的类型：
- 在Lua中我们常常使用函数来描述迭代器，每次调用该函数就返回集合的下一个元素。Lua 的迭代器包含以下两种类型：
    - 无状态的迭代器
    - 多状态的迭代器

#### 无状态的迭代器
- 无状态的迭代器是指`不保留任何状态`的迭代器，因此在循环中我们可以利用无状态迭代器`避免创建闭包花费额外的代价`。
- 每一次迭代，迭代函数都是`用两个变量（状态常量和控制变量）的值作为参数`被调用，一个无状态的迭代器只`利用这两个值`可以`获取下一个元素`。
- 这种无状态迭代器的`典型`的简单的`例子是 ipairs`，它遍历数组的每一个元素，`元素的索引需要是数值`。
- 以下实例我们使用了一个简单的函数来实现迭代器，实现 数字 n 的平方：
```
function square(iteratorMaxCount,currentNumber)
   if currentNumber<iteratorMaxCount
   then
      currentNumber = currentNumber+1
   return currentNumber, currentNumber*currentNumber
   end
end

for i,n in square,3,0
do
   print(i,n)
end
```
输出为：
```
1    1
2    4
3    9
```

#### 多状态的迭代器:
- 很多情况下，`迭代器需要保存多个状态信息`而不是简单的状态常量和控制变量，最简单的方法是`使用闭包`，还有一种方法就是`将所有的状态信息封装到 table 内`，将 table 作为迭代器的状态常量，因为这种情况下可以将所有的信息存放在 table 内，所以迭代函数通常不需要第二个参数。

- 以下实例我们创建了自己的迭代器：
```
array = {"Google", "Runoob"}

function elementIterator (collection)
   local index = 0
   local count = #collection
   -- 闭包函数
   return function ()
      index = index + 1
      if index <= count
      then
         --  返回迭代器的当前元素
         return collection[index]
      end
   end
end

for element in elementIterator(array)
do
   print(element)
end
```
输出：
```
Google
Runoob
```

====================================================================

## table(表):
- table 是 Lua 的一种数据结构用来帮助我们`创建不同的数据类型，如：数组、字典等`。
- Lua table 使用`关联型数组`，你可以用任意类型的值来作数组的索引，但这个值不能是 nil。
- Lua table 是`不固定大小`的，你可以根据自己需要进行扩容。
- Lua也是`通过table来解决模块（module）、包（package）和对象（Object）`的。 例如string.format表示使用"format"来索引table string。

----------------------------------------------------------------

### table(表)的构造:
- `构造器是创建和初始化表的表达式`。表是Lua特有的功能强大的东西。最简单的构造函数是{}，用来创建一个空表。可以直接初始化数组:
```
-- 初始化表
mytable = {}

-- 指定值
mytable[1]= "Lua"

-- 移除引用
mytable = nil
-- lua 垃圾回收会释放内存
```

- 当我们为 table a 并设置元素，然后将 a 赋值给 b，`则 a 与 b 都指向同一个内存`。如果 a 设置为 nil ，则 b 同样能访问 table 的元素。如果`没有指定的变量指向a`，Lua的垃圾回收机制会`清理相对应的内存`。

```
-- 简单的 table
mytable = {}
print("mytable 的类型是 ",type(mytable))

mytable[1]= "Lua"
mytable["wow"] = "修改前"
print("mytable 索引为 1 的元素是 ", mytable[1])
print("mytable 索引为 wow 的元素是 ", mytable["wow"])

-- alternatetable和mytable的是指同一个 table
alternatetable = mytable

print("alternatetable 索引为 1 的元素是 ", alternatetable[1])
print("mytable 索引为 wow 的元素是 ", alternatetable["wow"])

alternatetable["wow"] = "修改后"

print("mytable 索引为 wow 的元素是 ", mytable["wow"])

-- 释放变量
alternatetable = nil
print("alternatetable 是 ", alternatetable)

-- mytable 仍然可以访问
print("mytable 索引为 wow 的元素是 ", mytable["wow"])

mytable = nil
print("mytable 是 ", mytable)
```
结果：
```
mytable 的类型是     table
mytable 索引为 1 的元素是     Lua
mytable 索引为 wow 的元素是     修改前
alternatetable 索引为 1 的元素是     Lua
mytable 索引为 wow 的元素是     修改前
mytable 索引为 wow 的元素是     修改后
alternatetable 是     nil
mytable 索引为 wow 的元素是     修改后
mytable 是     nil
```

----------------------------------------------------------------

### Table 操作：
- Table 操作常用的方法：
    - 1、`table.concat (table [, sep [, start [, end]]])`：concat是concatenate(连锁, 连接)的缩写. table.concat()函数列出参数中指定table的数组部分从start位置到end位置的所有元素, 元素间`以指定的分隔符(sep)隔开`。
    - 2、`table.insert (table, [pos,] value)`：在table的数组部分`指定位置(pos`)插入`值为value`的一个元素. pos参数可选, `默认为数组部分末尾`。
    - 3、`table.remove (table [, pos])`：`返回`table数组部分`位于pos位置的元素`。`其后的元素会被前移`。pos参数可选, 默认为table长度, 即从最后一个元素删起。
    - 4、`table.sort (table [, comp])`：对给定的table进行`升序`排序。

-------------------------------------------------------------- 

- table.concat实例：
```
fruits = {"banana","orange","apple"}
-- 返回 table 连接后的字符串
print("连接后的字符串 ",table.concat(fruits))

-- 指定连接字符
print("连接后的字符串 ",table.concat(fruits,", "))

-- 指定索引来连接 table
print("连接后的字符串 ",table.concat(fruits,", ", 2,3))
```
结果：
```
连接后的字符串     bananaorangeapple
连接后的字符串     banana, orange, apple
连接后的字符串     orange, apple
```

-------------------------------------------------------------- 


- table.insert 和 table.remove实例：
```
fruits = {"banana","orange","apple"}

-- 在末尾插入
table.insert(fruits,"mango")
print("索引为 4 的元素为 ",fruits[4])

-- 在索引为 2 的键处插入
table.insert(fruits,2,"grapes")
print("索引为 2 的元素为 ",fruits[2])

print("最后一个元素为 ",fruits[5])
table.remove(fruits)
print("移除后最后一个元素为 ",fruits[5])
```
结果：
```
索引为 4 的元素为     mango
索引为 2 的元素为     grapes
最后一个元素为     mango
移除后最后一个元素为     nil
```

-------------------------------------------------------------- 


- table.sort实例：
```
fruits = {"banana","orange","apple","grapes"}
print("排序前")
for k,v in ipairs(fruits) do
        print(k,v)
end

table.sort(fruits)
print("排序后")
for k,v in ipairs(fruits) do
        print(k,v)
end
```
结果：
```
排序前
1    banana
2    orange
3    apple
4    grapes
排序后
1    apple
2    banana
3    grapes
4    orange
```

================================================================

## 模块与包:
- `模块类似于一个封装库`，从 Lua 5.1 开始，Lua 加入了标准的模块管理机制，可以`把一些公用的代码放在一个文件`里，以 `API 接口的形式`在其他地方`调用`，有利于`代码的重用`和`降低代码耦合`度。

- Lua 的模块是由`变量、函数`等已知元素`组成的 table`，因此`创建一个模块`很简单，`就是创建一个 table`，然后`把需要导出的常量、函数放入其中`，`最后返回这个 table `就行。以下为创建自定义模块 module.lua，文件代码格式如下：
```
-- 文件名为 module.lua
-- 定义一个名为 module 的模块
module = {}
 
-- 定义一个常量
module.constant = "这是一个常量"
 
-- 定义一个函数
function module.func1()
    io.write("这是一个公有函数！\n")
end
 
local function func2()
    print("这是一个私有函数！")
end
 
function module.func3()
    func2()
end
 
return module
```
- 由上可知，`模块的结构就是一个 table 的结构`，因此可以`像操作调用 table 里的元素那样来操作调用模块里的常量或函数`。

- 上面的 func2 声明为程序块的`局部变`量，即`表示一个私有函数`，因此是不能从外部访问模块里的这个私有函数，`必须通过`模块里的`公有函数`来`调用`.

--------------------------------------------------------------

### require 函数:
- Lua提供了一个名为`require的函数用来加载模块`。要加载一个模块，只需要简单地调用就可以了。例如：
```
require("<模块名>")
require "<模块名>"
```
- 执行 require 后会`返回一个由模块常量或函数组成的 table`，并且还会`定义一个包含该 table 的全局变量`。
```
-- test_module.lua 文件
-- module 模块为上文提到到 module.lua
require("module")
 
print(module.constant)
 
module.func3()
```
输出：
```
这是一个常量
这是一个私有函数！
```
- 或者给加载的模块定义一个别名变量，方便调用：
```
-- test_module2.lua 文件
-- module 模块为上文提到到 module.lua
-- 别名变量 m
local m = require("module")
 
print(m.constant)
 
m.func3()
```

--------------------------------------------------------------

### 加载机制:
- 对于自定义的模块，模块文件不是放在哪个文件目录都行，`函数 require 有它自己的文件路径加载策略`，它`会尝试从 Lua 文件或 C 程序库中加载模块`。

- require 用于`搜索` Lua 文件的`路径`是存`放在全局变量 package.path 中`，当 Lua 启动后，会`以环境变量 LUA_PATH 的值`来`初始这个环境变量`。如果没有找到该环境变量，则使用一个编译时定义的默认路径来初始化。

- 当然，如果`没有 LUA_PATH `这个环境变量，也可以自定义设置，在当前用户`根目录下`打开 `.profile 文件`（没有则创建，打开` .bashrc 文件也可以`），例如`把 "~/lua/" 路径加入 LUA_PATH 环境变量`里：
```
#LUA_PATH
export LUA_PATH="~/lua/?.lua;;"
```
- 文件路径以 ";" 号分隔，最后的 2 个 ";;" 表示新加的路径后面加上原来的默认路径。
- 接着，更新环境变量参数，使之立即生效。
```
source ~/.profile
```
- 假设 package.path 的值是：
```
/Users/dengjoe/lua/?.lua;./?.lua;/usr/local/share/lua/5.1/?.lua;/usr/local/share/lua/5.1/?/init.lua;/usr/local/lib/lua/5.1/?.lua;/usr/local/lib/lua/5.1/?/init.lua
```
- 那么调用 require("module") 时就会尝试打开以下文件目录去搜索目标。
```
/Users/dengjoe/lua/module.lua;
./module.lua
/usr/local/share/lua/5.1/module.lua
/usr/local/share/lua/5.1/module/init.lua
/usr/local/lib/lua/5.1/module.lua
/usr/local/lib/lua/5.1/module/init.lua
```
- 如果`找过目标文件`，则会调用 `package.loadfile` 来加载模块。否则，就会`去找 C 程序库`。
- 搜索的文件路径是`从全局变量 package.cpath 获取`，而这个变量则是`通过环境变量 LUA_CPATH 来初始`。
- 搜索的策略跟上面的一样，只不过现在换成搜索的是 so 或 dll 类型的文件。如果找得到，那么 require 就会通过 package.loadlib 来加载它。

--------------------------------------------------------------

### C 包:
- Lua和C是很容易结合的，`使用 C 为 Lua 写包`。
- 与Lua中写包不同，C包在`使用以前必须首先加载并连接`，在`大多数`系统中最容易的实现方式是`通过动态连接库机制`。
- Lua在一个叫`loadlib`的函数内`提供了所有的动态连接的功能`。这个函数有`两个参数`:`库的绝对路径`和`初始化函数`。所以典型的调用的例子如下:
```
local path = "/usr/local/lua/lib/libluasocket.so"
local f = loadlib(path, "luaopen_socket")
```
- loadlib 函数加载指定的库并且连接到 Lua，然而它`并不打开库`（也就是说没有调用初始化函数），反之他`返回初始化函数作为 Lua 的一个函数`，这样我们就可`以直接在Lua中调用他`。
- 如果`加载动态库或者查找初始化函数时出错`，loadlib `将返回 nil 和错误信息`。我们可以修改前面一段代码，使其检测错误然后调用初始化函数：
```
local path = "/usr/local/lua/lib/libluasocket.so"
-- 或者 path = "C:\\windows\\luasocket.dll"，这是 Window 平台下
local f = assert(loadlib(path, "luaopen_socket"))
f()  -- 真正打开库
```
- 一般情况下我们期望二进制的发布库包含一个与前面代码段相似的 stub 文件，安装二进制库的时候可以随便放在某个目录，只需要修改 stub 文件对应二进制库的实际路径即可。
- 将 stub 文件所在的目录加入到 LUA_PATH，这样设定后就可以使用 require 函数加载 C 库了。

===================================================================================================

##  元表(Metatable):
- 在 Lua table 中我们可以访问对应的 key 来得到 value 值，但是却无法对两个 table 进行操作(比如相加)。
- 因此 Lua 提供了`元表(Metatable)`，`允许`我们`改变 table 的行为`，`每个行为关联`了对应的`元方法`。
- 例如，使用元表我们可以定义 Lua 如何计算两个 table 的相加操作 a+b。

- 当 Lua 试图对两个表进行相加时，先检查`两者之一`是否有元表，之后检查是否有一个叫` __add `的字段，若`找到`，则`调用对应的值`。 __add 等`即时字段`，其`对应的值`（往往是`一个函数`或是 `table`）就是`"元方法"`。
- 有两个很重要的函数来处理元表：  
    -` setmetatable(table,metatable)`: 对指定 table `设置元表`(metatable)，如果元表(metatable)中`存在 __metatable 键值`，setmetatable 会`失败`。  
    -` getmetatable(table)`: `返回`对象的元表(metatable)。

- 以下实例演示了如何对指定的表设置元表：
```
mytable = {}                          -- 普通表
mymetatable = {}                      -- 元表
setmetatable(mytable,mymetatable)     -- 把 mymetatable 设为 mytable 的元表

getmetatable(mytable)                 -- 这会返回 mymetatable
```

---------------------------------

### __index 元方法:
- 这是 `metatable 最常用的键`。
- 当你`通过键`来访问 table 的时候，如果这个`键没有值`，那么Lua就`会寻找该table的metatable（假定有metatable）中的__index 键`。如果__index包含一个表格，Lua会在表格中查找相应的键。
- 实例：
```
> other = { foo = 3 }
> t = setmetatable({}, { __index = other })
> t.foo
3
> t.bar
nil
```

- 如果`__index包含一个函数`的话，Lua就会`调用那个函数`，`table`和`键`会作为`参数`传递给函数。
- __index 元方法`查看表中元素是否存在`，如果`不存在`，返回结果为 `nil`；如果`存在`则`由 __index 返回结果`:
```
mytable = setmetatable({key1 = "value1"}, {
  __index = function(mytable, key)
    if key == "key2" then
      return "metatablevalue"
    else
      return nil
    end
  end
})

print(mytable.key1,mytable.key2)
```
- 输出结果为：
```
value1    metatablevalue
```

---------------------------------

### 查表元素的流程总结:
- Lua 查找一个表元素时的规则，其实就是如下 3 个步骤:
    - 1.`在表中查找`，如果找到，返回该元素，找不到则继续
    - 2.判断该表`是否有元表`，如果`没有元表`，返回 `nil`，`有元表`则`继续`。
    - 3.判断元表`有没有 __index 方法`，如果 `__index 方法`为 `nil`，则返回` nil`；如果 `__index` 方法`是一个表`，则`重复 1、2、3`；如果 `__index 方法`是`一个函数`，则返回`该函数的返回值`。

---------------------------------

### __newindex 元方法:
- `__newindex` 元方法用来`对表更新`，`__index`则用来`对表访问` 。
- 当你`给表的一个缺少的索引赋值`，解释器就会`查找__newindex 元方法`：如果`存在`则`调用`这个`函数`而`不进行赋值操作`。
- 以下实例演示了 __newindex 元方法的应用：
```
mymetatable = {}
mytable = setmetatable({key1 = "value1"}, { __newindex = mymetatable })

print(mytable.key1)

mytable.newkey = "新值2"
print(mytable.newkey,mymetatable.newkey)

mytable.key1 = "新值1"
print(mytable.key1,mymetatable.key1)
```
输出：
```
value1
nil    新值2
新值1    nil
```
- 以上实例中表设置了元方法 __newindex，在`对新索引键（newkey）赋值`时（mytable.newkey = "新值2"），会`调用元方法`，而`不进行赋值`。而如果对`已存在的索引键`（key1），则`会进行赋值`，而`不调用元方法 __newindex`。

---------------------------------

### 为表添加操作符:
- 以下实例演示了两表相加操作：
```
-- 计算表中最大值，table.maxn在Lua5.2以上版本中已无法使用
-- 自定义计算表中最大键值函数 table_maxn，即返回表最大键值
function table_maxn(t)
    local mn = 0
    for k, v in pairs(t) do
        if mn < k then
            mn = k
        end
    end
    return mn
end

-- 两表相加操作
mytable = setmetatable({ 1, 2, 3 }, {
  __add = function(mytable, newtable)
    for i = 1, table_maxn(newtable) do
      table.insert(mytable, table_maxn(mytable)+1,newtable[i])
    end
    return mytable
  end
})

secondtable = {4,5,6}

mytable = mytable + secondtable
        for k,v in ipairs(mytable) do
print(k,v)
end
```
- 输出结果为：
```
1    1
2    2
3    3
4    4
5    5
6    6
```
---------------------------------
#### 表中对应的操作列表如下：
```
模式	        描述
__add	    对应的运算符 '+'.
__sub	    对应的运算符 '-'.
__mul	    对应的运算符 '*'.
__div	    对应的运算符 '/'.
__mod	    对应的运算符 '%'.
__unm	    对应的运算符 '-'.
__concat	对应的运算符 '..'.
__eq	    对应的运算符 '=='.
__lt	    对应的运算符 '<'.
__le	    对应的运算符 '<='.
```

---------------------------------

### __call 元方法：
- __call 元方法`在 Lua 调用一个值时调用`。以下实例演示了计算表中元素的和：
```
-- 计算表中最大值，table.maxn在Lua5.2以上版本中已无法使用
-- 自定义计算表中最大键值函数 table_maxn，即计算表的元素个数
function table_maxn(t)
    local mn = 0
    for k, v in pairs(t) do
        if mn < k then
            mn = k
        end
    end
    return mn
end

-- 定义元方法__call
mytable = setmetatable({10}, {
  __call = function(mytable, newtable)
        sum = 0
        for i = 1, table_maxn(mytable) do
                sum = sum + mytable[i]
        end
    for i = 1, table_maxn(newtable) do
                sum = sum + newtable[i]
        end
        return sum
  end
})
newtable = {10,20,30}
print(mytable(newtable))
```
- 输出结果为:
```
70
```

---------------------------------

### __tostring 元方法:
- __tostring 元方法用于`修改表的输出行为`。以下实例我们自定义了表的输出内容：
```
mytable = setmetatable({ 10, 20, 30 }, {
  __tostring = function(mytable)
    sum = 0
    for k, v in pairs(mytable) do
                sum = sum + v
        end
    return "表所有元素的和为 " .. sum
  end
})
print(mytable)
```
- 输出结果为：
```
表所有元素的和为 60
```

### 总结：
- 元表可以很好的`简化我们的代码功能`，所以了解 Lua 的元表，可以让我们写出更加简单优秀的 Lua 代码。


===============================================================================

## 文件 I/O：
- Lua I/O 库用于读取和处理文件。分为`简单模式`（和C一样）、`完全模式`。
    - 简单模式（simple model）拥有`一个当前输入`文件和`一个当前输出`文件，并且提供针对这些文件相关的操作。
    - 完全模式（complete model） 使用`外部`的`文件句柄`来实现。它以一种`面对对象`的形式，将所有的文件操作定义为文件句柄的方法
- 简单模式在做一些简单的文件操作时较为合适。但是在进行一些高级的文件操作的时候，简单模式就显得力不从心。例如`同时读取多个文件`这样的操作，`使用完全模式`则较为合适。

----------------------------------------------------------------

### 打开文件操作：
```
file = io.open (filename [, mode])

mode 的值有：
    r	以只读方式打开文件，该文件必须存在。
    w	打开只写文件，若文件存在则文件长度清为0，即该文件内容会消失。若文件不存在则建立该文件。
    a	以附加的方式打开只写文件。若文件不存在，则会建立该文件，如果文件存在，写入的数据会被加到文件尾，即文件原先的内容会被保留。（EOF符保留）
    r+	以可读写方式打开文件，该文件必须存在。
    w+	打开可读写文件，若文件存在则文件长度清为零，即该文件内容会消失。若文件不存在则建立该文件。
    a+	与a类似，但此文件可读可写
    b	二进制模式，如果文件是二进制文件，可以加上b
    +	号表示对文件既可以读也可以写
```

----------------------------------------------------------------

### 简单模式:
- 简单模式使用`标准的 I/O `或使用一个当前输入文件和一个当前输出文件。
- 以下为 file.lua 文件代码，操作的文件为test.lua(如果没有你需要创建该文件)，代码如下：
```
-- 以只读方式打开文件
file = io.open("test.lua", "r")

-- 设置默认输入文件为 test.lua
io.input(file)

-- 输出文件第一行
print(io.read())

-- 关闭打开的文件
io.close(file)

-- 以附加的方式打开只写文件
file = io.open("test.lua", "a")

-- 设置默认输出文件为 test.lua
io.output(file)

-- 在文件最后一行添加 Lua 注释
io.write("--  test.lua 文件末尾注释")

-- 关闭打开的文件
io.close(file)
```
- 执行以上代码，你会发现，输出了 test.lua 文件的第一行信息，并在该文件最后一行添加了 lua 的注释。
- 在以上实例中我们使用了 io."x" 方法，其中 `io.read() `中我们没有带参数，`参数`可以是下表中的一个：
```
"*n"	读取一个数字并返回它。例：file.read("*n")
"*a"	从当前位置读取整个文件。例：file.read("*a")
"*l"（默认）	读取下一行，在文件尾 (EOF) 处返回 nil。例：file.read("*l")
number	返回一个指定字符个数的字符串，或在 EOF 时返回 nil。例：file.read(5)
```
- 其他的 `io 方法`有：
    - `io.tmpfile()`:返回一个临时文件句柄，该文件以更新模式打开，程序结束时自动删除
    - `io.type(file)`: 检测obj是否一个可用的文件句柄
    - `io.flush()`: 向文件写入缓冲中的所有数据
    - `io.lines(optional file name)`: 返回一个迭代函数，每次调用将获得文件中的一行内容，当到文件尾时，将返回 nil，但不关闭文件。

----------------------------------------------------------------

### 完全模式:
- 通常我们需要`在同一时间处理多个文件`。我们需要`使用 file:function_name` 来`代替` `io.function_name `方法。以下实例演示了如何同时处理同一个文件:
```
-- 以只读方式打开文件
file = io.open("test.lua", "r")

-- 输出文件第一行
print(file:read())

-- 关闭打开的文件
file:close()

-- 以附加的方式打开只写文件
file = io.open("test.lua", "a")

-- 在文件最后一行添加 Lua 注释
file:write("--test")

-- 关闭打开的文件
file:close()
```
- `read 的参数与简单模式一致`。
- 其他方法:
    - `file:seek(optional whence, optional offset)`:` 设置和获取当前文件位置`,`成功`则`返回最终的文件位置`(按字节),`失败`则`返回nil`加错误信息。参数 whence 值可以是:
        - "set": 从文件`头`开始
        - "cur": 从`当前位置`开始[默认]
        - "end": 从文件`尾`开始
        - offset:默认为0
    - `file:flush()`: 向文件写入`缓冲`中的`所有数据`
    - `io.lines(optional file name)`: 打开指定的文件 filename 为`读模式`并返回一个`迭代函数`，`每次调用`将获得文件中的`一行内容`，当到`文件尾`时，将`返回 nil`，并`自动关闭`文件。
        - 若`不带参数时`io.lines() <=> io.input():lines(); `读取默认输入设备`的内容，但结束时不关闭文件，如：
```
for line in io.lines("main.lua") do

　　print(line)

　　end
```
- 以下实例使用了 seek 方法，定位到文件倒数第 25 个位置并使用 read 方法的 *a 参数，即从当前位置(倒数第 25 个位置)读取整个文件。
```
-- 以只读方式打开文件
file = io.open("test.lua", "r")

file:seek("end",-25)
print(file:read("*a"))

-- 关闭打开的文件
file:close()
```

===============================================================================

## 协同程序(coroutine):
### 什么是协同(coroutine)？
- Lua 协同程序(coroutine)`与线程`比较`类似`：`拥有独立的堆栈，独立的局部变量，独立的指令指针`，同时又`与其它协同程序共享全局变量`和其它大部分东西。
- 协同是非常强大的功能，但是用起来也很复杂。

----------------------------------------------------------------

### 线程和协同程序区别:
- 线程与协同程序的`主要区别`在于，一个`具有多个线程的程序可以同时运行几个线程`，而`协同程序`却`需要彼此协作的运行`。
- 在`任一指定时刻只有一个协同程序在运行`，并且这个`正在运行的协同程序`只有在`明确`的`被要求挂起`的时候`才会被挂起`。
- 协同程序有点类似同步的多线程，在等待同一个线程锁的几个线程有点类似协同。

----------------------------------------------------------------

### 基本语法:
- `coroutine.create()`：创建 coroutine，`返回 coroutine`， 参数是一个函数，当和 resume 配合使用的时候就唤醒函数调用
- `coroutine.resume()`：`重启` coroutine，和 create 配合使用
- `coroutine.yield()`：`挂起` coroutine，将 coroutine 设置为挂起状态，这个和 resume 配合使用能有很多有用的效果
- `coroutine.status()`：查看 coroutine 的`状态`
注：coroutine 的状态有三种：`dead，suspended，running`，具体什么时候有这样的状态请参考下面的程序
- `coroutine.wrap()`：创建 coroutine，`返回一个函数`，一旦你调用这个函数，就进入 coroutine，`和 create 功能重复`
- `coroutine.running()`：`返回正在跑的 coroutine`，一个 coroutine 就是一个线程，当使用running的时候，就是返回一个 coroutine 的线程号

- 实例：
```
co1 = coroutine.create(
	function(i)
		print("co1 " ..i)
		print("co1 status = " .. coroutine.status(co1))
	end
)


coroutine.resume(co1, 1)
print("co1 status = " ..  coroutine.status(co1))

print("----------")

function_co1 = coroutine.wrap(
	function(i)
		print("function --- " .. i)
	end
)

function_co1(100)
print("co1 status = " ..  coroutine.status(co1))


print("----------")

co2 = coroutine.create(
	function()
        for i=1,10 do
            print("co2 ---- " .. i)
            if i == 3 then
                print( "co2 status = " .. coroutine.status(co2))  --running
                print(coroutine.running()) --thread:XXXXXX
            end
            coroutine.yield()
        end
    end
)

coroutine.resume(co2)
coroutine.resume(co2)
coroutine.resume(co2)
coroutine.resume(co2)

print("co2 status = " .. coroutine.status(co2))


print("----------")
```

- coroutine.running就可以看出来，`coroutine在底层实现就是一个线程`。
- 当`create`一个coroutine的时候就是`在新线程中注册了一个事件`。
- 当使用`resume`触发事件的时候，`create的coroutine函数就被执行`了，当遇到`yield`的时候就代表`挂起当前线程`，`等候再次resume`触发事件。

- 实例：
```
function foo (a)
    print("foo 函数输出", a)
    return coroutine.yield(2 * a)
end

co = coroutine.create(function (a , b)
    print("第一次协同程序执行输出", a, b)
    local r = foo(a + 1)

    print("第二次协同程序执行输出", r)
    local r, s = coroutine.yield(a + b, a - b)

    print("第三次协同程序执行输出", r, s)
    return b, "结束协同程序"
end)

print("main", coroutine.resume(co, 1, 10))
print("--分割线----")
print("main", coroutine.resume(co, "r"))
print("---分割线---")
print("main", coroutine.resume(co, "x", "y"))
print("---分割线---")
print("main", coroutine.resume(co, "x", "y"))
print("---分割线---")
```
- 输出：
```
第一次协同程序执行输出    1    10
foo 函数输出    2
main    true    4
--分割线----
第二次协同程序执行输出    r
main    true    11    -9
---分割线---
第三次协同程序执行输出    x    y
main    true    10    结束协同程序
---分割线---
main    false    cannot resume dead coroutine
---分割线---
```
- 以上实例过程如下：
    - 调用resume，将协同程序唤醒,resume操作成功返回true，否则返回false；
    - 协同程序运行；
    - 运行到`yield语句`；
    - `yield挂起`协同程序，第一次resume返回；（注意：此处yield返回，参数是resume的参数）
    - 第二次resume，再次唤醒协同程序；（注意：此处resume的参数中，除了第一个参数，剩下的参数将作为yield的参数）
    - yield返回；
    - 协同程序继续运行；
    - 如果使用的协同程序继续运行完成后继续调用 resume方法则输出：cannot resume dead coroutine

- `resume和yield的配合强大之处在于，resume处于主程中，它将外部状态（数据）传入到协同程序内部；而yield则将内部的状态（数据）返回到主程中`。


================================================================================================

# 关于lua的多线程编程问题：
- 在 Lua 中，官方的标准库提供的是`基于协程的轻量级线程`（coroutine），而`不是操作系统级别的多线程`。
- 这意味着 Lua` 并不直接支持`操作系统提供的`真正的多线程`，并不是像Java或C++那样可以直接操作操作系统级别的线程。

## lua协程：
- Lua 的协程（coroutine）是一种`半抢占式`的`用户态线程`，是在程序内部进行调度的`轻量级线程`。协程允许在一段代码`执行到一半时暂停`，并在`需要时恢复执行`，这样可以实现`类似多线程`的`非抢占式并发`执行。

================================================================================================


# lua截取某个字符串之后的内容：
```
    local _, endIndex = string.find(full_ip, "::")
    local ip_m = string.sub(full_ip, endIndex + 1)
```

# lua中，如果想要某个table中的key值为变量，可以如下写：
```
local x = "test"
local t = {
    [x] = "123"
}


这样就相当于：
local t = {
    "test" = "123"
}
```

# `lua中的table作为参数引用后，修改table的值的问题`：
- 下面的两种方式都无法成功改变外部res对象的值。`因为直接对res对象进行赋值操作，相当于创建了一个新的res变量并在函数内部对其进行操作，不影响外部res变量`
- 如果在函数内部`重新对参数绑定了一个新的table`，那么`进行的修改操作就不会影响外部传入的table`
```
比如：
local function update(list)
    list = {
        test1 = "1",
        test2 = "2"
    }
end

或者
local function update(list)
    local tmp_list = {
        test1 = "1",
        test2 = "2"
    }
    list = tmp_list
end
```
- 如果修改操作是`直接对table中的属性进行赋值或添加`，这种操作`会影响到外部的表`，因为`这时的操作是在同一个表上进行`的
- 如果要在函数内修改table的值，需要使用下面这几种方式。
```
table.insert()或者table["test1"] = "1111"或者table.test1 = "111"等方法。
比如：
local function test2(res)
        res.add1 = "11"
        res.add2 = "22"
end

local function test3(res)
        res["add3"] = "33"
        res["add4"] = "44"
end

```