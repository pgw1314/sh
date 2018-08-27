#!/bin/bash
#############################################################
#
#功能： 该脚本是用来将视频上传到YouTube
#
#版本：v1.0.2
#
#最后修改时间：2018年8月23日
#
#############################################################
#引入脚本
#打印模块
. ~/sh/funs/m_print.sh
. ~/sh/funs/m_utils.sh

#上传的视频格式
video_types=("mp4" "mkv" "avi" "wmv")

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
        print_r "  功能："
        print_g "      将文件夹内格式为${types[*]}格式的文件上传到YouTube "
        print_r "  使用格式："
        print_g "      youtube  文件目录1  文件目录2 ....  "
        print_r "  参数说明："
        print_g "      文件目录：要上传到YouTube的视频所在目录"
        print_r "  示例："
        print_g "      youtube /home/download/qsh /home/download/shiji "
        exit
}
#-------------------------------------------------
#函数名称： 上传文件
#
#参数：文件路径 视频标题  视频标题前缀
#   
#功能：将文件上传到YouTube
#-------------------------------------------------
upload_file(){
    #判断文件路径是否为空
    if [[ -z $1 || -z $2 ]]; then
        print_r "错误：文件路径和标题都不能为空！"
        return
    fi
    upload_file_path=$1
    upload_file_title=$2
    # print_y "开始上传：$upload_file_path"
    upload_file_cmd="youtube-upload -t '$upload_file_title' -d '$desc' --tags '$tags' --playlist  '$play_list' '$upload_file_path' "
    # echo "--------------------upload----------------------------------"
    # print_y "上传文件路径："$upload_file_path
    # print_g "上传标题    ："$upload_file_title
    # print_y "上传命令    ："$upload_file_cmd
    # echo "------------------------------------------------------"
    # return
    #执行上传命令
    echo "\$($upload_file_cmd)" >> $youtube_cmd
    # if [[ $? == 0 ]]; then
    #     #statements
    #     print_g "上传成功：$upload_file_path"
    #     else
    #     print_r "上传失败：$upload_file_path"
    #     exit
    # fi
    # print_g "上传成功：$upload_path"
}
#-------------------------------------------------
#函数名称： 准备上传
#   
#功能：准备上传所需的数据
#-------------------------------------------------
pre_upload(){
    pre_upload_path=$1  
    pre_upload_file=$2  
    pre_upload_file_path=$1"/"$2
    # echo "--------------------pre_upload变量列表----------------------------------"
    # print_y "pre_upload_path="$pre_upload_path
    # print_g "pre_upload_file="$pre_upload_file
    # print_y "pre_upload_file_path="$pre_upload_file_path
    # echo "------------------------------------------------------"
    # return
    #获取文件类型和文件名
    pre_upload_file_type=${pre_upload_file##*.}
    pre_upload_file_name=${pre_upload_file%.*}

    # echo "--------------------变量列表----------------------------------"
    # print_y "pre_upload_file_type="$pre_upload_file_type
    # print_g "pre_upload_file_name="$pre_upload_file_name
    # echo "------------------------------------------------------"
    # return
    #判断是有标题前缀
    if [[ -n $pre_title ]]; then
        pre_upload_pre_title="[$pre_title]"
    fi
    #构建标题前缀+文件名
    pre_upload_title=$pre_upload_pre_title$pre_upload_file_name
    # echo "--------------------pre_upload变量列表----------------------------------"
    # print_y "pre_upload_file_path="$pre_upload_file_path
    # print_y "pre_upload_pre_title="$pre_upload_pre_title
    # print_y "pre_upload_title="$pre_upload_title
    # print_y "pre_upload_file_type="$pre_upload_file_type
    # echo "------------------------------------------------------"
    # return
    #判断是否要上传的格式
    for pre_upload_type in ${video_types[@]}; do
        if [[ $pre_upload_file_type == $pre_upload_type ]]; then
            #  echo "--------------------pre_upload变量列表----------------------------------"
            # print_y "pre_upload_file_path="$pre_upload_file_path
            # print_y "pre_upload_pre_title="$pre_upload_pre_title
            # print_y "pre_upload_title="$pre_upload_title
            # print_y "pre_upload_file_type="$pre_upload_file_type
            # echo "------------------------------------------------------"
            # return
            upload_file "$pre_upload_file_path" "$pre_upload_title"
        fi
    done
}
#-------------------------------------------------
#函数名称： 遍历文件夹
#   
#功能：如果是文件夹的话读取文件列表
#-------------------------------------------------
read_dir(){
    read_dir_path=$1
    ls $read_dir_path | while read read_dir_file; do
        read_dir_file_path="$read_dir_path/$read_dir_file"
        if [ -d "$read_dir_file_path" ]  #注意此处之间一定要加上空格，否则会报错
        then
            read_dir $read_dir_file_path
        else
           pre_upload "$read_dir_path" "$read_dir_file"
        fi
    done
}

#----------------------------函数定义结束----------------------------------------
#如果灭有传任何参数则打印使用文档
if [[ -z $1 || $1 == "-h"  ]]; then
    helper
    exit
fi
old_path=$1
#去除路径后面的/
old_path=${old_path%*/}
#获取视频上传所需要的参数
read_arg 

#去除文件空格
/usr/local/bin/myrename $old_path " " "_" y n n y
#删除认证文件
rm -rf ~/.youtube-upload-credentials.json
# 准备命令文件
youtube_cmd=/tmp/youtube_cmd.sh
echo "#!/bin/bash" > $youtube_cmd
print_y "开始准备上传命令...."
# echo "--------------------参数列表----------------------------------"
# print_y "old_path="$old_path
# print_y "pre_title="$pre_title
# print_g "desc="$desc
# print_y "tags="$tags
# print_g "play_list="$play_list
# echo "------------------------------------------------------"
# exit
#判断是否是文件夹
if [[ -d $old_path ]]; then
        #遍历文件夹内容
        read_dir $old_path
    else
        slip_path=${old_path%/*}
        slip_name=${old_path##*/}
        pre_upload $slip_path $slip_name

fi
print_g "上传命令如下：执行请按Enter，取消请按Ctrl+C"
cat $youtube_cmd
read aa
#开始执行命令
print_y "开始上传....."
$(bash $youtube_cmd)
# echo "执行结果：$?"
rm -rf $youtube_cmd
print_y "上传完成....."


