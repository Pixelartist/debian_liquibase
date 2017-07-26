FROM debian:latest
MAINTAINER Manuel Mueller

RUN apt-get update && apt-get upgrade -y

#java
RUN apt-get -y install default-jre default-jdk wget ant git nano procps
#set JAVA_HOME
RUN JAVA_HOME=$(readlink -f /usr/bin/java | sed "s:bin/java::")

# download liquibase
# ADD http://sourceforge.net/projects/liquibase/files/Liquibase%20Core/liquibase-3.2.2-bin.tar.gz/download /tmp/liquibase-3.2.2-bin.tar.gz

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

VOLUME ["/changelogs"]

WORKDIR /

ENTRYPOINT ["/bin/bash"]
