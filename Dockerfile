FROM alpine
MAINTAINER Paul Tinsley <paul.tinsley@gmail.com>

ENV SLAVE_JAR_URI 'http://repo.jenkins-ci.org/public/org/jenkins-ci/main/remoting/2.62/remoting-2.62.jar'


RUN apk add --no-cache openjdk8-jre bash git python bash openssh-client wget \
  && apk add --no-cache -t build-deps gcc musl-dev libffi-dev openssl-dev python-dev py-pip \
  && pip install pyopenssl \
  && adduser -S -g "Jenkins user" -s bash -h /home/jenkins jenkins \
  && echo 'docker:x:107:jenkins' >> /etc/group \
  && mkdir -p /usr/share/jenkins \
  && chmod 755 /usr/share/jenkins \
  && wget -q -O /usr/share/jenkins/slave.jar $SLAVE_JAR_URI \
  && chmod 644 /usr/share/jenkins/slave.jar \
  && mkdir -p /tmp/gcp_install && cd /tmp/gcp_install \
  && wget https://dl.google.com/dl/cloudsdk/release/google-cloud-sdk.tar.gz -O google-cloud-sdk.tar.gz \
  && cd / \
  && tar zxvf /tmp/gcp_install/google-cloud-sdk.tar.gz \
  && /google-cloud-sdk/install.sh -q --additional-components kubectl --usage-reporting=true --path-update=true --command-completion=false  \
  && apk del -q --no-cache build-deps \
  && rm -rf /tmp/*

RUN for z in `ls /google-cloud-sdk/bin`; do ln -s /google-cloud-sdk/bin/$z /bin/$z; done 

ADD ./jenkins-slave /usr/local/bin/jenkins-slave

WORKDIR /home/jenkins
USER jenkins

ENTRYPOINT ["/usr/local/bin/jenkins-slave"]
