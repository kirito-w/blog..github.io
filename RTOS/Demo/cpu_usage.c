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