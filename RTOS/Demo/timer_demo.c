
/*
    freeRTOS 定时器demo
*/

#include "FreeRTOS.h"
#include <stdio.h>
#include <pthread.h>
#include <unistd.h>

/* Kernel includes. */
#include "task.h"
#include "timers.h"
#include "semphr.h"

/* Local includes. */
#include "console.h"

#define mainTimer_FREQUENCY_MS        pdMS_TO_TICKS( 1000UL )

TimerHandle_t xTimer;

void vTimerCallback(TimerHandle_t xTimer) {
    printf("Timer callback executed\n");
}

int main(void) {
    // 创建定时器
    
    // - "My_Timer": 定时器的名称，用于调试时标识定时器（可以为任意字符串）
    // - mainTimer_FREQUENCY_MS: 定时器周期的时间，单位是 ticks。该值决定了定时器多久触发一次。这里是根据定义的常量转换的时间周期（例如 1000ms 或其他周期）。
    // - pdTRUE: 表示定时器是循环定时器（定时器到期后会自动重新启动），如果是 pdFALSE，定时器只会触发一次，之后停止。
    // - 0: 定时器的 ID，通常可以设置为 0，除非你需要使用多个定时器区分每个定时器的上下文。
    // - vTimerCallback: 定时器到期时要调用的回调函数，用于在定时器触发时执行某些操作。
    xTimer = xTimerCreate("My_Timer", mainTimer_FREQUENCY_MS, pdTRUE, 0, vTimerCallback);

    if (xTimer != NULL) {
        xTimerStart(xTimer, 0); // 启动定时器
        vTaskStartScheduler(); // 启动调度器
    }

    for( ;; ) 
    {    // 代码不会到达这里
    }
}
