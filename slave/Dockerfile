FROM leeyunhyeong/mysql8:1
MAINTAINER leeyun

USER root
RUN echo "slave" > slave.txt

ADD slave.sh /root/
RUN chmod 755 /root/slave.sh

#ENTRYPOINT ["/root/slave.sh"]
