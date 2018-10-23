import requests


login_headers = {
    "x-requested-with": "XMLHttpRequest",
    "referer": "https://anythink.info/auth/login",
    "User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/68.0.3440.106 Safari/537.36",

}

user_headers={
    "x-requested-with":"XMLHttpRequest",
    "referer":"https://anythink.info/user",
    "User-Agent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/68.0.3440.106 Safari/537.36",

}
# 自动签到
def auto_chckin(mail,passwd):
    login_data = {
        'email': mail,
        'passwd': passwd,
    }
    # 开始会话
    s=requests.session()
    r = s.post("https://anythink.info/auth/login",data=login_data, headers=login_headers)
    user=s.get("https://anythink.info/user")

    # 得到签到的流量
    checkin=s.post("https://anythink.info/user/checkin",headers=user_headers)

    print(checkin.text.encode("UTF-8").decode("unicode_escape"))
#调用
auto_chckin("peigangweiforever@gmail.com","peigangwei")
auto_chckin("pgw1314@gmail.com","peigangwei")
auto_chckin("xiaowei1385@gmail.com","wei@1992.")
auto_chckin("794480644@qq.com","peigangwei")
