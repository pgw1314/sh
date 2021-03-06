#!/bin/bash
#############################################################
#
#功能： 该脚本是用来用来安装youtube-upload工具
#
#版本：v1.0.1
#
#最后修改时间：2018年8月22日
#
#############################################################

#引入脚本
#---------------------打印模块---------------------
print_y(){
    echo -e "\033[33m $@ \033[0m"
}
print_r(){
    echo -e "\033[31m $@ \033[0m"
}
print_g(){
    echo -e "\033[32m $@ \033[0m"
}
#---------------------------------------------------


#-------------------------------------------------
#函数名称： 获取操作系统类型
#
#   
#返回值：Mac=1  Linux=2 Other=3 
#-------------------------------------------------
get_os_type(){

    if [[ "$(uname)" == "Darwin" ]]; then
        # Mac OS X 操作系统
        #echo "Mac OS 操作系统"
         os_type=1
    elif [[ "$(expr substr $(uname -s) 1 5)" == "Linux" ]]; then
        #echo "Linux 操作系统"
        os_type=2
    else
        os_type=3
    fi

}

loc_epel_path=~/sh/conf/epel.repo
sys_epel_path=/etc/yum.repos.d/epel.repo
tmp_path=/tmp/youtube_upload
#-------------------------------------------------
#函数名称： 安装环境
#   
#功能：安装环境
#-------------------------------------------------
install_env(){
	sudo yum -y install wget
	sudo yum -y install unzip

	pip -v
	if [[ $? != 0 ]]; then
		sudo yum -y install epel-release
		sudo yum -y install python-pip
		if [[ $? != 0 ]]; then
			# 将自己的epel.repo复制到系统中
			sudo mv $sys_epel_path $sys_epel_path.bak
			sudo mv $loc_epel_path $sys_epel_path


			sudo cp $loc_epel_path $sys_epel_path
			sudo yum -y install python-pip
			if [[ $? != 0 ]]; then
				print_r "错误：pip安装失败!"
				exit
			fi
		fi
	fi

}

#-------------------------------------------------
#函数名称： 安装扩展包
#   
#功能：安装Python 扩展包
#-------------------------------------------------
install_ext(){
	sudo pip install --upgrade pip
	# if [[ $? ]]; then
	# 	print_r "错误：pip更新失败!"
	# 	exit
	# fi
	sudo pip install --upgrade google-api-python-client 
	# if [[ $? ]]; then
	# 	print_r "错误：google-api-python-client 扩展包安装失败!"
	# 	exit
	# fi
	sudo pip install --upgrade oauth2client 
	# if [[ $? ]]; then
	# 	print_r "错误：oauth2client 扩展包安装失败!"
	# 	exit
	# fi
	sudo pip install --upgrade progressbar2
	# if [[ $? ]]; then
	# 	print_r "错误：progressbar2 扩展包安装失败!"
	# 	exit
	# fi

}
#-------------------------------------------------
#函数名称： 安装主程序
#   
#功能：安装youtube-upload主程序
#-------------------------------------------------
installing(){
	sudo mkdir -p $tmp_path
	if [[ $? != 0 ]]; then
		print_r "错误：临时文件创建失败!"
		exit
	fi
	rm -rf ./youtube-upload-master
	
	zip_path=$tmp_path/youtube-upload-master.zip
	wget -O $zip_path https://github.com/tokland/youtube-upload/archive/master.zip
	unzip $zip_path
	if [[ $? != 0 ]]; then
		print_r "错误：压缩文件解压失败"
		exit
	fi
	cd youtube-upload-master
	sudo python setup.py install
	if [[ $? != 0 ]]; then
		print_r "[错误]：youtube-upload 安装失败！"
		exit
	fi
	print_g "youtube-upload 安装成功！！请尽情的上传吧"
	cd -
	rm -rf $zip_path

	
}

#安装环境
install_env
#安装扩展包
install_ext
#安装主程序
installing
#删除缓存
rm -rf $tmp_path
rm -rf ./youtube-upload-master


