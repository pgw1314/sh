#!/bin/bash
#############################################################
# 该脚本是用来批量将视频上传到youtube中
#############################################################

#上传的视频格式
video_hz=("mp4" "mkv" "avi" "wmv")

#----------------------------函数定义开始----------------------------------------
#查找字符串最后出现的位置
point_index=0
get_last_index(){
	tmp=$(echo $1 | sed "s/\(.*$2\)\(.*\)/\1/")
	point_index=${#tmp}
}

#文件的后缀名
hz=""
#取到文件后缀名
get_hz(){
    file=$1
	#获取文件名结束的位置
	get_last_index $file "\."
    #获取到后缀名
	hz=${file:$point_index:${#file}}

}

#将文件名中的空格替换为_
remove_blank(){
    #替换文件名中的空格
	new_file=${file/ /_}
	new_file=`echo $file | sed "s/ /_/g"`
	if [[ $file != $new_file ]]; then
	    `mv "$path/$file" "$path/$new_file"`
	    file=new_file
	fi

}

#获取视频的参数
read_arg(){
    echo -e "\033[33m 请输入视频的名称的前缀!上传格式：[前缀]文件名 \033[0m"
    read title 
    echo -e "\033[33m 请输入视频的描述： \033[0m"
    read desc
    echo -e "\033[33m 请输入视频的标签：格式：标签1,标签2 \033[0m"
    read tags
    echo -e "\033[33m 请输入视频的播放列表：播放列表名称如果没有则自动创建！ \033[0m"
    read play_list

}
#----------------------------函数定义结束----------------------------------------

 function main(){
     #初始化参数
        path=$1
        title=$2
        desc=""
        tags=""
        play_list=""

        read_arg 
        
        #判断路径是否带/
        last_char=${path:((${#path} - 1 )):${#path}}
        if [[ $last_char == "/" ]]; then
            path=${path:0:(( ${#path} - 1 ))}
        fi
 

        ls $path | while read file; do
            remove_blank $file $path
            if [ -d $path"/"$file ]  #注意此处之间一定要加上空格，否则会报错
            then
                main $path"/"$file
            else
                #获取到文件后缀
                get_hz $file
                
                #判断文件类型
                for v_hz in ${video_hz[@]}; do
                	if [[ "$v_hz" == "$hz" ]]; then
                	    #   文件路径
                	    if [[ -d $path ]]; then
                	            file_path=$path"/"$file
                	            file_name=${file:0:(($point_index -1))}
                	        else
                	            file_path=$file
                	            get_last_index $path "\/"
                                file_name=${path:$point_index:${#path}}
                                get_last_index $file_name "\."
                                file_name=${file_name:0:(($point_index - 1))}
    
                	    fi
                		
                		#文件名
                		
                		echo -e "\033[33m 开始上传：$file_name \033[0m"
                		echo $file_path
                		`youtube-upload -t "["$title"]"$file_name -d "$desc" --tags "$tags" --playlist  "$play_list" $file_path`
                		echo -e "\033[32m 上传完成：$file_name \033[0m"
                	fi
                done

            fi
        done
    }   
    #读取第一个参数
    main $1