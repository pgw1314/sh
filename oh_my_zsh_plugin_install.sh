#!/bin/bash
#############################################################
#
#功能： 该脚本是用来安装oh-my-zsh的插件
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
    if [[ $? != 0 ]]; then
        print_r "下载错误：autojump下载失败!"
        exit
    fi
    python /tmp/autojump/install.py
    if [[ $? != 0 ]]; then
        print_r "错误：autojump插件安装失败!"
        exit
    fi
    rm -rf $autojump_path
}


syntax_highlighting_plugin_install(){
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    if [[ $? != 0 ]]; then
        print_r "错误：syntax-highlighting插件安装失败!"
        exit
    fi
}

autosuggestions_plugin_install(){
    git clone git://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions
    if [[ $? != 0 ]]; then
        print_r "错误：autosuggestions插件安装失败!"
        exit
    fi
}





#判断是否安装zsh
is_install=$(cat /etc/shells |grep zsh)
if [[ -z $is_install ]]; then
    print_r "请先运行oh_my_zsh_install，安装oh-my-zsh!"
    exit
fi

#--------------------------插件安装-------------------------------------------
print_y "开始安装autojump插件...."
autojump_plugin_install
print_g "autojump插件安装完成！"

print_y "开始安装syntax-highlighting插件...."
syntax_highlighting_plugin_install
print_g "syntax-highlighting插件安装完成！"

print_y "开始安装autosuggestions插件...."
autosuggestions_plugin_install
print_g "autosuggestions插件安装完成！"

#--------------------------配置-------------------------------------------
print_y "开始安装配置oh-my-zsh..."
$(cat ./conf/zshrc  > ~/.zshrc )
source ~/.zshrc
print_g "oh-my-zsh配置完成！"





