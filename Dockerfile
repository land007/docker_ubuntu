FROM ubuntu:22.04

MAINTAINER Yiqiu Jia <yiqiujia@hotmail.com>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get upgrade -y && \
	apt-get install -y --force-yes --no-install-recommends net-tools iputils-ping vim curl wget unzip screen openssh-server git subversion locales software-properties-common lsof nmon iftop sysstat netcat-traditional pciutils kmod uuid-runtime tzdata fonts-wqy-microhei ttf-wqy-zenhei && \
	apt-get clean
#iostat 1
#vmstat 1
#nmon

# 设置区域和语言为UTF-8
RUN echo "zh_CN.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen zh_CN.UTF-8 && \
    dpkg-reconfigure locales && \
    /usr/sbin/update-locale LANG=zh_CN.UTF-8

ENV LC_ALL zh_CN.UTF-8

# 配置SSH
RUN echo "MaxAuthTries 20" >> /etc/ssh/sshd_config && \
    echo "ClientAliveInterval 30" >> /etc/ssh/sshd_config && \
    echo "ClientAliveCountMax 3" >> /etc/ssh/sshd_config && \
    echo "TMOUT=0" >> /etc/profile && \
	sed -i 's/Port 22/Port 20022/g' /etc/ssh/sshd_config && \
	useradd -s /bin/bash -m land007 && \
	echo "land007:1234567" | /usr/sbin/chpasswd && \
#land007:x:1000:1000::/home/land007:/bin/bash
	sed -i "s/^land007:x.*/land007:x:0:1000::\/home\/land007:\/bin\/bash/g" /etc/passwd && \
#	set /files/etc/ssh/sshd_config/PermitRootLogin yes && \
#	echo "PermitRootLogin yes" >> /etc/ssh/sshd_config && \
	sed -i "s/^PermitRootLogin prohibit-password/PermitRootLogin yes/g" /etc/ssh/sshd_config

# 设置时区为上海
#RUN cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
    echo $TZ > /etc/timezone

# 复制脚本并使其可执行
ADD *.sh /

# 防止windows换行符，设置镜像元数据
RUN sed -i 's/\r$//' /*.sh ; chmod +x /*.sh && \
	echo $(date "+%Y-%m-%d_%H:%M:%S") >> /.image_times && \
	echo $(date "+%Y-%m-%d_%H:%M:%S") > /.image_time && \
	echo "land007/ubuntu" >> /.image_names && \
	echo "land007/ubuntu" > /.image_name

# 暴露SSH端口
#ENTRYPOINT /etc/init.d/ssh start && bash
EXPOSE 20022/tcp

# 定义入口点和命令
#ENTRYPOINT /etc/init.d/ssh start && bash
#CMD /etc/init.d/ssh start && /start.sh && bash
CMD /task.sh ; /start.sh ; bash

#docker build -t land007/ubuntu:22.04 .
#> docker buildx build --platform linux/amd64,linux/arm64/v8,linux/arm/v7 -t land007/ubuntu:22.04 --push .
#> docker buildx build --platform linux/amd64,linux/arm64/v8,linux/arm/v7 -t wrt.qhkly.com:5000/ubuntu:22.04 --push .
#18.04
#curl -d "v=1&t=pageview&tid=UA-10056144-4&cid=&dh=docker.qhkly.com&dp=land007/ubuntu&dt={start_time:2019-05-26_11:07:12,image_time:2019-05-26_11:02:48}" https://www.google-analytics.com/collect
#docker stop ubuntu1 ; docker rm ubuntu1; docker run -it --privileged --name ubuntu1 land007/ubuntu:latest
#docker stop ubuntu ; docker rm ubuntu ; docker run -it -p 222:20022 -p 3000:3000 -p 3001:3001 -p 3002:3002 -p 3003:3003 -p 3004:3004 -p 3005:3005 -p 3006:3006 -p 3007:3007 -p 3008:3008 -p 3009:3009 --privileged --name ubuntu land007/ubuntu:latest
#16.04
#docker stop ubuntu ; docker rm ubuntu ; docker run -it --privileged --name ubuntu land007/ubuntu:16.04
#docker stop ubuntu ; docker rm ubuntu ; docker run -it -p 222:20022 -p 3000:3000 -p 3001:3001 -p 3002:3002 -p 3003:3003 -p 3004:3004 -p 3005:3005 -p 3006:3006 -p 3007:3007 -p 3008:3008 -p 3009:3009 --privileged --name ubuntu land007/ubuntu:16.04
