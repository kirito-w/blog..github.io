```
#!/bin/sh

for mod in $(opkg list | cut -d ' ' -f1); do
        echo "$mod"
        res=$(opkg files $mod | grep board.json | xargs echo -n)
        [ "$(echo $res | grep board.json)" != "" ] && {
                echo "$mod" >> /tmp/wqj.log
        }
done
```