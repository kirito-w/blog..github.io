
`可在 /lib/functions/procd.sh 此文件中确认是否支持 procd_add_reload_trigger 和 procd_add_raw_trigger`

## uci配置改变时reload
- procd_add_reload_trigger “uci 文件名”
例子
```
reload_service()
{
        echo "Explicitly restarting service, are you sure you need this?"
        stop
        start
}

service_triggers()
{
      procd_add_reload_trigger "uci-file-name"
}

当 /etc/config/uci-file-name的md5值改变时，触发reload操作
```


## 指定信号触发
- ubus call service event '{"type":"abcd","data":{}}'

例子：
```
在init脚本中添加 
service_triggers() {
   procd_add_raw_trigger "abcd" 1000 /etc/init.d/nc_trans restart
}

使用ubus call -t 3 service event '{"type":"abcd","data":{}}'
即可触发 service_triggers中 abcd对应的动作
```