FROM ubuntu:16.04

MAINTAINER Yiqiu Jia <yiqiujia@hotmail.com>

RUN apt-get update && apt-get upgrade -y && apt-get clean
RUN apt-get install -y net-tools iputils-ping vim curl wget unzip screen openssh-server git subversion locales software-properties-common lsof nmon sysstat
#iostat 1
#vmstat 1
#nmon

ENV DEBIAN_FRONTEND noninteractive

## Set LOCALE to UTF8
RUN echo "zh_CN.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen zh_CN.UTF-8 && \
    dpkg-reconfigure locales && \
    /usr/sbin/update-locale LANG=zh_CN.UTF-8
ENV LC_ALL zh_CN.UTF-8
RUN apt-get install -y --force-yes --no-install-recommends fonts-wqy-microhei ttf-wqy-zenhei

RUN echo "MaxAuthTries 20" >> /etc/ssh/sshd_config && echo "ClientAliveInterval 30" >> /etc/ssh/sshd_config && echo "ClientAliveCountMax 3" >> /etc/ssh/sshd_config && echo "TMOUT=0" >> /etc/profile
RUN sed -i 's/Port 22/Port 20022/g' /etc/ssh/sshd_config

RUN useradd -s /bin/bash -m land007
RUN echo "land007:1234567" | /usr/sbin/chpasswd
#land007:x:1000:1000::/home/land007:/bin/bash
RUN sed -i "s/^land007:x.*/land007:x:0:1000::\/home\/land007:\/bin\/bash/g" /etc/passwd
#RUN set /files/etc/ssh/sshd_config/PermitRootLogin yes
#RUN echo "PermitRootLogin yes" >> /etc/ssh/sshd_config
RUN sed -i "s/^PermitRootLogin prohibit-password/PermitRootLogin yes/g" /etc/ssh/sshd_config

CMD /etc/init.d/ssh start && bash
#ENTRYPOINT /etc/init.d/ssh start && bash
#RUN cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

#ENTRYPOINT /etc/init.d/ssh start && bash
EXPOSE 20022/tcp


#18.04
#docker stop ubuntu ; docker rm ubuntu ; docker run -it --privileged --name ubuntu land007/ubuntu:latest
#docker stop ubuntu ; docker rm ubuntu ; docker run -it -p 222:20022 -p 3000:3000 -p 3001:3001 -p 3002:3002 -p 3003:3003 -p 3004:3004 -p 3005:3005 -p 3006:3006 -p 3007:3007 -p 3008:3008 -p 3009:3009 --privileged --name ubuntu land007/ubuntu:latest
#16.04
#docker stop ubuntu ; docker rm ubuntu ; docker run -it --privileged --name ubuntu land007/ubuntu:16.04
#docker stop ubuntu ; docker rm ubuntu ; docker run -it -p 222:20022 -p 3000:3000 -p 3001:3001 -p 3002:3002 -p 3003:3003 -p 3004:3004 -p 3005:3005 -p 3006:3006 -p 3007:3007 -p 3008:3008 -p 3009:3009 --privileged --name ubuntu land007/ubuntu:16.04
