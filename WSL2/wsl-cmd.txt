【查看】
wsl -l -v


【导入】
wsl --import 5018-ssd e:\5018-ssd D:\work\zz_tar\wsl2_u20_5018_single_ok_20230505.tar
wsl --import-in-place <Distro> <FileName>


【导出】
直接拷贝vhdx文件


【压缩vhdx】
进入容器后
fstrim -a -v

wsl --shutdown
diskpart
# open window Diskpart
select vdisk file="E:\5018-ssd\ext4.vhdx"
attach vdisk readonly
compact vdisk
detach vdisk
exit


【查看】
PS C:\Users\dev> wsl -l -v
  NAME           STATE           VERSION
* 5018-ssd       Stopped         2
  7981-ssd       Running         2
  5018-d         Running         2
  7981-d         Stopped         2
  5018-ipv6-c    Stopped         2

【进入虚拟机镜像】
wsl -d 7981-ssd
