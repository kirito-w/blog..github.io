- 什么是MQTT:
    - https://blog.csdn.net/Teminator_/article/details/142177223
    - https://blog.csdn.net/black_pp/article/details/132106773?spm=1001.2101.3001.6650.1&utm_medium=distribute.pc_relevant.none-task-blog-2%7Edefault%7EBlogCommendFromBaidu%7ECtr-1-132106773-blog-142177223.235%5Ev43%5Epc_blog_bottom_relevance_base3&depth_1-utm_source=distribute.pc_relevant.none-task-blog-2%7Edefault%7EBlogCommendFromBaidu%7ECtr-1-132106773-blog-142177223.235%5Ev43%5Epc_blog_bottom_relevance_base3&utm_relevant_index=2
    - https://blog.csdn.net/zhouwu_linux/article/details/132407033
    - https://blog.csdn.net/lpcarl/article/details/121064213
    - https://blog.csdn.net/qq_38113006/article/details/105665658
    - https://blog.csdn.net/weixin_42042544/article/details/142516846
- mosquitto库接口：
    - https://mosquitto.org/api/files/mosquitto-h.html


- mosquitto库使用遇到的问题：
    - 断连后loop_stop的问题：https://www.cnblogs.com/zxq89/p/18266852
    - 常用方法：
        - https://shaocheng.li/posts/2015/08/11/
        - https://blog.csdn.net/weixin_45880057/article/details/124487132

- mosquitto库保持连接的方法： https://www.cnblogs.com/zhaogaojian/p/16852915.html

## 使用主线程时：
```
mosquitto_loop_forever()   //阻塞运行
```

## 使用多线程时：
```
启动一个线程处理mqtt网络事件

while(1) {
    int rc = mosquitto_loop(client.mosq, -1, 1);

    if (rc)
        {
            //如果网络出现异常，尝试重连
            log_debug("[MQTT] mosquitto_loop rc = %d \n", rc);
            mosquitto_reconnect(client.mosq);
            log_debug("[MQTT] ======= mosquitto reconnecting =======\n");
        }
}
```
或者
```
mosquitto_loop_start()    //非阻塞，启动新线程
```