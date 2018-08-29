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
print_y(){
    echo -e "\033[33m $@ \033[0m"
}

Error="[错误]:"
Info="[信息]："

shell_path=/usr/local/shell
bin_path=/usr/local/bin
# temp_path=/tmp/shell
#所有脚本所在位置
sh_path=~/sh
#安装脚本所在位置
install_sh_path=$sh_path/install

github_path="https://github.com/pgw1314/sh.git"

install_list=(
    myrename.sh
    mytrans.sh
    myyoutube.sh
    myinstall.sh
    mp3tag.sh
)

mac_sh=(
    zsh
    zshp
)




#-------------------------------------------------
#函数名称： 获取操作系统类型
#
#   
#返回值：Mac=1  Linux=2 Other=3 
#-------------------------------------------------
Get_OS_Type(){

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
#判断该脚本是否安装
Shell_Is_Install(){
    shell_name=$1

    is_install=''
    for i_sh in ${install_list[@]}; do
        # echo $i_sh
        if [[ $i_sh == $shell_name ]]; then
            is_install=y
        fi
    done
    if [[ -z $is_install ]]; then
        return 0
    else
        return 1
    fi
}



#从GitHub上获取程序
Clone_Github(){
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
}

# #将shell拷贝到/usrlocal/bin目录下
# Copy_Shell(){

#     #将所有代码拷贝到/usr/local/shell
#     rm -rf $temp_path
#     #print_y $Info   "请输入管理员密码！"

#     mkdir -p $temp_path
#     if [[ $? != 0 ]]; then
#         print_r $Error "临时文件夹：$temp_path创建错误！"
#         exit
#     fi
#     #替换引用文件路径
#     print_y $Info   "开始修复脚本中的引用路径..."
#     read_dir $sh_path rep
#     print_g $Info "引用路径修复成功！"

#     print_y $Info   "开始复制脚本文件..."

#     sudo rm -rf $shell_path
#     if [[ $? != 0 ]]; then
#         print_r $Error "获取Root权限失败！！"
#         exit
#     fi
#     sudo cp -r $temp_path /usr/local/
#     if [[ $? == 0 ]]; then
#         print_g $Info "脚本文件复制完成！！"
#     else
#         print_r $Error "脚本复制失败！！"
#         exit
#     fi

#     sudo chmod -R 755 $shell_path
#     if [[ $? != 0 ]]; then
#         print_r $Error "获取Root权限失败！！"
#         exit
#     fi

#     # print_y $Info   "开始配置环境变量..."
#     read_dir $shell_path env
#     if [[ $? != 0 ]]; then
#         print_r $Error "环境变量配置失败！！"
#         exit
#     fi
#     rm -rf $temp_path
#     print_g $Info "脚本部署完成完成！！"

# }

# 配置bashrc
Config_Bashrc(){
    #配置bashrc
    print_y "$Info 开始配置bashrc..."
    mv ~/.bashrc ~/.bashrc.bak
    cp $sh_path/conf/bashrc ~/.bashrc
    if [[ $? != 0 ]]; then
        print_r "$Error bashrc配置中出错了！"
        exit
    fi
    print_g "$Info bashrc配置完成"
    . ~/.bashrc
}

#基础安装
Base_Install(){
    #安装基本软件
    print_y "$Info 开始安装基础软件包..."
    $install_sh_path/base_install.sh
    if [[ $? != 0 ]]; then
        print_r "$Error 基本软件安装中出错了！"
        exit
    fi
    print_g "$Info 基本软件安装完成"
}


Opencc_Install(){
    #安装opencc
    print_y "$Info 开始安装opencc软件包..."
    $install_sh_path/opencc_install.sh
    if [[ $? != 0 ]]; then
        print_r "$Error Opencc安装中出错了！"
        exit
    fi
    print_g "$Info opencc软件包安装完成"
}


Youtube_Upload_Insatll(){
    #安装youtube_upload_install
    print_y "$Info 开始安装youtube-upload软件包..."
    $install_sh_path/youtube_upload_install.sh
    if [[ $? != 0 ]]; then
        print_r "$Error youtube_upload_install安装中出错了！"
        exit
    fi
    print_g "$Info youtube-upload软件包安装完成"
}



Arai2_Install(){
    #aria2
    print_y "$Info 开始安装aria2软件包..."
    $install_sh_path/my_aria2_install.sh
    if [[ $? != 0 ]]; then
        print_r "$Error aria2安装中出错了！"
        exit
    fi
    print_g "$Info aria2软件包安装完成"
}


#安装shadowsocksR
ShadowsocksR_Install(){
    print_y "$Info 开始安装shadowsocksR软件包..."
    $install_sh_path/my_shadowsocksR_install.sh
    if [[ $? != 0 ]]; then
        print_r "$Error shadowsocksR安装中出错了！"
        exit
    fi
    print_g "$Info shadowsocksR软件包安装完成"
}


#安装ffmpeg
FFmpeg_Install(){
    print_y "$Info 开始安装ffmpeg软件包..."
    $install_sh_path/ffmpeg_install.sh
    if [[ $? != 0 ]]; then
        print_r "$Error ffmpeg安装中出错了！"
        exit
    fi
    print_g "$Info ffmpeg软件包安装完成"
}

#开始安装LNMP
LNMP_Install(){
    print_y "$Info 开始安装LNMP软件包..."
    rm -rf ./lnmp*
    wget https://github.com/pgw1314/sh/raw/master/conf/lnmp1.5.tar.gz -cO lnmp1.5.tar.gz && tar zxf lnmp1.5.tar.gz && cd lnmp1.5 && LNMP_Auto="y" DBSelect="2" DB_Root_Password="wei@1992." InstallInnodb="y" PHPSelect="6" SelectMalloc="1" ./install.sh lnmp
    if [[ $? != 0 ]]; then
        print_r "$Error LNMP安装中出错了！"
        exit
    fi
    print_g "$Info LNMP软件包安装完成"
}

#安装oh_my_zsh_install
ZSH_Install(){
    print_y "$Info 开始安装oh-my-zsh软件包..."
    $install_sh_path/oh_my_zsh_install.sh
    if [[ $? != 0 ]]; then
        print_r "$Error oh_my_zsh_install安装中出错了！"
        exit
    fi
    print_g "$Info oh-my-zsh软件包安装完成"
}
#安装oh_my_zsh 插件
ZSHP_Install(){
    print_y "$Info 开始安装oh-my-zsh所有插件..."
    $install_sh_path/oh_my_zsh_plugin_install.sh
    if [[ $? != 0 ]]; then
        print_r "$Error oh_my_zsh 插件安装中出错了！"
        exit
    fi
    print_g "$Info oh-my-zsh插件安装完成"
}

#安装oh_my_zsh 插件
Netdata_Install(){
    print_y "$Info 开始安装NetData..."
    $install_sh_path/netdata_install.sh
    if [[ $? != 0 ]]; then
        print_r "$Error NetData 插件安装中出错了！"
        exit
    fi
    print_g "$Info NetData安装完成"
}

Shell_Install(){
        file_path=$1
        file=$2
        Shell_Is_Install $file
        if [[ $? == 0 ]]; then
            continue  
        fi
        # print_g "安装Shell:" $file
 
        # 判断文件类型
        file_type=${file_path##*.}
        if [[ $file_type == "sh" ]]; then
            print_y $Info   "开始配置："$file_path
            shell_file_path=$shell_path/$file
            #替换文件路径
            # if [[ $2 == "rep"  ]]; then
                # echo "-------------------------------------"
                # print_g $Info "file_path=$file_path"
                # print_g $Info "file=$file"
                # print_g $Info "shell_file_path=$shell_file_path"
                # echo "-------------------------------------"
                # continue
                
                #复制脚本
                sudo cp  $file_path $shell_file_path

                sudo chmod -R 755 $shell_file_path
    #             #替换函数库路径
    #             replase_file_content $shell_file_path ".\/funs" "\/usr\/local\/shell\/funs"  
    # # #             #替换配置文件路径
    #             replase_file_content $shell_file_path ".\/conf" "\/usr\/local\/shell\/conf"  
    # # #             #替换配置文件路径
    #             replase_file_content $shell_file_path ".\/rename.sh" "\/usr\/local\/shell\/rename.sh" 
            # fi
                file_name=${file%.*}

                sudo rm -rf $bin_path/$file_name

                ln -s $shell_file_path $bin_path/$file_name
                if [[ $? == 0 ]]; then
                    print_g $Info "配置完成：$bin_path/$file_name"
                    else
                    return 127
                fi
                
            fi
}

#-------------------------------------------------
#函数名称： 遍历文件夹
#   
#功能：如果是文件夹的话读取文件列表
#-------------------------------------------------
Read_Dir(){

    for file in `ls $1`
    do  
        file_path=$1"/"$file
        if [ -d $file_path ]
        then 
            Read_Dir $file_path
        else
            Shell_Install $file_path $file
            # echo $file_path
            # echo "-------------------------------------"
            #     print_g $Info "file_path=$file_path"
            #     print_g $Info "file=$file"
            #     echo "-------------------------------------"
        fi  
    done
}

#在Mac上安装
Mac_Install(){
#Mac上可以安装的脚本
mac_install_list=()
    for mac in ${mac_sh[@]}; do
        for in_sh in $@; do
            if [[ $mac == $in_sh ]]; then
                echo $mac
                mac_install_list=("${mac_install_list[@]}" $mac)
            fi
        done
    done
    if [[ ${#mac_install_list[@]} == 0 ]]; then
        print_r $Error "对不起， $* 不能在Mac OS上安装！！"
        exit
    fi

    for mac in ${mac_install_list[@]}; do
        if [[ $mac == "zsh" ]]; then   
            # print_y $Info "安装 zsh"
            ZSH_Install
        elif [[ $mac == "zshp" ]]; then   
            # print_y $Info "安装 zshp"
            ZSHP_Install
       fi
    done

}

#在Linux上安装
Linux_Install(){
    Config_Bashrc
    for name in $@; do
        if [[ $name == "all" ]]; then
            print_y $Info "安装全部...."
            Base_Install
            Opencc_Install
            Youtube_Upload_Insatll
            Arai2_Install
            ShadowsocksR_Install
            FFmpeg_Install
            LNMP_Install

        elif [[ $name == "no_lnmp" ]]; then
            print_y $Info "不装LNMP...."
            Base_Install
            Opencc_Install
            Youtube_Upload_Insatll
            Arai2_Install
            ShadowsocksR_Install
            FFmpeg_Install
        elif [[ $name == "ssr" ]]; then
            print_y $Info "安装ssr..."
            ShadowsocksR_Install
        elif [[ $name == "youtube" ]]; then
            print_y $Info "安装 youtube"
            Youtube_Upload_Insatll
        elif [[ $name == "aria2" ]]; then
            print_y $Info "安装 aria2"
            Arai2_Install
        elif [[ $name == "ffmpeg" ]]; then
            print_y $Info "安装 ffmpeg"
            FFmpeg_Install
        elif [[ $name == "opencc" ]]; then
            print_y $Info "安装 opencc"
            Opencc_Install
        elif [[ $name == "zsh" ]]; then   
            print_y $Info "安装 zsh"
            ZSH_Install
        elif [[ $name == "zshp" ]]; then   
            print_y $Info "安装 zshp"
            ZSHP_Install
        elif [[ $name == "lnmp" ]]; then   +
            print_y $Info "安装 LNMP"
            LNMP_Install
        elif [[ $name == "netdata" ]]; then   
            print_y $Info "安装 netdata"
            Netdata_Install
         elif [[ $name == "screen" ]]; then   
            print_y $Info "安装 Screen"
            yum -y install screen
            if [[ $? == 0 ]]; then
                    print_g $Info "Screen 安装成功！！"
                else
                    print_r $Error "Screen 安装失败！"
            fi
        else
            print_r $Error "对不起，没有$name安装项！！"

        fi
    done
}


#-----------------------------主程序开始-------------------------------------------
# sudo rm -rf $shell_path
# sudo mkdir -p $shell_path
# Read_Dir $sh_path

# Clone_Github

Get_OS_Type
if [[ $os_type == 1 ]]; then
    Mac_Install "$@"
elif [[ $os_type == 2 ]]; then
    sudo rm -rf $shell_path
    sudo mkdir -p $shell_path
    Read_Dir $sh_path
    Linux_Install "$@"
elif [[ $os_type == 3 ]]; then
    [ ! -z $1 ] && print_r $Error "对不起你的系统不支持，其他程序的安装！"
fi





# # 安装全部






