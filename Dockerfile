FROM centos:7
RUN yum install java-1.8.0-openjdk-devel
RUN curl --silent --location http://pkg.jenkins-ci.org/redhat-stable/jenkins.repo | sudo tee /etc/yum.repos.d/jenkins.repo
RUN sudo rpm --import https://jenkins-ci.org/redhat/jenkins-ci.org.key
RUN yum install jenkins
RUN systemctl start jenkins

RUN systemctl enable jenkins
EXPOSE 8080
