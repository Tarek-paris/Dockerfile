FROM phusion/baseimage:latest                                                                                                                                                                                        

MAINTAINER George Vagenas - gvagenas@telestax.com                                                                                                                                                                    
MAINTAINER Jean Deruelle - jean.deruelle@telestax.com                                                                                                                                                                
MAINTAINER Lefteris Banos - liblefty@telestax.com                                                                                                                                                                    
MAINTAINER Gennadiy Dubina - gennadiy.dubina@dataart.com                                                                                                                                                             

### install java and etc ###                                                                                                                                                                                         
ENV DEBIAN_FRONTEND noninteractive                                                                                                                                                                                   
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections                                                                                                                                   
RUN locale-gen en_US en_US.UTF-8 && dpkg-reconfigure locales                                                                                                                                                         
RUN add-apt-repository ppa:openjdk-r/ppa -y && apt-cache search mysql-client-core && apt-get update && apt-get install -y wget ipcalc bsdtar openjdk-7-jdk mysql-client-core-5.7 openssl unzip && apt-get autoremove 
&& apt-get autoclean && rm -rf /var/lib/apt/lists/*                                                                                                                                                                  

### end ###                                                                                                                                                                                                          

# create work dir                                                                                                                                                                                                    
ENV SBC_DIR /opt/sbc                                                                                                                                                                                                 
ENV SBC_APP_DIR "/opt/sbc/SBC-Tomcat"                                                                                                                                                                                
#ENV SBC_CONFIG /opt/sbc/webapps/restcomm-sbc/WEB-INF/conf/sbc.xml                                                                                                                                                   

# download build                                                                                                                                                                                                     
RUN mkdir ${SBC_DIR}                                                                                                                                                                                                 
RUN wget -qO- https://mobicents.ci.cloudbees.com/view/RestComm/job/Restcomm-SBC/lastSuccessfulBuild/artifact/sbc-version.txt -O version.txt                                                                          
RUN wget -qc --no-check-certificate "https://webukraine-my.sharepoint.com/personal/denis_zaytsev_mobius-software_com/_layouts/15/guestaccess.aspx?docid=0ea8e3826f417421f94fe1f3e0416e5d4&authkey=AXQKu_-sEqw7ajmQWlK
yVPw" -O ${SBC_DIR}/SBC.zip                                                                                                                                                                                          

RUN unzip -o ${SBC_DIR}/SBC.zip -d ${SBC_DIR}                                                                                                                                                                        
RUN mv ${SBC_DIR}/SBC-Tomcat7-`cat version.txt` ${SBC_APP_DIR}                                                                                                                                                       

RUN chmod +x $SBC_APP_DIR/bin/sbc-configuration-docker.sh                                                                                                                                                            
RUN chmod +x ${SBC_APP_DIR}/bin/sbc-docker.sh                                                                                                                                                                        
RUN chmod +x ${SBC_APP_DIR}/bin/certs-docker.sh                                                                                                                                                                      
RUN chmod +x ${SBC_APP_DIR}/bin/catalina.sh                                                                                                                                                                          

RUN ${SBC_APP_DIR}"/bin/sbc-docker.sh" -a start                                                                                                                                                                      
CMD ${SBC_APP_DIR}"/bin/catalina.sh" run                                                                                                                                                                             

EXPOSE 8080                 
