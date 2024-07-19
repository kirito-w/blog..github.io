## 简介
- Socket 套接字是由 BSD（加州大学伯克利分校软件研发中心）开发的一套`独立于具体协议的网络编程接口`，`应用程序`可以`用这个接口进行网络通信`。
- 但 Socket `实际`上还是`属于进程间通信`（IPC），因为网络通信实质上是`不同机器上的进程之间的通信`。
- Socket 接口主要有下面这些特征：
    - 是一个编程接口
    - 是一个文件描述符（Linux 下一切皆文件）
    - 不局限与 TCP/IP 协议
    - 面向有连接(TCP)和无连接(UDP)


## TCP网络编程流程
- 服务器：
    - 创建套接字  socket()
    - 填充服务器网络信息结构体 struct sockaddr_in
    - 将套接字与服务器网络信息结构体绑定 bind()
    - 将套接字设置为被动监听状态 listen()
    - 阻塞等待客户端的连接 accept()
    - 进行通信 read()/write()、recv()/send()、recvfrom()\sendto()
- 客户端：
    - 创建套接字  socket()
    - 填充服务器网络信息结构体 struct sockaddr_in
    - 给服务器发送连接请求 connect()
    - 进行通信 read()/write()、recv()/send()、recvfrom()\sendto()

## UDP网络编程流程
- 服务器：
    - 创建套接字 socket()
    - 填充服务器网络信息结构体 struct sockaddr_in
    - 将套接字与服务器网络信息结构体绑定 bind()
    - 进行通信  recvfrom()/sendto()

- 客户端：
    - 创建套接字 socket()
    - 填充服务器网络信息结构体 struct sockaddr_in
    - 进行通信  recvfrom()/sendto()


# socket和套接字
## socket
- `socket是一种编程接口`，用于在计算机网络中进行通信。它提供了一种机制，使不同计算机之间可以通过网络进行数据传输。简单来说，`socket是网络通信的一种抽象`。它通过一系列的`套接字函数`来实现网络通信。
- 当我们谈到socket通信时，通常是指使用socket接口进行网络通信。在网络通信中，`套接字`（socket）是指`支持网络数据传输`的一种`数据结构`，它`包含`了通信所需的`网络地址`、`端口号`以及`相关的控制信息`。通过使用套接字，我们可以在不同的计算机之间建立连接，以进行数据的发送和接收。
- `套接字在网络编程中扮演着重要的角色`，它被广泛应用于各种网络通信场景，如`客户端与服务器的通信`、`进程间的通信`等。通过socket编程，开发人员可以方便地实现网络应用，实现数据的传输与交互。

## 套接字
- 套接字（Socket）是在计算机网络中进行通信的一种机制，它用于建立连接和进行数据传输。套接字抽象了底层网络通信细节，提供了一组API（应用程序编程接口），使开发人员可以通过编程来实现网络通信。
- 套接字由以下几个要素组成：
    - `IP地址`：用于标识主机在网络中的唯一性。
    - `端口号`：用于标识主机上的应用程序。
    - `传输协议`：如TCP（传输控制协议）或UDP（用户数据报协议），决定了数据如何在网络中传输。
- 通过创建套接字，我们可以在网络上建立连接并进行数据的发送和接收。`服务器端和客户端可以通过套接字进行双向通信，互相交换数据`。

## 实例：
### 实现客户端——服务器端通信：
- 服务器端：
```
local socket = require("socket")

-- 创建套接字
local server = assert(socket.bind("127.0.0.1", 12345))

-- 等待客户端连接
print("服务器已启动，等待连接...")
local client = server:accept()
print("客户端已连接:", client:getpeername())

-- 接收客户端发送的数据
local data = client:receive()
print("客户端发送的数据:", data)

-- 发送响应数据给客户端
local response = "Hello, client!"
client:send(response)

-- 关闭连接
client:close()
```

- 客户端：
```
local socket = require("socket")

-- 创建套接字
local client = assert(socket.connect("127.0.0.1", 12345))

-- 发送数据给服务器
local data = "Hello, server!"
client:send(data)

-- 接收服务器的响应
local response, err = client:receive()
if response then
    print("服务器的响应:", response)
else
    print("错误:", err)
end

-- 关闭连接
client:close()
```

----------------------------------------------------------------

### 实现进程间通信
- 进程A：
```
local posix = require("posix")

-- 创建管道
local pipe_name = "/tmp/my_pipe"
posix.mkfifo(pipe_name, tonumber("0666", 8))  -- 创建命名管道

-- 打开管道
local pipe_fd = posix.open(pipe_name, posix.O_WRONLY)

-- 发送数据到管道
local message = "Hello, Process B!"
posix.write(pipe_fd, message)

-- 关闭管道
posix.close(pipe_fd)

```
- 进程B：
```
local posix = require("posix")

-- 打开管道
local pipe_name = "/tmp/my_pipe"
local pipe_fd = posix.open(pipe_name, posix.O_RDONLY)

-- 读取管道中的数据
local message = posix.read(pipe_fd, 1024)
print("接收到的消息:", message)

-- 关闭管道
posix.close(pipe_fd)

-- 删除管道文件
posix.unlink(pipe_name)
```



- https://dlonng.com/posts/network
- https://juejin.cn/post/7020006813521330189
- https://www.jianshu.com/p/1c262c5d7e26
- https://github.com/rongweihe/CS_Offer/blob/master/notes/Linux%E7%BD%91%E7%BB%9C%E7%BC%96%E7%A8%8B.md

## 进程间通信方式：
- https://www.xiaolincoding.com/os/4_process/process_commu.html#%E6%B6%88%E6%81%AF%E9%98%9F%E5%88%97

## socket编程实例：
- https://blog.csdn.net/qq_40170041/article/details/130220094
- https://blog.csdn.net/cpp_learner/article/details/127813889?spm=1001.2101.3001.6650.7&utm_medium=distribute.pc_relevant.none-task-blog-2%7Edefault%7EBlogCommendFromBaidu%7ERate-7-127813889-blog-106311964.235%5Ev43%5Epc_blog_bottom_relevance_base2&depth_1-utm_source=distribute.pc_relevant.none-task-blog-2%7Edefault%7EBlogCommendFromBaidu%7ERate-7-127813889-blog-106311964.235%5Ev43%5Epc_blog_bottom_relevance_base2&utm_relevant_index=14

## socket编程：
- https://e-mailky.github.io/2017-01-13-socket-programs