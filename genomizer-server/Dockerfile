#-*- mode:conf-space; -*-

FROM java:7-jre

EXPOSE 7000

RUN apt-get update -y \
    apt-get install python

CMD java -jar genomizer-server.jar -debug
