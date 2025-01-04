/*
    freeRTOS 按键事件demo
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

#define mainQUEUE_LENGTH                   ( 2 )
#define mainBUTTON_TASK_PRIORITY    ( tskIDLE_PRIORITY + 1 )
#define mainBUTTON_ACTION_TASK_PRIORITY    ( tskIDLE_PRIORITY + 2 )
#define mainBUTTON_TASK_FREQUENCY_MS          pdMS_TO_TICKS( 50UL )
#define mainBUTTON_ACTION_FREQUENCY_MS        pdMS_TO_TICKS( 10UL )

static QueueHandle_t xQueue = NULL;
#define BUTTON_PIN 0  // 假设按键连接到 GPIO Pin 0

void vTaskButton(void *pvParameters) {
    ( void ) pvParameters;

    // 初始化按键引脚
    // 引脚逻辑
    char message[32] = {0};
    snprintf(message, sizeof(message), "Button Pressed");
    TickType_t xLastWakeTime = xTaskGetTickCount(); //记录上次唤醒时间
    const TickType_t xBlockTime = mainBUTTON_TASK_FREQUENCY_MS; //任务执行频率
    for( ; ; ) 
    {
        if (access("/tmp/press_buttom", F_OK) == 0) { // 判断是否按下按键
            remove("/tmp/press_buttom");

            // - xQueue: 要发送消息的队列句柄
            // - &message: 要发送的消息内容的指针
            // - 0U: 发送消息时的阻塞时间，这里设置为 0，表示立即返回，不阻塞
            xQueueSend(xQueue, &message, 0U);  // 按键按下，发送消息

            // - &xLastWakeTime: 上次任务唤醒的时间，用于计算延迟时间
            // - xBlockTime: 当前任务延迟时间，单位是 tick，表示去抖动时长
            vTaskDelayUntil(&xLastWakeTime, xBlockTime);  // 去抖动 50 毫秒,避免误认为按键被多次按下
        }

        // - &xLastWakeTime: 上次任务唤醒的时间，用于计算延迟时间
        // - mainBUTTON_ACTION_FREQUENCY_MS: 每次读取按键的间隔时间
        vTaskDelayUntil(&xLastWakeTime, mainBUTTON_ACTION_FREQUENCY_MS);  // 读取间隔
    }
}

void vTaskButtonAction(void *pvParameters) {
    char message[32];

    ( void ) pvParameters;

    for( ; ; ) 
    {
        if (xQueueReceive(xQueue, &message, portMAX_DELAY)) { //从队列中接收信息 portMAX_DELAY表示无线阻塞
            // 执行按键操作
            console_print( "Button pressed: %s\n", message );
        }
    }
}

int main(void) {
    xQueue = xQueueCreate(mainQUEUE_LENGTH, sizeof(char[32]));
    
    if( xQueue != NULL ) {
        xTaskCreate(vTaskButton, "Button Task", configMINIMAL_STACK_SIZE, NULL, mainBUTTON_TASK_PRIORITY, NULL);  // 创建按键读取任务
        xTaskCreate(vTaskButtonAction, "Button Action Task", configMINIMAL_STACK_SIZE, NULL, mainBUTTON_ACTION_TASK_PRIORITY, NULL);  // 创建按键处理任务
        vTaskStartScheduler();  // 启动调度器
    }

   // 不会到达这里
   for( ; ; )
   {
   }
}