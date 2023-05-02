# Yunzai-Script

包含Yunzai,小派蒙自动安装脚本
目前处于测试阶段

# 首先下载脚本

```
git clone https://github.com/Yummy-cookie/Yunzai-Script.git
#拉取库
wget https://github.com/Yummy-cookie/Yunzai-Script/raw/fd8764cce40b3126c860e2389adb4a4019b772dc/install.sh
#拉取脚本 可能具有时效性
```

# 运行

```

cd Yunzai-Script && bash install.sh

```

*注意:首次启动会创建和加载配置文件 建议选root运行

您可以使用文字运行脚本(目前不是很理想)

例如

```

bash install.sh -install Xpm

##安装小派蒙

```

具体文字运行那可使用

```

bash install.sh -h

```

查看

(小声) 您也可以在其他设置中增加脚本启动命令 后续脚本启动可以直接使用您所设置的启动命令执行（复制自身文件到/usr/bin/ 再次设置会删除上一次所设置的内容）

# 安装

```

方式一:

bash install.sh

#运行脚本

```

选择您要安装的机器人

方式二:

```

bash install.sh -install Xpm

#具体可以使用 bash install.sh -h 查看

```

# 修复

倘若脚本遇到了一些莫名其妙的错误 请执行

```

rm -rfv /gancm/*

```

这是脚本的配置储存位置 将其删除可重置一切 配置错误

有能力者可以在其他设置中根据报错内容修改脚本 或许直接编辑 

/gancm/cfg.cfg 

/gancm/bot.cfg

# 联系
QQ↓

Mit_gancm:2169238901

饼干:2562248115
