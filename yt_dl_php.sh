#!/bin/bash
#切换到影片文件夹
cd /Users/xiaowei/Movies
# 判断如果地址为空直接退出
if [[ $1 != '' ]]; then
	url=$1
else
	exit
fi
# 判断如果格式是否为空如果为空
if [[ $2 != '' ]]; then
	if [ "$2" != "140" ]; then
		formart=$2+140
	fi
	youtube-dl --proxy socks5://127.0.0.1:1086 -o "%(title)s.%(ext)s" -f $formart $url
else
	echo $formart
	youtube-dl --proxy socks5://127.0.0.1:1086  -o "%(title)s.%(ext)s" $url
fi

