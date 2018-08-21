#!/bin/bash
#############################################################
# 该脚本是用来安装所有脚本的
#############################################################
#引入脚本
. ./funs/m_print.sh
. ./funs/m_utils.sh


shell_path=/usr/local/shell
bin_path=/usr/local/bin
temp_path=/tmp/shell
#-------------------------------------------------
#函数名称： 替换文件中的内容
#
#参数 文件路径 匹配模式 替换内容 输出
#   
#功能：替换文件中的内容
#-------------------------------------------------
replase_file_content(){
	file_path=$1
	pattern=$2
	rep_con=$3
	to_file_path=$4
	#判断路径是否存在，是否为文件
	if [[ -n $file_path && -f $file_path ]]; then
		#print_y "开始替换："$file_path
		# 判断是否备份
		if [[ -z $to_file_path  ]]; then
			to_file_path=$file_path
		fi
		#替换文件中的内容
		cat $file_path | while read line; do
				new_line=`echo $line | sed "s/$pattern/$rep_con/g"`
				echo "$new_line" >> $to_file_path
				#echo $new_line
		done
		#print_g "替换完成："$to_file_path
	fi
}
#-------------------------------------------------
#函数名称： 遍历文件夹
#   
#功能：如果是文件夹的话读取文件列表
#-------------------------------------------------
read_dir(){
    path=$1
    ls $path | while read file; do
    	file_path=$path"/"$file

    	#print_y "开始复制："$file_path
    	temp_file=$temp_path"/"$file
    	if [[ -d $file_path ]]; then
    		cp -r $file_path $temp_file
    	else
    		get_file_type $file_path
    		if [[ $file_type == "sh" ]]; then
    			#print_y "开始配置："$file_path
    			#替换文件路径
    			if [[ $2 == "rep"  ]]; then
    				replase_file_content $file_path ".\/funs" "\/usr\/local\/shell\/funs"  $temp_file
    			fi
    			#配置环境变量
    			if [[ $2 == "env"  ]]; then
    				print_y "开始配置环境变量：$file_path"
    				old_file_path=$file_path

    				slip_path $file_path
    				get_file_name $file_name
    				
    				sudo rm -rf $bin_path"/"$file_name
    				ln -s $old_file_path $bin_path"/"$file_name
    				print_g "环境变量配置完成：$file_path"
    			fi
    			#print_g "配置完成："$file_path
    		fi
        	
    	fi
    	#print_g "复制完成:"$temp_file
      
    done

}



# done
#将所有代码拷贝到/usr/local/shell
rm -rf $temp_path
#print_y "请输入管理员密码！"
sudo rm -rf $shell_path
mkdir -p $temp_path
if [[ $? != 0 ]]; then
	print_r "临时文件夹：$temp_path创建错误！"
fi
#cp -r ./ $temp_path
#print_g "将所有脚本复制到：$temp_path"
#替换引用文件路径
print_y "开始修复脚本中的引用路径..."
read_dir . rep
print_g "引用路径修复成功！"
print_y "开始复制脚本文件..."
sudo cp -r $temp_path /usr/local/
sudo chmod -R 755 $shell_path
if [[ $? == 0 ]]; then
	print_g "脚本文件复制完成！！"
else
	print_r "安装错误：安装失败！！"
fi
print_y "开始配置环境变量..."
read_dir $shell_path env
rm -rf $temp_path
print_g "脚本安装完成！！"

