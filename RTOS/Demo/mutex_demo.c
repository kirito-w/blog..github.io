/*
    freeRTOS 互斥量demo —— 读写锁
*/

#include "FreeRTOS.h"
#include <stdio.h>
#include <pthread.h>

/* Kernel includes. */
#include "task.h"
#include "timers.h"
#include "semphr.h"

/* Local includes. */
#include "console.h"

#define mainCOMMON_TASK_PRIORITY       ( tskIDLE_PRIORITY + 1 )
#define mainMutex_FREQUENCY_MS        pdMS_TO_TICKS( 500UL )

/*
互斥量(同样也是信号量) SemaphoreHandle_t —— 通常用于管理共享资源的访问，确保任务对资源的互斥访问，也可以用于任务之间的 同步
*/

SemaphoreHandle_t xMutex = NULL;
int sharedResource = 0;

void vTaskWriter(void *pvParameters) {
    (void) pvParameters;
    for( ;; ) {
        if (xSemaphoreTake(xMutex, portMAX_DELAY) == pdTRUE) {
            // 获取互斥锁，访问共享资源
            printf("Writer task: Writing to shared resource\n");
            sharedResource++;
            printf("Shared resource value: %d\n", sharedResource);
            xSemaphoreGive(xMutex); // 释放互斥锁
        }
        vTaskDelay(mainMutex_FREQUENCY_MS); // 模拟操作的延时
    }
}

void vTaskReader(void *pvParameters) {
    (void) pvParameters;
    for( ;; ) {
        if (xSemaphoreTake(xMutex, portMAX_DELAY) == pdTRUE) {
            // 获取互斥锁，访问共享资源
            printf("Reader task: Reading shared resource\n");
            printf("Shared resource value: %d\n", sharedResource);
            xSemaphoreGive(xMutex); // 释放互斥锁
        }
        vTaskDelay(mainMutex_FREQUENCY_MS); // 模拟操作的延时
    }
}

int main(void) {
    xMutex = xSemaphoreCreateMutex(); // 创建一个互斥锁

    if (xMutex != NULL) {
        xTaskCreate(vTaskWriter, "Writer", configMINIMAL_STACK_SIZE, NULL, mainCOMMON_TASK_PRIORITY, NULL);
        xTaskCreate(vTaskReader, "Reader", configMINIMAL_STACK_SIZE, NULL, mainCOMMON_TASK_PRIORITY, NULL);
        vTaskStartScheduler(); // 启动调度器
    }

    for( ;; ) {
        // 代码不会到达这里
    }
}