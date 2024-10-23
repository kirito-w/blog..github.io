# Linux I/O 多路复用：
- https://blog.csdn.net/modi000/article/details/106788038
- https://www.cnblogs.com/cheer-lingmu/p/16423909.html


# 注意：`select函数与【阻塞/非阻塞socket】没有半毛钱的关系。select函数本身是阻塞的（与socket是否阻塞并没有关系）`
 
# 例子：
- socket_client:
```
int Init(SocketClient *client, const char *socketPath) 
{
    client->Socket = socket(AF_UNIX, SOCK_STREAM, 0);
    if (client->Socket < 0) 
    {
        log_error("Failed to create socket");
        return -1;
    }

    client->Addr.sun_family = AF_UNIX;
    strncpy(client->Addr.sun_path, socketPath, sizeof(client->Addr.sun_path) - 1);

    if (connect(client->Socket, (struct sockaddr*)&client->Addr, sizeof(client->Addr)) < 0) 
    {
        LogAndCloseSocket("Connection failed", client);
        return -1;
    }

    return 0;
}

void Destroy(SocketClient *client) 
{
    if (client->Socket >= 0) 
    {
        close(client->Socket);
        client->Socket = -1;
    }
}

int send_data(int socket, const char *data, size_t data_len) {
    ssize_t bytesWritten = 0;

    while (bytesWritten < data_len) {
        fd_set write_fds;
        FD_ZERO(&write_fds);
        FD_SET(socket, &write_fds);

        struct timeval timeout;
        timeout.tv_sec = 1;  // 设置为1秒超时
        timeout.tv_usec = 0;

        int select_result = select(socket + 1, NULL, &write_fds, NULL, &timeout);
        if (select_result < 0) {
            log_error("select failed while sending data");
            return -1;
        } else if (select_result == 0) {
            log_error("Timeout while sending data");
            return -1;
        }

        ssize_t result = write(socket, data + bytesWritten, data_len - bytesWritten);
        if (result < 0) {
            if (errno == EAGAIN || errno == EWOULDBLOCK) {
                continue; // 重试
            } else {
                log_error("Failed to send data");
                return -1;
            }
        }
        bytesWritten += result;
    }

    return 0;
}

ssize_t receive_data(int socket, char *buffer, size_t buffer_size) {
    ssize_t bytesReceived = 0;

    while (bytesReceived < buffer_size - 1) {
        fd_set read_fds;
        FD_ZERO(&read_fds);
        FD_SET(socket, &read_fds);

        struct timeval timeout;
        timeout.tv_sec = 1;  // 设置为1秒超时
        timeout.tv_usec = 0;

        int select_result = select(socket + 1, &read_fds, NULL, NULL, &timeout);
        if (select_result < 0) {
            log_error("select failed while receiving data");
            return -1;
        } else if (select_result == 0) {
            log_error("Timeout while receiving data");
            return -1;
        }

        ssize_t result = read(socket, buffer + bytesReceived, buffer_size - 1 - bytesReceived);
        if (result < 0) {
            if (errno == EAGAIN || errno == EWOULDBLOCK) {
                continue; // 重试
            } else {
                log_error("Failed to receive data");
                return -1;
            }
        }
        bytesReceived += result;
        if (result == 0) break; // 连接关闭
    }

    buffer[bytesReceived] = '\0';  // 终止字符串
    return bytesReceived;
}

int SendMessage(SocketClient *client, cmd_type cmdType, const char *message, char *response) 
{
    char *sendBuffer = NULL;
    size_t totalLength = 0;

    if (BuildMessage(cmdType, message, &sendBuffer, &totalLength) < 0) {
        return -1;
    }

    // 设置 socket 为非阻塞模式
    // if (SetSocketNonBlocking(client->Socket) < 0) {
    //     free(sendBuffer);
    //     log_error("Failed to set socket to non-blocking mode");
    //     return -1;
    // }

    // 发送消息
    if (send_data(client->Socket, sendBuffer, totalLength) < 0) {
        free(sendBuffer);
        return -1;
    }

    free(sendBuffer);

    // 接收响应
    ssize_t bytesReceived = receive_data(client->Socket, response, RESPONSE_BUFFER_SIZE);
    if (bytesReceived < 0) {
        return -1;
    }

    // 解析响应
    int responseLength = ParseResponse(response, bytesReceived, cmdType);
    if (responseLength < 0) {
        log_error("Failed to parse response");
        return -1;
    }

    char *textStart = response + 4 + sizeof(uint16_t);
    memcpy(response, textStart, responseLength);
    response[responseLength] = '\0';

    return 0;
}

```

- socket_server:
```
void socket_server_run(int server_socket) {
    fd_set read_fds;
    struct timeval timeout;
    int client_socket;

    while (1) {
        FD_ZERO(&read_fds);
        FD_SET(server_socket, &read_fds);
        timeout.tv_sec = 1;  // 设置为1秒超时
        timeout.tv_usec = 0;

        int activity = select(server_socket + 1, &read_fds, NULL, NULL, &timeout);
        if (activity < 0 && errno != EINTR) {
            yrbus_info("Error in select");
            break;
        }

        if (FD_ISSET(server_socket, &read_fds)) {
            client_socket = accept(server_socket, NULL, NULL);
            if (client_socket < 0) {
                if (errno == EAGAIN || errno == EWOULDBLOCK) {
                    continue;  // 没有连接可接受，继续循环
                }
                yrbus_info("Error accepting client connection");
                break;
            }

            if (handle_request(client_socket) < 0) {
                yrbus_info("Error handling client request");
            }
            close(client_socket);
        }
    }
}

void socket_server_release(int server_socket) {
    close(server_socket);
    unlink(YRBUS_SOCKET_PATH);
}

int socket_server_init() {
    int server_socket;
    struct sockaddr_un server_addr;

    // 创建UNIX域套接字
    if ((server_socket = socket(AF_UNIX, SOCK_STREAM, 0)) < 0) {
        perror("Error creating socket");
        return -1;
    }

    // 初始化地址
    memset(&server_addr, 0, sizeof(server_addr));
    server_addr.sun_family = AF_UNIX;
    strncpy(server_addr.sun_path, YRBUS_SOCKET_PATH, sizeof(server_addr.sun_path) - 1);

    // 绑定套接字
    unlink(YRBUS_SOCKET_PATH);
    if (bind(server_socket, (struct sockaddr*)&server_addr, sizeof(server_addr)) < 0) {
        perror("Error binding socket");
        return -1;
    }

    // 监听连接
    if (listen(server_socket, 5) < 0) {
        perror("Error listening on socket");
        return -1;
    }
    yrbus_info("Server listening for connections...\n");
    return server_socket;
}
```