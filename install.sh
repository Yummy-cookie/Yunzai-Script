#!/bin/bash
RED='\e[1;31m' # 红
GREEN='\e[1;32m' # 绿
YELLOW='\e[1;33m' # 黄
BLUE='\e[1;34m' # 蓝
PINK='\e[1;35m' # 粉红
RES='\e[0m' # 清除颜色
##字体颜色

jzbl(){
whereinstall=$(grep -oP 'whereinstall\s*:\s*\"\K[^"]+' /gancm/cfg.cfg)
MRLJ=$(grep -oP 'MRLJ\s*:\s*\"\K[^"]+' /gancm/cfg.cfg)
DYC=$(grep -oP 'DYC\s*:\s*\"\K[^"]+' /gancm/cfg.cfg)
JBXX=$(grep -oP 'JBXX\s*:\s*\"\K[^"]+' /gancm/cfg.cfg)
QDML=$(grep -oP 'QDML\s*:\s*\"\K[^"]+' /gancm/cfg.cfg)
K=$(grep -oP 'K\s*:\s*\"\K[^"]+' /gancm/cfg.cfg)
ROOT=$(grep -oP 'ROOT\s*:\s*\"\K[^"]+' /gancm/cfg.cfg)
PPA=$(grep -oP 'PPA\s*:\s*\"\K[^"]+' /gancm/cfg.cfg)



BOTDYC=$(grep -oP 'BOTDYC\s*:\s*\"\K[^"]+' /gancm/bot.cfg)
Yunzai=$(grep -oP 'Yunzai\s*:\s*\"\K[^"]+' /gancm/bot.cfg)
YunzaiLJ=$(grep -oP 'YunzaiLJ\s*:\s*\"\K[^"]+' /gancm/bot.cfg)
xpm=$(grep -oP 'xpm\s*:\s*\"\K[^"]+' /gancm/bot.cfg)
xpmLJ=$(grep -oP 'xpmLJ\s*:\s*\"\K[^"]+' /gancm/bot.cfg)
}

zxpd(){
# 创建计数器a并初始化为0
zxpdml="$@"
jsq=0
error_file=$(mktemp)

# 循环执行指令b，最多重试3次
while [ $jsq -lt 4 ]
do
    $zxpdml 2>"${error_file}"  # 执行指令 并隐藏报错信息
    if [ $? -eq 0 ]   # 如果执行成功，则跳出循环
    then
        echo 0 > /gancm/log/install.log
        break
    else   # 如果执行失败，则重试
        let jsq++
        if [ $jsq -ge 4 ]   # 如果重试次数超过3次，则输出异常信息并跳出循环
        then
            echo 1 > /gancm/log/install.log
            echo -e "${RED}\n指令执行异常${RES}"
            if [ -s "$error_file" ]; then
                  echo -e "${RED}运行日志${RES}:"
                  cat "$error_file"
            fi

          rm -rf "$error_file"

            break
        fi
        echo -e "${RED}指令执行错误，重新执行指令:${YELLOW}${zxpdml}  ${RED}第${YELLOW}${jsq}${RED}次${RES}"
    fi
done

if [ $jsq -lt 0 ]   # 如果$a小于0，则输出指令执行错误
then
    echo 2 > /gancm/log/install.log
    echo "${RED}指令执行错误${RES}"
fi
}


csh(){
if [ -d /gancm ];then
echo -e "${GREEN}成功匹配到配置文件存放目录${RES}"
else
echo -e "${RED}没有匹配到配置文件存放目录 尝试初始化配置信息${RES}"
mkdir /gancm
touch /gancm/bot.cfg
touch /gancm/cfg.cfg
echo -e '
PPA:"0"
MRLJ:"gancm"
DYC:"1"
K:""
QDML:""
JBXX:"1"
ROOT:"1"
Nodes:"0"
whereinstall:""
' > /gancm/cfg.cfg
echo -e '
BOTDYC:"1"
Yunzai:"0"
xpm:"0"
YunzaiLJ:""
xpmLJ:""
' > /gancm/bot.cfg
fi

if [ -d /gancm/log ];then
echo -e "${GREEN}成功读取到日志存放目录${RES}"
else 
echo -e "${RED}日志文件夹不存在  尝试创建${RES}"
mkdir /gancm/log
fi

chmod -Rv 775 /gancm > /dev/null

if [ -f /gancm/cfg.cfg ];then
echo -e "${GREEN}成功读取到配置文件${RES}"
else 
echo -e "${RED}配置文件不存在  尝试创建${RES}"
touch /gancm/cfg.cfg
fi

if [ -f /gancm/bot.cfg ];then
echo -e "${GREEN}成功读取到BOT配置文件${RES}"
else 
echo -e "${RED}配置文件不存在  尝试创建${RES}"
touch /gancm/bot.cfg
fi


ROOT=$(grep -oP 'ROOT\s*:\s*\"\K[^"]+' /gancm/cfg.cfg)
if [ "${ROOT}" = 1 ];then
if [ "$(whoami)" != "root" ];then
if (whiptail --title "运行警告"  --yes-button "退出脚本" --no-button "继续运行"  --yesno "该脚本的大多数内容需要root权限 当前运行环境并非root建议 切换为root权限执行 我们非常建议您使用Root权限运行 如果没有root权限脚本将无法存放配置文件  在必要情况下我们会请求获取root权限" 10 60) then
    echo -e "${GREEN}感谢你的使用 脚本已退出${RES}"
    exit 0
else
    if (whiptail --title "个人习惯配置" --yes-button "不再理会警告" --no-button "每次都要自己选择"  --yesno "你希望下次检测到根除以非root权限运行时怎么做？" 10 60) then
    echo -e "${YELLOW}当前脚本并没有root权限 只能尝试写入${RES}"
    sed -i "s/ROOT:".*"/ROOT:\"0\"/" /gancm/cfg.cfg
    ROOT=$(grep -oP 'ROOT\s*:\s*\"\K[^"]+' /gancm/cfg.cfg)
    if [ "$ROOT" = "0" ]; then
      echo -e "${GREEN}ROOT检测关闭成功${RES}"
    elif [ "$ROOT" = "1" ]; then
      echo -e "${RED}Root检测关闭失败 原因:无法写入${RES}"
    else
      echo -e "${RED}Root检测关闭失败 无法确定原因 可能是因为配置文件不存在 或 Root检查配置数据异常${RES}"    
    fi
else
    echo 
fi
fi
fi
fi

##配置文件

whereinstall=$(grep -oP 'whereinstall\s*:\s*\"\K[^"]+' /gancm/cfg.cfg)
MRLJ=$(grep -oP 'MRLJ\s*:\s*\"\K[^"]+' /gancm/cfg.cfg)
DYC=$(grep -oP 'DYC\s*:\s*\"\K[^"]+' /gancm/cfg.cfg)
JBXX=$(grep -oP 'JBXX\s*:\s*\"\K[^"]+' /gancm/cfg.cfg)
QDML=$(grep -oP 'QDML\s*:\s*\"\K[^"]+' /gancm/cfg.cfg)
K=$(grep -oP 'K\s*:\s*\"\K[^"]+' /gancm/cfg.cfg)
ROOT=$(grep -oP 'ROOT\s*:\s*\"\K[^"]+' /gancm/cfg.cfg)
PPA=$(grep -oP 'PPA\s*:\s*\"\K[^"]+' /gancm/cfg.cfg)



BOTDYC=$(grep -oP 'BOTDYC\s*:\s*\"\K[^"]+' /gancm/bot.cfg)
Yunzai=$(grep -oP 'Yunzai\s*:\s*\"\K[^"]+' /gancm/bot.cfg)
YunzaiLJ=$(grep -oP 'YunzaiLJ\s*:\s*\"\K[^"]+' /gancm/bot.cfg)
xpm=$(grep -oP 'xpm\s*:\s*\"\K[^"]+' /gancm/bot.cfg)
xpmLJ=$(grep -oP 'xpmLJ\s*:\s*\"\K[^"]+' /gancm/bot.cfg)

##读取配置文件的变量

if [ "$DYC" = "" ]; then 
echo -e " ${RED}配置信息不存在或数据异常 尝试初始化默认数据${RES}"
echo -e '
MRLJ:"gancm"
DYC:"1"
K:""
QDML:""
JBXX:"1"
ROOT:"1"
whereinstall:""
' > /gancm/cfg.cfg
elif [ $DYC = 1 ]; then
echo -e "${GREEN}脚本读取完成${RES}"
else
echo -e "${RED}异常退出 原因:可能为用户修改了配置文件校验数值
   请尝试使用rm -rfv /gancm/* 删除配置文件${RES}"
exit 1
fi
##脚本配置文件信息校验


if [ "$BOTDYC" = "" ]; then 
echo -e " ${RED}BOT配置信息不存在或数据异常 尝试初始化默认数据${RES}"
echo -e '
BOTDYC:"1"
Yunzai:"0"
xpm:"0"
YunzaiLJ:""
xpmLJ:""
' > /gancm/bot.cfg
elif [ "$BOTDYC" = 1 ]; then
echo -e "${GREEN}BOT信息读取完成${RES}"
else
echo -e "${RED}异常退出 原因:可能为用户修改了配置文件校验数值
   请尝试使用rm -rfv /gancm/* 删除配置文件${RES}"
exit 1
fi


##Bot配置文件信息校验




#全新单文件记录方式

if [ "$Yunzai" = "1" ]; then 
echo -e " ${GREEN}Yunzai-Bot成功安装 ${RES}路径为${YELLOW}${YunzaiLJ}${RES}"
elif [ "$Yunzai" = "0" ]; then
echo -e " ${GREEN}Yunzai-Bot未安装"
else
echo -e "${RED}异常退出 原因:可能为用户修改了BOT配置文件
   请尝试使用rm -rfv /gancm/* 删除配置文件${RES}"
exit 1
fi

if [ "$xpm" = "1" ]; then 
echo -e " ${GREEN}小派蒙成功安装 ${RES}路径为${YELLOW}${xpmLJ}${RES}"
elif [ "$xpm" = "0" ]; then
echo -e " ${GREEN}小派蒙未安装"
else
echo -e "${RED}异常退出 原因:可能为用户修改了BOT配置文件
   请尝试使用rm -rfv /gancm/* 删除配置文件${RES}"
exit 1
fi
##BOT安装检测

if [ "$Yunzai" = "0" ]; then 
if [ "$YunzaiLJ" = "$K" ]; then 
echo -e "${GREEN}Yunzai-Bot非法修改路径 则校验完成${RES}"
else
echo -e "${RED}异常退出 原因:可能为用户在未安装BOT情况下修改了BOT路径文件值
       ${RES} ${YELLOW}请手动修改/gancm/bot.cfg Yunzai的路径 或删除文件再次生成 如果安装了BOT请一定要将 Yunzai: 中0修改为1 ${RES}"
exit 1
fi
else
echo -e "${RED}已安装 跳过校验${RES}"
fi

if [ "$xpm" = "0" ]; then 
if [ "$xpmLJ" = "$K" ]; then 
echo -e "${GREEN}小派蒙非法修改路径 则校验完成${RES}"
else
echo -e "${RED}异常退出 原因:可能为用户在未安装BOT情况下修改了BOT路径文件值
       ${RES} ${YELLOW}请手动修改/gancm/bot.cfg 小派蒙的路径 或删除文件再次生成 如果安装了BOT请一定要将 xpm: 中0修改为1${RES}"
exit 1
fi
else
echo -e "${RED}已安装跳过校验${RES}"
fi


##bot.cfg文件错误修改校验

python=$(python3 --version)
NODE=$(node -v)
##软件版本

release_num=$(lsb_release -r --short)
release_os=$(lsb_release -i --short)
yingpan=$(free -mh)
os_start=$(date -d "$(awk -F. '{print $1}' /proc/uptime) second ago" +"%Y-%m-%d %H:%M:%S")
 ##信息定义

wherpyin=$(pip3 config list)


##函数请求变量

##whereinstall初始化检测

 if [ "${whereinstall}" = "${K}" ]; then
 whereinstallCSH=$(whiptail --title "选择默认安装源" --menu "以后的每次安装会优先考虑默认安装源" 15 60 4 \
     "1" "Github" \
     "2" "Gitee" \
     "0" "退出" 3>&1 1>&2 2>&3)
if [ "${whereinstallCSH}" = 1 ]; then
sed -i "s/whereinstall:".*"/whereinstall:\"Github\"/" /gancm/cfg.cfg
elif [ "${whereinstallCSH}" = 2 ]; then
sed -i "s/whereinstall:".*"/whereinstall:\"Gitee\"/" /gancm/cfg.cfg
else 
echo
fi
else
echo 
fi

#%函数
}


startbot()
{
if [ "$1" == Yunzai ]; then
         YunzaiLJS=$(grep -oP 'YunzaiLJ\s*:\s*\"\K[^"]+' /gancm/bot.cfg)      
         STARTTIME=`date +%s`
         cd ${YunzaiLJS} && redis-server --daemonize yes && node app
         echo -e "${GREEN}已为您尝试启动BOT 如果是时雨bot请手动启动go-qchttp${RES}"
         echo -e "${GREEN}前台启动请不要关闭当前shell${RES}"
         ENDTIME=`date +%s`
         DELTATIME=`expr $ENDTIME - $STARTTIME`
         if [ "$DELTATIME" -le "3" ]; then
         echo -e "${YELLOW}脚本用时 $DELTATIME sec（s）. ${RES}\n${RED}脚本城市运行后在短时间内退出 可能是由路径填写错误 或 安装不完整 ${RES}"
         fi
         hcjx
elif [ "$1" == Yunzaijm ]; then
         YunzaiLJS=$(grep -oP 'YunzaiLJ\s*:\s*\"\K[^"]+' /gancm/bot.cfg)
         STARTTIME=`date +%s`
         cd ${YunzaiLJS} && redis-server --daemonize yes && pnpm run start
         echo -e "${GREEN}后台启动可关闭当前 shell${RES}"
         echo -e "${GREEN}已为您尝试启动BOT 如果是时雨bot请手动启动go-qchttp${RES}"
         ENDTIME=`date +%s`
         DELTATIME=`expr $ENDTIME - $STARTTIME`
         if [ "$DELTATIME" -le "3" ]; then
         echo -e "${YELLOW}脚本用时 $DELTATIME sec（s）. ${RES}\n${RED}脚本城市运行后在短时间内退出 可能是由路径填写错误 或 安装不完整${RES}"
         fi
         hcjx
elif [ "$1" == Yunzaistop ]; then
echo -e "${RED}获取BOT运行PID${RES}"
server=`ps -ef | grep "Yunzai-B" | grep -v grep | awk '{print $2}'`
            #如果不存在就重新启动
            if [ "$server" != "$K" ]; then
            kill -9 ${server}
            echo $server
            echo -e "${RED}已尝试结束BOT运行进程${RES}"
            else
            echo -e "${YELLOW}没有找到Yunzai-Bot前台进程${RES}"
            fi
        
server2=`ps -ef | grep "Yunzai-Bot" | grep -v grep | awk '{print $2}'`
            #如果不存在就重新启动
            if [ "$server2" != "$K" ]; then
            kill -9 ${server2}
            echo $server
            echo -e "${RED}已尝试结束BOT运行进程${RES}"
            else
            echo -e "${YELLOW}没有找到Yunzai-Bot后台进程${RES}"
            fi
hcjx
elif [ "$1" == Yunzailog ]; then
     YunzaiLJ=$(grep -oP 'YunzaiLJ\s*:\s*\"\K[^"]+' /gancm/bot.cfg)
     cd ${YunzaiLJS} && pnpm run log
     
elif [ "$1" == Xpm ]; then
         STARTTIME=`date +%s`
         xpmLJS=$(grep -oP 'xpmLJ\s*:\s*\"\K[^"]+' /gancm/bot.cfg)
         cd ${xpmLJ} && nb run
         echo -e "${GREEN}已为您尝试启动小派蒙BOT 请手动启动go-qchttp${RES}"
         echo -e "${GREEN}前台启动请不要关闭当前shell${RES}"
         ENDTIME=`date +%s`
         DELTATIME=`expr $ENDTIME - $STARTTIME`
         if [ "$DELTATIME" -le "3" ]; then
         echo -e "${YELLOW}脚本用时 $DELTATIME sec（s）. ${RES}\n${RED}脚本城市运行后在短时间内退出 可能是由路径填写错误 或 安装不完整 ${RES}"
         fi
         hcjx
         
elif [ "$1" == Xpmjm ]; then
         STARTTIME=`date +%s`
         xpmLJS=$(grep -oP 'xpmLJ\s*:\s*\"\K[^"]+' /gancm/bot.cfg)
         cd ${xpmLJ}
         screen -S bot -m bash -c 'nb run; exec bash'
         echo -e "${GREEN}已为您尝试启动小派蒙BOT 请手动启动go-qchttp${RES}"
         ENDTIME=`date +%s`
         DELTATIME=`expr $ENDTIME - $STARTTIME`
         if [ "$DELTATIME" -le "3" ]; then
         echo -e "${YELLOW}脚本用时 $DELTATIME sec（s）. ${RES}\n${RED}脚本城市运行后在短时间内退出 可能是由路径填写错误 或 安装不完整 ${RES}"
         fi
         hcjx
elif [ "$1" = ceshi ]; then
     echo 可用
fi
}

jdt(){
pid=$!
    spin='-\|/'
    echo -e "${GREEN}正在下载${YELLOW} ${1} ${GREEN}中 ${RES}\n"
    while kill -0 $pid > /dev/null 2>&1; do
        printf "\b\r${GREEN} ${spin:a++%${#spin}:1} ${RES}"
        sleep 0.1
    done
    while true; do
    while ! kill -0 $pid > /dev/null 2>&1; do
        ret=$(cat /gancm/log/install.log)
           if [ "$ret" = "0" ]; then
	            echo -e "\n下载成功"
	            break 2
	     elif [ "$ret" = "1" ]; then
	            echo -e "\n下载失败"
	            break 2
          else
                 echo -e "\n脚本内部运行失败 这是脚本的问题 请反馈给开发者"
	            break 2                 
          fi
        
    done
    done
}

jcapt(){
if ps -e | grep -q "apt"; then
  # 如果有，杀死相关进程
  echo -e "${RED}有其他apt程序正在运行,正在杀死相关进程${RES}}"
  pkill apt 
  pkill apt-get
  echo -e "${GREEN}清理成功\n 正在尝试修复dpkg${RES}"
  zxpd dpkg --configure -a
else
  echo "Apt程序没有运行"
  zxpd dpkg --configure -a

fi
}

installapt(){
    a=0
    	if [ -f "/usr/bin/yum" ] && [ -d "/etc/yum.repos.d" ]; then
    	     jcapt
	     zxpd yum autoremove -y > /dev/null 2>&1 &    	     
	     zxpd yum install $@ -y > /dev/null 2>&1 &
	elif [ -f "/usr/bin/apt-get" ] && [ -f "/usr/bin/dpkg" ]; then
	     jcapt
	     zxpd apt autoremove -y > /dev/null 2>&1 &	     
	     zxpd apt install $@ -y > /dev/null 2>&1 &
	else
	     jcapt
	     zxpd apt autoremove -y > /dev/null 2>&1 &
	     zxpd apt install $@ -y > /dev/null 2>&1 & 
	fi
    jdt $@
}
PPAADD(){
if [ "$1" == python ]; then
     if [ "$2" == add ]; then
          zxpd echo -e "\n" | add-apt-repository ppa:deadsnakes/ppa
          zxpd apt update -y
     elif [ "$2" == unadd ]; then
          zxpd echo -e "\n" | add-apt-repository -r ppa:deadsnakes/ppa
          zxpd apt update -y
     fi
elif [ "$1" == chromium ]; then
     if [ "$2" == add ]; then
          zxpd echo -e "\n" | add-apt-repository ppa:saiarcot895/chromium-beta
          zxpd apt update -y
     elif [ "$2" == unadd ]; then
          zxpd echo -e "\n" | add-apt-repository -r ppa:saiarcot895/chromium-beta
          zxpd apt update -y
     fi
elif [ "$1" == ceshi ]; then
    echo 可用
fi
}

hcjx(){
echo -e "${GREEN}请按回车键继续下一条指令...${RES}"
     read -r
}

wjjpd(){
dir="$@"
            res=$(ls -A $dir)
               if ! [ -z "$res" ];then
                      echo -e "${YELLOW}文件夹${RES} ${RED}$dir${RES} ${YELLOW}不为空..........${RES}"
                      echo -e "${YELLOW}这会干扰正常的安装步骤${RES}"
                      echo -e " ${RED}是否删除文件夹${RES} ${YELLOW}（y/o/n）${RES}"
                      echo Y删除 N结束安装进程 O无视报错强制执行
                      read -r Buginstall
                      case ${Buginstall} in
                      Y | y )
                         zxpd rm -rfv ${dir}/*
                         zxpd rm -rfv $${dir}}/.*
                         zxpd echo -e "${GREEN}删除完成${RES}"
                         ;;
                      N | n )
                         echo -e "${RED}为了不破坏原文件夹 安装程序终止${RES}"
                         exit 1
                         ;;
                      O | o)
                         echo -e "${RED}无视报错强制执行${RES}"
                         ;;
                         esac
               fi
}

installxpmbot(){
        zxpd apt update -y
if ! [ -x "$(command -v git)" ];then
               echo -e "${RED}目前并没有安装 Git 正在安装${RES}"
               installapt git git
              fi
if ! [ -x "$(command -v wget)" ];then
               echo -e "${RED}目前并没有安装 wget 正在安装${RES}"
               installapt wget wget
              fi
         echo $OPTION
               echo -e "${YELLOW} $python ${RES} ${RED} \n 我们需要python大于3.8到3.10的版本 请仔细核对 五秒后开始继续安装${RES}"
                if ! [ -x "$(command -v python3.10)" ];then
               echo -e "${RED}目前并没有安装 Python 正在安装${RES}"
               installapt  python3.10 python3.10 
              fi
                  if ! [ -x "$(command -v pip3)" ];then
               echo -e "${RED}目前并没有安装 pip3 正在安装${RES}"
               installapt  python3-pip python3-pip
              fi
              
              if [ "${wherpyin}" = "global.index-url='https://pypi.tuna.tsinghua.edu.cn/simple'" ]; then
                    echo -e "${GREEN}当前pip源为:清华大学开源软件镜像站${RES}"
              elif [ "${wherpyin}" = "global.index-url='https://pypi.mirrors.ustc.edu.cn/simple'" ]; then
                    echo -e "${GREEN}当前pip源为:中国科技大学开源软件镜像站${RES}"
              elif [ "${wherpyin}" = "global.index-url='http://mirrors.aliyun.com/pypi/simple/'" ]; then
                    echo -e "${GREEN}当前pip源为:阿里云开源软件镜像站${RES}"
              elif [ "${wherpyin}" = "global.index-url='http://mirrors.cloud.tencent.com/pypi/simple'" ]; then
                    echo -e "${GREEN}当前pip源为:腾讯开源软件镜像站${RES}"
              elif [ "${wherpyin}" = "global.index-url='http://pypi.douban.com/simple/'" ]; then
                    echo -e "${GREEN}当前pip源为:豆瓣开源软件镜像站${RES}"
              else
              while true; do
              echo -e "${YELLOW}当前并非 ${GREEN}豆瓣 腾讯 阿里云 中国科技大学 清华大学${RES}"
                   echo -e "${GREEN}1.修改pip源为:清华大学开源软件镜像站${RES}"
                   echo -e "${GREEN}2.修改pip源为:中国科技大学开源软件镜像站${RES}"
                   echo -e "${GREEN}3.修改pip源为:阿里云开源软件镜像站${RES}"
                   echo -e "${GREEN}4.修改pip源为:腾讯开源软件镜像站${RES}"
                   echo -e "${GREEN}5.修改pip源为:豆瓣开源软件镜像站${RES}"
                   echo -e "${GREEN}0.不修改pip源${RES}"                   
              read -p "是否更改为国内源(0~5)" yes
              case "$yes" in
            1)
                echo -e "${GREEN}修改pip源为:清华大学开源软件镜像站${REDS}"
                zxpd pip3 config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple
                break
                ;;
            2)
                echo -e "${GREEN}修改pip源为:中国科技大学开源软件镜像站${RES}"
                zxpd pip3 config set global.index-url https://pypi.mirrors.ustc.edu.cn/simple
                break
                ;;
            3)
                echo -e "${GREEN}修改pip源为:阿里云开源软件镜像站${RES}"
                zxpd  pip3 config set global.index-url http://mirrors.aliyun.com/pypi/simple/
                break
                ;;
            4)
                echo -e "${GREEN}修改pip源为:腾讯开源软件镜像站${RES}"
                zxpd pip3 config set global.index-url http://mirrors.cloud.tencent.com/pypi/simple
                break
                ;;
            5)
                echo -e "${GREEN}修改pip源为:豆瓣开源软件镜像站${RES}"
                zxpd pip3 config set global.index-url http://pypi.douban.com/simple/
                break
                ;;
            0)
                     echo -e "${GREEN}取消更改${RES}"
                           break
                     ;;
            *)
                echo -e "${RED}请输入正确数值${RES}"
          esac
          done
               fi
               
               ##安装完成Python
                   if (whiptail --title "Yes/No 安装方式" --yes-button "pip" --no-button "pipx"  --yesno "几乎没有什么区别-pipx安装失败请更换pip" 10 60) then
                    installxpm=pip3
                   else
                    installxpm=pipx
                   fi
                   # 获取root权限，如果本来就以root权限登录，那可以跳过
                   zxpd apt update -y && sudo apt upgrade -y
                   # 更新系统
                   if [ ${installxpm} = "pipx" ]; then
                   installapt  pipx  
                   # 安装pipx
                   zxpd pipx ensurepath  
                   fi
                   # 把pipx添加到环境变量
                   zxpd ${installxpm} install nb-cli
                   zxpd nb self install nb-cli-plugin-littlepaimon  
                   # 安装小派蒙脚手架插件
                   zxpd nb paimon create  
                   # 创建小派蒙项目
                   cd LittlePaimon  
                   # LittlePaimon为你刚刚填写的项目目录名
                   zxpd nb paimon res  
                   # 给出的两次选择均保持默认(回车两次)
                   zxpd nb paimon run playwright install chromium --with-deps  
                   # 安装playwright相关依赖
                   echo -e "${GREEN}安装已完成 在小派蒙目录下使用nb run 启动 ${RES}"     
                   sed -i "s/xpm:".*"/xpm:\"1\"/" /gancm/bot.cfg
                   pwd=$(pwd)
                   sed -i "s/xpmLJ:".*"/xpmLJ:\"${pwd//\//\\/}\"/" /gancm/bot.cfg
                   }

installyzbot(){
 YZI=$(whiptail --title "选择" --menu "选择功能" 15 70 8 \
     "1" "Yunzai原版安装" \
     "2" "Yunzai喵喵版安装" \
     "3" "Yunzai go-cqhtt版" 3>&1 1>&2 2>&3)
    
        if [ "${YZI}" = "1" -o "${YZI}" = "2" -o "${YZI}" = "3" ]; then
        if ! [ -x "$(command -v git)" ];then
               echo -e "${RED}目前并没有安装 Git 正在安装${RES}"
               installapt  git git
              fi
        if ! [ -x "$(command -v wget)" ];then
               echo -e "${RED}目前并没有安装 wget 正在安装${RES}"
               installapt  wget wget
              fi
             echo -e "${YELLOW}${NODE}${RES}"
            echo -e "${RED}Node.js（版本至少v16以上）yunzai喵喵 或 原版 Redis go版 go-qchttp 请仔细核对 三秒后开始继续安装${RES}"
            
            sleep 3s
            dir="Yunzai-Bot"
            res=$(ls -A $dir)
               if ! [ -z "$res" ];then
                      echo -e "${YELLOW}文件夹${RES} ${RED}$dir${RES} ${YELLOW}不为空..........${RES}"
                      echo -e "${YELLOW}这会干扰正常的安装步骤${RES}"
                      echo -e " ${RED}是否删除文件夹${RES} ${YELLOW}（y/n）${RES}"
                      read -r BuginstallYZ
                      case ${BuginstallYZ} in
                      Y | y )
                         zxpd rm -rfv ./Yunzai-Bot/
                         zxpd rm -rfv ./Yunzai-Bot/.*
                         zxpd echo -e "${GREEN}删除完成${RES}"
                         ;;
                      N | n )
                         echo -e "${RED}为了不破坏原Yunzai-Bot文件 安装程序终止${RES}"
                         exit 0
                         ;;
                      *)
                         echo -e "${YELLOW}未知参数${RES}"
                         echo -e "${RED}为了不破坏原Yunzai-Bot文件 安装程序终止${RES}"
                         exit 0
                         ;;
                           esac
               fi
                        
                    if [ ${YZI} = "1" ]; then
                    echo -e "${GREEN}正在拉取"${whereinstall}"中Yunzai-Bot仓库${RES}"
                    zxpd git clone --depth=1 -b main https://"${installfor}"/Le-niao/Yunzai-Bot.git &
                    jdt Yunzai-Bot
                    elif [ ${YZI} = "2" ]; then
                    echo -e "${GREEN}正在拉取"${whereinstall}"中Yunzai-Bot仓库${RES}"
                    zxpd git clone --depth=1 -b main https://"${installfor}"/yoimiya-kokomi/Yunzai-Bot.git &
                    jdt Yunzai-Bot喵版
                    elif [ ${YZI} = "3" ]; then
                    echo -e "${GREEN}正在拉取"${whereinstall}"中Yunzai-Bot仓库${RES}"
                    zxpd git clone --depth 1 https://"${installfor}"/TimeRainStarSky/Yunzai ./Yunzai-Bot &
                    jdt Yunzai-Botgo版
                    zxpd git clone --depth 1 https://"${installfor}"/yoimiya-kokomi/miao-plugin ./Yunzai-Bot/plugins/miao-plugin &
                    jdt 喵喵插件 
                   
                    fi
                    if ! [ -x "$(command -v npm)" ];then
               echo -e "${RED}目前并没有安装 npm 正在安装${RES}"
               installapt npm 
              fi
              Nodest=$(grep -oP 'Nodes\s*:\s*\"\K[^"]+' /gancm/cfg.cfg)
              if [ ${Nodest} = 0 ]; then
                  zxpd npm install n -g
                  zxpd npm config set registry npm config set registry https://registry.npmmirror.com/
                  zxpd n 16
                  hash -r
              fi
                    zxpd apt-get install chromium-browser -y
                    cd Yunzai-Bot
                    zxpd npm install pnpm -g
                    zxpd pnpm install -P
                    zxpd pnpm add oicq -w
                    if [ ${YZI} = 3 ]; then
                    echo -e "${YELLOW}正在安装go-qchttp${RES}"
                    osType=$(uname -s)
                         if [[ $(uname -m) == "x86_64" ]]; then
                              url="https://github.com/Mrs4s/go-cqhttp/releases/download/v1.0.1/go-cqhttp_1.0.1_linux_amd64.deb"
                         elif [[ $(uname -m) == "aarch64" ]]; then
                              url="https://github.com/Mrs4s/go-cqhttp/releases/download/v1.0.1/go-cqhttp_1.0.1_linux_arm64.deb"
                         else
                              echo "改成本脚本无法为$(uname -m)框架的cup安装bot"
                              exit 1
                         fi
                    zxpd wget ${url} -O go-cqhttp.deb
                    jdt go-cqhttp
                    dpkg -i go-cqhttp.deb
                    echo "安装完成 后续请自行更改和设置配置文件"
                    elif [ ${YZI} = "1" -o ${YZI} = "2" ]; then
                    echo -e "${YELLOW}正在安装redis${RES}"
                    installapt redis 
                    fi
                    echo -e "${GREEN}安装已完成 在Yunzai目录下使用node app 启动 ${RES}"
                    if [ ${YZI} = 3 ]; then
                    echo -e "${GREEN}请先执行一遍 go-cqhttp 选择反向代理
                    ${YELLOW} 编辑文件 config.yml 修改为
      # 反向WS Universal 地址
      universal: ws://localhost:2536/go-cqhttp 
      ${RES}
      ${GREEN}account: # 账号相关
      栏目下 修改账号密码 
      或许启动只需要在存有config.yml文件夹的目录下使用 go-cqhttp 指令即可"
                    fi
                    sed -i "s/Yunzai:".*"/Yunzai:\"1\"/" /gancm/bot.cfg
                    pwd=$(pwd)
                     sed -i "s/YunzaiLJ:".*"/YunzaiLJ:\"${pwd//\//\\/}\"/" /gancm/bot.cfg
                    hcjx
            
            fi
}

chajian(){
     case "$1" in
     Xpm)
          echo 1
          ;;
     Yunzai)
          OPTIONSPL=$(whiptail --title "云崽bot插件安装--空格选择" --checklist \
                   "请选择以下选项：" 15 60 4 \
                   "1" "锅巴插件" OFF \
                   "2" "喵喵插件" OFF \
                   "3" "文案插件" OFF \
                   "4" "星穹铁道插件" OFF \
                   3>&1 1>&2 2>&3)
               
               # 使用for循环依次输出选项
               for opt in ${OPTIONSPL}
               do
                   case $opt in
                       \"1\")
                           cd ${YunzaiLJ}
                           wjjpd ./plugins/Guoba-Plugin
                           zxpd git clone --depth=1 https://"${installfor}"/guoba-yunzai/guoba-plugin.git ./plugins/Guoba-Plugin/ &
                           jdt 锅巴插件
                           zxpd pnpm install --filter=guoba-plugin
                           jdt 锅巴插件依赖
                           ;;
                       \"2\")
                           cd ${YunzaiLJ}
                           wjjpd ./plugins/miao-plugin
                           zxpd git clone --depth=1 https://"${installfor}"/yoimiya-kokomi/miao-plugin.git ./plugins/miao-plugin/ &
                           jdt 喵喵插件
                           zxpd pnpm install --filter=miao-plugin
                           jdt 喵喵插件依赖
                           ;;
                           \"3\")
                           cd ${YunzaiLJ}
                           wjjpd ./plugins/wenan-plugin
                           zxpd git clone --depth=1 https://gitee.com/white-night-fox/wenan-plugin.git ./plugins/wenan-plugin/ &
                           jdt 文案插件
                           zxpd pnpm install --filter=wenan-plugin
                           jdt 文案插件依赖
                           ;;
                       \"4\")
                          cd ${YunzaiLJ}
                          wjjpd ./plugins/StarRail-plugin
                          zxpd git clone --depth=1 https://"${installfor}"/hewang1an/StarRail-plugin.git ./plugins/StarRail-plugin &
                          jdt 星穹铁道插件
                          zxpd pnpm install --filter=StarRail-plugin
                          jdt 星穹铁道插件依赖
                          ;;
                   esac
               done
     ;;
     esac
}
case $1 in
-h | --help)
echo -e "

                         ${YELLOW}帮助内容  ${RES}
 本脚本提供  小派蒙  Yunzai-Bot各版本 QQ机器人自动安装
 这是有本人（MIt_gancm[QQ:2169238901]） 闲来无事写的
 如果遇到bug请进入群聊[QQ群:708903788] 联系MIt_gancm
 作者要想要让脚本支持 文字 和 gui 所以真的有在想办法兼容
 
 文字指令:
 -h                          显示当前帮助
 -install [安装参数]          安装bot 当前可为Yunzai（云崽机器人） 和 Xpm（小派蒙机器人）
 
 贡献 不分先后主次
 网名                      QQ                       帮助类型
 屑丿饼干         2562248115(屑丿饼干)         脚本的编写建议和精神上的帮助
 漠漠             22911884（漠漠）             脚本的编写建议和精神上的帮助
 "
;;


-i | --install | i | install)
     jzbl
     case $2 in
     Yunzai)
          installyzbot
              exit 0
              ;;
     Xpm)
          installxpmbot
              exit 0
              ;;
     *)
          echo -e "${RED}未知参数 请用-h查看${RES}"
          ;;
     esac
;;
    


-start)
jzbl
     case $2 in
     Yunzai)
          zxpd startbot Yunzai
              ;;
     Yunzaijm)
          zxpd startbot Yunzaijm
              ;;
     Xpm)
          startbot Xpm
              ;;
     Xpmjm)
          startbot Xpmjm
              ;;
     esac
         
;;

*)

csh

PPAADD ceshi 
startbot ceshi 
##函数
jzbl
if [ "${whereinstall}" = "Gitee" ]; then
          installfor=gitee.com
     elif [ "${whereinstall}" = "Github" ]; then
          installfor=github.com
     else
          echo -e "${YELLOW}未知安装源 已重置为github${RES}"
          installfor=github.com
     fi



##安装源
  if [ "${JBXX}" = "1" ]; then

 echo -e ${YELLOW}安装必要依赖 无论之前是否安装${RES}
 apt install neofetch whiptail -y
    
 neofetch
 echo -e "
 
 
 
 
 
 
${YELLOW}####################################################################################${RES}

${GREEN}当前是${YELLOW}${release_os}${GREEN}系统版本号为：${YELLOW}${release_num}  ${GREEN}系统运行时间:${YELLOW}${os_start}${RES}  

硬盘占用信息:
${RED}${yingpan}${RES}
                                             -By MIt_gancm
   脚本属于静默安装 部分操作会拦截提示 如果长时间未出现任何提示 请尝试重新运行版脚本
${RED}即将开始运行${RES}
                                                        
${YELLOW}####################################################################################${RES}
 "
 sleep 2s
 else
  echo 
  fi
 ##系统信息
 
 




##文字版
 while true; do
 
##if1
     OPTION=$(whiptail --title "选择安装" --menu "选择你要安装的机器人（Yunzai-Bot请使用乌班图18   小派蒙请使用乌班图20 问就是有bug）" 15 50 4 \
     "1" "小派蒙--Bot NB2" \
     "2" "Yunzai-Bot" \
     "3" "待添加" \
     "0" "其他设置" 3>&1 1>&2 2>&3)
     
     if [ "$OPTION" = 1 ]; then 
           while true; do
           XPMI=$(whiptail --title "选择" --menu "选择功能" 15 70 8 \
            "1" "安装小派蒙" \
            "2" "启动小派蒙" \
            "3" "启动小派蒙 -- 后台" \
            "4" "解决13579链接失败" \
            "0" "返回上级" 3>&1 1>&2 2>&3)
            if [ "${XPMI}" = 1 ]; then
             installxpmbot
            elif [ "${XPMI}" = 2 ]; then
             startbot Xpm
            elif [ "${XPMI}" = 3 ]; then
             startbot Xpmjm
             echo -e ${GREEN}进程已被放置在虚拟终端${YELLOW}screen -r bot${GREEN}查看日志\n进入虚拟终端后 退出终端请点击 ${YELLOW} clrl+ad${GREEN}\n进入虚拟终端后 结束终端请进程点击 ${YELLOW} clrl+d${GREEN}${RES}
            elif [ "${XPMI}" = 4 ]; then
              if ! [ -x "$(command -v iptables)" ];then
               echo -e "${RED}目前并没有安装 iptables 正在安装${RES}"
               installapt iptables
              fi 
              if ! [ -x "$(command -v npm)" ];then
               echo -e "${RED}目前并没有安装 lsof 正在安装${RES}"
               installapt lsof
              fi
              if ! [ -x "$(command -v netstat)" ];then
               echo -e "${RED}目前并没有安装 net-tools 正在安装${RES}"
               installapt net-tools
              fi

               # 查找端口为 13579 的进程 ID
               PID=$(lsof -ti :13579)
               if [[ -n $PID ]]; then
                 # 结束进程
                 echo "已结束进程 : $PID"
                 kill -9 $PID
               else
                 echo "没用进程占用13579"
               fi
               # 查找与端口为 13579 相关的链接并关闭它们
               CONNS=$(netstat -tnp | grep ':13579' | awk '{print $5}' | awk -F: '{print $1}' | sort -u)
               
               for conn in $CONNS; do
                 echo "尝试结束进程 :$conn"
                 iptables -A INPUT -s $conn -j DROP
               done
               hcjx
            elif [ "${XPMI}" = 0 ]; then
               break
            else 
               break
            fi
               done
            
     
   elif [ "$OPTION" = 2 ]; then
   while true; do
     YunzaiBot=$(whiptail --title "选择安装" --menu "选择你要安装的机器人" 27 60 8 \
     "1" "安装Yunzai-Bot" \
     "2" "启动Yunzai-Bot"  \
     "3" "后台启动Yunzai-Bot" \
     "4" "停止Yunzai-Bot" \
     "5" "查看后台Yunzai-Bot日志" \
     "6" "重置Yunzai-Bot账号" \
     "7" "解决锅巴插件端口被占用" \
     "8" "插件安装" \
     "0" "返回上级" 3>&1 1>&2 2>&3)
     if [ "${YunzaiBot}" = 1 ]; then
     installyzbot

         elif [ "${YunzaiBot}" = 2 ]; then
         startbot Yunzai
         ENDTIME=`date +%s`
         
         
         elif [ "${YunzaiBot}" = 3 ]; then
         startbot Yunzaijm
         
         elif [ "${YunzaiBot}" = 4 ]; then
         startbot Yunzaistop
         hcjx
         
         elif [ "${YunzaiBot}" = 5 ]; then
         startbot Yunzailog
         hcjx
         
         elif [ "${YunzaiBot}" = 6 ]; then
         cd ${YunzaiLJ} && pnpm run login
         hcjx
         
         elif [ "${YunzaiBot}" = 7 ]; then
           if ! [ -x "$(command -v iptables)" ];then
               echo -e "${RED}目前并没有安装 iptables 正在安装${RES}"
               installapt iptables
              fi 
              if ! [ -x "$(command -v lsof)" ];then
               echo -e "${RED}目前并没有安装 lsof 正在安装${RES}"
               installapt lsof
              fi
             if ! [ -x "$(command -v netstat)" ];then
               echo -e "${RED}目前并没有安装 net-tools 正在安装${RES}"
               installapt net-tools
              fi
              
         # 查找端口为 50831 的进程 ID
               PID=$(lsof -ti :50831)
               if [[ -n $PID ]]; then
                 # 结束进程
                 echo "已结束进程 : $PID"
                 kill $PID
               else
                 echo "没用进程占用50831"
               fi
               
               # 查找与端口为 13579 相关的链接并关闭它们
               CONNS=$(netstat -tnp | grep ':50831' | awk '{print $5}' | awk -F: '{print $1}' | sort -u)
               
               for conn in $CONNS; do
                 echo "尝试结束进程 :$conn"
                 sudo iptables -A INPUT -s $conn -j DROP
               done
               hcjx
          
         elif [ "${YunzaiBot}" = 8 ]; then
            chajian Yunzai
            
         elif [ "${YunzaiBot}" = 0 ]; then
         break
         else 
         break
   
fi
     done
     
     elif [ "$OPTION" = 3 ]; then 
      echo 你想选择3
      
      
      elif [ "$OPTION" = 0 ]; then
while true; do
      OPTIONQT=$(whiptail --title "选择" --menu "选择功能" 17 55 8 \
     "1" "增加脚本启动命令" \
     "2" "sh脚本安全性查杀" \
     "3" "bot基本信息修改" \
     "4" "脚本配置基本信息修改" \
     "5" "增减PPA源" \
     "114514" "关于" \
     "1919810" "可用性测试" \
     "0" "返回上级" 3>&1 1>&2 2>&3)
     
     
     if [ "${OPTIONQT}" = 1 ];then
     read -p "输入默认启动名:" cj
     if [ "${cj}" = "${K}" ];then
     echo -e "${RED}启动命令无效 或 未设置启动命令${RES}"
     hcjx
     else
     if [ "${QDML}" = "${K}" ]; then
     echo -e "${YELLOW}上一次的启动命令为空值${RES}"
     else
     echo 上次启动命令为${QDML}
     echo -e "${RED}删除/usr/bin/${QDML}${RES}"
     rm -rfv /usr/bin/"${QDML}"
     fi
     cp "${0}" /usr/bin/"${cj}"
     chmod 777 /usr/bin/"${cj}"
     sed -i "s/QDML:".*"/QDML:\"$cj\"/" /gancm/cfg.cfg
     echo -e "接下来你可以通过使用${GREEN}${cj}${RES}来启动本脚本 \n 如果需要删除，请手动执行 ${RED}rm -rfv /usr/bin/${cj}${RES}"
     echo -e "${GREEN}目前启动命名为${cj}${RES}"
     hcjx
     fi
     
     
     elif [ "${OPTIONQT}" = 2 ];then
    Chasha=$(whiptail --title "异常脚本查杀" --inputbox "查杀初始目录" 10 60 ./ 3>&1 1>&2 2>&3)

exitstatus=$?

if [ "${exitstatus}" = 0 ]; then
    yisi=$(find ${Chasha} -name "*.sh")
    echo -e "${GREEN}检查脚本关键词: 『rm』...${RES}"
    grep -r 'rm' ${yisi}*.sh --color=auto "or"
    echo -e "${YELLOW}以上为一场小本信息及关键词标注${RES}"
    echo -e "${RED}这条删除命令 虽然没有什么大问题 但请一定要注意后续删掉的目录 或文件${RES}"
    echo -e 
    echo -e "####################################################################################################"
    
    echo -e "${GREEN}检查脚本关键词: 『su』...${RES}"
    grep -r 'su' ${yisi}*.sh --color=auto "or"
    echo -e "${YELLOW}以上为一场小本信息及关键词标注${RES}"
    echo -e "${RED}他会将用户等级切换为SU 请一定要设置好密码${RES}"
    echo -e "####################################################################################################"
    
    echo -e "${GREEN}检查脚本关键词: 『usr』...${RES}"
    grep -r 'usr' ${yisi}*.sh --color=auto "or"
    echo -e "${YELLOW}以上为一场小本信息及关键词标注${RES}"
    echo -e "${RED}涉及系统目录操作${RES}"
    echo -e "####################################################################################################"
    
    echo -e "${GREEN}检查脚本关键词: 『etc』...${RES}"
    grep -r 'etc' ${yisi}*.sh --color=auto "or"
    echo -e "${YELLOW}以上为一场小本信息及关键词标注${RES}"
    echo -e "${RED}涉及系统目录操作${RES}"
    echo -e "####################################################################################################"
    
    echo -e "${GREEN}检查脚本关键词: 『passwd』...${RES}"
    grep -r 'passwd' ${yisi}*.sh --color=auto "or"
    echo -e "${YELLOW}以上为一场小本信息及关键词标注${RES}"
    echo -e "${RED}涉及更改用户密码${RES}"
    echo -e "####################################################################################################"
    

    echo -e "${GREEN}检查脚本关键词: 『kill -9』...${RES}"
    grep -r 'kill -9' ${yisi}*.sh --color=auto "or"
    echo -e "${YELLOW}以上为一场小本信息及关键词标注${RES}"
    echo -e "${RED}强制结束一些进程 一般是用于 解决无响应进程 也可以被不法分子利用来隐藏运行软件${RES}"
    echo -e "####################################################################################################"
    
    echo -e "${GREEN}检查脚本关键词: 『ssh』...${RES}"
    grep -r 'ssh' ${yisi}*.sh --color=auto "or"
    echo -e "${YELLOW}以上为一场小本信息及关键词标注${RES}"
    echo -e "${RED}涉及远程ssh 内网用户无需担心 公网用户，请你一再检查${RES}"
    echo -e "####################################################################################################"
    echo -e "${RED}检查结果均为关键词匹配 自行检查安全性 ${RES}"
    hcjx
    
    
     else
    echo "您取消了查杀"
     fi
   
    
    
    elif [ "${OPTIONQT}" = 3 ];then
    while true; do
    BOTPZWJ=$(whiptail --title "选择" --menu "选择功能" 16 50 7 \
     "1" "Yunzai安装状态修正" \
     "2" "Yunzai安装路径修正" \
     "3" "小派蒙安装状态修正" \
     "4" "小派蒙安装路径修正" \
     "0" "退出" 3>&1 1>&2 2>&3)
     if [ "${BOTPZWJ}" = "1" ]; then
     if (whiptail --title "Yes/No Yunzai安装状态" --yes-button "安装了" --no-button "未安装"  --yesno "脚本开始的基本信息" 10 60) then
     
    sed -i "s/Yunzai:".*"/Yunzai:\"1\"/" /gancm/bot.cfg
else
    sed -i "s/Yunzai:".*"/Yunzai:\"0\"/" /gancm/bot.cfg
fi


     elif [ "${BOTPZWJ}" = "2" ]; then
     
     YunzaiLJXZ=$(whiptail --title "Yunzai安装路径修正" --inputbox "请输入Yunzai安装路径 结尾不要带斜杠" 10 60 ./ 3>&1 1>&2 2>&3)
 
exitstatus=$?
if [ $exitstatus = 0 ]; then
    sed -i "s/YunzaiLJ:".*"/YunzaiLJ:\"${YunzaiLJXZ//\//\\/}\"/" /gancm/bot.cfg
else
    echo -e "${YELLOW}取消修正${RES}."
fi
     
     elif [ "${BOTPZWJ}" = "3" ]; then
     
    if (whiptail --title "Yes/No Yunzai安装状态" --yes-button "安装了" --no-button "未安装"  --yesno "脚本开始的基本信息" 10 60) then
     
    sed -i "s/Yunzai:".*"/xpm:\"1\"/" /gancm/bot.cfg
else
    sed -i "s/Yunzai:".*"/xpm:\"0\"/" /gancm/bot.cfg
fi
     elif [ "${BOTPZWJ}" = "4" ]; then
     
     xpmLJXZ=$(whiptail --title "小派蒙安装路径修正" --inputbox "请输入Yunzai安装路径 结尾不要带斜杠" 10 60 ./ 3>&1 1>&2 2>&3)
 
exitstatus=$?
if [ $exitstatus = 0 ]; then
    sed -i "s/xpmLJ:".*"/xpmLJ:\"${xpmLJXZ//\//\\/}\"/" /gancm/bot.cfg
else
    echo -e "${YELLOW}取消修正${RES}."
fi
     
     
     
     elif [ "${BOTPZWJ}" = "0" ]; then
      break
     else
      break
    fi
    done
    
    
    elif [ "${OPTIONQT}" = 4 ];then
    while true; do
     PZWJ=$(whiptail --title "选择" --menu "选择功能" 15 60 4 \
     "1" "是否开启基本信息显示" \
     "2" "是否开启脚本权限校验" \
     "0" "返回上级" 3>&1 1>&2 2>&3)
     
     if [ "${PZWJ}" = "1" ]; then
     if (whiptail --title "Yes/No 是否开启基本信息" --yes-button "on" --no-button "off"  --yesno "脚本开始的基本信息" 10 60) then
    sed -i "s/JBXX:".*"/JBXX:\"1\"/" /gancm/cfg.cfg
    else
    sed -i "s/JBXX:".*"/JBXX:\"0\"/" /gancm/cfg.cfg
    fi
    
    elif [ "${PZWJ}" = "2" ]; then
     if (whiptail --title "Yes/No 是否开启ROOT权限校验" --yes-button "on" --no-button "off"  --yesno "脚本开始的基本信息" 10 60) then
    sed -i "s/ROOT:".*"/ROOT:\"1\"/" /gancm/cfg.cfg
    else
    sed -i "s/ROOT:".*"/ROOT:\"0\"/" /gancm/cfg.cfg
    fi
    
    elif [ "${PZWJ}" = "0" ]; then
    break
    else 
    echo 脚本配置结束
    break
    fi
    done
    
     
    elif [ "${OPTIONQT}" = 5 ];then
         if [ "${PPA}" = 0 ];then
         echo -e "${YELLOW}正在安装 PPA必要模块${RES}"
         zxpd apt -y install software-properties-common dirmngr apt-transport-https lsb-release ca-certificates
         zxpd apt update -y
         sed -i "s/PPA:".*"/PPA:\"1\"/" /gancm/cfg.cfg
         PPA=$(grep -oP 'PPA\s*:\s*\"\K[^"]+' /gancm/cfg.cfg)
         fi
       APPA=$(whiptail --title "选择" --menu "选择功能" 16 50 7 \
     "1" "增减Python PPA 源" \
     "2" "增减chromium-beta PPA 源" \
     "0" "退出" 3>&1 1>&2 2>&3)
     if [ "${APPA}" = "1" ]; then
          if (whiptail --title "Yes/No 增减Python PPA 源" --yes-button "增加" --no-button "删除"  --yesno "为系统添加第三方Python下载源 几乎全版本" 10 60) then
     
                 zxpd PPAADD python add
          else
                 zxpd PPAADD python unadd
          fi
     elif [ "${APPA}" = "2" ]; then
          if (whiptail --title "Yes/No 增减chromium-beta PPA 源" --yes-button "增加" --no-button "删除"  --yesno "为系统添加第三方Python下载源 几乎全版本" 10 60) then
     
                 zxpd PPAADD chromium add
          else
                 zxpd PPAADD chromium unadd
          fi  
     elif [ "${PPA}" = "0" ]; then
       echo
     fi

              elif [ "${OPTIONQT}" = 114514 ];then
               echo -e "

                         ${YELLOW}帮助内容  ${RES}
 本脚本提供  小派蒙  Yunzai-Bot各版本 QQ机器人自动安装
 这是有本人（MIt_gancm[QQ:2169238901]） 闲来无事写的
 如果遇到bug请进入群聊[QQ群:708903788] 联系MIt_gancm
 作者要想要让脚本支持 文字 和 gui 所以真的有在想办法兼容
 
 文字指令:
 -h                          显示当前帮助
 -install [安装参数]          安装bot 当前可为Yunzai（云崽机器人） 和 Xpm（小派蒙机器人）
 
 
 贡献 不分先后主次
 网名                      QQ                       帮助类型
 屑丿饼干         2562248115(屑丿饼干)         脚本的编写建议和精神上的帮助
 漠漠             22911884（漠漠）             脚本的编写建议和精神上的帮助
 "
hcjx

     elif [ "${OPTIONQT}" = 1919810 ];then
     while true; do
     CS=$(whiptail --title "选择" --menu "选择功能" 16 50 7 \
     "1" "执行判断 错误检测" \
     "2" "执行判断 正确检测" \
     "3" "待添加" \
     "0" "退出" 3>&1 1>&2 2>&3)
     if [ "${CS}" = "1" ]; then
           zxpd 测试
           hcjx
     elif [ "${CS}" = "2" ]; then
           zxpd echo 测试
           hcjx
     elif [ "${CS}" = "3" ]; then
           zxpd echo 都说了待添加 还点手痒痒是吧
           hcjx
     elif [ "${CS}" = "0" ]; then
           break
           
     else
           break
     fi
     done

    else
    echo 其他结束
    break
    fi
done
    
    else
      echo 返回值为否
      echo 选项值为$OPTION
      break
    fi
##fi1
done
;;

esac


