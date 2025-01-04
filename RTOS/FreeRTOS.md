## 简介：https://freertos.org/Documentation/01-FreeRTOS-quick-start/01-Beginners-guide/01-RTOS-fundamentals

## 论坛：https://forums.freertos.org/t/posix-gcc-demo-stack-smashing-detected/20125

## RTOS扩展库：https://www.freertos.org/Documentation/01-FreeRTOS-quick-start/01-Beginners-guide/04-FreeRTOS-libraries-and-3rd-party-tools

## 一些内核的使用示例：https://www.freertos.org/Documentation/02-Kernel/02-Kernel-features/00-Developer-docs

- 1、拉取代码： git clone https://github.com/FreeRTOS/FreeRTOS.git
- 2、克隆子模块： git submodule update --init --recursive
- 3、进入对应demo编译：   
    - make -C FreeRTOS/FreeRTOS/Demo/Posix_GCC
    - ./FreeRTOS/FreeRTOS/Demo/Posix_GCC/build/posix_demo

## 核心组件（内核代码）
- 1、任务调度（task.h）
- 2、定时器和延时（timers.h）
- 3、信号量和互斥量（semphr.h）
- 4、队列的创建、发送和接收，队列是任务之间通信的一个基本手段。(queue.h)
- 4、中断与任务切换
- 5、上下文切换

## RTOS特性
- 任务调度 确保了不同优先级任务的及时执行；
- 定时器 保证了定时任务的精确触发；
- 信号量和互斥量 确保了任务之间的安全同步；
- 中断与任务切换 保证了系统能够快速响应外部事件。

## FreeRTOS内存管理
- https://blog.csdn.net/qq_61672347/article/details/125670837?spm=1001.2014.3001.5502
- https://freertoskernel.asicfans.com/dui-nei-cun-guan-li


## 计算cpu占用率
- https://blog.csdn.net/liuyi_lab/article/details/112833260
```
void DumpTaskSysFree(void)
{
    uint8_t CPU_RunInfo[400] = {0};

    memset(CPU_RunInfo, 0, 400);
    vTaskList((char *)&CPU_RunInfo);
    printf("任务名  任务状态  优先级  剩余栈  任务序号\r\n ");
    printf("%s\r\n", CPU_RunInfo);
   
    memset(CPU_RunInfo,0,400); 
    vTaskGetRunTimeStats((char *)&CPU_RunInfo); 
    printf("任务名  运行计数  使用率 \r\n ");
    printf("%s\r\n", CPU_RunInfo);
}
```


## 一些注意事项
- 1.`任务（Task）` 是系统并发执行的`基本单位`。
- 2.单个 main() 函数：在 FreeRTOS 中，整个系统通过一个 main() 函数启动。您可以在 main() 中创建多个任务，但仍然是一个`共享内存空间的系统`。
- 3.多任务并发：FreeRTOS `支持并发任务（类似于多线程）`，`每个任务都有自己的栈和优先级`，但它们共`享同一个地址空间`。
- 4.没有多进程：FreeRTOS 没有多进程的概念，`所有的任务都运行在同一个地址空间，没有进程隔离`。任务之间的切换`由 FreeRTOS 调度器管理`，不同的任务通过`优先级和时间片`来进行`切换`。
- 5.


## 相关文档
- 野火STM32:https://doc.embedfire.com/linux/stm32mp1/freertos/zh/latest/README.html
- FreeRTOS启动流程:https://doc.embedfire.com/linux/stm32mp1/freertos/zh/latest/application/freertos_startup.html
- 临界段：https://doc.embedfire.com/linux/stm32mp1/freertos/zh/latest/application/critical_protect.html
- 任务管理机制：https://doc.embedfire.com/linux/stm32mp1/freertos/zh/latest/application/tasks_management.html
- TCP相关：https://www.freertos.org/Documentation/03-Libraries/02-FreeRTOS-plus/02-FreeRTOS-plus-TCP/04-Tutorial/01-TCP-networking-tutorial