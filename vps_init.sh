#!/bin/bash
#############################################################
#
#功能： 该脚本是用来将VPS初始化，安装常用的软件
#
#版本：v1.0.1
#
#最后修改时间：2018年8月23日
#
#############################################################
Error="[错误]:"
sh_path=~/sh
install_sh_path=/tmp/install.sh
github_path=https://raw.githubusercontent.com/pgw1314/sh/master/install.sh
#下载安装脚本
curl -o $install_sh_path $github_path
if [[ $? != 0 ]]; then
    echo "$Error 安装脚本下载失败！"
    exit
fi

#运行安装脚本
$($install_sh_path)
if [[ $? != 0 ]]; then
    echo "$Error 安装脚本安装过程中出错了！"
    exit
fi

#安装基本软件
$($sh_path/bash_install.sh)
if [[ $? != 0 ]]; then
    echo "$Error 基本软件安装中出错了！"
    exit
fi

#安装opencc
$($sh_path/opencc_install.sh)
if [[ $? != 0 ]]; then
    echo "$Error Opencc安装中出错了！"
    exit
fi
# sh -c "$(curl -fsSL https://raw.githubusercontent.com/pgw1314/sh/master/install.sh)"

#安装youtube_upload_install
$($sh_path/youtube_upload_install.sh)
if [[ $? != 0 ]]; then
    echo "$Error youtube_upload_install安装中出错了！"
    exit
fi

#aria2
$($sh_path/aria2.sh)
if [[ $? != 0 ]]; then
    echo "$Error aria2安装中出错了！"
    exit
fi

#安装shadowsocksR
$($sh_path/shadowsocksR.sh)
if [[ $? != 0 ]]; then
    echo "$Error shadowsocksR安装中出错了！"
    exit
fi
#安装oh_my_zsh_install
$($sh_path/oh_my_zsh_install.sh)
if [[ $? != 0 ]]; then
    echo "$Error oh_my_zsh_install安装中出错了！"
    exit
fi

rm -rf $install_sh_path