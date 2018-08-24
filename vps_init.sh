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

print_r(){
    echo -e "\033[31m $@ \033[0m"
}
print_g(){
    echo -e "\033[32m $@ \033[0m"
}
print_y(){
    echo -e "\033[33m $@ \033[0m"
}

Error="[错误]:"
Info="[信息]："
sh_path=~/sh
rm -rf $sh_path
# install_sh_path=/tmp/install.sh
github_path=https://raw.githubusercontent.com/pgw1314/sh/master/install.sh
#下载安装脚本
print_y "$Info 开始下载安装脚本..."
yum -y install wget
if [[ $? != 0 ]]; then
    print_r "$Error wget安装失败！"
    exit
fi
rm -rf ./install.sh
wget $github_path
if [[ $? != 0 ]]; then
    print_r "$Error 安装脚本下载失败！"
    exit
fi
print_g "$Info 安装脚本下载完成"


#运行安装脚本
#给安装脚本执行权限
print_y "$Info 开始执行安装脚本..."
chmod 755 ./install.sh
./install.sh
if [[ $? != 0 ]]; then
    print_r "$Error 安装脚本安装过程中出错了！"
    exit
fi
print_g "$Info 安装脚本执行完成"


#安装基本软件
print_y "$Info 开始安装基础软件包..."
$sh_path/base_install.sh
if [[ $? != 0 ]]; then
    print_r "$Error 基本软件安装中出错了！"
    exit
fi
print_g "$Info 基本软件安装完成"


#安装opencc
print_y "$Info 开始安装opencc软件包..."
$sh_path/opencc_install.sh
if [[ $? != 0 ]]; then
    print_r "$Error Opencc安装中出错了！"
    exit
fi
print_g "$Info opencc软件包安装完成"
# sh -c "$(curl -fsSL https://raw.githubusercontent.com/pgw1314/sh/master/install.sh)"

#安装youtube_upload_install
print_y "$Info 开始安装youtube-upload软件包..."
$sh_path/youtube_upload_install.sh
if [[ $? != 0 ]]; then
    print_r "$Error youtube_upload_install安装中出错了！"
    exit
fi
print_g "$Info youtube-upload软件包安装完成"

#aria2
print_y "$Info 开始安装aria2软件包..."
$sh_path/aria2.sh
if [[ $? != 0 ]]; then
    print_r "$Error aria2安装中出错了！"
    exit
fi
print_g "$Info aria2软件包安装完成"

#安装shadowsocksR
print_y "$Info 开始安装shadowsocksR软件包..."
$sh_path/shadowsocksR.sh
if [[ $? != 0 ]]; then
    print_r "$Error shadowsocksR安装中出错了！"
    exit
fi
print_g "$Info shadowsocksR软件包安装完成"


#安装oh_my_zsh_install
print_y "$Info 开始安装oh-my-zsh软件包..."
$sh_path/oh_my_zsh_install.sh
if [[ $? != 0 ]]; then
    print_r "$Error oh_my_zsh_install安装中出错了！"
    exit
fi
print_g "$Info oh-my-zsh软件包安装完成"






# 删除install文件
rm -rf ./install.sh
