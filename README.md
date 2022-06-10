# 安装 fusionpbx & freeswitch


## 基于veasion/fusionpbx-freeswitch-debian构建镜像
```
docker run --net=host --privileged --restart=always --name fusionpbx -d veasion/fusionpbx-freeswitch-debian
```

## postgressql数据库设置:

```
docker exec fusionpbx sudo -u postgres psql -c "ALTER USER fusionpbx WITH PASSWORD '123456';"
```

访问fusionpbx：https://ip:80
安装fusionpbx，设置账户密码，数据库部分：数据库用户名/密码:fusionpbx/123456，其余默认即可。



## 完成安装后替换配置文件
```
sudo sh replace_conf.sh
```

## 防火墙开放端口：

5060/tcp 5060/udp 5080/tcp 5080/udp as SIP Signaling ports.
5066/tcp 7443/tcp as WebSocket Signaling ports.
8021/tcp as Event Socket port.
64535-65535/udp as media ports.
16384-32768/udp


sudo ufw allow 443/tcp
sudo ufw allow 5060/tcp
sudo ufw allow 5060/udp
sudo ufw allow 5080/tcp
sudo ufw allow 5080/udp
sudo ufw allow 5066/tcp
sudo ufw allow 7443/tcp
sudo ufw allow 8021/tcp
sudo ufw allow 64535:65535/udp
sudo ufw allow 16384:19999/udp


## 添加分机号 Accounts > Extensions

添加
Extension
Effective Caller ID Name
Effective Caller ID Number

点击 SAVE，页面刷新后 找到 Password 修改密码 完成。


分机号 1001-2999
视频会议号 3000+

## 安装常见问题：

## 安装第三步 选择 Country 时：默认使用 United States  不要选择 China 容易安装失败

### 安装时出现以下提示：

Warning: fsockopen(): unable to connect to localhost:8021 (Connection refused) in /var/www/fusionpbx/resources/classes/event_socket.php on line 106
Failed to detect configuration detect_switch reported: Failed to use event socket

尝试如下操作：

1）稍等片刻重新刷新页面

2）很可能安装失败，请仔细检查freeswtich日志是否有错误，



### 安装时出现以下提示：

Failed to create the switch conf directory.

尝试重新输入ip访问，不修改 socket event 密码，直接默认下一步。



### 不能挂载任意目录
否则安装失败


注意：--net=host在windows desktop版本下无效


## fusionpbx详细设置地址：
http://note.youdao.com/noteshare?id=74a91bfa08a298cfab62262a66713fbc&sub=35DB41D2771B4E2F82C6C1B139421E33