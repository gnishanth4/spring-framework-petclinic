FROM tomcat:jdk8-adoptopenjdk-hotspot

COPY ./target/*.war  /usr/local/tomcat/webapps/petclinic.war
