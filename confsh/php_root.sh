#!/bin/bash
#############################################################
#
#功能： 将php的运行权限更改为root将运行目录更给为/
#
#版本：v1.0.2
#
#最后修改时间：2018年8月23日
#
#############################################################
#引入脚本
. ~/sh/funs/m_print.sh
. ~/sh/funs/m_utils.sh

Error="[错误]:"
Info="[信息]："


php_fpm_path=/usr/local/php/etc/php-fpm.conf
fastcgi_path=/usr/local/nginx/conf/fastcgi.conf

if [[ ! -f $php_fpm_path ]]; then
    print_r $Error "抱歉，你的php没有安装"
fi
cp $php_fpm_path $php_fpm_path.bak

sed -i "s/user = www/user = root/" $php_fpm_path
sed -i "s/group = www/group = root/" $php_fpm_path
if [[ $? == 0 ]]; then
    print_g $Info "php root运行权限修改完成！"
fi
#------------修改opendir----------------------------------------
if [[ ! -f $fastcgi_path ]]; then
    print_r $Error "抱歉，你的Nginx没有安装！"
fi
cp $fastcgi_path $fastcgi_path.bak
cp ~/sh/conf/fastcgi.conf $fastcgi_path
if [[ $? == 0 ]]; then
    print_g $Info "opendir修改完成！"
fi
print_y $Info "正在重启Nginx..."
/etc/init.d/nginx stop
/etc/init.d/nginx start
if [[ $? == 0 ]]; then
    print_g $Info "Nginx启动成功！"
else
    print_r $Error "Nginx启动失败！"
fi
#-----------------重启和添加启动项---------------------------------------------
print_y $Info "正在重启php-fpm..."
/etc/init.d/php-fpm stop
php-fpm -R
if [[ $? == 0 ]]; then
    print_g $Info "php-fpm启动成功！"
else
    print_r $Error "php-fpm启动失败！"
fi
print_y $Info "正在添加到开机启动.."
is_start=$(cat /etc/rc.d/rc.local | grep php-fpm)
if [[ -z $is_start ]]; then
    $(echo php-fpm -R >> /etc/rc.d/rc.local)
fi
sudo chmod 755 /etc/rc.d/rc.local
is_start=$(cat /etc/rc.local | grep php-fpm)
if [[ -n $is_start ]]; then
    print_g $Info "开机启动设置成功！"
else
    print_g $Error "开机启动设置失败！"
fi
