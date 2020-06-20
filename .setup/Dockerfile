FROM ubuntu:18.04
MAINTAINER Ilya Ageev <iamuyga@gmail.com>

ENV MYSQL_ROOT_PASSWORD root

RUN export DEBIAN_FRONTEND=noninteractive \
    && apt-get update -y \
    && apt-get install -y --no-install-recommends \
        gnupg \
        software-properties-common

RUN add-apt-repository ppa:ondrej/php \
    && bash -c "debconf-set-selections <<< 'mysql-server-5.7 mysql-server/root_password password $MYSQL_ROOT_PASSWORD'" \
    && bash -c "debconf-set-selections <<< 'mysql-server-5.7 mysql-server/root_password_again password $MYSQL_ROOT_PASSWORD'" \
    && echo "UTC" > /etc/timezone

RUN export DEBIAN_FRONTEND=noninteractive \
    && apt-get update -y \
    && apt-get install -y --no-install-recommends \
        nginx \
        mysql-server-5.7 \
        php7.2-curl \
        php7.2-fpm \
        php7.2-gd \
        php7.2-imagick \
        php7.2-json \
        php7.2-mbstring \
        php7.2-mysqlnd \
        php7.2-soap \
        php7.2-xml \
        php7.2-cli \
        strace \
        vim \
        openssh-server \
        git \
        sendmail \
        imagemagick \
        exiftool \
    && rm -rf /var/lib/apt/lists/*

RUN useradd -ms /bin/bash  git && usermod -G www-data git

RUN mkdir -pv /local/logs
COPY etc/ /etc/
COPY local/ /local/

VOLUME /var/lib/mysql
VOLUME /home/git
VOLUME /local/codeisok

EXPOSE 80 22
CMD bash /local/init.sh
