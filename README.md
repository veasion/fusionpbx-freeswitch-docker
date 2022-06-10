# 安装 fusionpbx & freeswitch


## 基于veasion/fusionpbx-freeswitch-debian构建镜像
```
docker run --net=host --privileged --restart=always --name fusionpbx -d veasion/fusionpbx-freeswitch-debian
```

## postgressql数据库设置:

```
docker exec fusionpbx sudo -u postgres psql -c "ALTER USER fusionpbx WITH PASSWORD '123456';"
```

初始化fusionpbx，访问地址：http://你的外网IP

前面直接 NEXT 下一步，设置 Admin 的 username/password 和 Database 的 Database username / password即可。数据库用户名/密码为上面执行的命令: fusionpbx / 123456，其余默认即可。

## 完成初始化后执行命令替换配置文件
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

添加设置如下字段
Extension
Effective Caller ID Name
Effective Caller ID Number

点击 SAVE，页面刷新后 找到 Password 修改密码 完成。

分机号 1001-2999
视频会议号 3000+

## 设置 fusionpbx 参数
### Adanced > Variables

修改 default_language 为 zh ；default_dialect 为 cn；default_voice 为 link；default_country 为 CN；

external_rtp_ip  和 external_sip_ip 修改为 公网IP；

在 Sound 下新增 sound_prefix 为 $${sounds_dir}/zh/cn/link  设置优先级 006

### Adanced > SIP Profiles

修改 internal 和 external 中的 ext-rtp-ip 和 ext-sip-ip 为 公网IP



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

socket event默认设置为: localhost  端口 8021  默认密码： ClueCon



### 不能挂载任意目录
否则安装失败

注意：--net=host在windows desktop版本下无效



### 拨打96646不通，日志报错 

[CRIT] switch_loadable_module.c:1520 Error Loading module /usr/lib/freeswitch/mod/mod_local_stream.so
**Module load routine returned an error

fs_cli 中执行  reload mod_local_stream



### sip软电话测试

windows 安装 eyeBeam https://veasion-files.oss-cn-shanghai.aliyuncs.com/github/files/eyebeam_V1.5.rar

android 安装 linphone http://www.linphone.org/sites/default/files/linphone-latest.apk



添加SIP账号示例：用户名和鉴权用户名 1000，口令 1234，域名 139.224.75.196:5060    类型：udp

另一台电脑也运行一个，两个拨号测试。

也可以直接拨打 9664 内置音乐号码。



查看freeswitch日志：

docker exec -it fusionpbx bash

tail -fn 200 /var/log/freeswitch/freeswitch.log




## fusionpbx详细设置地址：
http://note.youdao.com/noteshare?id=74a91bfa08a298cfab62262a66713fbc&sub=35DB41D2771B4E2F82C6C1B139421E33



## ~~配置网关和拨号计划~~

配置网关(conf/sip_profiles/external 下添加一个 gateway_test.xml)：

<gateway name="gateway_test">
    <param name="realm" value="语音网关IP" />
    <param name="username" value="账号" />
    <param name="password" value="密码" />
    <!-- <param name="proxy" value="代理IP:5060" /> -->
    <param name="register" value="true" />
</gateway>



拨号计划(conf/dialplan/default 下添加一个 test.xml)：

<include>
    <extension name="call out">
	    <!-- 86开头路由到test网关（真实号码不包含86） -->
        <condition field="destination_number" expression="^86(\d+)$">
            <action application="bridge" data="sofia/gateway/gateway_test/$1"/>
        </condition>
    </extension>
</include>

