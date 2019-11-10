#!/bin/bash

# 判断是否在命令后添加了地址
if [[ $1 != '' ]]; then
	url=$1
else
	echo -n  "请输入YouTube播放地址："
	read url
fi

if [[ $2 != '' ]]; then
	level=$2
else
	echo -n  "请输入下载的视频清晰度[0|360|480|720|1080](默认720P)："
	read level
fi
#切换到影片文件夹
cd /Users/xiaowei/Movies
formart=''
if [ "$level" == "360" ]; then
	formart="243+140"
elif [ "$level" == "480" ]; then
	formart="244+140"
elif [ "$level" == "720" ]; then
	formart="247+140"
elif [ "$level" == "1080" ]; then
	formart="248+140"
elif [ "$level" == "0" ]; then
	formart="140"
	cd /Users/xiaowei/Music
else
	#默认下载720P
	formart="247+140"
fi
youtube-dl --proxy socks5://127.0.0.1:1086 -f $formart $url

# /Users/xiaowei/Code/sh/rname.sh ./ "-[0-9a-zA-Z]*$" "" y