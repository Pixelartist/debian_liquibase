FROM debian:latest
MAINTAINER Manuel Mueller

#   __         .__                                       ________                 __
# _/  |_  ____ |  |   ____   ____ _____ _______   ____   \______ \   ____   ____ |  | __ ___________
# \   __\/ __ \|  | _/ __ \_/ ___\\__  \\_  __ \_/ __ \   |    |  \ /  _ \_/ ___\|  |/ // __ \_  __ \
# |  | \  ___/|  |_\  ___/\  \___ / __ \|  | \/\  ___/   |    `   (  <_> )  \___|    <\  ___/|  | \/
# |__|  \___  >____/\___  >\___  >____  /__|    \___  > /_______  /\____/ \___  >__|_ \\___  >__|
#           \/          \/     \/     \/            \/          \/            \/     \/    \/

# get base
RUN apt-get update && apt-get upgrade -y
# githubfullpath = https://github.comsomething.git
ARG TOKEN
ARG GITHUBPROJECTFULLPATH
ARG PROJECTTARGETPATH
ARG LIQUIBASE_DRIVER=postgresql
ARG LIQUIBASE_DATABASEURL
ARG LIQUIBASE_USERNAME
ARG LIQUIBASE_PASSWORD

ENV TOKEN=$TOKEN
ENV GITHUBPROJECTFULLPATH=$GITHUBPROJECTFULLPATH
ENV PROJECTTARGETPATH=$PROJECTTARGETPATH

ENV LIQUIBASE_DRIVER=$LIQUIBASE_DRIVER
ENV LIQUIBASE_DATABASEURL=$LIQUIBASE_DATABASEURL
ENV LIQUIBASE_USERNAME=$LIQUIBASE_USERNAME
ENV LIQUIBASE_PASSWORD=$LIQUIBASE_PASSWORD

##################################
# java Section Start
##################################

#java and system files
RUN apt-get -y install default-jre default-jdk wget ant git nano procps unzip maven
#set JAVA_HOME
RUN JAVA_HOME=$(readlink -f /usr/bin/java | sed "s:bin/java::")

##################################
# Java Section End
##################################

##################################
# SSH Section Start
##################################

RUN apt-get install -y openssh-server
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config

##################################
# SSH Section End
##################################

##################################
# Get Pentaho Server Start
##################################
RUN echo https://sourceforge.net/projects/pentaho/files/latest/download | xargs wget -O- -O tmp.zip && \
    unzip -q tmp.zip -d /opt && \
    rm -f tmp.zip
RUN mv /opt/data-integration /opt/pentaho

##################################
# Get Pentaho Server End
##################################

##################################
# liquibase Section Start
##################################
# moved git liquibase clone to shell due to ENV restriction: https://stackoverflow.com/questions/34911622/dockerfile-set-env-to-result-of-command
COPY scripts /
RUN chmod u+x build_liquibase.sh
RUN ./build_liquibase.sh

##################################
# liquibase Section End
##################################

##################################
# Cleaner System Section Start
##################################
RUN apt-get autoremove -y && \
apt-get clean && \
apt-get autoclean
##################################
# Cleaner System Section End
##################################

WORKDIR /

EXPOSE 22

ENTRYPOINT ["/bin/bash"]
