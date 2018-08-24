#!/bin/bash
#############################################################
#
#功能： 该脚本是用来将所有的脚本移动到系统目录
#
#版本：v1.0.2
#
#最后修改时间：2018年8月23日
#
#############################################################

#引入脚本
. ~/sh/funs/m_print.sh
. ~/sh//funs/m_utils.sh

Error="[错误]:"
Info="[信息]："

get_os_type
if [[ $os_type != 2 ]]; then
    print_r $Error '抱歉，你的系统不支持！！'
    exit
fi

 ffmpeg -h
 if [[ $? == 0 ]]; then
     print_g $Info "ffmpeg已安装！"
 fi

#安装rpm包
sudo rpm --import http://li.nux.ro/download/nux/RPM-GPG-KEY-nux.ro
sudo rpm -Uvh http://li.nux.ro/download/nux/dextop/el7/x86_64/nux-dextop-release-0-5.el7.nux.noarch.rpm
#开始安装
sudo yum install ffmpeg ffmpeg-devel -y
if [[ $? == 0 ]]; then
     print_g $Info "ffmpeg安装成功！"
 else
    print_r $Error 'ffmpeg安装失败！'
    exit
fi


