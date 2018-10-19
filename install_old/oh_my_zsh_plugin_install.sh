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
. ~/sh/funs/m_print.sh
. ~/sh/funs/m_utils.sh
#-------------------------------------------------
#函数名称： 安装autojump插件
#   
#功能：给oh-my-zsh安装autojump插件
#   
#-------------------------------------------------
autojump_plugin_install(){
    rm -rf ./autojump
    git clone git://github.com/joelthelion/autojump.git $autojump_path
    if [[ $? != 0 ]]; then
        print_r "下载错误：autojump下载失败!"
        exit
    fi
    cd ./autojump
    # exit
    ./install.py
    if [[ $? != 0 ]]; then
        print_r "错误：autojump插件安装失败!"
        exit
    fi
    cd -
    rm -rf ./autojump
}

#-------------------------------------------------
#函数名称： 安装syntax_highlighting插件
#   
#功能：给oh-my-zsh安装syntax_highlighting插件
#   
#-------------------------------------------------
syntax_highlighting_plugin_install(){
    syntax_highlighting_path=${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
   sudo  rm -rf $syntax_highlighting_path
    sudo git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $syntax_highlighting_path
    if [[ $? != 0 ]]; then
        print_r "错误：syntax-highlighting插件安装失败!"
        exit
    fi
}
#-------------------------------------------------
#函数名称： 安装autosuggestions插件
#   
#功能：给oh-my-zsh安装autosuggestions插件
#   
#-------------------------------------------------
autosuggestions_plugin_install(){
    autosuggestions_path=$ZSH_CUSTOM/plugins/zsh-autosuggestions
   sudo  rm -rf $autosuggestions_path
   sudo  git clone git://github.com/zsh-users/zsh-autosuggestions $autosuggestions_path
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
# exit
print_y "开始安装syntax-highlighting插件...."
syntax_highlighting_plugin_install
print_g "syntax-highlighting插件安装完成！"

print_y "开始安装autosuggestions插件...."
autosuggestions_plugin_install
print_g "autosuggestions插件安装完成！"

#--------------------------配置-------------------------------------------
print_y "开始安装配置oh-my-zsh..."
mv ~/.zshrc ~/.zshrc.bak
$(cat ~/sh/conf/zshrc > ~/.zshrc )
#source ~/.zshrc
print_g "oh-my-zsh配置完成！"





