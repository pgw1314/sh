#!/bin/bash



. ./funs/m_print.sh
. ./funs/m_utils.sh

transing(){
    old_path=$1
    new_path=$2
    start_time=$3
    trans_args=$4
    time=$5
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
    `$cmd`
    if [[ $? == 0 ]]; then
            print_g "转码成功：$new_path"
        else
            print_r "转码失败：$old_path"
            exit
    fi

}
old_path="/Users/xiaowei/tt/11-Shell编程基本概念.mp4"
new_path="/Users/xiaowei/tt/11.mp4"
start_time="00:00:04"
trans_args="-strict -2 '"
transing $old_path $new_path $start_time "$trans_args"

