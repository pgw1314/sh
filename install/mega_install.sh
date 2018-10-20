#!/bin/bash
#############################################################
#
#功能： 该脚本是用来安装MEGA网盘的命令行客户端
#
#版本：v1.0.2
#
#应用平台：Centos7、CentOS6
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
#配置文件路径
Config_Path=~/.megacmd.json
#命令所在路径
Cmd_Path=/usr/local/bin/megacmd

#判断系统类型
get_os_type
if [[ $os_type != 2 ]]; then
    print_r $Error '抱歉，你的系统不支持！！'
    exit
fi

#安装
Install(){
    #判断是否安装了
    if [[ -f ${Cmd_Path} &&  -f ${Config_Path} ]]; then
        print_g $Info"你已经安装了MEGA客户端，不需要再安装了！！"
        exit
    fi
    print_g $Info"开始安装MEGA..."
    sudo yum install -y go git
    git clone https://github.com/t3rm1n4l/megacmd.git
    cd megacmd
    #拷贝所需的文件到指定地方
    cp -r ./vendor/* /usr/lib/golang/src/
    mkdir -p /usr/lib/golang/src/github.com/t3rm1n4l/megacmd/client
    cp -r ./client/* /usr/lib/golang/src/github.com/t3rm1n4l/megacmd/client
    
    GOPATH=/tmp/ make
    if [[ $? != 0 ]]; then
        print_r $Error"编译错误，请检查"
        exit
    fi
    sudo  cp megacmd /usr/local/bin
    if [[ $? != 0 ]]; then
        print_r $Error"复制megacmd到/usr/local/bin错误，请检查"
        exit
    fi
    #写入配置文件
cat > ${Config_Path}<<-EOF
    {
        "User" : "MEGA_USERNAME",
        "Password" : "MEGA_PASSWORD",
        "DownloadWorkers" : 4,
        "UploadWorkers" : 4,
        "SkipSameSize" : true,
        "Verbose" : 1
    }
EOF
    
    print_g $Info"MEGA安装完成，请在${Config_Path}内填入用户名和密码！！"
    #删除源码文件
    cd .. 
    rm -rf ./megacmd
}
#卸载
Uninstall(){
    #判断是否安装了
    if [[ ! -f ${Cmd_Path} ]]; then
        print_r $Error"你没用安装MEGA客户端不需要卸载！！"
        exit
    fi
	read -p "你真的要删除Mega客户端吗? [Y/n] :" yn
	[[ -z "${yn}" ]] && yn="y"
	if [[ $yn == [Yy] ]]; then
		rm -rf ${Config_Path}
        sudo rm -rf ${Cmd_Path}
        if [[ $? == '0' ]]; then
            print_g $Info"MEGA卸载完成！"
        else
            print_r $Error"MEGA卸载中发生错误，请检查"
        fi
	fi
    
}


action=$1
if [[ -z "${action}" ]]; then
    Install
elif [[ "${action}" == "uninstall" ]]; then
    Uninstall
fi



