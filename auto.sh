#!/bin/bash
print_r(){
    echo -e "\033[31m $@ \033[0m"
}
cd ~/
git clone git@git.coding.net:pgw1314/sh.git
shDir=`pwd`/sh
if [[ ! -d "$shDir" ]]; then
  print_r "[错误]克隆sh仓库时发生失败请检查错误!"
  exit
fi
# 执行基本安装
baseSh=shDir/install/base_install.sh
sh $baseSh
