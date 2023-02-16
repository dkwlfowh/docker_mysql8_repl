FROM leeyunhyeong/mysql8:1
MAINTAINER leeyun

USER root
RUN echo "master" > master.txt

ADD master.sh /root/
RUN chmod 755 /root/master.sh

#ENTRYPOINT ["/root/master.sh"]
