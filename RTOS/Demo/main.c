/*
FreeRTOS的两种启动流程
*/

/*
第一种
*/
int main (void)
 {
    /* 硬件初始化 */
    HardWare_Init();

    /* RTOS 系统初始化 */
    RTOS_Init();

    /* 创建一个任务 */
    RTOS_TaskCreate(AppTaskCreate);

    /* 启动RTOS，开始调度 */
    RTOS_Start();

    // 不会走到这里
    for( ; ; )
    {
    }
 }

 /* 起始任务，在里面创建任务 */
 voidAppTaskCreate( void *arg )
 {
    /* 创建任务1，然后执行 */
    RTOS_TaskCreate(Task1);

    /* 当任务1阻塞时，继续创建任务2，然后执行 */
    RTOS_TaskCreate(Task2);

    /* ......继续创建各种任务 */

    /* 当任务创建完成，删除起始任务 */
    RTOS_TaskDelete(AppTaskCreate);
 }

 void Task1( void *arg )
 {
    while (1)
    {
        /* 任务实体，必须有阻塞的情况出现 */
    }
 }

 void Task2( void *arg )
 {
    while (1)
    {
        /* 任务实体，必须有阻塞的情况出现 */
    }
 }


/*
第二种
*/
 int main (void)
 {
    /* 硬件初始化 */
    HardWare_Init();

    /* RTOS 系统初始化 */
    RTOS_Init();

    /* 创建任务，但任务不会执行，因为调度器还没有开启
    RTOS_TaskCreate(Task);

    /* ......创建各种任务 */

    /* 启动RTOS，开始调度 */
    RTOS_Start();

    // 不会走到这里
    for( ; ; )
    {
    }
 }

 voidTask1( void *arg )
 {
    while (1)
    {
        /* 任务实体，必须有阻塞的情况出现 */
    }
 }
