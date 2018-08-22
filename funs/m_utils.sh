#!/bin/bash
#############################################################
#
#功能： 该脚本为函数库！放置常用的函数
#
#版本：v1.0.1
#
#最后修改时间：2018年8月22日
#
#############################################################


#-------------------------------------------------
#函数名称： 获取字符在字符串中最后出现的位置
#
#参数：字符串  字符
#   
#功能：获取字符在字符串中最后出现的位置
#
#返回值：字符最后出现的位置
#-------------------------------------------------
get_last_char_index(){
	tmp=$(echo $1 | sed "s/\(.*$2\)\(.*\)/\1/")
	return ${#tmp}
}


#-------------------------------------------------
#函数名称： 获取文件的类型
#
#参数： 文件名
#   
#功能：获取文件的类型
#
#返回值：file_type
#   
#-------------------------------------------------
get_file_type(){
    file_type=${1##*.}
 #    old_file=$file
 #    file=$1
    
	# #获取文件名结束的位置
	# get_last_char_index $file "\."
 #    #获取到后缀名
 #    index=$?
	# file_type=${file:$index:${#file}}


	# file=$old_file
	# unset index
}

#-------------------------------------------------
#函数名称： 获取文件名（去后缀）
#
#参数： 文件名
#   
#功能：获取文件的名称
#
#返回值：file_name
#   
#-------------------------------------------------
get_file_name(){
    file_name=${1##*/}
 #    file=$1
	# #获取文件名结束的位置
	# get_last_char_index $file "\."
 #    #获取到后缀名
 #    end=$?
    
 #    #判断是否是目录
 #    if [[ $end == ${#file} ]]; then
 #        file_name=$file
 #        else
 #        # echo "file="$file
 #        # echo "size="${#file}
 #        # echo "start="$start
 #        # echo "end="$end
 #         file_name=${file:0:(( $end -1 ))}
    # fi
	
}


#-------------------------------------------------
#函数名称：重命名
#   
#参数：旧的文件路径  新的文件路径
#   
#功能：将文件重命名
#   
#-------------------------------------------------
rename(){
    #echo "原文件名："$1
    #echo "新文件名："$2
    #判断路径是否为空
    if [[  -n $1 &&  -n $2 ]]; then
        #判断两个路径是否一样
        if [[ $1 != $2 ]]; then
        #判断文件是否存在
            if [[ -e $1 ]]; then
                print_y "开始重命名文件：$1"
                `mv "$1" "$2"`
                if [[ $? == 0 ]]; then
                    print_g "重命名完成：$2"
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
#函数名称： 检查路径是否最后是否带/
#   
#参数：路径
#
#功能：检查路径是否最后是否带/,如果带/则去掉/
#
#返回值：path   
#-------------------------------------------------
check_path_last_char(){
    path=$1
    last_char=${path:((${#path} - 1 )):${#path}}
    if [[ $last_char == "/" ]]; then
        path=${path:0:(( ${#path} - 1 ))}
    fi
}

#-------------------------------------------------
#函数名称： 替换文件名中的空格
#   
#参数：文件所在路径
#
#功能：将文件名中的空格替换为_
#
#返回值：new_path
#-------------------------------------------------
rename_blank(){
    o_path=$1
    new_path=`echo $1 | sed "s/ /_/g"`
    rename "$o_path" "$new_path"
}

#-------------------------------------------------
#函数名称： 判断值是否为空
#   
#参数：打印信息 是否结束脚本  值
#
#功能：判断值是否为空，如果为空打印信息
#-------------------------------------------------
is_null(){
    if [[ -z $3 ]]; then
        #打印信息
        print_r $1
        #判断是否结束脚本
        if [[ $2 == "y" ]]; then
            exit
        fi
    fi
}

#-------------------------------------------------
#函数名称： 判断是文件还是文件夹
#   
#参数： 路径
#
#功能：判断是文件还是文件夹
#-------------------------------------------------
is_dir(){
    if [[ -d $1 ]]; then
        return 0
    else
        return 1
    fi
}

#-------------------------------------------------
#函数名称： 分割目录和文件名
#   
#参数： 路径
#
#功能：分割目录和文件名
#
#返回值：file_path  file_name
#-------------------------------------------------
# slip_path(){
#     # p=$1
#     # get_last_char_index $p "\/"
#     # i=$?
#     # file_path=${p:0:(( $i - 1 ))}
#     # file_name=${p:$i:${#p}}
#     # file_path=${file_path%/*}
#     # file_name=${file_path##*/}
# }
#-------------------------------------------------
#函数名称： 文件转码
#   
#参数： 源文件路径 新的文件路径 截取开始时间 转码参数 截取结束时间
#
#功能：文件转码
#-------------------------------------------------
transing(){
    old_path=$1
    new_path=$2
    start_time=$3
    trans_args=$4
    time=$5
    
     # print_y "old_path=$old_path"
     # print_y "new_path=$new_path"
     # print_y "start_time=$start_time"
     # print_y "trans_args=$trans_args"
     # print_y "time=$time"
     # return
    print_y "开始转码：$old_path "
    
    #判断是否要剪辑影片
    #构建命令
    if [[ -z $start_time ]]; then
        cmd="ffmpeg -y -i $old_path $trans_args $new_path"
     else
     #判断结束时间
        if [[ -z $time ]]; then
            cmd="ffmpeg -y -ss $start_time -i $old_path $trans_args $new_path"
        else
            cmd="ffmpeg -y -ss $start_time -t $time  -i $old_path $trans_args $new_path"
        fi 
    fi
    print_y "转码命令：" $cmd
    echo $path
    #执行转码
    ` $cmd `
    if [[ $? == 0 ]]; then
            print_g "转码成功：$new_path"
        else
            print_r "转码失败：$old_path"
            exit
    fi

}
#-------------------------------------------------
#函数名称： 替换文件中的内容
#
#参数 文件路径 匹配模式 替换内容
#   
#功能：替换文件中的内容
#-------------------------------------------------
replase_file_content(){
    file_path=$1
    pattern=$2
    rep_con=$3
    #判断路径是否存在，是否为文件
    if [[ -n $file_path && -f $file_path ]]; then

        if [[ "$(uname)" == "Darwin" ]]; then
            # Mac OS X 操作系统
            #echo "Mac OS 操作系统"
             sed -i "" "s/$pattern/$rep_con/g" $file_path
        elif [[ "$(expr substr $(uname -s) 1 5)" == "Linux" ]]; then
            #echo "Linux 操作系统"
            sed -i "s/$pattern/$rep_con/g" $file_path
        else
            print_r "错误：你的系统不支持！！"
            exit
        fi

    fi
}