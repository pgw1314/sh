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



#-------------------------------------------------
#函数名称： 打印红色
#
#参数：字符串
#   
#功能：在命令行中打印红色字体
#
#-------------------------------------------------
print_r(){
    echo -e "\033[31m $@ \033[0m"
}



#-------------------------------------------------
#函数名称： 打印绿色
#
#参数：字符串
#   
#功能：在命令行中打印绿色字体
#
#-------------------------------------------------
print_g(){
    echo -e "\033[32m $@ \033[0m"
}

#-------------------------------------------------
#函数名称： 打印黄色
#
#参数：字符串
#   
#功能：在命令行中打印黄色字体
#
#-------------------------------------------------
print_y(){
    echo -e "\033[33m $@ \033[0m"
}

#-------------------------------------------------
#函数名称： 获取操作系统类型
#
#   
#返回值：Mac=1  Linux=2 Other=3 
#-------------------------------------------------
get_os_type(){

    if [[ "$(uname)" == "Darwin" ]]; then
        # Mac OS X 操作系统
        #echo "Mac OS 操作系统"
         os_type=1
    elif [[ "$(expr substr $(uname -s) 1 5)" == "Linux" ]]; then
        #echo "Linux 操作系统"
        os_type=2
    else
        os_type=3
    fi

}

i_cmake=''
i_git=''
i_wget=''
i_unzip=''
i_gcc=''
i_gdb=''
i_gjj=''
i_vim=''
i_youtube_dl=''
i_screen=''
i_sshfs=''

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

    yum -y install gcc
    if [[ $? == 0 ]]; then
        i_gcc=y
    fi

    yum -y install gdb
    if [[ $? == 0 ]]; then
        i_gdb=y
    fi

    yum -y install gcc-c++   
    if [[ $? == 0 ]]; then
        i_gjj=y
    fi

    yum -y install vim 
    if [[ $? == 0 ]]; then
        i_vim=y
    fi

    yum -y install screen
    if [[ $? == 0 ]]; then
        i_screen=y
    fi

    yum -y install fuse-sshfs
    if [[ $? == 0 ]]; then
        i_sshfs=y
    fi

    sudo wget https://yt-dl.org/downloads/latest/youtube-dl -O /usr/local/bin/youtube-dl
    if [[ $? == 0 ]]; then
        sudo chmod a+rx /usr/local/bin/youtube-dl
        i_youtube_dl=y
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

    if [[ -n $i_gcc ]]; then
        print_g "gcc    :安装成功"
    else
        print_r "gcc    :安装失败"
    fi

    if [[ -n $i_gdb ]]; then
        print_g "gdb    :安装成功"
    else
        print_r "gdb    :安装失败"
    fi

    if [[ -n $i_gjj ]]; then
        print_g "c++    :安装成功"
    else
        print_r "c++    :安装失败"
    fi

    if [[ -n $i_vim ]]; then
        print_g "vim    :安装成功"
    else
        print_r "vim    :安装失败"
    fi
    if [[ -n $i_screen ]]; then
        print_g "screen    :安装成功"
    else
        print_r "screen    :安装失败"
    fi
    if [[ -n $i_sshfs ]]; then
        print_g "sshfs    :安装成功"
    else
        print_r "sshfs    :安装失败"
    fi

    if [[ -n $i_youtube_dl ]]; then
        print_g "youtube-dl :安装成功"
    else
        print_r "youtube-dl :安装失败"
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
