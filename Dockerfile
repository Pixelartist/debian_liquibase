FROM debian:latest
MAINTAINER Manuel Mueller

# get base
RUN apt-get update && apt-get upgrade -y

##################################
# java Section Start
##################################

#java and system files
RUN apt-get -y install default-jre default-jdk wget ant git nano procps unzip maven
#set JAVA_HOME
RUN JAVA_HOME=$(readlink -f /usr/bin/java | sed "s:bin/java::")

##################################
# liquibase Section end
##################################

##################################
# SSH Section Start
##################################

RUN apt-get install -y openssh-server

##################################
# SSH Section End
##################################
# Get Pentaho Server

RUN echo https://sourceforge.net/projects/pentaho/files/Data%20Integration/7.1/pdi-ce-7.1.0.0-12.zip/download | xargs wget -O- -O tmp.zip && \
    unzip -q tmp.zip -d /opt && \
    rm -f tmp.zip
RUN mv /opt/data-integration /opt/pentaho
##################################
# Pentaho Section Start
##################################

RUN apt-get install -y openssh-server

##################################
# Pentaho Section End
##################################

##################################
# liquibase Section Start
##################################

# download liquibase
# Create a directory for liquibase
RUN mkdir /opt/liquibase

WORKDIR /opt/liquibase

COPY conf /opt/liquibase

##################################
# liquibase Section End
##################################

WORKDIR /

EXPOSE 22

ENTRYPOINT ["/bin/bash"]
