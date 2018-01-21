FROM debian:9.2

RUN apt-get update
RUN apt-get install -y default-jre default-jdk dos2unix
RUN apt-get clean

VOLUME [ "/var/atlassian/application-data/jira" ]

RUN useradd -ms /bin/bash jira
RUN mkdir -p /opt/atlassian

RUN mkdir -p /var/atlassian/application-data/jira
RUN chown -R jira /var/atlassian/application-data/jira
RUN chmod -R u=rwx,go-rwx /var/atlassian/application-data/jira

RUN wget "https://product-downloads.atlassian.com/software/jira/downloads/atlassian-jira-software-7.6.0.tar.gz" -O /usr/src/atlassian-jira-software-7.6.0.tar
RUN tar -xvf /usr/src/atlassian-jira-software-7.6.0.tar -C /opt/atlassian/
RUN mv /opt/atlassian/atlassian-jira-software-7.6.0-standalone /opt/atlassian/jira
COPY ./tools/jira-application.properties /opt/atlassian/jira/atlassian-jira/WEB-INF/classes/jira-application.properties
COPY ./tools/check-java.sh /opt/atlassian/jira/bin/check-java.sh
RUN dos2unix /opt/atlassian/jira/bin/check-java.sh
RUN chmod +x /opt/atlassian/jira/bin/check-java.sh

RUN rm -fr /usr/src/atlassian-jira-software-7.6.0.tar

RUN chown -R jira /opt/atlassian
RUN chmod -R u=rwx,go-rwx /opt/atlassian

ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64
ENV JAVA_JRE /usr/lib/jvm/java-8-openjdk-amd64/jre
ENV JIRA_HOME /var/atlassian/application-data/jira

RUN export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
RUN export JAVA_JRE=/usr/lib/jvm/java-8-openjdk-amd64/jre

RUN export JIRA_HOME=/var/atlassian/application-data/jira

EXPOSE 8080
EXPOSE 8005

CMD [ "/opt/atlassian/jira/bin/start-jira.sh", "-fg"]
