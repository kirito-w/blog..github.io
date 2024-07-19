## 将lan侧访问1.2.3.4的包转发到本地的指定端口：
```
config redirect 'auth_redirect'
    option target 'DNAT'  
    option src 'lan'      
    option dest 'wan'     
    option src_dip '1.2.3.4'        
    option proto 'tcp'              
    option dest_port '80'           
    option src_dport '80' 
```