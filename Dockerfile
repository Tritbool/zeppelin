FROM java:8

WORKDIR /opt

RUN apt-get update \ 
&& apt-get install -y wget \
&& wget http://mirror.ibcp.fr/pub/apache/spark/spark-2.3.2/spark-2.3.2-bin-hadoop2.7.tgz \
&& tar zxf spark-2.3.2-bin-hadoop2.7.tgz \
&& rm spark-2.3.2-bin-hadoop2.7.tgz

RUN wget http://mirrors.ircam.fr/pub/apache/zeppelin/zeppelin-0.8.0/zeppelin-0.8.0-bin-all.tgz \
&& tar zxf zeppelin-0.8.0-bin-all.tgz \
&& rm zeppelin-0.8.0-bin-all.tgz \
&& mkdir /tmp/spark-events


ADD spark-defaults.conf /opt/spark-2.3.2-bin-hadoop2.7/conf
ADD spark-env.sh /opt/spark-2.3.2-bin-hadoop2.7/conf
ADD log4j.properties /opt/spark-2.3.2-bin-hadoop2.7/conf

ADD zeppelin-env.sh /opt/zeppelin-0.8.0-bin-all/conf
ADD interpreter.json /opt/zeppelin-0.8.0-bin-all/conf

ENV SPARK_HOME /opt/spark-2.3.2-bin-hadoop2.7
ENV PATH $PATH:/opt/spark-2.3.2-bin-hadoop2.7/sbin
ENV PATH $PATH:/opt/spark-2.3.2-bin-hadoop2.7/bin
ENV ZEPPELIN_PORT 8091
ENV MASTER spark://spark-master:7077
ENV ZEPPELIN_MEM "-Xms256m -Xmx512m -XX:MaxPermSize=512m"
ENV ZEPPELIN_JAVA_OPTS "-Dspark.dynamicAllocation.enabled=true"

RUN chmod +x /opt/spark-2.3.2-bin-hadoop2.7/sbin/* && chmod +x /opt/spark-2.3.2-bin-hadoop2.7/bin/*

EXPOSE 8091

CMD ["/bin/bash", "/opt/zeppelin-0.8.0-bin-all/bin/zeppelin.sh"]
