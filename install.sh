#!/bin/sh
echo -n "请输入您的V2Ray服务端口（默认：12345）";
read V2Ray_Port;
echo "您输入的是：${V2Ray_Port:-12345}"

echo -n "请输入您的V2Ray传输协议（默认：ws）";
read V2Ray_Network;
echo "您输入的是：${V2Ray_Network:-ws}"

echo -n "请输入您的数据库地址（默认：127.0.0.1）";
read Mysql_Host;
echo "您输入的是：${Mysql_Host:-127.0.0.1}"

echo -n "请输入您的数据库端口（默认：3306）";
read Mysql_Port;
echo "您输入的是：${Mysql_Port:-3306}"

echo -n "请输入您的数据库表名（默认：MyV2Ray）";
read Mysql_Db;
echo "您输入的是：${Mysql_Db:-MyV2Ray}"

echo -n "请输入您的数据库用户名（默认：MyV2Ray）";
read Mysql_User;
echo "您输入的是：${Mysql_User:-MyV2Ray}"

echo -n "请输入您的数据库密码（默认：123456）";
read Mysql_Password;
echo "您输入的是：${Mysql_Password:-123456}"

apt-get update -y
apt-get install curl git supervisor -y
wget https://install.direct/go.sh && chmod +x go.sh && ./go.sh
mkdir /root/v2mlite
cd /root/v2mlite
git clone -b master https://github.com/Moexin/V2MLite.git tmp && mv tmp/.git . && rm -rf tmp && git reset --hard
chmod +x v2mlite
sed -i "12s/12345/${V2Ray_Port:-52083}/g" /root/v2mlite/v2ray.json
sed -i "18s/ws/${V2Ray_Network:-ws}/g" /root/v2mlite/v2ray.json
sed -i "2s/127.0.0.1/${Mysql_Host:-127.0.0.1}/g" /root/v2mlite/config.json
sed -i "3s/3306/${Mysql_Port:-3306}/g" /root/v2mlite/config.json
sed -i "4s/MyV2Ray/${Mysql_Db:-MyV2Ray}/g" /root/v2mlite/config.json
sed -i "5s/MyV2Ray/${Mysql_User:-MyV2Ray}/g" /root/v2mlite/config.json
sed -i "6s/123456/${Mysql_Password:-123456}/g" /root/v2mlite/config.json
cat << EOF >> /etc/supervisor/conf.d/v2mlite.conf
[program:v2mlite]
directory=/root/v2mlite
command=/root/v2mlite/v2mlite
user=root
autostart = true
autorestart = true
startsecs=5
EOF
systemctl stop v2ray
sleep 3
systemctl disable v2ray
supervisorctl reload
echo '部署完成,请等待5秒查看以下输出有无报错。'
sleep 6
supervisorctl status