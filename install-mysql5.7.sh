#!/bin/bash
cd /usr/local
tar -zxvf mysql-5.7.35-linux-glibc2.12-x86_64.tar.gz
mv mysql-5.7.35-linux-glibc2.12-x86_64 mysql
cd /usr/local/mysql

# 检查是否存在MySQL和mariadb
# rpm -qa | grep mysql mariadb
# rm -rf /etc/my.cnf

# 创建 MySQL 用户以及用户组
groupadd mysql
useradd -r -g mysql mysql

# 创建data、tmp、etc文件夹（usr/local/mysql/目录下）
mkdir /usr/local/mysql/data
mkdir /usr/local/mysql/tmp
mkdir /usr/local/mysql/etc

# 因为mysql从5.7开始就没有my.cnf文件了，所以，需要进入usr/local/mysql/etc目录下创建my.cnf文件。
cat>my.cnf<<EOF 
[mysql]

default-character-set=utf8
[mysqld]
skip-name-resolve
#设置3306端口
# skip-grant-tables
port = 3306
# 设置mysql
basedir=/usr/local/mysql

datadir=/usr/local/mysql/data

max_connections=200
character-set-server=utf8
default-storage-engine=INNODB
lower_case_table_names=1
max_allowed_packet=16M
EOF

# 把mysql目录下除了data外的改为root所有，data为mysql用户所有。
chgrp -R mysql .
chown -R root .
chown -R mysql data

# 初始化MySQL配置表（usr/local/mysql/目录下）执行命令
/usr/local/mysql/bin/mysqld --initialize --user=mysql --basedir=/usr/local/mysql --datadir=/usr/local/mysql/data 
./usr/local/mysql/support-files/mysql.server start

# 作MySQL配置
cp /usr/local/mysql/support-files/mysql.server  /etc/init.d/mysqld
chmod 755 /etc/init.d/mysqld
chkconfig --list mysqld
chkconfig --add mysqld
chkconfig mysqld on
service mysqld start

# 创建软链接（目的就是为了能够在全局使用mysql命令）
ln -s /usr/local/mysql/bin/mysql  /usr/local/bin

# 修改密
# 1、修改/usr/local/mysql/etc/my.cnf 配置文件，找到[mysqld]在之后添加：skip-grant-tables。然后保存并退出。
# 2、重启mysql：service mysqld  restart
# 3、mysql -u root -p免密登录
# 4、使用：update mysql.user e tauthentication_string=password('123456') where user='root';修改密码
# 5、命令：flush privileges刷新
# 6、退出mysql，并进入my.cnf文件删除skip-grant-tables命令。
# 7、重启使用新密码登录mysql即可。码
