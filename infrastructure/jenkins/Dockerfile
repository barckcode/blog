FROM jenkins/jenkins:2.248

USER root

RUN apt-get update && \
    apt-get install python-pip -y && \
    pip install -U ansible

USER jenkins
