#!/bin/bash
#############################################################
#
#功能： 该脚本是用来安装ffmpeg
#
#版本：v1.0.2
#
#应用平台：Centos7、CentOS6
#
#最后修改时间：2018年10月19日
#
#############################################################

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
#判断是否已经安装了！
 ffmpeg -h
 if [[ $? == 0 ]]; then
     print_g $Info "ffmpeg已安装！"
 fi

#安装rpm包
#判断系统版本
isCenos7=`cat /etc/redhat-release | grep 7.`
isCenos6=`cat /etc/redhat-release | grep 6.`
#Centos7安装
if [[ -n "$isCenos7" ]]; then
    # echo "Centos 7"
    sudo rpm --import http://li.nux.ro/download/nux/RPM-GPG-KEY-nux.ro
    sudo rpm -Uvh http://li.nux.ro/download/nux/dextop/el7/x86_64/nux-dextop-release-0-5.el7.nux.noarch.rpm
fi
#Centos6安装
if [[ -n "$isCenos6" ]]; then
    # echo "Centos 6"
    sudo rpm --import http://li.nux.ro/download/nux/RPM-GPG-KEY-nux.ro
    sudo rpm -Uvh http://li.nux.ro/download/nux/dextop/el6/x86_64/nux-dextop-release-0-2.el6.nux.noarch.rpm

fi
#开始安装
sudo yum install ffmpeg ffmpeg-devel -y
if [[ $? == 0 ]]; then
     print_g $Info "ffmpeg安装成功！"
 else
    print_r $Error 'ffmpeg安装失败！'
fi


