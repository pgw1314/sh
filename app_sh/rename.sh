#!/bin/bash
#############################################################
#
#功能： 该脚本是用来批量给文件重命名
#
#版本：v1.0.2
#
#最后修改时间：2018年8月23日
#
#############################################################


#引入脚本
. ~/sh/funs/m_print.sh
. ~/sh/funs/m_utils.sh


#----------------------------函数定义开始----------------------------------------
#-------------------------------------------------
#函数名称： 帮助文档
#   
#功能：打印该脚本的使用方法
#   
#-------------------------------------------------
hellper(){
        #statements
        print_r "  功能："
        print_g "      给文件或文件夹重命名！"
        print_r "  使用格式："
        print_g "         rename 文件路径 匹配  替换 替换模式 编号  繁简体转换 日志 "
        print_r "  参数："
        print_g "      文件路径：要重命名的文件所在目录"
        print_g "      匹配：匹配要替换的字符串，该匹配为全局匹配（支持正则表达式）"
        print_g "      替换：替换匹配的字符串，如果替换为空使用传入_del "
        print_g "      替换模式：为y是替换文件，不传或为n是显示替换信息 "
        print_g "      编号：如果编号传n，如果编号则传入开始数值！ "
        print_g "      繁简体转换：为y是则繁体转换为简体，为n或不传是不转换！ "
        print_g "      日志：如果为y则不显示文件重命名日志，为n或不传是则显示日志！ "

        print_r "  示例："
        print_g "         rename /home/download \"[0-9]*\" \"aa\"  y 1 n n "
}

build_new_name(){
        g_old_file_name=$1
        # #获取文件名和文件类型
        g_file_type=${1##*.}
        if [[ $g_file_type == $g_old_file_name ]]; then
            g_file_type=''
        fi

        # 获取文件名
        b_n_n_file_name=${1%.*}
        # #判断是否繁简体转换
        if [[ $g_is_trans_name == "y" ]]; then
            # 判断是否安装了OpenCC如果没有安装则安装
            opencc --version
            if [[ $? != 0 ]]; then
                $(opencc_install)
            fi
           old_b_n_n_file_name=$b_n_n_file_name
           b_n_n_file_name=$(echo $b_n_n_file_name | opencc -c t2s)
           if [[ $? != 0 ]]; then
            b_n_n_file_name=$old_b_n_n_file_name
            print_y "错误：文件名转换为简体错误！！"
           fi
        fi
        
        # #判断匹配字符串和替换字符串是否为空
        g_new_file_name=$(echo $b_n_n_file_name | sed "s/$g_pattern/$g_match/g")

}


#-------------------------------------------------
#函数名称：重命名
#   
#参数：旧的文件路径  新的文件路径
#   
#功能：将文件重命名
#   
#-------------------------------------------------
rename_file(){
    #判断路径是否为空
    if [[  -n $1 &&  -n $2 ]]; then
        #判断两个路径是否一样
        if [[ $1 != $2 ]]; then
        #判断文件是否存在
            if [[ -e $1 ]]; then
                if [[ -z $g_is_log ]]; then
                    print_y "开始重命名文件：$1"
                fi
                
                $(mv "$1" "$2")
                if [[ $? == 0 ]]; then
                    if [[ -z $g_is_log ]]; then
                        print_g "重命名完成：$2"
                    fi
                else
                    print_r "错误：$1重命名失败！！"
                fi
            else
                print_r "错误：$1文件或目录不存在！！"
            fi

        fi
        
    else
        print_r "错误：重命名原文件路径和新文件路径都不能为空！"
    fi
    
}

#-------------------------------------------------
#函数名称：准备数据
#   
#参数：文件路径  文件名
#   
#功能：准备新文件名数据 
#   
#-------------------------------------------------
pre_data(){

        pre_data_path=$1
        pre_data_file=$2
        #原文件路径
        g_old_file_path=$1"/"$2

        
        
        # #替换文件名中的空格
        # pre_data_new_path=$(echo "$pre_data_path" | sed "s/ /_/g")
        #pre_data_new_file=$(echo "$pre_data_file" | sed "s/ /_/g")    
        # pre_data_new_file_path=$pre_data_new_path/$pre_data_new_file

        # #构建新的文件名b_n_n_new_file_name
        build_new_name $(echo "$pre_data_file" | sed "s/ /_/g")
        pre_data_new_file_name=$g_new_file_name
       
        # #判断是否为文件标号
        if [[ $g_number =~ ^-?[0-9]+$ ]]; then
            if [[ $g_number -lt 10 ]]; then
                    pre_data_new_file_name="0"$g_number"-"$pre_data_new_file_name
            else
                  pre_data_new_file_name=$g_number"-"$pre_data_new_file_name
            fi
            #增加索引
            g_number=`expr $g_number + 1`

        fi
        #新的文件路径
        if [[ -z $g_file_type ]]; then
                g_new_file_path=$pre_data_path/$pre_data_new_file_name
             else
                g_new_file_path=$pre_data_path/$pre_data_new_file_name.$g_file_type
        fi
        # print_y "--------------------pre_data 变量列表---------------------"
        # print_g "pre_data_path=$pre_data_path"
        # print_g "pre_data_file=$pre_data_file"
        # print_y "pre_data_new_file_path=$pre_data_new_file_path"

        # print_g "pre_data_file_path=$pre_data_file_path"
        # print_y "pre_data_file_type=$pre_data_file_type"
        # print_r "pre_data_new_path=$pre_data_new_path"
        # print_r "pre_data_new_file=$pre_data_new_file"
        # print_r "pre_data_new_file_path=$pre_data_new_file_path"
        # print_y "------------------------------------------------------"
        # #新文件夹路径和新文件名
        # if [[ -n $file_type ]]; then
        #         new_file=$new_file"."$file_type
        # fi
        # new_path=$new_path"/"$new_file
}
#-------------------------------------------------
#函数名称：预览模式
#   
#功能：打印重命名文件的信息
#   
#-------------------------------------------------
preview(){
            echo  "------------------------------------------------------------------------"
            print_r "原文件名：$g_old_file_name"
            print_g "新文件名：$g_new_file_name "
            print_y "文件格式：$g_file_type "
            if [[ $g_is_trans_name == "y" ]]; then
                print_g "将文件名转换为简体：开启 "
            else
                print_r "将文件名转换为简体：关闭 "
            fi
            print_r "原文件路径：$g_old_file_path"
            print_g "新文件路径：$g_new_file_path"
            echo  "------------------------------------------------------------------------" 
}

#-------------------------------------------------
#函数名称：遍历文件列表
#   
#参数：1
#   
#功能：递归读取目录中的文件
#   
#-------------------------------------------------
read_dir(){
    read_dir_path=$1
    #检查路径是否最后是否带/
   # print_g "read_dir_path=$read_dir_path"
    ls $read_dir_path | while read read_dir_file; do
        read_dir_file_path="$read_dir_path/$read_dir_file"
        # print_y "--------------------read_dir 变量列表---------------------"
        # print_g "read_dir_path=$read_dir_path"
        # print_g "read_dir_file=$read_dir_file"
        # print_y "------------------------------------------------------"
        # return
        # #准备新文件名数据
         pre_data "$read_dir_path" "$read_dir_file"
         ##开始重命名文件
         if [[  $g_is_rep == "y" ]]; then
                rename_file "$g_old_file_path" "$g_new_file_path"
             else
                if [[ -z $g_is_log ]]; then
                    preview
                fi
                
         fi
        
  
        # #为y则重命名否则为预览模式
        # if [[ (-n $g_is_rep) && ($g_is_rep == "y")]]; then
        #         rename "$old_path" "$new_path"
        #     else
        #         preview
        # fi
        # print_g "read_dir_file_path=$read_dir_file_path"
        # #判断是否递归
        # if [[ $g_is_tree == "y" ]]; then
            # if [[ ! -f "$read_dir_file_path" ]]; then
            #         #echo "递归"
            #     # print_y "--------------------递归 变量列表---------------------"
            #     # print_r "read_dir_file_path=$read_dir_file_path"
            #     # print_y "------------------------------------------------------"
            #     read_dir "$read_dir_file_path"
            # fi
            
        # fi
    done
}

#----------------------------函数定义结束----------------------------------------

init_arg(){
    # 参数个数
    g_arg_num=$#
    #初始化参数
    g_path=${1%/}
     #匹配模式
    g_pattern=$2
    #替换字符串
    g_match=$3
    #是否替换
    g_is_rep=$4
    #编号
    g_number=$5
    #繁简体转换
    g_is_trans_name=$6
    #递归
    # g_is_tree=$7
    #是否打印log
    g_is_log=$7
    #旧的文件路径
    g_old_file_path=''
    #新的的文件路径
    g_new_file_path=''
    # 旧的文件名
    g_old_file_name=''
    # 新的文件名
    g_new_file_name=''
    #文件类型
    g_file_type=''

    
    #默认替换空格文件名,如果匹配模式等于空
    if [[ $g_pattern == "y" && $g_arg_num -eq 2 ]]; then
        #statements
        g_pattern=" "
        g_match="_"
        g_is_rep="y"
    fi
    # print_y "--------------------init_arg变量列表---------------------"
    # print_g "g_arg_num=$g_arg_num"
    # print_g "g_path=$g_path"
    # print_g "g_pattern=$g_pattern"
    # print_g "g_match=$g_match"
    # print_g "g_is_rep=$g_is_rep"
    # print_g "g_number=$g_number"
    # print_g "g_is_trans_name=$g_is_trans_name"
    # print_g "g_is_log=$g_is_log"
    # print_y "------------------------------------------------------"

}

#----------------------------主程序开始----------------------------------------

    #判断参数列表是否为空
    if [[ -z $1 || $1 == "-h"  ]]; then
        hellper
        exit
    fi
    init_arg "$@"

    #获取文件列表
    read_dir $g_path



    