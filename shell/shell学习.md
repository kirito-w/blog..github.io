# Shell
## 概念：
- Shell 是一个用 C 语言编写的`程序`，它是用户使用 Linux 的桥梁。`Shell 既是一种命令语言，又是一种程序设计语言`。
- Shell 是`指一种应用程序`，这个应用程序提供了一个界面，用户通过这个界面`访问操作系统内核的服务`。

## Shell 环境:
- Linux 的 Shell 种类众多，常见的有：
    - Bourne Shell（/usr/bin/sh或/bin/sh）
    - Bourne Again Shell（/bin/bash）
    - C Shell（/usr/bin/csh）
    - K Shell（/usr/bin/ksh）
    - Shell for Root（/sbin/sh）

- 本教程关注的是 `Bash`，也就是 `Bourne Again Shell`，由于易用和免费，Bash 在日常工作中被广泛使用。同时，Bash 也是大多数Linux 系统默认的 Shell。
- 在一般情况下，人们并不区分 Bourne Shell 和 Bourne Again Shell，所以，`像 #!/bin/sh，它同样也可以改为 #!/bin/bash`。
- `#!`——告诉系统其后路径所指定的程序即是`解释此脚本文件的 Shell 程序`。

## Shell 基础：
- `echo` —— 命令用于`向窗口输出文本`。
```
#!/bin/bash
echo "Hello World !"
```

## 运行 Shell 脚本有两种方法：
- 1、作为可执行程序
```
将代码保存为 test.sh，并 cd 到相应目录：

chmod +x ./test.sh  #使脚本具有执行权限
./test.sh  #执行脚本

```
- 2、作为解释器参数
    - 这种方式运行的脚本，`不需要在第一行指定解释器信息，写了也没用`。
```
这种运行方式是，直接运行解释器，其参数就是 shell 脚本的文件名，如：

/bin/sh test.sh
/bin/php test.php
```

## Shell变量：
### 变量使用
- 定义变量(`变量名和等号之间不能有空格`)：
    - 命名只能使用英文字母，数字和下划线，首个字符不能以数字开头。
    - 中间不能有空格，可以使用下划线 _。
    - 不能使用标点符号。
    - 不能使用bash里的关键字（可用help命令查看保留关键字）。
```
your_name="runoob.com"
```
- 使用变量(在变量名前面`加美元符号$`):
    - 变量名外面的花括号是可选的，加不加都行，加花括号是为了帮助解释器识别变量的边界
```
your_name="qinjx"
echo $your_name
echo ${your_name}
```
- 只读变量:
    - 使用 `readonly` 命令可以将变量定义为只读变量，`只读变量的值不能被改变`。
```
#!/bin/bash

myUrl="https://www.google.com"
readonly myUrl
myUrl="https://www.runoob.com"
```

- 删除变量:
    - 使用 unset 命令可以删除变量
```
unset variable_name
```

### 变量类型:
- 1) 局部变量 局部变量在脚本或命令中定义，仅在当前shell实例中有效，其他shell启动的程序不能访问局部变量。
- 2) 环境变量 所有的程序，包括shell启动的程序，都能访问环境变量，有些程序需要环境变量来保证其正常运行。必要的时候shell脚本也可以定义环境变量。
- 3) shell变量 shell变量是由shell程序设置的特殊变量。shell变量中有一部分是环境变量，有一部分是局部变量，这些变量保证了shell的正常运行

### Shell 字符串:
- 字符串可以用单引号，也可以用双引号，也可以不用引号。
- `单引号`字符串的限制：
    - 单引号里的任何字符都会原样输出，单引号字符串中的变量是无效的；
    - 单引号字串中不能出现单独一个的单引号（对单引号使用转义符后也不行），但可成对出现，作为字符串拼接使用。
```
str='this is a string'
```
- `双引号`的优点：
    - 双引号里可以有变量
    - 双引号里可以出现转义字符
```
your_name="runoob"
str="Hello, I know you are \"$your_name\"! \n"
echo -e $str
```
- 拼接字符串:
```
your_name="runoob"
# 使用双引号拼接
greeting="hello, "$your_name" !"
greeting_1="hello, ${your_name} !"
echo $greeting  $greeting_1

# 使用单引号拼接
greeting_2='hello, '$your_name' !'
echo $greeting_2 
```
- 获取字符串长度:
    - 变量为字符串时，${#string} 等价于 ${#string[0]}:
```
string="abcd"
echo ${#string}   # 输出 4
```

- 提取子字符串:
    - 注意：`第一个字符的索引值为 0`。
    - 以下实例从字符串第 2 个字符开始截取 4 个字符：
```
string="runoob is a great site"
echo ${string:1:4} # 输出 unoo
```

- 查找子字符串：
查找字符 i 或 o 的位置(哪个字母`先出现`就计算哪个)：
```
string="runoob is a great site"
echo `expr index "$string" io`  # 输出 4
```
- 注意： 以上脚本中 ` 是反引号，而不是单引号 '，不要看错了哦。

### Shell 数组
- bash`支持一维数组`（不支持多维数组），并且`没有限定数组的大小`。
- 下标由 0 开始编号。
- 定义数组：
```
array_name=(value0 value1 value2 value3)

array_name=(
value0
value1
value2
value3
)

array_name[0]=value0
array_name[1]=value1
array_name[n]=valuen
```
- 读取数组:
    - 使用 `@` 符号可以`获取数组中的所有元素`
```
valuen=${array_name[n]}

echo ${array_name[@]}
```
- 获取数组的长度:
    - 获取数组长度的方法与获取字符串长度的方法相同:
```
# 取得数组元素的个数
length=${#array_name[@]}
# 或者
length=${#array_name[*]}
# 取得数组单个元素的长度
length=${#array_name[n]}
```

#### 关联数组:Bash 支持关联数组，可以`使用任意的字符串、或者整数作为下标`来访问数组元素(map)。
- 关联数组使用 declare 命令来声明，语法格式如下：
```
declare -A array_name
```
- -A 选项就是用于声明一个关联数组。
- 关联数组的`键是唯一的`。

```
声明时赋值
declare -A site=(["google"]="www.google.com" ["runoob"]="www.runoob.com" ["taobao"]="www.taobao.com")
```


```
声明后赋值
declare -A site
site["google"]="www.google.com"
site["runoob"]="www.runoob.com"
site["taobao"]="www.taobao.com"
```

- 以下实例我们通过键来访问关联数组的元素：
```
declare -A site
site["google"]="www.google.com"
site["runoob"]="www.runoob.com"
site["taobao"]="www.taobao.com"

echo ${site["runoob"]}
```

#### 获取数组中的所有元素
- 使用 @ 或 * 可以获取数组中的所有元素，例如：
```
#!/bin/bash
# author:菜鸟教程
# url:www.runoob.com

my_array[0]=A
my_array[1]=B
my_array[2]=C
my_array[3]=D

echo "数组的元素为: ${my_array[*]}"
echo "数组的元素为: ${my_array[@]}"

declare -A site
site["google"]="www.google.com"
site["runoob"]="www.runoob.com"
site["taobao"]="www.taobao.com"

echo "数组的元素为: ${site[*]}"
echo "数组的元素为: ${site[@]}"
```
- 在数组前加一个感叹号 ! 可以获取数组的`所有键`，例如：
```
declare -A site
site["google"]="www.google.com"
site["runoob"]="www.runoob.com"
site["taobao"]="www.taobao.com"

echo "数组的键为: ${!site[*]}"
echo "数组的键为: ${!site[@]}"
```



### Shell 注释:
- 以 # 开头的行就是注释，会被解释器忽略。
- 通过每一行加一个 # 号设置多行注释，像这样：
```
#--------------------------------------------
# 这是一个注释
# author：菜鸟教程
# site：www.runoob.com
# slogan：学的不仅是技术，更是梦想！
#--------------------------------------------
##### 用户配置区 开始 #####
#
#
# 这里可以添加脚本描述信息
# 
#
##### 用户配置区 结束  #####
```
- 可以`把这一段要注释的代码`用一对`花括号`括起来，`定义成一个函数`，没有地方调用这个函数，这块代码就不会执行，达到了和注释一样的效果。


### Shell 传递参数:
- 我们可以在执行 Shell 脚本时，向脚本传递参数，脚本内获取参数的格式为：`$n`。n 代表一个数字，1 为执行脚本的第一个参数，2 为执行脚本的第二个参数，以此类推……
```
#!/bin/bash

echo "Shell 传递参数实例！";
echo "执行的文件名：$0";
echo "第一个参数为：$1";
echo "第二个参数为：$2";
echo "第三个参数为：$3";

$ chmod +x test.sh 
$ ./test.sh 1 2 3
Shell 传递参数实例！
执行的文件名：./test.sh
第一个参数为：1
第二个参数为：2
第三个参数为：3
```

- 另外，还有几个特殊字符用来处理参数：
```
- $#    传递到脚本的`参数个数`
- $*	以一个单字符串显示所有向脚本传递的参数。如"$*"用引号括起来的情况、以"$1 $2 … $n"的形式输出所有参数。
- $$	脚本运行的`当前进程ID号`
- $!	后台运行的`最后一个进程的ID号`
- $@	与$*相同，但是使用时加引号，并`在引号中返回每个参数`。如"$@"用「"」括起来的情况、以"$1" "$2" … "$n" 的形式输出所有参数。
- $-	显示Shell使用的当前选项，与set命令功能相同。
- $?    显示`最后命令的退出状态`。0表示没有错误，其他任何值表明有错误。
```

- 实例：
```
#!/bin/bash

echo "Shell 传递参数实例！";
echo "第一个参数为：$1";

echo "参数个数为：$#";
echo "传递的参数作为一个字符串显示：$*";
```

- $* 与 $@ 区别：
    - 相同点：都是引用所有参数。
    - 不同点：`只有在双引号中体现出来`。假设在脚本运行时写了三个参数 1、2、3，则 " * " 等价于 "1 2 3"（传递了一个参数），而 "@" 等价于 "1" "2" "3"（传递了三个参数）。

-----------------------------------------------------------------------

## Shell 基本运算符
- Shell 和其他编程语言一样，支持多种运算符，包括：
    - 算数运算符
    - 关系运算符
    - 布尔运算符
    - 字符串运算符
    - 文件测试运算符

- `原生bash不支持简单的数学运算`，但是可以通过其他命令来实现，例如 awk 和 expr，expr 最常用。

- expr 是一款`表达式计算工具`，使用它`能完成表达式的求值操作`。
- 例如，两个数相加(注意使用的是反引号 ` 而不是单引号 ')：
```
#!/bin/bash

val=`expr 2 + 2`
echo "两数之和为 : $val"
```
- 需要注意的点：
    - `表达式和运算符之间要有空格`，例如 2+2 是不对的，必须写成 2 + 2，这与我们熟悉的大多数编程语言不一样。
    - 完整的表达式要被 反引号 ` 包含，注意这个字符不是常用的单引号，在 Esc 键下边。

### 算术运算符:
- 下表列出了常用的算术运算符，假定变量 a 为 10，变量 b 为 20
```
+	加法	                                    `expr $a + $b` 结果为 30。
-	减法	                                    `expr $a - $b` 结果为 -10。
*	乘法	                                    `expr $a \* $b` 结果为  200。
/	除法	                                    `expr $b / $a` 结果为 2。
%	取余	                                    `expr $b % $a` 结果为 0。
=	赋值	                                    a=$b 把变量 b 的值赋给 a。
==	相等。用于比较两个数字，相同则返回 true。	    [ $a == $b ] 返回 false。
!=	不相等。用于比较两个数字，不相同则返回 true。   [ $a != $b ] 返回 true。
```

- 注意：条件表达式要放在`方括号之间`，并且`要有空格`，例如: [$a==$b] 是错误的，必须写成 [ $a == $b ]。

### 关系运算符：
- 关系运算符只支持数字，不支持字符串，除非字符串的值是数字。
- 下表列出了常用的关系运算符，假定变量 a 为 10，变量 b 为 20：
```
-eq	检测两个数是否相等，相等返回 true。	                    [ $a -eq $b ] 返回 false。
-ne	检测两个数是否不相等，不相等返回 true。	                [ $a -ne $b ] 返回 true。
-gt	检测左边的数是否大于右边的，如果是，则返回 true。	     [ $a -gt $b ] 返回 false。
-lt	检测左边的数是否小于右边的，如果是，则返回 true。	     [ $a -lt $b ] 返回 true。
-ge	检测左边的数是否大于等于右边的，如果是，则返回 true。	 [ $a -ge $b ] 返回 false。
-le	检测左边的数是否小于等于右边的，如果是，则返回 true。	 [ $a -le $b ] 返回 true。
```

### 布尔运算符：
- 下表列出了常用的布尔运算符，假定变量 a 为 10，变量 b 为 20：
```
!	非运算，表达式为 true 则返回 false，否则返回 true。	        [ ! false ] 返回 true。
-o	或运算，有一个表达式为 true 则返回 true。	                [ $a -lt 20 -o $b -gt 100 ] 返回 true。
-a	与运算，两个表达式都为 true 才返回 true。	                [ $a -lt 20 -a $b -gt 100 ] 返回 false。
```

### 逻辑运算符:
- 以下介绍 Shell 的逻辑运算符，假定变量 a 为 10，变量 b 为 20:
```
&&	逻辑的 AND	                    [[ $a -lt 100 && $b -gt 100 ]] 返回 false
||	逻辑的 OR	                    [[ $a -lt 100 || $b -gt 100 ]] 返回 true
```

### 字符串运算符：
- 下表列出了常用的字符串运算符，假定变量 a 为 "abc"，变量 b 为 "efg"：
```
=	检测两个字符串是否相等，相等返回 true。	             [ $a = $b ] 返回 false。
!=	检测两个字符串是否不相等，不相等返回 true。	         [ $a != $b ] 返回 true。
-z	检测字符串长度是否为0，为0返回 true。	            [ -z $a ] 返回 false。
-n	检测字符串长度是否不为 0，不为 0 返回 true。	    [ -n "$a" ] 返回 true。
$	检测字符串是否不为空，不为空返回 true。	            [ $a ] 返回 true。
```

### 文件测试运算符：
- 文件测试运算符用于检测 Unix 文件的各种属性。
- 属性检测描述如下：
```
-b file	检测文件是否是块设备文件，如果是，则返回 true。	                        [ -b $file ] 返回 false。
-c file	检测文件是否是字符设备文件，如果是，则返回 true。	                    [ -c $file ] 返回 false。
-d file	检测文件是否是目录，如果是，则返回 true。	                            [ -d $file ] 返回 false。
-f file	检测文件是否是普通文件（既不是目录，也不是设备文件），如果是，则返回 true。	[ -f $file ] 返回 true。
-g file	检测文件是否设置了 SGID 位，如果是，则返回 true。	                    [ -g $file ] 返回 false。
-k file	检测文件是否设置了粘着位(Sticky Bit)，如果是，则返回 true。	            [ -k $file ] 返回 false。
-p file	检测文件是否是有名管道，如果是，则返回 true。	                        [ -p $file ] 返回 false。
-u file	检测文件是否设置了 SUID 位，如果是，则返回 true。	                    [ -u $file ] 返回 false。
-r file	检测文件是否可读，如果是，则返回 true。	                                [ -r $file ] 返回 true。
-w file	检测文件是否可写，如果是，则返回 true。	                                [ -w $file ] 返回 true。
-x file	检测文件是否可执行，如果是，则返回 true。	                            [ -x $file ] 返回 true。
-s file	检测文件是否为空（文件大小是否大于0），不为空返回 true。	             [ -s $file ] 返回 true。
-e file	检测文件（包括目录）是否存在，如果是，则返回 true。	                    [ -e $file ] 返回 true。
```
- 其他检查符：
    - S: 判断某文件`是否 socket`。
    - L: 检测文件`是否存在`并且`是一个符号链接`。

---------------------------------------------------------------------------------------------
## Shell echo命令
- 1.显示普通字符串:
```
echo "It is a test"
双引号可以省略
```
- 2.显示转义字符
```
echo \"It is a test\"
```
- 3.显示变量
read 命令从`标准输入中读取一行`,并`把输入行的每个字段的值`指定给 shell 变量
```
#!/bin/sh
read name 
echo "$name It is a test"

-------------------------

[root@www ~]# sh test.sh
OK                     #标准输入
OK It is a test        #输出

```
- 4.显示换行
```
echo -e "OK! \n" # -e 开启转义
echo "It is a test"
```
- 5.显示不换行
```
#!/bin/sh
echo -e "OK! \c" # -e 开启转义 \c 不换行
echo "It is a test"
```

- 6.显示结果定向至文件
```
echo "It is a test" > myfile
```

- 7.原样输出字符串，不进行转义或取变量(用单引号)
```
echo '$name\"'
```

- 8.显示命令执行结果
```
echo `date`

注意： 这里使用的是反引号 `, 而不是单引号 '。
结果将显示当前日期
Thu Jul 24 10:08:46 CST 2014
```

------------------------------------------------------------------------

## Shell printf 命令
- printf 命令模仿 C 程序库（library）里的 printf() 程序。
- 实例：
```
#!/bin/bash
# author:菜鸟教程
# url:www.runoob.com
 
# format-string为双引号
printf "%d %s\n" 1 "abc"

# 单引号与双引号效果一样 
printf '%d %s\n' 1 "abc" 

# 没有引号也可以输出
printf %s abcdef

# 格式只指定了一个参数，但多出的参数仍然会按照该格式输出，format-string 被重用
printf %s abc def

printf "%s\n" abc def

printf "%s %s %s\n" a b c d e f g h i j

# 如果没有 arguments，那么 %s 用NULL代替，%d 用 0 代替
printf "%s and %d \n"

-------------------------------------

1 abc
1 abc
abcdefabcdefabc
def
a b c
d e f
g h i
j  
and 0

```

--------------------------------------------------------------------------------

## Shell test 命令
- Shell中的 `test 命令用于检查某个条件是否成立`，它可以进行`数值、字符和文件`三个方面的测试。
### 数值测试:
```
-eq	等于则为真
-ne	不等于则为真
-gt	大于则为真
-ge	大于等于则为真
-lt	小于则为真
-le	小于等于则为真
```
- 实例：
```
num1=100
num2=100
if test $[num1] -eq $[num2]
then
    echo '两个数相等！'
else
    echo '两个数不相等！'
fi
```
- 代码中的 [] 执行基本的算数运算，如：
```
#!/bin/bash

a=5
b=6

result=$[a+b] # 注意等号两边不能有空格
echo "result 为： $result"
```
### 字符串测试：
```
=	等于则为真
!=	不相等则为真
-z 字符串	字符串的长度为零则为真
-n 字符串	字符串的长度不为零则为真
```
- 实例：
```
num1="ru1noob"
num2="runoob"
if test $num1 = $num2
then
    echo '两个字符串相等!'
else
    echo '两个字符串不相等!'
fi
```

### 文件测试：
```
-e 文件名	如果文件存在则为真
-r 文件名	如果文件存在且可读则为真
-w 文件名	如果文件存在且可写则为真
-x 文件名	如果文件存在且可执行则为真
-s 文件名	如果文件存在且至少有一个字符则为真
-d 文件名	如果文件存在且为目录则为真
-f 文件名	如果文件存在且为普通文件则为真
-c 文件名	如果文件存在且为字符型特殊文件则为真
-b 文件名	如果文件存在且为块特殊文件则为真
```

- 实例：
```
cd /bin
if test -e ./bash
then
    echo '文件已存在!'
else
    echo '文件不存在!'
fi
```

### 另外，Shell 还提供了与( -a )、或( -o )、非( ! )三个逻辑操作符用于将测试条件连接起来，其优先级为： ! 最高， -a 次之， -o 最低。

--------------------------------------------------------------------------------

## Shell 流程控制
- 和 Java、PHP 等语言不一样，`sh 的流程控制不可为空`，如(以下为 PHP 流程控制写法)：
```
<?php
if (isset($_GET["q"])) {
    search(q);
}
else {
    // 不做任何事情
}
```
- 在 sh/bash 里可不能这么写，`如果 else 分支没有语句执行，就不要写这个 else`。

### if else
- if 语句语法格式：
```
if condition
then
    command1 
    command2
    ...
    commandN 
fi
```
- if else 语法格式：
```
if condition
then
    command1 
    command2
    ...
    commandN
else
    command
fi
```
- if else-if else
```
if condition1
then
    command1
elif condition2 
then 
    command2
else
    commandN
fi
```

- if else 的 [...] 判断语句中大于使用 -gt，小于使用 -lt。
```
if [ "$a" -gt "$b" ]; then
    ...
fi
```
- 如果使用 ((...)) 作为判断语句，大于和小于可以直接使用 > 和 <。
```
if (( a > b )); then
    ...
fi
```

### if else 语句经常与 test 命令结合使用，如下所示：
```
num1=$[2*3]
num2=$[1+5]
if test $[num1] -eq $[num2]
then
    echo '两个数字相等!'
else
    echo '两个数字不相等!'
fi
```

### for 循环
- 与其他编程语言类似，Shell支持for循环。
- for循环一般格式为：
```
for var in item1 item2 ... itemN
do
    command1
    command2
    ...
    commandN
done
```

### while 语句
- while 循环用于不断执行一系列命令，也用于从输入文件中读取数据。其语法格式为：
```
while condition
do
    command
done
```
- 以下是一个基本的 while 循环，测试条件是：如果 int 小于等于 5，那么条件返回真。int 从 1 开始，每次循环处理时，int 加 1。运行上述脚本，返回数字 1 到 5，然后终止。
```
#!/bin/bash
int=1
while(( $int<=5 ))
do
    echo $int
    let "int++"
done
```
- 以上实例使用了 `Bash let` 命令，它用于执行一个或多个表达式，变量计算中不需要加上 $ 来表示变量

- while循环可用于`读取键盘信息`。下面的例子中，输入信息被设置为变量FILM，按<Ctrl-D>结束循环。
```
echo '按下 <CTRL-D> 退出'
echo -n '输入你最喜欢的网站名: '
while read FILM
do
    echo "是的！$FILM 是一个好网站"
done
```

### 无限循环
```
while :
do
    command
done

---------------------

while true
do
    command
done

---------------------

for (( ; ; ))
```

### until 循环
- until 循环执行一系列命令直至条件为 true 时停止。
- `until 循环与 while 循环在处理方式上刚好相反`。
- 一般 while 循环优于 until 循环，但在某些时候—也只是极少数情况下，until 循环更加有用。
```
until condition
do
    command
done
```

### case ... esac
- case ... esac 为多选择语句，与其他语言中的 switch ... case 语句类似，是一种多分支选择结构，每个 case 分支用右圆括号开始，用两个分号 ;; 表示 break，即执行结束，跳出整个 case ... esac 语句，esac（就是 case 反过来）作为结束标记。
- 可以用 case 语句匹配一个值与一个模式，如果匹配成功，执行相匹配的命令。
- case ... esac 语法格式如下：
```
case 值 in
模式1)
    command1
    command2
    ...
    commandN
    ;;
模式2)
    command1
    command2
    ...
    commandN
    ;;
esac
```
- 实例：
```
echo '输入 1 到 4 之间的数字:'
echo '你输入的数字为:'
read aNum
case $aNum in
    1)  echo '你选择了 1'
    ;;
    2)  echo '你选择了 2'
    ;;
    3)  echo '你选择了 3'
    ;;
    4)  echo '你选择了 4'
    ;;
    *)  echo '你没有输入 1 到 4 之间的数字'
    ;;
esac
```
- 下面的脚本匹配字符串：
```
#!/bin/sh

site="runoob"

case "$site" in
   "runoob") echo "菜鸟教程" 
   ;;
   "google") echo "Google 搜索" 
   ;;
   "taobao") echo "淘宝网" 
   ;;
esac
```

### 跳出循环
- 在循环过程中，有时候需要在未达到循环结束条件时强制跳出循环，Shell 使用两个命令来实现该功能：`break 和 continue`。
- break实例
```
#!/bin/bash
while :
do
    echo -n "输入 1 到 5 之间的数字:"
    read aNum
    case $aNum in
        1|2|3|4|5) echo "你输入的数字为 $aNum!"
        ;;
        *) echo "你输入的数字不是 1 到 5 之间的! 游戏结束"
            break
        ;;
    esac
done
```
- continue实例
```
#!/bin/bash
while :
do
    echo -n "输入 1 到 5 之间的数字: "
    read aNum
    case $aNum in
        1|2|3|4|5) echo "你输入的数字为 $aNum!"
        ;;
        *) echo "你输入的数字不是 1 到 5 之间的!"
            continue
            echo "游戏结束"
        ;;
    esac
done
```

-------------------------------------------------------------------------

## Shell 函数
- linux shell 可以用户定义函数，然后在shell脚本中可以随便调用。
- shell中函数的定义格式如下：
```
[ function ] funname [()]

{

    action;

    [return int;]

}
```
- 说明：
    - 1、可以带function fun() 定义，也可以直接fun() 定义,不带任何参数。
    - 2、参数返回，可以显示加：return 返回，如果不加，将以最后一条命令运行结果，作为返回值。 return后跟数值n(0-255

- 下面的例子定义了一个函数并进行调用：
```
#!/bin/bash
# author:菜鸟教程
# url:www.runoob.com

demoFun(){
    echo "这是我的第一个 shell 函数!"
}
echo "-----函数开始执行-----"
demoFun
echo "-----函数执行完毕-----"
```
- 下面定义一个带有return语句的函数：
```
#!/bin/bash
# author:菜鸟教程
# url:www.runoob.com

funWithReturn(){
    echo "这个函数会对输入的两个数字进行相加运算..."
    echo "输入第一个数字: "
    read aNum
    echo "输入第二个数字: "
    read anotherNum
    echo "两个数字分别为 $aNum 和 $anotherNum !"
    return $(($aNum+$anotherNum))
}
funWithReturn
echo "输入的两个数字之和为 $? !"
```
- `函数返回值`在调用该函数后通过 `$?` 来获得。
- 注意：所有函数在使用前必须定义。这意味着`必须将函数放在脚本开始部分`，直至shell解释器首次发现它时，才可以使用。调用函数仅使用其函数名即可。

### 函数参数
- 在Shell中，调用函数时可以向其传递参数。在函数体内部，通过 $n 的形式来获取参数的值，例如，$1表示第一个参数，$2表示第二个参数...

- 带参数的函数示例：
```
#!/bin/bash
# author:菜鸟教程
# url:www.runoob.com

funWithParam(){
    echo "第一个参数为 $1 !"
    echo "第二个参数为 $2 !"
    echo "第十个参数为 $10 !"
    echo "第十个参数为 ${10} !"
    echo "第十一个参数为 ${11} !"
    echo "参数总数有 $# 个!"
    echo "作为一个字符串输出所有参数 $* !"
}
funWithParam 1 2 3 4 5 6 7 8 9 34 73
```
- 注意，$10 不能获取第十个参数，获取第十个参数需要${10}。`当n>=10时，需要使用${n}来获取参数`。
- 另外，还有几个特殊字符用来处理参数：
```
$#	传递到脚本或函数的参数个数
$*	以一个单字符串显示所有向脚本传递的参数
$$	脚本运行的当前进程ID号
$!	后台运行的最后一个进程的ID号
$@	与$*相同，但是使用时加引号，并在引号中返回每个参数。
$-	显示Shell使用的当前选项，与set命令功能相同。
$?	显示最后命令的退出状态。0表示没有错误，其他任何值表明有错误。
```

---------------------------------------------------------------

## Shell 输入/输出重定向
- 大多数 UNIX 系统命令`从你的终端接受输入`并`将所产生的输出发送回​​到您的终端`。一个命令通常从一个叫`标准输入`的地方读取输入，默认情况下，这恰好是你的终端。同样，一个命令通常将其输出写入到`标准输出`，默认情况下，这也是你的终端。

- 重定向命令列表如下：
```
command > file	        将输出重定向到 file。
command < file	        将输入重定向到 file。
command >> file	        将输出以追加的方式重定向到 file。
n > file	            将文件描述符为 n 的文件重定向到 file。
n >> file	            将文件描述符为 n 的文件以追加的方式重定向到 file。
n >& m	                将输出文件 m 和 n 合并。
n <& m	                将输入文件 m 和 n 合并。
<< tag	                将开始标记 tag 和结束标记 tag 之间的内容作为输入。
```
- 需要注意的是文件描述符 `0 通常是标准输入（STDIN），1 是标准输出（STDOUT），2 是标准错误输出（STDERR）`。

### 重定向深入讲解
- 一般情况下，每个 Unix/Linux 命令运行时都会打开三个文件：
    - 标准输入文件(stdin)：stdin的文件描述符为`0`，Unix程序默认从stdin`读取数据`。
    - 标准输出文件(stdout)：stdout 的文件描述符为`1`，Unix程序默认向stdout`输出数据`。
    - 标准错误文件(stderr)：stderr的文件描述符为`2`，Unix程序会向stderr流中`写入错误信息`。

`默认情况下，command > file 将 stdout 重定向到 file`，command < file 将stdin 重定向到 file。

- 如果希望 stderr 重定向到 file，可以这样写：
```
$ command 2>file
```

- 如果希望 stderr `追加`到 file 文件末尾，可以这样写：
```
$ command 2>>file
```
- 2 表示标准错误文件(stderr)。

### /dev/null 文件
- 如果希望`执行某个命令，但又不希望在屏幕上显示输出结果`，那么可以将输出重定向到 /dev/null：
```
$ command > /dev/null
```
- `/dev/null` 是一个特殊的文件，`写入到它的内容都会被丢弃`；如果尝试从该文件读取内容，那么什么也读不到。但是 /dev/null 文件非常有用，将命令的输出重定向到它，会起到`"禁止输出"的效果`。

- 如果希望`屏蔽 stdout 和 stderr`，可以这样写：
```
$ command > /dev/null 2>&1
```

----------------------------------------------------------------

## Shell 文件包含
- 和其他语言一样，Shell 也`可以包含外部脚本`。这样可以很方便的`封装一些公用的代码作为一个独立的文件`。
- Shell 文件包含的语法格式如下：
```
. filename   # 注意点号(.)和文件名中间有一空格

或

source filename
```
- 实例:
```
创建两个 shell 脚本文件。

test1.sh 代码如下：
#!/bin/bash
# author:菜鸟教程
# url:www.runoob.com

url="http://www.runoob.com"

-------------------------------------

test2.sh 代码如下：
#!/bin/bash
# author:菜鸟教程
# url:www.runoob.com

#使用 . 号来引用test1.sh 文件
. ./test1.sh

# 或者使用以下包含文件代码
# source ./test1.sh

echo "菜鸟教程官网地址：$url"

-------------------------------------

接下来，我们为 test2.sh 添加可执行权限并执行：
$ chmod +x test2.sh 
$ ./test2.sh 
菜鸟教程官网地址：http://www.runoob.com

```


# 关于脚本引用：
- . /usr/share/libubox/jshn.sh：这个带有小数点的写法用于在当前的 shell 环境中引用脚本。这意味着 /usr/share/libubox/jshn.sh 中的代码会直接在当前的 shell 会话中进行解释和执行。这使得在当前的 shell 中可使用在被引用脚本中定义的函数和变量。
- /usr/share/libubox/jshn.sh：没有小数点，这种写法用于在单独的子 shell 中执行脚本。/usr/share/libubox/jshn.sh 中的代码会独立于当前的 shell 会话执行。除非明确从子 shell 导出，否则脚本中定义的变量或函数将无法在外部访问。

因此，`如果你希望在当前的 shell 中访问 /usr/share/libubox/jshn.sh 中定义的函数和变量，应该使用 . /usr/share/libubox/jshn.sh 的写法，包括小数点`。

## 关于管道：
- 当命令中使用管道符号 `|` 时，`左边的命令将作为子 shell 的输入`，`然后子 shell 执行这两个命令`，并`将左边命令的输出作为输入传递给右边的命令`。
- 例如：当使用命令 `echo "$line" | tr -d '\r'` 时，实际上创建了一个管道，`将 echo "$line" 的输出`作为 `tr -d '\r' 的输入`
- 这种管道的使用`可以方便地将一个命令的输出作为另一个命令的输入`，以便进行数据处理和操作

# 关于变量在if中使用
- 如 if [ $abc -eq 1 ]   如果$abc不存在，会导致语句变成 [ -eq 1 ]，所以应该加双引号，保证即使不存在，也是用空字符串和1比较

# 需要对变量进行算数运算：
- a=$((a | b))

# 按行读取shell输出：
- 方法一(管道)：（`此方法的缺点：管道会使得while循环内部的代码在子shell中执行，不是在原始shell`）
```
iw dev "$device" info | while read line;do
    echo $line
done
```
- 方法二（使用临时文件保存指令输出）：
```
tmp_file=$(mktemp)
iwlist "$device" scan > "$tmp_file"

while read -r line; do
    echo $line
done < "$tmp_file"
rm "$tmp_file"

```

## shell判断字符串是否包含某字串：
```
if [ -n "$(echo "$line" | grep "ESSID")" ]; then
```

## 要提取某个字符，可以使用awk先分割为前半段和后半段，然后再取后半段以空格分割的第一个，如：
```
Quality=87/94 Signal level=-63 dBm Noise level=-96 dBm (BDF averaged NF value in dBm)
要提取上面的Noise level
可以使用：
echo xxx | awk -F 'Noise level=' '{print $2}' | awk '{print $1}'
```


## 使用cut指令提取输出的第一列（学一学cut详细用法！）：
- cmd | cut -d ' ' -f1


## shell中有用的一些符号：
- https://e-mailky.github.io/2015-02-04-shell-special


## Bash参数展开(Parameter Expansion)
- https://e-mailky.github.io/2017-01-20-shell-special2
- 截取字符串（从第2个字符开始的长度为7的子串）—————— ${string:2:7}

## shell基本功：
- https://e-mailky.github.io/2017-04-14-shell_cmp
- if [-z $x]; then  —— 如果x的长度等于0
- if [-e /xxx/file]; then —— 如果文件file存在

## Awk基本使用：
- | awk -F '分隔符' '{print $1}'
- | awk '{print $1}' —— 不加-F默认用空格分隔

- https://www.runoob.com/linux/linux-comm-awk.html
- https://kysonlok.gitbook.io/blog/shell/awk
- https://www.geeksforgeeks.org/awk-command-unixlinux-examples/
- https://www.gnu.org/software/gawk/manual/gawk.html（官方手册）


## 使用$()执行指令并且赋值时，需要注意返回值中如果带有 : 字符时，需要在$()外层加双引号！