# getting base image ubuntu 
FROM ubuntu:12.04
# this is optional
MAINTAINER keshav

RUN apt-get update && apt-get install -y apache2

ADD . /home/Documents/
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2

EXPOSE 80


CMD ["usr/sbin/apache2", "-D","FOREGROUND"]