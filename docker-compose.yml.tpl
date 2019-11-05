sigla:
  image: docker.si.cnr.it/##{CONTAINER_ID}##
  volumes:
    - ./cert.p12:/opt/cert.p12
    - ./project-formazione.yml:/opt/project-formazione.yml
  command: java -Xmx1g -Xss512k -agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=8787 -Dspring.profiles.active=liquibase-cnr -Dremote.maven.repo=https://repository.jboss.org/nexus/content/groups/public/ -DarubaRemoteSignService.url=http://arss3.cedrc.cnr.it:8080/ArubaSignService/ArubaSignService?WSDL -Djava.security.egd=file:/dev/./urandom -jar /opt/sigla-thorntail.jar -s/opt/project-formazione.yml
  labels:
   SERVICE_NAME: "##{SERVICE_NAME}##"
