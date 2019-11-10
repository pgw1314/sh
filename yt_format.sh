#!/bin/bash
# 判断如果地址为空直接退出
if [[ $1 != '' ]]; then
	url=$1
else
	exit
fi

youtube-dl --proxy socks5://127.0.0.1:1086  -F $url

