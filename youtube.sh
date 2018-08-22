#!/bin/bash
#############################################################
#
#功能： 该脚本是用来将视频上传到YouTube
#
#版本：v0.0.1
#
#最后修改时间：2018年8月22日
#
#############################################################
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
#引入脚本
#打印模块
. ./funs/m_print.sh
#常用函数模块
. ./funs/m_utils.sh

#上传的视频格式
types=("mp4" "mkv" "avi" "wmv")

#----------------------------函数定义开始----------------------------------------

#-------------------------------------------------
#函数名称： 获取视频的参数
#   
#功能：获取上传YouTube视频所需的参数
#-------------------------------------------------
#
read_arg(){
    print_y "请输入视频的名称的前缀!上传格式：[前缀]文件名"
    read pre_title 
    print_y "请输入视频的描述："
    read desc
    print_y "请输入视频的标签：格式：标签1,标签2"
    read tags
    print_y "请输入视频的播放列表：播放列表名称如果没有则自动创建！"
    read play_list

}
#-------------------------------------------------
#函数名称： 打印使用帮助文档
#   
#功能：打印使用帮助文档
#-------------------------------------------------
helper(){
        #statements
        print_r "--功能："
        print_g "----将文件夹内格式为${types[*]}格式的文件上传到YouTube "
        print_r "--使用格式："
        print_g "        youtube  文件目录1  文件目录2 ....  "
        print_r "--参数说明："
        print_g "----文件目录：要上传到YouTube的视频所在目录"
        print_r "--示例："
        print_g "        youtube /home/download/qsh /home/download/shiji "
        exit
}
#-------------------------------------------------
#函数名称： 上传文件
#
#参数：文件路径 视频标题  视频标题前缀
#   
#功能：将文件上传到YouTube
#-------------------------------------------------
upload(){
    file_path=$1
    title=$2
    pre_title=$3
    #判断文件路径是否为空
    is_null "上传文件名不能为空！！" y $1
    print_y "开始上传：$file_path"
    `youtube-upload -t "$pre_title$title:=" -d "$desc" --tags "$tags" --playlist  "$play_list" $file_path `
    print_g "上传成功：$file_path"
}
#-------------------------------------------------
#函数名称： 准备上传
#   
#功能：准备上传所需的数据
#-------------------------------------------------
pre_upload(){
    file_path=$1"/"$2
    #获取文件类型和文件名
    get_file_type $2
    get_file_name $2
    #判断是有标题前缀
    if [[ -n $pre_title ]]; then
        pre_title="[$pre_title]"
    fi
    #判断是否要上传的格式
    for type in ${types[@]}; do
        if [[ $file_type == $type ]]; then
            upload $file_path $file_name $pre_title
        fi
    done
}
#-------------------------------------------------
#函数名称： 遍历文件夹
#   
#功能：如果是文件夹的话读取文件列表
#-------------------------------------------------
read_dir(){
    path=$1
    ls $path | while read file; do
        if [ -d $path"/"$file ]  #注意此处之间一定要加上空格，否则会报错
        then
            read_dir $path"/"$file
        else
           pre_upload $path $file
        fi
    done
}

#----------------------------函数定义结束----------------------------------------
#如果灭有传任何参数则打印使用文档
if [[ -z $1 || $1 == "-h"  ]]; then
    helper
    exit
fi
#获取视频上传所需要的参数
read_arg 
#判断路径是否带/
check_path_last_char $1
#判断是否是文件夹
is_dir $path
if [[ $? == 0 ]]; then
        #遍历文件夹内容
        read_dir $path
    else
        slip_path $path
        pre_upload $file_path $file_name

fi


