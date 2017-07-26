FROM debian:latest
MAINTAINER Manuel Mueller

# get base
RUN apt-get update && apt-get upgrade -y

##################################
# java Section Start
##################################

#java and system files
RUN apt-get -y install default-jre default-jdk wget ant git nano procps unzip
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
RUN echo https://github.com/liquibase/liquibase/releases/download/liquibase-parent-3.5.3/liquibase-3.5.3-bin.tar.gz | xargs wget -O- -O tmp.tar.gz && \
        tar -zxf tmp.tar.gz && \
    	rm -f tmp.tar.gz
RUN chmod +x /opt/liquibase/liquibase

# Symlink to liquibase to be on the path
RUN ln -s /opt/liquibase/liquibase /usr/local/bin/

# Get the postgres JDBC driver from http://jdbc.postgresql.org/download.html
# ADD http://jdbc.postgresql.org/download/postgresql-9.3-1102.jdbc41.jar /opt/jdbc_drivers/
RUN mkdir /opt/jdbc_drivers/
RUN echo https://jdbc.postgresql.org/download/postgresql-9.4.1212.jar | xargs wget -O- -O /tmp/postgresql-9.4.1212.jar

RUN ln -s /opt/jdbc_drivers/postgresql-9.4.1212.jar /usr/local/bin/

# Add command scripts
ADD scripts /opt/liquibase/scripts
RUN chmod -R +x /opt/liquibase/scripts

##################################
# liquibase Section End
##################################

WORKDIR /

ENTRYPOINT ["/bin/bash"]
