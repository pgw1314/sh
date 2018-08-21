#!/bin/bash
#############################################################
# 该脚本是用来安装所有脚本的
#############################################################
#引入脚本
. ./funs/m_print.sh
. ./funs/m_utils.sh

#-------------------------------------------------
#函数名称： 遍历文件夹
#   
#功能：如果是文件夹的话读取文件列表
#-------------------------------------------------
read_dir(){
    path=$1
    ls $path | while read file; do
        if [ -d $path"/"$file ]  
        then
            read_dir $path"/"$file
        else
            print_r $path $file
        fi
    done

}



# done
#将所有代码拷贝到/usr/local/shell
sudo cp -r ./ /usr/local/shell
#列出所有的