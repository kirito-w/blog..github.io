/*
    freeRTOS 事件优先级demo
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

#define mainLOW_PRIORITY    ( tskIDLE_PRIORITY + 1 )
#define mainHIGH_PRIORITY    ( tskIDLE_PRIORITY + 3 )
#define mainHIGH_FREQUENCY_MS          pdMS_TO_TICKS( 1000UL )
#define mainLOW_DATA_FREQUENCY_MS          pdMS_TO_TICKS( 5000UL )

void vTaskHighPriority(void *pvParameters) {
    ( void ) pvParameters;

    TickType_t xLastWakeTime = xTaskGetTickCount();
    const TickType_t xBlockTime = mainHIGH_FREQUENCY_MS;
    for( ; ; ) 
    {
        console_print( "High priority task running\n" );
        vTaskDelayUntil(&xLastWakeTime, xBlockTime);  // 每 1 秒打印一次
    }
}

void vTaskLowPriority(void *pvParameters) {
    ( void ) pvParameters;

    TickType_t xLastWakeTime = xTaskGetTickCount();
    const TickType_t xBlockTime = mainLOW_DATA_FREQUENCY_MS;
    for( ; ; ) 
    {
        console_print( "Low priority task running\n");
        vTaskDelayUntil(&xLastWakeTime, xBlockTime);  // 每 5 秒打印一次
    }
}

int main(void) {
    xTaskCreate(vTaskHighPriority, "High Priority Task", configMINIMAL_STACK_SIZE, NULL, mainHIGH_PRIORITY, NULL);  // 高优先级任务
    xTaskCreate(vTaskLowPriority, "Low Priority Task", configMINIMAL_STACK_SIZE, NULL, mainLOW_PRIORITY, NULL);  // 低优先级任务
    vTaskStartScheduler();  // 启动调度器

    for( ; ; ) 
    {
    }  // 不会到达这里
}
