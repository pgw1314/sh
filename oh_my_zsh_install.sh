#!/bin/bash
#############################################################
#
#功能： 该脚本是用来安装oh-my-zsh
#
#版本：v1.0.1
#
#最后修改时间：2018年8月23日
#
#############################################################


#引入脚本
. ./funs/m_print.sh
. ./funs/m_utils.sh

autojump_plugin_install(){
    autojump_path=/tmp/autojump
    git clone git://github.com/joelthelion/autojump.git $autojump_path
    $autojump_path/install.py
    if [[ $? != 0 ]]; then
        print_r "错误：autojump插件安装失败!"
        exit
    fi
    rm -rf $autojump_path
}


mac_install(){
    #检查是否安装brew
    sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
    if [[ $? != 0  ]]; then
        print_r "安装失败：oh-my-zsh"
        exit
    fi

}

linux_install(){
    yum -y install zsh
   sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
    if [[ $? != 0  ]]; then
        print_r "安装失败：oh-my-zsh"
        exit
    fi
    
}


#判断是否安装zsh
is_install=$(cat /etc/shells |grep zsh)
if [[ -n $is_install ]]; then
    print_g "你的系统已经安装好了oh-my-zsh!"
    exit
fi

print_y "开始安装oh-my-zsh...."
#判断系统类型
get_os_type
if [[ $os_type == 1 ]]; then
    mac_install
elif [[ $os_type == 2 ]]; then
    linux_install
fi
print_g "oh-my-zsh安装完成！"
print_y "开始安装autojump插件...."
autojump_plugin_install
print_g "autojump插件安装完成！"


print_y "开始安装配置oh-my-zsh..."
$(cat ./conf/zshrc  > ~/.zshrc )
print_g "oh-my-zsh配置完成"





