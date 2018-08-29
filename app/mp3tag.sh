#!/bin/bash
#############################################################
#
#功能： 该脚本是用来批量替换MP3的歌手专辑信息的！
#
#版本：v1.0.2
#
#最后修改时间：2018年8月22日
#
#############################################################

#----------------------------函数定义开始----------------------------------------

print_r(){
    echo -e "\033[31m $@ \033[0m"
}
print_g(){
    echo -e "\033[32m $@ \033[0m"
}
print_y(){
    echo -e "\033[33m $@ \033[0m"
}
Error="[错误]:"
Info="[信息]："

Rep_Tag(){

    file_path=$1
    file=$2
    file_path_name=$1/$2
    #保存原路径
    #获取到文件类型和文件名
    file_type=${file##*.}
    if [[ $file_type == $file ]]; then
        file_type=''
    fi
    file_name=${file%.*}


    #查看该文件格式是否匹配
    if [[ $file_type == "mp3" ]]; then
        print_y $Info "开始替换：$file_name"
        t=${file_name##*-}
        title=${t%.*}
        songer=${file%-*}
       #print_y "--------------------pre_trans 变量列表---------------------"
        # print_g "file_path=$file_path"
        # print_g "file_name=$file_name"
        # print_g "file_type=$file_type"
        #print_g "file_path_name=$file_path_name"
        # print_g "file=$file"
          # # #   print_g "pre_trans_new_file_path=$pre_trans_new_file_path"

         #print_y "------------------------------------------------------"
        #  rm -rf $file_path_name
        # ffmpeg -i ./周杰伦-开不了口.mp3 -metadata  album="开不了口" -metadata title="开不了口" -metadata artist=周杰伦  tmp.mp3
        ffmpeg -i $file_path_name -metadata  album=$title -metadata title=$title -metadata artist=$songer $file_path/tmp.mp3
        if [[ $? == 0 ]]; then
                rm -rf $file_path_name
                mv $file_path/tmp.mp3 $file_path_name
                print_g $Info "替换完成：$file_name"
                rm -rf $file_path/tmp.mp3
            else
                print_r $Error "替换失败:$file_name"
                exit
        fi
        
    fi

}


#-------------------------------------------------
#函数名称： 遍历文件夹
#   
#功能：如果是文件夹的话读取文件列表
#-------------------------------------------------
Read_Dir(){
    /usr/local/bin/myrename $1 " " "_" y n n y

    for file in `ls $1`
    do  
        file_path=$1"/"$file
        if [ -d $file_path ]
        then 
            Read_Dir $file_path
        else
            Rep_Tag $1 $file
        fi  
    done
}

#----------------------------主程序开始----------------------------------------

 #遍历传入的所有文件名
 for g_path in $@ ; do
    
    #去除路径带/
    g_path=${g_path%/}


    #判断是否是文件夹
    if [[ -d $g_path ]]; then
            #遍历文件夹内容
            Read_Dir $g_path
        else
            # 分解路径和文件名
            file_path=${g_path%/*}
            file_name=${g_path##*/}
            #  print_y "--------------------init_arg变量列表---------------------"
            # print_g "file_path=$file_path"
            # print_g "file_name=$file_name"
            # print_y "------------------------------------------------------"
            Rep_Tag $file_path $file_name 

    fi
 done



