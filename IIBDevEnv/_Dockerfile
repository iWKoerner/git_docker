# set os for the container
FROM ubuntu:20.04
#FROM ubuntu/mysql:8.0-20.04_beta
SHELL ["/bin/bash", "-c"]
    RUN apt-get update && apt-get upgrade
    RUN apt-get install nano
    RUN echo 'Start des Containers'

#RUN apt-get install -y mysql
RUN apt-get install -y mysql-server
# Create a non-root user
RUN useradd -m -d /home/iibadmin -s /bin/bash iibadmin && \
    echo 'iibadmin:iibadmin' | chpasswd && \
    usermod -aG sudo iibadmin
RUN echo "root:1234" | chpasswd

# Copy IIB and MQ installation files to the container
COPY 10.0.0.19-IIB-LINUX64-DEVELOPER.tar /opt/
COPY mqadv_dev915_ubuntu_x86-64.tar /tmp
COPY iibdeploy_skript.sh /app/
COPY iibdeploy_check.sh /app/
COPY mq_commands.mqsc /home/iibadmin/#
COPY databaseconfig.txt /app/
COPY start.sh /app/
# Set working directory to /tmp
WORKDIR /tmp

# Install MQ
RUN tar -xvf mqadv_dev915_ubuntu_x86-64.tar && \
    /tmp/MQServer/mqlicense.sh -accept
RUN apt-get install /tmp/MQServer/ibmmq-runtime_9.1.5.0_amd64.deb
RUN apt-get install /tmp/MQServer/ibmmq-java_9.1.5.0_amd64.deb
RUN apt-get install /tmp/MQServer/ibmmq-jre_9.1.5.0_amd64.deb
RUN apt-get install /tmp/MQServer/ibmmq-gskit_9.1.5.0_amd64.deb
RUN apt-get install /tmp/MQServer/ibmmq-client_9.1.5.0_amd64.deb
RUN apt-get install /tmp/MQServer/ibmmq-server_9.1.5.0_amd64.deb
# Install Maria DB
#RUN apt-get update && apt-get install -y mysql
#\ && rm -rf /var/lib/apt/lists/*
#RUN apt install -y software-properties-common
#RUN apt-get install -y software-properties-common
#RUN apt-key adv --fetch-keys 'https://mariadb.org/mariadb_release_signing_key.asc'
#RUN add-apt-repository 'deb [arch=amd64,arm64,ppc64el] https://mariadb.mirror.liquidtelecom.com/repo/10.6/ubuntu focal main'
#RUN apt update && sudo apt install -y mariadb-server mariadb-client

# Install IIB
WORKDIR /opt
RUN tar -xvf 10.0.0.19-IIB-LINUX64-DEVELOPER.tar 

# Set the mq standard installation
WORKDIR /opt/mqm/bin
    RUN ./setmqinst -i -n Installation1 

WORKDIR /opt/iib-10.0.0.19
    RUN ./iib make registry global accept license silently

# Add iibadmin to the mqbrkrs and mqm usergroup.
RUN usermod -a -G mqbrkrs,mqm iibadmin

#Setting the basic environment for IIB
USER iibadmin
WORKDIR /home/iibadmin  
    RUN echo ". /opt/iib-10.0.0.19/server/bin/mqsiprofile" > .profile
USER root
# verify installation
WORKDIR /opt/iib-10.0.0.19
RUN ./iib verify all

# open iib(1616), mq(1414) standard ports and ssh port(22)
EXPOSE 22
EXPOSE 1414
EXPOSE 1616
EXPOSE 3306
# autostart development environment IIB
USER iibadmin
# Create Queuemanager TODO Au
RUN date &>> /tmp/logmq.txt
RUN crtmqm IIB10QM1_DEV &>> /tmp/logmq.txt
RUN strmqm IIB10QM1_DEV &>> /tmp/logmq.txt
USER root

USER iibadmin
# create queue inside runmqsc option to close runmqsc automatically
RUN dspmq &>> /tmp/logmq.txt
RUN strmqm IIB10QM1_DEV && cat /home/iibadmin/mq_commands.mqsc | runmqsc IIB10QM1_DEV &>> /tmp/logmq.txt

# Create IIB Node TODO authentication
#RUN mqsicreatebroker IIB10NODE_DEV -q IIB10QM1_DEV
#RUN mqsicreateexecutiongroup IIB10NODE_DEV -e default

USER root
WORKDIR /app/

##setup DB for IIB TODO Credentials in secret, no credentials so far, ODBC check
#RUN chmod +x /start.sh
#RUN apt-get install -y systemd
#RUN systemctl status mariadb
#RUN systemctl start mariadb
#RUN systemctl enable mariadb
#RUN mysql_secure_installation
#RUN cat databaseconfig.txt | mariadb -u root -p
# RUN mqsisetdbparms IIB10QM1_DEV -n odbc::DEVDB1 -u default_userID -p default_password

CMD su - iibadmin
# . so reponame folder is not checked out 
# RUN git clone  .
# RUN . iibdeploy_skript.sh
# RUN . iibdeploy_check.sh