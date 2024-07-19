# Dynamic debug
- Dynamic debug允许内核开发者`动态使用或者关闭内核输出`。
- 可用于内核代码调试

## 添加调用栈和pr_debug示例：
```
diff -Naur a/include/linux/dynamic_debug.h b/include/linux/dynamic_debug.h
--- a/include/linux/dynamic_debug.h	2024-01-04 07:44:32.000000000 +0000
+++ b/include/linux/dynamic_debug.h	2024-01-04 08:13:38.000000000 +0000
@@ -54,6 +54,7 @@
 extern int ddebug_remove_module(const char *mod_name);
 extern __printf(2, 3)
 void __dynamic_pr_debug(struct _ddebug *descriptor, const char *fmt, ...);
+void __dynamic_pr_debug_stack(struct _ddebug *descriptor, const char *fmt, ...);
 
 extern int ddebug_dyndbg_module_param_cb(char *param, char *val,
 					const char *modname);
@@ -153,6 +154,10 @@
 	_dynamic_func_call(fmt,	__dynamic_pr_debug,		\
 			   pr_fmt(fmt), ##__VA_ARGS__)
 
+#define dynamic_pr_debug_stack(fmt, ...)				\
+	_dynamic_func_call(fmt,	__dynamic_pr_debug_stack,		\
+			   pr_fmt(fmt), ##__VA_ARGS__)
+
 #define dynamic_dev_dbg(dev, fmt, ...)				\
 	_dynamic_func_call(fmt,__dynamic_dev_dbg, 		\
 			   dev, fmt, ##__VA_ARGS__)
diff -Naur a/include/linux/printk.h b/include/linux/printk.h
--- a/include/linux/printk.h	2024-01-04 07:44:33.000000000 +0000
+++ b/include/linux/printk.h	2024-01-04 07:13:18.000000000 +0000
@@ -329,12 +329,16 @@
 /* dynamic_pr_debug() uses pr_fmt() internally so we don't need it here */
 #define pr_debug(fmt, ...) \
 	dynamic_pr_debug(fmt, ##__VA_ARGS__)
+#define pr_debug_stack(fmt, ...) \
+	dynamic_pr_debug_stack(fmt, ##__VA_ARGS__)	
 #elif defined(DEBUG)
 #define pr_debug(fmt, ...) \
 	printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_debug_stack(fmt, ...) 	
 #else
 #define pr_debug(fmt, ...) \
 	no_printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
+	pr_debug_stack(fmt, ...) 
 #endif
 
 /*
diff -Naur a/lib/dynamic_debug.c b/lib/dynamic_debug.c
--- a/lib/dynamic_debug.c	2024-01-04 07:44:32.000000000 +0000
+++ b/lib/dynamic_debug.c	2024-01-04 07:19:07.000000000 +0000
@@ -572,6 +572,12 @@
 }
 EXPORT_SYMBOL(__dynamic_pr_debug);
 
+void __dynamic_pr_debug_stack(struct _ddebug *descriptor, const char *fmt, ...)
+{
+	dump_stack();
+}
+EXPORT_SYMBOL(__dynamic_pr_debug_stack);
+
 void __dynamic_dev_dbg(struct _ddebug *descriptor,
 		      const struct device *dev, const char *fmt, ...)
 {
diff -Naur a/mm/util.c b/mm/util.c
--- a/mm/util.c	2024-01-04 07:44:48.000000000 +0000
+++ b/mm/util.c	2024-01-04 08:52:01.000000000 +0000
@@ -23,7 +23,7 @@
 #include <linux/processor.h>
 #include <linux/sizes.h>
 #include <linux/compat.h>
-
+#include <linux/kernel.h>
 #include <linux/uaccess.h>
 
 #include "internal.h"
@@ -571,7 +571,13 @@
 {
 	gfp_t kmalloc_flags = flags;
 	void *ret;
+	
+    pr_debug("%s: [%d]  kvmalloc_node size:%d,node:%d.\n",__func__,__LINE__,(int)size,node);
 
+    if(size == 4*1024)
+	{
+		pr_debug_stack("%s: [%d].\n",__func__,__LINE__);
+	}	
 	/*
 	 * vmalloc uses GFP_KERNEL for some internal allocations (e.g page tables)
 	 * so the given set of flags has to be compatible.

```

## 相关文档：
https://www.cnblogs.com/qiynet/p/17650530.html
https://blog.csdn.net/dachai/article/details/103807529
https://linux.laoqinren.net/kernel/kernel-dynamic-debug/