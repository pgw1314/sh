#!/bin/bash
#百度云的路径
bd_path='/GoogleDriver'
#GoogleDriver的路径
gd_path='/mnt/pgw1314/百度云'
#判断是否正在同步的临时文件
syncing_file="/www/wwwroot/dl.iwen.cf/bgSyncing"


#判断如果文件存在就说明正在同步中，退出当前程序
if [ -f "/www/wwwroot/dl.iwen.cf/bgSyncing" ]; then
    exit
fi
#开始同步
touch $syncing_file
#从GoogleDrive上传到百度云
/usr/bin/bypy syncup $gd_path $bd_path   -d
#从百度云上传到GoogleDriver
/usr/bin/bypy syncdown $bd_path $gd_path  -d
#同步完成后删除同步文件
rm -rf $syncing_file
