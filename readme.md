
## VPS常用脚本
## 脚本列表：
- [基础安装脚本](https://github.com/pgw1314/sh#vps%E5%9F%BA%E7%A1%80%E5%AE%89%E8%A3%85%E8%84%9A%E6%9C%ACbase_installsh)
- [LNMP安装脚本](https://github.com/pgw1314/sh#lnmp%E5%AE%89%E8%A3%85%E8%84%9A%E6%9C%AClnmp_installsh)
- [FFmpeg安装脚本](https://github.com/pgw1314/sh#ffmpeg%E5%AE%89%E8%A3%85%E8%84%9A%E6%9C%ACffmpeg_installsh)
- [Aria2c安装脚本](https://github.com/pgw1314/sh#aria2c%E5%AE%89%E8%A3%85%E8%84%9A%E6%9C%ACaria2_installsh)
- [ShadowsocksR安装脚本](https://github.com/pgw1314/sh#shadowsocksr%E5%AE%89%E8%A3%85%E8%84%9A%E6%9C%ACshadowsocksr_installsh)
- [MEGAcmd安装脚本](https://github.com/pgw1314/sh#megacmd%E5%AE%89%E8%A3%85%E8%84%9A%E6%9C%ACmega_installsh)
## 脚本详情：
#### VPS基础安装脚本（base_install.sh）
##### 安装列表：
- cmake
- git
- wget
- unzip
- gcc
- gdb
- gjj
- vim
- youtube_dl
- screen
- sshfs
##### 安装代码：
` sh -c "$(curl -fsSL https://raw.githubusercontent.com/pgw1314/sh/master/install/base_install.sh)"`

#### LNMP安装脚本（lnmp_install.sh）
##### 软件版本：
- Nginx版本 1.14
- MySQL版本 5.5
- PHP版本 7.0
##### 安装代码：
` sh -c "$(curl -fsSL https://raw.githubusercontent.com/pgw1314/sh/master/install/lnmp_install.sh)"`

#### FFmpeg安装脚本（ffmpeg_install.sh）
##### 安装代码：
` sh -c "$(curl -fsSL https://raw.githubusercontent.com/pgw1314/sh/master/install/ffmpeg_install.sh)"`

#### Aria2c安装脚本（aria2_install.sh）
配置文件路径：/var/local/aria2/aria2.conf

日志文件路径：/var/local/aria2/aria2.log
##### 安装代码：
` sh -c "$(curl -fsSL https://raw.githubusercontent.com/pgw1314/sh/master/install/aria2_install.sh)"`

#### ShadowsocksR安装脚本（shadowsocksR_install.sh）
##### 配置信息
- 端    口：15656
- 加密方法：chacha20
- 协    议：auth_sha1_v4
- 混    淆：http_simple

##### 安装代码：
` sh -c "$(curl -fsSL https://raw.githubusercontent.com/pgw1314/sh/master/install/shadowsocksR_install.sh)"`

#### MEGAcmd安装脚本（mega_install.sh）

##### 安装代码：
` curl -o mega_install.sh https://raw.githubusercontent.com/pgw1314/sh/master/install/mega_install.sh && sh mega_install.sh && rm -rf mega_install.sh`
##### 卸载代码：
` curl -o mega_install.sh https://raw.githubusercontent.com/pgw1314/sh/master/install/mega_install.sh && sh mega_install.sh uninstall && rm -rf mega_install.sh`