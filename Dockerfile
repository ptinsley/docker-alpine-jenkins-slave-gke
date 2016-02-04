FROM alpine
MAINTAINER Paul Tinsley <paul.tinsley@gmail.com>

ENV SLAVE_JAR_URI 'http://repo.jenkins-ci.org/public/org/jenkins-ci/main/remoting/2.52/remoting-2.52.jar'

RUN apk add --no-cache openjdk8-jre  \
  && adduser -S -g "Jenkins user" -s bash -h /home/jenkins jenkins \
  && echo 'docker:x:107:jenkins' >> /etc/group \
  && mkdir -p /usr/share/jenkins \
  && chmod 755 /usr/share/jenkins \
  && wget -q -O /usr/share/jenkins/slave.jar $SLAVE_JAR_URI \
  && chmod 644 /usr/share/jenkins/slave.jar \

COPY jenkins-slave /usr/local/bin/jenkins-slave

WORKDIR /home/jenkins
USER jenkins

ENTRYPOINT ['jenkins-slave']
