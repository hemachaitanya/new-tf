FROM maven:3.9.3-eclipse-temurin-17
RUN apt update && apt install git -y
RUN git clone https://github.com/spring-projects/spring-petclinic.git
WORKDIR spring-petclinic
RUN mvn package
EXPOSE 8080
CMD [ "java","-jar","/spring-petclinic/target/spring-petclinic-3.1.0-SNAPSHOT.jar" ]