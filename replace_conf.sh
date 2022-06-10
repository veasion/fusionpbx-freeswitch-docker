sudo docker cp conf/vars.xml fusionpbx:/etc/freeswitch/vars.xml
sudo docker cp conf/freeswitch.xml fusionpbx:/etc/freeswitch/freeswitch.xml
sudo docker cp conf/switch.conf.xml fusionpbx:/etc/freeswitch/autoload_configs/switch.conf.xml
# sudo docker cp conf/lang/zh fusionpbx:/etc/freeswitch/lang/zh
# 安装fusionpbx完成后路径变为/etc/freeswitch/languages 之前是 /etc/freeswitch/lang
sudo docker cp conf/lang/zh fusionpbx:/etc/freeswitch/languages/zh
sudo docker cp conf/sounds/zh fusionpbx:/usr/share/freeswitch/sounds/zh
sudo docker exec fusionpbx bash -c "sudo chown -R freeswitch:freeswitch /etc/freeswitch && sudo chmod 777 /etc/freeswitch"
sudo docker exec fusionpbx bash -c "sudo chown -R freeswitch:freeswitch /usr/share/freeswitch/sounds/zh && sudo chmod 777 /usr/share/freeswitch/sounds/zh"
sudo docker exec fusionpbx bash -c "sudo cp /usr/share/freeswitch/sounds/music /usr/share/freeswitch/sounds/default -r"
sudo docker restart fusionpbx
sudo echo "done."