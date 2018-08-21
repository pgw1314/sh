#!/bin/bash



#引入脚本
. ./funs/m_print.sh
. ./funs/m_utils.sh


#----------------------------函数定义开始----------------------------------------
#-------------------------------------------------
#函数名称： 帮助文档
#   
#功能：打印该脚本的使用方法
#   
#-------------------------------------------------
hellper(){
        #statements
        print_r "--功能："
        print_g "---给文件或文件夹重命名！"
        print_r "--使用格式："
        print_g "         rename 文件路径 匹配  替换 替换模式 编号  繁简体转换 递归 "
        print_r "--参数："
        print_g "----文件路径：要重命名的文件所在目录"
        print_g "----匹配：匹配要替换的字符串，该匹配为全局匹配（支持正则表达式）"
        print_g "----替换：替换匹配的字符串，如果替换为空使用传入_del "
        print_g "----替换模式：为y是替换文件，不传或为n是显示替换信息 "
        print_g "----编号：如果编号传n，如果编号则传入开始数值！ "
        print_g "----繁简体转换：为y是则繁体转换为简体，为n或不传是不转换！ "
        print_g "----递归：如果为y则重命名子目录中的所有文件，为n或不传是不递归！ "

        print_r "  示例："
        print_g "         rename /home/download \"[0-9]*\" \"aa\"  y 1 n n "
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
        old_file=$file
        old_path=$path"/"$file
        
        #替换文件名中的空格
        new_path=`echo $path | sed "s/ /_/g"`
        new_file=`echo $file | sed "s/ /_/g"`
        #获取文件名和文件类型
        get_file_name $new_file
        new_file=$file_name
        get_file_type $file
       
        #判断是否繁简体转换
        if [[ (-n $fj) && ($fj == "y")]]; then
           new_file=`echo $new_file | opencc -c t2s`
        fi
        
        #判断匹配字符串和替换字符串是否为空
        new_file=`echo $new_file | sed "s/$pp/$th/g"`
    
        #判断是否为文件标号
        if [[ $bh =~ ^-?[0-9]+$ ]]; then
            if [[ $bh -lt 10 ]]; then
                    new_file="0"$bh"-"$new_file
            else
                  new_file=$bh"-"$new_file
            fi
            #增加索引
            bh=`expr $bh + 1`

        fi
        #新文件夹路径和新文件名
        if [[ -n $file_type ]]; then
                new_file=$new_file"."$file_type
        fi
        new_path=$new_path"/"$new_file
}
#-------------------------------------------------
#函数名称：预览模式
#   
#功能：打印重命名文件的信息
#   
#-------------------------------------------------
preview(){
            echo  "------------------------------------------------------------------------"
            print_r "原文件名：$old_file"
            print_g "新文件名：$new_file "
            print_y "文件格式：$file_type "
            if [[ (-n $fj) && ($fj == "y") ]]; then
                print_g "繁简体转换：开启 "
            else
                print_r "繁简体转换：关闭 "
            fi
            print_r "原文件路径：$old_path"
            print_g "新文件路径：$new_path"
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
    path=$1
    #检查路径是否最后是否带/
    check_path_last_char $path
    ls $path | while read file; do
        #准备新文件名数据
        pre_data $path $file
  
        #为y则重命名否则为预览模式
        if [[ (-n $thms) && ($thms == "y")]]; then
                rename "$old_path" "$new_path"
            else
                preview
        fi
        #判断是否递归
        if [[ (-n $dg) && ($dg == "y") ]]; then
            if [[ -d $new_path ]]; then
                    #echo "递归"
                read_dir $new_path
            fi
            
        fi
    done
}

#----------------------------函数定义结束----------------------------------------

#----------------------------主程序开始----------------------------------------

    #判断参数列表是否为空
    if [[ -z $1 || $1 == "-h"  ]]; then
        hellper
        exit
    fi
    #初始化参数
     #匹配
    pp=$2
    #替换
    th=$3
    #替换模式
    thms=$4
    #编号
    bh=$5
    #繁简体转换
    fj=$6
    #递归
    dg=$7
    
    
    #替换空格文件名
    if [[ -z $pp ]]; then
        #statements
        pp=" "
    fi
    if [[ ($pp == "y") && ( -z $th)  ]]; then
        #statements
        pp=" "
        th="_"
        thms="y"
    fi

    #获取文件列表
    read_dir $1



    