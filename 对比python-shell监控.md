[TOC]



### 监控

- 一台机器里的监控===》100台机器的监控===》 1万台机器的监控
- 批量部署处理、zabbix、分布式



#### 你经常使用哪些命令去监控cpu？

- top，htop

#### 网络流量如何监控？

#### 如何监控Web服务器？

- 出问题后如何通知你？
  - 微信、短信、邮件





##### 编写脚本

- 获取当前CPU的使用率  %us+%sy  是否繁忙？

  - shell脚本：

    - ```shell
      #!/usr/bin
      
      # 获取cpu使用率 %us+%sy 
      get_cpu(){
      	echo "##############GET CPUINFO###############"
      	# grep -A 1:可以取到无特征行
      	cpu_us_sy=($(iostat|grep -A 1 avg-cpu|tail -1|awk '{print $1,$3,$6}'))
      	echo "用户进程消耗CPU是${cpu_us_sy[0]}"
      	echo "系统进程消耗CPU是${cpu_us_sy[1]}"
      	echo "空闲CPU是${cpu_us_sy[2]}"
      	
      	# 1,5,15分钟负载
      	# tr -d ",":把逗号，去掉变成空格，形成一个数列array
      	cpu_load_avg=$(top -b -n 1|head -1|awk '{print $10,$11,$12}'|tr -d ",")
      	echo "CPU的平均负载是${cpu_load_avg}"
      }
      ```

  - python脚本：

    - ```python
      import psutil as pl
      # yum install gcc python3-devel -y
      # pip3 install psutil
      import time
      
      # CPU的使用率
      def  us_cpu():
          print("#####cpu的使用率是{}######".format(pl.cpu_percent(1)))
          return pl.cpu_percent(1)  # 每隔1秒统计一次
      ```

      

- 获取内存是否使用完，使用多少需要知道，使用超过80%需要发警告？

  - shell脚本：

    - ```shell
      
      # 获取memory的大小和使用率
      get_memory(){
      	echo "##############GET MEMORY################"
      	mem_size=($(free -m|grep "Mem"|awk '{print $2,$4}')) 
      	mem_use=$(free -m|grep "Mem"|awk '{print 1-$4/$2}') # awk有计算功能
      	echo "内存的总共有${mem_size[0]}"	
      	echo "内存的空闲有${mem_size[1]}"	
      	echo "内存的使用率有${mem_use}"
          if (($mem_use >= 0.8))
          then
          		echo  "内存的使用率超过80%"
          else
          		echo  "内存充足！"
          fi
      }
      ```

  - python脚本：

    - ```python
      # memory的使用率和大小
      def memory_info():
          mem_use = pl.virtual_memory().percent
          print("#####memory的使用率是{}%######".format(mem_use))
          if mem_use >= 80:
              print("WARNING!!内存使用率太高超过80%")
          return mem_use
      
      ```

      

- 获取当前磁盘里的/分区的使用情况，超过80%给予提醒

  - shell脚本：

    - ```shell
      # 根分区的使用情况
      get_rootpart(){
              root_percent=$(df -Th|grep "/$"|awk '{print $6}'|tr -d "%")
              if (($root_percent >= 80))
              then
                      echo "/根分区的使用率超过80%"
              else
                      echo "/根分区还有充足的使用空间"
              fi
      }
      ```

  - python脚本：

    - ```python
      # 根分区的使用情况
      def rootpart_info():
          root_info = pl.disk_usage("/").percent
          print("##########磁盘中/分区的使用率是{}%##########".format(root_info))
          return root_info
      ```

      

- 获取当前Linux系统里最消耗CPU和memory的5个进程，最消耗内存的5个进程
  
  - ```shell
    ps  aux|tail  -n  +2|sort  -k  3  -nr|head  -5|awk  '{print  $2,$11}'
    ps  aux|tail  -n  +2|sort  -k  4  -nr|head  -5|awk  '{print  $2,$11}'
    ```
  
    
  
- 获取当前Linux系统网络的流量信息
  
  - dstat  -n   --output  /lianxi/Network.csv  1  5
  
- 监控Web服务个MySQL服务是否挂掉，如果挂掉了马上给予提醒
  
  - 查看mysql的服务是否起了，根据echo  $? 是否为0，可用nc结合echo $?,还可以用netstat  -naplut查看。如果不是检查本机的服务，建议使用nc和echo $?的配合。
  
    - ```shell
      nc  -z  192.168...   3306
      echo $?
      
      [root@localhost lianxi]# netstat -anplut|grep mysqld
      tcp6       0      0 :::3306                 :::*                    LISTEN      17127/mysqld  
      ```
  
  - 查看端口：
  
    - lsof  -i:3306
  
    - ```shell
      root@sanchuang-cs ~]# yum install mariadb mariadb-server -y
      [root@sanchuang-cs ~]# service mariadb start
      Redirecting to /bin/systemctl start mariadb.service
      [root@sanchuang-cs ~]# 
      [root@sanchuang-cs ~]# lsof -i:3306
      COMMAND   PID  USER   FD   TYPE DEVICE SIZE/OFF NODE NAME
      mysqld  51035 mysql   14u  IPv4 223983      0t0  TCP *:mysql (LISTEN)
      ```
  
      


