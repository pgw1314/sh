#!/bin/bash
#############################################################
#
#功能： 该脚本是用来将所有的脚本移动到系统目录
#
#版本：v1.0.2
#
#最后修改时间：2018年8月23日
#
#############################################################

print_r(){
    echo -e "\033[31m $@ \033[0m"
}
print_g(){
    echo -e "\033[32m $@ \033[0m"
}
print_b(){
    echo -e "\033[34m $@ \033[0m"
}
print_r(){
    echo -e "\033[33m $@ \033[0m"
}

Error="[错误]:"
Info="[信息]："

shell_path=/usr/local/shell
bin_path=/usr/local/bin
temp_path=/tmp/shell

install_sh=(
    rename.sh
    trans.sh
    youtube.sh
    )
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
            print_r  $Error "错误：你的系统不支持！！"
            exit
        fi

	fi
}
#-------------------------------------------------
#函数名称： 遍历文件夹
#   
#功能：如果是文件夹的话读取文件列表
#-------------------------------------------------
read_dir(){
    my_path=$1
    ls $my_path | while read file; do
    	file_path=$my_path"/"$file

    	#print_r $Info  "开始复制："$file_path
    	temp_file=$temp_path"/"$file
    	if [[ -d $file_path ]]; then
    		cp -r $file_path $temp_file
    	else
            #判断该脚本是否安装
            is_install=''
            for i_sh in ${install_sh[@]}; do
                # echo $i_sh
                if [[ $i_sh == $file ]]; then
                    is_install=y
                fi
            done
            # echo $file"  is_install=$is_install"
            #如果文件不在install_sh中则跳过
            if [[ -z $is_install ]]; then
                continue
            fi
    		file_type=${file_path##*.}
    		if [[ $file_type == "sh" ]]; then
    			#print_r $Info  "开始配置："$file_path
    			#替换文件路径
    			if [[ $2 == "rep"  ]]; then
                    # echo "-------------------------------------"
                    # print_g $Info "file_path=$file_path"
                    # print_g $Info "temp_file=$temp_file"
                    # print_g $Info "file=$file"
                    # echo "-------------------------------------"
                    #复制脚本
                    cp $file_path $temp_file
                    #替换函数库路径
    				replase_file_content $temp_file ".\/funs" "\/usr\/local\/shell\/funs"  
        #             #替换配置文件路径
                    replase_file_content $temp_file ".\/conf" "\/usr\/local\/shell\/conf"  
        #             #替换配置文件路径
                    replase_file_content $temp_file ".\/rename.sh" "\/usr\/local\/shell\/rename.sh" 
    			fi
    			#配置环境变量
    			if [[ $2 == "env"  ]]; then
    				print_r $Info  "开始配置环境变量：$file_path"
    				old_file_path=$file_path
                    #获取到文件名和路径
                    #file_path=${file_path%/*}
                    file_name=${old_file_path##*/}
                    file_name=${file_name%.*}
                # echo $file_name
    				rm -rf $bin_path"/"$file_name

    				ln -s $old_file_path $bin_path"/"$file_name
                    if [[ $? == 0 ]]; then
                        print_g $Info "环境变量配置完成：$bin_path/$file_name"
                        else
                        
                        return 127
                    fi
    				
    			fi
    		fi
        	
    	fi
      
    done

}

#-----------------------------主程序开始------------------------------------------

#------------------------------开始部署脚本---------------------------------------
#从GitHub上获取程序
sh_path=~/sh
github_path="https://github.com/pgw1314/sh.git"
if [[ ! -d $sh_path ]]; then
    yum -y install git
    if [[ $? != 0 ]]; then
        print_r $Error "安装git失败"
        exit
    fi
    rm -rf $sh_path
    git clone $github_path  $sh_path
    if [[ $? != 0 ]]; then
        print_r $Error "从GitHub拉取脚本失败！"
        exit
    fi
fi

#将所有代码拷贝到/usr/local/shell
rm -rf $temp_path
#print_r $Info  "请输入管理员密码！"

mkdir -p $temp_path
if [[ $? != 0 ]]; then
	print_r $Error "临时文件夹：$temp_path创建错误！"
    exit
fi
#替换引用文件路径
print_r $Info  "开始修复脚本中的引用路径..."
read_dir $sh_path rep
print_g $Info "引用路径修复成功！"

print_r $Info  "开始复制脚本文件..."

sudo rm -rf $shell_path
if [[ $? != 0 ]]; then
    print_r $Error "获取Root权限失败！！"
    exit
fi
sudo cp -r $temp_path /usr/local/
if [[ $? == 0 ]]; then
    print_g $Info "脚本文件复制完成！！"
else
    print_r $Error "脚本复制失败！！"
    exit
fi

sudo chmod -R 755 $shell_path
if [[ $? != 0 ]]; then
    print_r $Error "获取Root权限失败！！"
    exit
fi

# print_r $Info  "开始配置环境变量..."
read_dir $shell_path env
if [[ $? != 0 ]]; then
    print_r $Error "环境变量配置失败！！"
    exit
fi
rm -rf $temp_path
print_g $Info "脚本部署完成完成！！"



#------------------------------开始安装软件---------------------------------------




