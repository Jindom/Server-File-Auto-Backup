#!/bin/bash
echo "+------------------------------------------------------------------------+"
echo "|                    Server Data Auto Backup Script                      |"
echo "+------------------------------------------------------------------------+"
echo "|        A tool to auto-compress & auto-upload to FTP server             |"
echo "+------------------------------------------------------------------------+"
echo "|         For more information please visit https://wp.jinzz.cc          |"
echo "+------------------------------------------------------------------------+"
echo "请输入你的FTP服务器IP地址(例如182.148.157.246):"
read -p "FTP服务器IP:" FTPIP
echo "请输入你的FTP服务器端口(例如21):"
read -p "FTP服务器端口:" FTPPORT
echo "请输入你的FTP服务器的用户名和密码(例如admin password):"
read -p "FTP用户名密码:" USERPASSWD
echo "请输入你的数据库用户名(例如root):"
read -p "数据库用户名:" databasename
echo "请输入你的数据库密码(例如passowrd):"
read -p "数据库密码:" databasepass
echo "请输入你想要保存文档到FTP服务器的何位置(例如/share/backup):"
read -p "FTP服务器路径:" sdir1
echo "请输入你需要备份的目录(例如/root/data):"
read -p "备份目录名称:" dir1
echo "请输入你需要备份的数据库名(例如wordpress):"
read -p "数据库名称:" database1
date=`date +%Y%m%d`
echo +++++++++++++++++++++++++++++++++
echo "开始备份网页文件数据"
echo +++++++++++++++++++++++++++++++++
cd /
tar -cvf $dir1"_"$date.tar $dir1 >> /dev/null
echo +++++++++++++++++++++++++++++++++
echo "开始上传网页文件数据"
echo +++++++++++++++++++++++++++++++++
ftp -A -n<<EOF
open $FTPIP $FTPPORT
user $USERPASSWD
cd $sdir1
lcd /
prompt
mput $dir1"_"$date.tar
close
bye
EOF
echo +++++++++++++++++++++++++++++++++
echo "文件上传完成，清理环境"
echo +++++++++++++++++++++++++++++++++
rm -rf $dir1"_"$date.tar
echo +++++++++++++++++++++++++++++++++
echo "开始备份数据库数据"
echo +++++++++++++++++++++++++++++++++
mysqldump -u$databasename -p$databasepass -h127.0.0.1 $database1 > /$database1"_"$date.dump
echo +++++++++++++++++++++++++++++++++
echo "开始上传数据库数据"
echo +++++++++++++++++++++++++++++++++
ftp -A -n<<EOF
open $FTPIP $FTPPORT
user $USERPASSWD
cd $sdir1
lcd /
prompt
mput $database1"_"$date.dump
close
bye
EOF
echo +++++++++++++++++++++++++++++++++
echo "文件上传完成，清理环境"
echo +++++++++++++++++++++++++++++++++
rm -rf $database1"_"$date.dump
echo +++++++++++++++++++++++++++++++++
echo "日志已保存到/home/backuplog"
echo +++++++++++++++++++++++++++++++++
