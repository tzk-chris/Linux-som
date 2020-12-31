[TOC]

## tzk_shell三剑客之（awk）



### awk内置变量

NF：一行的字段总数

NR：行号

FS：输入分隔符    --等同于  -F

OFS：输出分隔符   output  field  separate



### 注意语法：


​	1、自定义的变量，一般建议在BEGIN
​	2、; 表示执行多条命令
​	3、{命令}
​	4、引用自定义变量，不需要接$符号
​	5、print是一个输出的命令



### awk的匹配：

匹配出行号是以5结尾的：

```shell
[root@sed ~]# awk -F: 'NR ~ /.*5/{print NR,$1}' /etc/passwd
5 lp
15 systemd-coredump
25 nginx
```

取出本机的ip地址：

```shell
[root@sed ~]# ip add|awk '/inet.*ens33/{print $2}'
192.168.0.18/24
```

取出ens33的网络流量（KB）

```shell
[root@sed ~]# ifconfig|awk 'NR==5||NR==7{print $5}'
622645750
8883745
```

使用shell变量，要用双引号“”

```shell
[root@sed ~]# name=robot
[root@sed ~]# cat /etc/passwd|awk -F: "/$name/{print \$1,\$3}"
robot 9925
robot1 9926
robot2 9927
```



### 自己遇到的经典面试题：

如果有第二列数字，怎么把它们加起来：

```shell
[root@mysql-bianyi ~]# cat tzk.txt 
1
2
3
4
5
[root@mysql-bianyi ~]# cat tzk.txt |awk 'BEGIN{n=0}{n+=$1}END{print n}'
15
```

