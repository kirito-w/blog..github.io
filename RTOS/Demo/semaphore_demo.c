/*
    freeRTOS 信号量触发事件demo
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

#define mainCOMMON_TASK_PRIORITY       ( tskIDLE_PRIORITY + 1 )
#define mainSemaphore_FREQUENCY_MS        pdMS_TO_TICKS( 1000UL )

/*
信号量 SemaphoreHandle_t —— 通常用于管理共享资源的访问，确保任务对资源的互斥访问，也可以用于任务之间的同步
*/

SemaphoreHandle_t xSemaphore = NULL;

void vTaskProducer(void *pvParameters) {
    (void) pvParameters;

    for( ;; ) {
        printf("Producer task: Producing item\n");
        xSemaphoreGive(xSemaphore); // 给信号量，通知消费者任务
        vTaskDelay(mainSemaphore_FREQUENCY_MS); // 模拟生产的延时
    }
}

void vTaskConsumer(void *pvParameters) {
    (void) pvParameters;

    for( ;; ) {
        if (xSemaphoreTake(xSemaphore, portMAX_DELAY) == pdTRUE) {
            // 获取信号量，表示消费任务开始
            printf("Consumer task: Consuming item\n");
        }
    }
}

int main(void) {
    xSemaphore = xSemaphoreCreateBinary(); // 创建一个二进制信号量

    if (xSemaphore != NULL) {
        xTaskCreate(vTaskProducer, "Producer", configMINIMAL_STACK_SIZE, NULL, mainCOMMON_TASK_PRIORITY, NULL);
        xTaskCreate(vTaskConsumer, "Consumer", configMINIMAL_STACK_SIZE, NULL, mainCOMMON_TASK_PRIORITY, NULL);
        vTaskStartScheduler(); // 启动调度器
    }

    for( ;; ) {
        // 代码不会到达这里
    }
}
