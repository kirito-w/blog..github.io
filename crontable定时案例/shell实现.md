# 添加定时任务
crontab -l > conf && echo "* * * * * hostname" >> conf && crontab conf && rm -f conf

# 使用 sed 实现定时任务的开启关闭
# 关闭定时任务
sed -i 's/\* \* \* \* \* hostname\b/#&/' /etc/crontabs/root

# 重新开启定时任务
sed -i 's/#\* \* \* \* \* hostname\b/* \* \* \* \* hostname/' /etc/crontabs/root