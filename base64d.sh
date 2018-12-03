#!/bin/bash
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
Error="[错误]:"
Info="[信息]："

if [[ -n "$1"   ]]; then
	print_g $Info"解码完成："
	echo $1 |base64 -D
else
	print_r $Error"参数不能为空！"
fi