Linux下编写shell脚本
实现创建10个用户，并设置10个不同的8个长度的密码

#!/bin/bash

# Author: BlueMiaomiao
# E-mail: xv2017@outlook.com
# GitHub: bluemiaomiao.github.io

for i in $(seq -w 10)
do
useradd user$i
echo  `id user$i`
echo  "password$i" | md5sum | cut -c -8 | tee -a passwd.txt | passwd --stdin user$i
done
