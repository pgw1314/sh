#!/bin/bash
#############################################################
#
#功能： 该脚本是用来安装Linux常用的应用
#
#版本：v1.0.1
#
#最后修改时间：2018年8月23日
#
#############################################################


#引入脚本
. ./funs/m_print.sh
. ./funs/m_utils.sh


i_cmake=''
i_git=''
i_wget=''
i_unzip=''

#-------------------------------------------------
#函数名称： 安装软件
#   
#功能：安装Linux常用的软件
#   
#-------------------------------------------------
install(){
    yum -y update

    yum -y install cmake
    if [[ $? == 0 ]]; then
        i_cmake=y
    fi

    yum -y install git
    if [[ $? == 0 ]]; then
        i_git=y
    fi

    yum -y install wget
    if [[ $? == 0 ]]; then
        i_wget=y
    fi

    yum -y install unzip
    if [[ $? == 0 ]]; then
        i_unzip=y
    fi


  
    
}
#-------------------------------------------------
#函数名称： 预览
#   
#功能：预览安装结果
#   
#-------------------------------------------------
preview(){

    echo "--------------------------安装列表------------------------------"
    if [[ -n $i_cmake ]]; then
        print_g "cmake  :安装成功"
    else
        print_r "cmake  :安装失败"
    fi

    if [[ -n $i_git ]]; then
        print_g "git    :安装成功"
    else
        print_r "git    :安装失败"
    fi

    if [[ -n $i_wget ]]; then
        print_g "wget   :安装成功"
    else
        print_r "wget   :安装失败"
    fi

    if [[ -n $i_unzip ]]; then
        print_g "unzip  :安装成功"
    else
        print_r "unzip  :安装失败"
    fi
    echo "---------------------------------------------------------------"
}

#---------------------------主程序开始-----------------------------------------
#判断系统类型
get_os_type
if [[ $os_type == 2 ]]; then
    install
    preview
else
    print_r "不好意思，该脚本不支持你的系统！"
fi

