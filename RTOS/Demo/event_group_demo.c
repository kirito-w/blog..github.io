/*
    freeRTOS 标志位demo  事件等待
*/

#include "FreeRTOS.h"
#include <stdio.h>
#include <pthread.h>
#include <unistd.h>

/* Kernel includes. */
#include "task.h"
#include "timers.h"
#include "semphr.h"
#include "event_groups.h"

/* Local includes. */
#include "console.h"

#define mainTask1_FREQUENCY_MS        pdMS_TO_TICKS( 1000UL )
#define mainTask2_FREQUENCY_MS        pdMS_TO_TICKS( 2000UL )
#define mainCOMMON_TASK_PRIORITY       ( tskIDLE_PRIORITY + 1 )

#define BIT_0 (1 << 0)
#define BIT_1 (1 << 1)

/*
标志位 EventGroupHandle_t —— 一般用来实现事件的同步或者等待
标志位非常适合用于等待多个条件同时满足的场景。例如，任务 A 和任务 B 都需要完成某个工作后，任务 C 才能开始执行。
*/

EventGroupHandle_t xEventGroup;

void vTask1(void *pvParameters) {
    (void) pvParameters;
    for( ;; ) {
        printf("Task 1: Setting BIT_0\n");
        // - xEventGroup：事件组句柄
        xEventGroupSetBits(xEventGroup, BIT_0); // 设置 BIT_0 标志，通知其他任务
        vTaskDelay(mainTask1_FREQUENCY_MS); // 模拟任务延时
    }
}

// Task2需要等待Task1和task3执行完后才能操作
void vTask2(void *pvParameters) {
    (void) pvParameters;
    for( ;; ) {
        // - xEventGroup：事件组句柄
        // - BIT_0：等待的标志位
        // - pdTRUE：等待成功后清除标志位（自动清除）
        // - pdFALSE：不需要等待所有的标志位，只需要 BIT_0 设置即可
        // - portMAX_DELAY：无限等待，直到标志位被设置
        EventBits_t bits_0 = xEventGroupWaitBits(xEventGroup, BIT_0, pdTRUE, pdFALSE, portMAX_DELAY);
        EventBits_t bits_1 = xEventGroupWaitBits(xEventGroup, BIT_1, pdTRUE, pdFALSE, portMAX_DELAY);

        // - (bits_0 & BIT_0)：检查从 xEventGroupWaitBits 返回的值中是否包含 BIT_0
        // - (bits_1 & BIT_1)：检查从 xEventGroupWaitBits 返回的值中是否包含 BIT_1
        if ((bits_0 & BIT_0)  && (bits_1 & BIT_1)) {
            printf("Task 2: Task 1 and Task 3 execute done! \n");
        }
    }
}

void vTask3(void *pvParameters) {
    (void) pvParameters;
    for( ;; ) {
        printf("Task 3: Setting BIT_1\n");
        // - xEventGroup：事件组句柄
        xEventGroupSetBits(xEventGroup, BIT_1); // 设置 BIT_1 标志，通知其他任务
        vTaskDelay(mainTask2_FREQUENCY_MS); // 模拟任务延时
    }
}

int main(void) {
    xEventGroup = xEventGroupCreate(); // 创建事件组

    if (xEventGroup != NULL) {
        xTaskCreate(vTask1, "Task1", configMINIMAL_STACK_SIZE, NULL, mainCOMMON_TASK_PRIORITY, NULL);
        xTaskCreate(vTask2, "Task2", configMINIMAL_STACK_SIZE, NULL, mainCOMMON_TASK_PRIORITY, NULL);
        xTaskCreate(vTask3, "Task3", configMINIMAL_STACK_SIZE, NULL, mainCOMMON_TASK_PRIORITY, NULL);
        vTaskStartScheduler(); // 启动调度器
    }

    for( ;; ) {
        // 代码不会到达这里
    }
}
