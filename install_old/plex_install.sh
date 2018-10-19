#!/bin/bash
#############################################################
#
#功能： 该脚本是用来安装plex的
#
#版本：v1.0.2
#
#最后修改时间：2018年8月23日
#
#############################################################
#引入脚本
. ~/sh/funs/m_print.sh
. ~/sh/funs/m_utils.sh

Error="[错误]:"
Info="[信息]："

wget https://downloads.plex.tv/plex-media-server/1.13.5.5332-21ab172de/plexmediaserver-1.13.5.5332-21ab172de.x86_64.rpm
if [[ $? != 0 ]]; then
    print_r $Error "rpm包下载失败！"
    exit
fi

sudo rpm -Uvh plexmediaserver-1.13.5.5332-21ab172de.x86_64.rpm

sudo systemctl enable plexmediaserver.service
sudo systemctl start plexmediaserver.service
if [[ $? != 0 ]]; then
    print_r $Error "Plex安装或启动失败！"
    exit
else
    print_g $Info "Plex安装并启动"
    rm -rf plexmediaserver-1.13.5.5332-21ab172de.x86_64.rpm
fi