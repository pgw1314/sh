#!/bin/bash
#############################################################
#
#功能： 该脚本是用来安装Python3.6
#
#版本：v1.0.2
#
#应用平台：Centos7
#
#最后修改时间：2018年10月19日
#
#############################################################
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
#---------------------打印模块---------------------


Print_Error(){
    echo -e "\033[31m [错误]: $@ \033[0m"
}
Print_Info(){
    echo -e "\033[32m [信息]: $@ \033[0m"
}
#---------------------------------------------------


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


 
#判断系统类型
get_os_type
if [[ $os_type != 2 ]]; then
    Print_Error '抱歉，你的系统不支持！！'
    exit
fi

Print_Info "开始安装Python3.6..."
sudo yum install epel-release -y
if [[ $? != 0 ]]; then
    Print_Error 'epel-release安装错误！'
    exit
fi
sudo yum install https://centos7.iuscommunity.org/ius-release.rpm -y
if [[ $? != 0 ]]; then
    Print_Error 'Yum源安装错误！'
    exit
fi
sudo yum install python36u -y
if [[ $? != 0 ]]; then
    Print_Error 'Python3.6源安装错误！'
    exit
fi
sudo ln -s /bin/python3.6 /bin/python3
if [[ $? != 0 ]]; then
    Print_Error 'Python3.6创建连接错误！'
    exit
fi
Print_Info "开始安装pip3..."
sudo yum install python36u-pip -y
if [[ $? != 0 ]]; then
    Print_Error 'pip安装错误！'
    exit
fi
sudo ln -s /bin/pip3.6 /bin/pip3
if [[ $? != 0 ]]; then
    Print_Error 'pip创建连接错误！'
    exit
fi
Print_Info "恭喜Python3.6和pip3安装完成！！"

