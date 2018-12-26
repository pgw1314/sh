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
print_y(){
    echo -e "\033[33m $@ \033[0m"
}
print_r(){
    echo -e "\033[31m $@ \033[0m"
}
print_g(){
    echo -e "\033[32m $@ \033[0m"
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


Error="[错误]:"
Info="[信息]："
 
#判断系统类型
get_os_type
if [[ $os_type != 2 ]]; then
    print_r $Error '抱歉，你的系统不支持！！'
    exit
fi

print_g $Info"开始安装Python3.6..."
sudo yum install epel-release -y
if [[ $? != 0 ]]; then
    print_r $Error 'epel-release安装错误！'
    exit
fi
sudo yum install https://centos7.iuscommunity.org/ius-release.rpm -y
if [[ $? != 0 ]]; then
    print_r $Error 'Yum源安装错误！'
    exit
fi
sudo yum install python36u -y
if [[ $? != 0 ]]; then
    print_r $Error 'Python3.6源安装错误！'
    exit
fi
sudo ln -s /bin/python3.6 /bin/python3
if [[ $? != 0 ]]; then
    print_r $Error 'Python3.6创建连接错误！'
    exit
fi
print_g $Info"开始安装pip3..."
sudo yum install python36u-pip -y
if [[ $? != 0 ]]; then
    print_r $Error 'pip安装错误！'
    exit
fi
sudo ln -s /bin/pip3.6 /bin/pip3
if [[ $? != 0 ]]; then
    print_r $Error 'pip创建连接错误！'
    exit
fi
print_g $Info"恭喜Python3.6和pip3安装完成！！"

