#!/bin/bash
#############################################################
# 该脚本是用来批量将视频进行转码
#############################################################


#引入脚本
#打印模块
. ./funs/m_print.sh
#常用函数模块
. ./funs/m_utils.sh

#----------------------------函数定义开始----------------------------------------



#-------------------------------------------------
#函数名称： 获取视频转换所需的参数
#  
#功能：获取视频转换所需的参数
#-------------------------------------------------
read_args(){
    file=$1
    #判断是否是文件，如果是文件则可以获取到文件格式则不需要输入
    get_file_type $file
    if [[ -f $file && -n $file_type ]]; then
        in_f_types=$file_type
    else
        print_y "请输入要转换的视频格式 ：多个格式用空格分割"
        read in_f_types 
        is_null "参数错误：转换的格式不能为空！" y $in_f_types
    fi
    

    print_y "请输入新的视频格式： "
    read to_type
    is_null  "参数错误：新文件格式不能为空！ " y $to_type
    
    print_y "请输入转换参数：如果为空则直接回车 "
    read trans_args
    
    
    print_y "是否剪辑：如果剪辑请输入开始时间（不剪辑直接回车） "
    read start_time
    if [[ -n $start_time ]]; then
        print_y "请输入剪辑的时长：如果不输入则到影片结尾 "
        read time
    fi
    
    print_y "转换完成目录：将转换完成文件放到该目录(默认：原文件路径-新视频格式 例：/root/shiji-mp4) "
    read to_path
    #初始化完成目录
    # if [[ -n $in_to_path ]]; then
    #     to_path=$in_to_path
    # else
    #     to_path=$1"-"$to_type
    # fi
    
    print_y "是否删除源文件：默认不删除，输入y则删除 "
    read is_del

}

#-------------------------------------------------
#函数名称： 预览
#
#功能：完成所有参数后预览效果
#-------------------------------------------------
preview(){
    if [[ -n $is_preview ]]; then
        return
    fi
    echo "-----------------预览按回车（Enter）开始转换 按Ctrl+C 取消--------------------------"
    print_y "要转换的文件格式：$in_f_types "
    print_r "新文件格式：$to_type "
    if [[ -z $start_time ]]; then
        print_r "剪辑模式：关闭 "
    else
        print_y "剪辑开始时间：$start_time "
        if [[ -n $time ]]; then
            print_y "剪辑时长：$time "
        fi
    fi
    #print_r "转换完成目录：$to_path "
    if [[ -z $is_del ]]; then
        print_y "是否删除源文件：不删除 "
    else
        print_r "是否删除源文件：删除 "
    fi
    echo "-------------------------------------------------------------------------------------"

    `read abc`
    is_preview="y"
    
}

#-------------------------------------------------
#函数名称： 打印使用帮助文档
#   
#功能：打印使用帮助文档
#-------------------------------------------------
helper(){
        #statements
        print_r "--功能："
        print_g "----给视频文件转码"
        print_r "--使用格式："
        print_g "trans  文件目录1  文件目录2 ....  "
        print_r "--参数说明："
        print_g "----文件目录：视频文件所在路径："

        print_r "--示例："
        print_g "trans /home/download/qsh /home/download/shiji "
        exit
}
#-------------------------------------------------
#函数名称： 初始化参数
#   
#功能：初始化要转换的视频格式列表和完成目录
#-------------------------------------------------
init_args(){
    path=$1
    #初始化要转换的视频格式列表
    f_types=($in_f_types)
    #判断路径是否带/
    check_path_last_char $path
    #初始化完成目录
    # if [[ -n $in_to_path ]]; then
    #     to_path=$in_to_path
    # else
    #     to_path=$path"-"$to_type
    # fi
    # `mkdir -p $to_path`
    
}

#-------------------------------------------------
#函数名称： 判断是否删除源文件
#   
#功能：判断是否删除源文件
#-------------------------------------------------
del_file(){
    if [[ (-n $is_del) && ( $is_del != "y") ]]; then
           `rm -rf $old_path`
    fi
}

#-------------------------------------------------
#函数名称： 构建新的文件路径
#
#参数：是否是文件
#-------------------------------------------------
get_new_file_path(){
    is_file=$1
    #判断是否转换单个文件
    if [[ -n $is_file  ]]; then
        # 文件判断输出路径是否为空
        if [[ -n $to_path ]]; then
            new_file_path=$to_path"/"$file_name"."$to_type
        else
            new_file_path=$file_path"/new_"$file_name"."$to_type
        fi
        
    else
        # 目录判断输出路径是否为空
        if [[ -n $to_path ]]; then
            new_file_path="$to_path/$file_name.$to_type"
        else
            #创建格式代格式的文件夹
            new_path=$file_path-$to_type
            if [[ ! -d $new_path ]]; then
                mkdir -p $new_path
            fi
            new_file_path=$new_path"/$file_name.$to_type"
        fi
    fi 
}
#-------------------------------------------------
#函数名称： 准备转换
#
#参数：文件路径  文件名
#   
#功能：做转换前的准备工作
#-------------------------------------------------
pre_trans(){
    # print_args "$@"
    # exit
    file_path=$1
    file_name=$2
    is_file=$3
    #保存原路径
    old_path=$file_path"/"$file_name
    #获取到文件类型和文件名
    get_file_type $file_name
    get_file_name $file_name
    #遍历要转换的文件格式
    for type in ${f_types[@]}; do
        #查看该文件格式是否匹配
        if [[ $file_type == $type ]]; then
            # 获取新的文件路径
            get_new_file_path $is_file

            # print_r "to_path=$to_path"
            # print_r "file_path=$file_path"
            # print_r "old_path=$old_path"
            # print_r "file_name=$file_name"
            # print_r "new_file_path=$new_file_path"
            # exit
        
            #开始转码
            transing "$old_path" "$new_file_path" "$start_time" "$trans_args" "$time"
            #判断是否删除源文件
            del_file
            
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
        if [ -d $path"/"$file ]  
        then
            read_dir $path"/"$file
        else
            pre_trans "$path" "$file"
        fi
    done

}

#----------------------------主程序开始----------------------------------------
 #检查文件名是否为空
 if [[ -z $1 || $1 == "-h" ]]; then
     helper
 fi
 #获取视频的参数
 read_args $1
 #预览
 preview 
 #遍历传入的所有文件名
 for path in $@ ; do
    #初始化参数
    init_args $path 
    #判断是否是文件夹
    if [[ -d $path ]]; then
            #遍历文件夹内容
            read_dir $path
        else
            slip_path $path
            pre_trans "$file_path" "$file_name" "y"

    fi
 done




