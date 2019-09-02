#!/bin/bash
#############################################################
#
#功能： 该脚本是用来批量将视频进行转码
#
#版本：v1.0.2
#
#最后修改时间：2018年8月22日
#
#############################################################

#引入脚本
#引入打印模块
source /Users/xiaowei/Code/sh/include/printer.sh

#-------------------------------------------------
#函数名称： 获取视频转换所需的参数
#  
#功能：获取视频转换所需的参数
#-------------------------------------------------
read_args(){

    #判断是否是文件，如果是文件则可以获取到文件格式则不需要输入

    read_args_file_type=${1##*.}
    if [[ -f $1 && $read_args_file_type != $1 ]]; then
            g_in_type=$read_args_file_type
        else
             print_y "请输入要转换的视频格式 ：多个格式用空格分割"
            read g_in_type 

    fi

    print_y "请输入新的视频格式： "
    read g_to_type

    
    print_y "请输入转换参数：如果为空则直接回车 "
    read g_trans_args
    
    print_y "是否剪辑：如果剪辑请输入开始时间（不剪辑直接回车） "
    read g_start_time
    if [[ -n $g_start_time ]]; then
        print_y "请输入剪辑的时长：如果不输入则到影片结尾 "
        read g_time
    fi

    print_y "转换完成目录：将转换完成文件放到该目录(默认：原文件路径-新视频格式 例：/root/shiji-mp4) "
    read g_to_path

    print_y "是否删除源文件：默认不删除，输入y则删除 "
    read g_is_del
    
}

#-------------------------------------------------
#函数名称： 预览
#
#功能：完成所有参数后预览效果
#-------------------------------------------------
preview(){
    echo "-----------------预览按回车（Enter）开始转换 按Ctrl+C 取消--------------------------"
    print_y "要转换的文件格式：$g_in_type "
    print_r "新文件格式：$g_to_type "
    if [[ -z $g_start_time ]]; then
        print_r "剪辑模式：关闭 "
    else
        print_y "剪辑开始时间：$g_start_time "
        if [[ -n $g_time ]]; then
            print_y "剪辑时长：$g_time "
        fi
    fi
    #print_r "转换完成目录：$to_path "
    if [[ -z $g_is_del ]]; then
        print_y "是否删除源文件：不删除 "
    else
        print_r "是否删除源文件：删除 "
    fi
    echo "-------------------------------------------------------------------------------------"

    read abc

    
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
#函数名称： 文件转码
#   
#参数： 源文件路径 新的文件路径 截取开始时间 转码参数 截取结束时间
#
#功能：文件转码
#-------------------------------------------------
trans_file(){
    
    # print_y "开始转码：$g_old_file_path "
    #判断是否要剪辑影片
    #构建命令
    if [[ -z $g_start_time ]]; then
        trans_cmd="ffmpeg -y -i $g_old_file_path $g_trans_args $g_new_file_path"
     else
     #判断结束时间
        if [[ -z $g_time ]]; then
            trans_cmd="ffmpeg -y -ss $g_start_time -i $g_old_file_path $g_trans_args $g_new_file_path"
        else
            trans_cmd="ffmpeg -y -ss $g_start_time -t $g_time -i $g_old_file_path $g_trans_args $g_new_file_path"
        fi 
    fi
    # print_y "转码命令：" $trans_cmd
    #将命令写入到临时文件中
    echo "\$($trans_cmd)" >> $g_cmd_file
    # if [[ $? == 0 ]]; then
    #         print_g "转码成功：$g_new_file_path"
    #     else
    #         print_r "转码失败：$g_new_file_path"
    #         exit
    # fi

}
#-------------------------------------------------
#函数名称： 准备转换
#
#参数：文件路径  文件名
#   
#功能：做转换前的准备工作
#-------------------------------------------------
pre_trans(){

    pre_trans_path=$1
    pre_trans_file=$2
    #保存原路径
    g_old_file_path=$1/$2
    is_file=$3
    #获取到文件类型和文件名
    pre_trans_file_type=${pre_trans_file##*.}
    if [[ $pre_trans_file_type == $pre_trans_file ]]; then
        pre_trans_file_type=''
    fi
    pre_trans_ile_name=${pre_trans_file%.*}

    #遍历要转换的文件格式
    for in_type in $g_in_type; do
        #查看该文件格式是否匹配
        if [[ $pre_trans_file_type == $in_type ]]; then
            # 获取新的文件路径
            # get_new_file_path $is_file
            ##构建输出路径
            #判断是否转换单个文件
            if [[ -n $is_file  ]]; then
                # 文件判断输出路径是否为空
                if [[ -n $g_to_path ]]; then
                    pre_trans_new_file_path=$g_to_path/$pre_trans_ile_name.$g_to_type
                else
                    pre_trans_new_file_path=$pre_trans_path/new_$pre_trans_ile_name.$g_to_type
                fi
                
            else
                # 目录判断输出路径是否为空
                if [[ -n $g_to_path ]]; then
                    #创建格式代格式的文件夹
                    
                    pre_trans_new_file_path=$g_to_path/$pre_trans_ile_name.$g_to_type
                else
                    new_to_path=$pre_trans_path-$g_to_type
                    mkdir -p $new_to_path
                    pre_trans_new_file_path=$new_to_path"/$pre_trans_ile_name.$g_to_type"
                fi
            fi 
            g_new_file_path=$pre_trans_new_file_path

            #开始转码
            trans_file
            # #判断是否删除源文件
            if [[ $g_is_del == "y" ]]; then
                   $(rm -rf $g_old_file_path)
                   print_y "删除文件：$g_old_file_path"
            fi
            
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
        read_dir_file_path=$read_dir_path/$read_dir_file
        if [[ -d $read_dir_file_path ]]; then
            read_dir $ead_dir_file_path
        else
            pre_trans $read_dir_path $read_dir_file
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

 print_y "开始准备转码命令...."
 #准备命令文件
 g_cmd_file=/tmp/trans_cmd.sh
 rm -rf $g_cmd_file
 echo "#!/bin/bash" > $g_cmd_file

 #遍历传入的所有文件名
 for g_path in $@ ; do
    
    #去除路径带/
    g_path=${g_path%/}
    #去除文件空格
    rename $g_path " " "_" y n n y

    #判断是否是文件夹
    if [[ -d $g_path ]]; then
            #遍历文件夹内容
            read_dir $g_path
        else
            # 分解路径和文件名
            file_path=${g_path%/*}
            file_name=${g_path##*/}

            pre_trans $file_path $file_name y

    fi
 done
 print_g "转码命令如下：执行请按Enter，取消请按Ctrl+C"
 cat $g_cmd_file
 read aa
 print_y "开始转码，请耐心等待！"
 #执行命令文件
 $(bash $g_cmd_file)
 print_g "转码完成，再见！！！"



