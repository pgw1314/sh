#!/bin/bash
#############################################################
#
#功能： 该脚本是用来安装OpenCC繁简体转换工具
#
#版本：v1.0.1
#
#最后修改时间：2018年8月23日
#
#############################################################


#引入脚本
. ~/sh/funs/m_print.sh
. ~/sh/funs/m_utils.sh
#-------------------------------------------------
#函数名称： Mac系统下安装Opencc
#   
#功能：Mac系统下安装Opencc
#-------------------------------------------------
mac_install(){
    #检查是否安装brew
    brew install cmake
    if [[ $? != 0 ]]; then
        print_r "安装错误：请先安装：brew"
        exit
    fi
    brew install opencc

}
#-------------------------------------------------
#函数名称： Linux系统下安装Opencc
#   
#功能：Linux系统下安装Opencc
#-------------------------------------------------
linux_install(){
    yum -y install cmake
    if [[ $? != 0 ]]; then
        print_r "安装错误：yum无法安装cmake!"
        exit
    fi
    yum -y install git

    yum -y install doxygen
    if [[ $? != 0 ]]; then
        print_r "安装错误：yum无法安装doxygen!"
        exit
    fi
    # 获取源码
    opencc_dir=/tmp/opencc
    rm -rf $opencc_dir
    git clone https://github.com/BYVoid/OpenCC $opencc_dir
    if [[ ! -d $opencc_dir ]]; then
        print_r "下载错误：OpenCC源码下载失败！"
        exit
    fi

    #开始编译安装
    cd $opencc_dir
    make
    if [[ $? != 0 ]]; then
        print_r "编译错误：请自己查找一下原因哦！"
        exit
    fi
    make install
    #如果安装成功删除源码文件
    if [[ $? == 0 ]]; then
        rm -rf $opencc_dir
    else
        print_r "安装错误：请自己查找一下原因哦！"
        exit
    fi
    #创建libopencc.so.2链接
    ln -s /usr/lib/libopencc.so.2 /usr/lib64/libopencc.so.2
    
}

#--------------------------主程序开始-----------------------------------
#判断是否已经安装了opencc
opencc --version
if [[ $? == 0 ]]; then
    print_g "你已经安装了OpenCC，尽情的使用吧！！"
    exit
fi


print_y "开始安装OpenCC...."
#判断系统类型
get_os_type
if [[ $os_type == 1 ]]; then
    mac_install
elif [[ $os_type == 2 ]]; then
    linux_install
fi
#判断opencc是否安装成功
opencc --version
if [[ $? != 0 ]]; then
    print_r "我也很抱歉，Opencc安装失败！！"
else
    print_g "Opencc安装成功，尽情的使用吧！！！！"
fi

