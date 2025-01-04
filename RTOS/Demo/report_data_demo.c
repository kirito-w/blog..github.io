/*
    freeRTOS 整理上报事件demo
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
#include "string.h"

#define mainQUEUE_LENGTH                   ( 2 )
#define mainSENSOR_READ_TASK_PRIORITY    ( tskIDLE_PRIORITY + 1 )
#define mainPROCESS_TASK_PRIORITY    ( tskIDLE_PRIORITY + 2 )
#define mainUPDATE_DATA_FREQUENCY_MS          pdMS_TO_TICKS( 1000UL )
#define STRING_SIZE  64

static QueueHandle_t xQueue = NULL;

// 模拟传感器读取任务
/*
xQueueSend(xQueue, &message, portMAX_DELAY)：
   任务会阻塞，直到队列有空间来接收消息，适合需要确保消息成功发送的场景。
xQueueSend(xQueue, &message, 0U)：
   非阻塞发送，如果队列已满，则立即返回，不阻塞，适合不希望任务等待的场景。
*/
void vTaskSensorRead(void *pvParameters) {
    ( void ) pvParameters;

    char message[STRING_SIZE] = "{\"result\":\"0\", \"data\" : {\"cpu\":\"23%\", \"version\":\"v1.0\"}}";  // 固定长度的字符串
    TickType_t xLastWakeTime = xTaskGetTickCount();
    const TickType_t xBlockTime = mainUPDATE_DATA_FREQUENCY_MS;
    for( ; ; ) 
    {
        if (xQueueSend(xQueue, &message, portMAX_DELAY) != pdPASS) {  //在队列已满时会阻塞任务，直到队列中有空间来接受新的数据
            printf("Failed to send message to queue\n");
        }

        vTaskDelayUntil(&xLastWakeTime, xBlockTime);  // 每1秒采集一次，周期性任务使用
    }
}

// 数据处理任务
void vTaskProcessData(void *pvParameters) {
    char message[STRING_SIZE];

    ( void ) pvParameters;

    for( ; ; ) 
    {
        if (xQueueReceive(xQueue, &message, portMAX_DELAY)) {
            // 处理数据
            console_print("Sensor Data: %s\n", message);
        }
    }
}

int main(void) {
    xQueue = xQueueCreate(mainQUEUE_LENGTH, sizeof(char[STRING_SIZE]));

    if( xQueue != NULL ) 
    {
        xTaskCreate(vTaskSensorRead, "Sensor Read Task", configMINIMAL_STACK_SIZE, NULL, mainSENSOR_READ_TASK_PRIORITY, NULL);  // 创建传感器读取任务
        xTaskCreate(vTaskProcessData, "Process Data Task", configMINIMAL_STACK_SIZE, NULL, mainPROCESS_TASK_PRIORITY, NULL);  // 创建数据处理任务
        vTaskStartScheduler();  // 启动调度器
    }


   // 不会到达这里
    for( ; ; )
    {
    }
}