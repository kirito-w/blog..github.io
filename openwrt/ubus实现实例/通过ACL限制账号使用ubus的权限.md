## 官方文档：
https://openwrt.org/docs/techref/ubus

## 实例：

在/usr/share/acl.d/目录下，
创建如下文件 xxx.json：
```
{
	"user": "obc",
	"access": {
		"network.interface": {
			"methods": [ "status" ]
		},
		"network.device": {
			"methods": [ "status" ]
		},
		"sysupgrade": {
			"methods": [ "system_fota_upgrade", "system_upgrade", "system_diff_upgrade" ]
		},
		"device_info": {
			"methods": [ "get_sta_list" ]
		}
	}
}

```