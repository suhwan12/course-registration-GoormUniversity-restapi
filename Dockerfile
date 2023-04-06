FROM openjdk:11-jre 
WORKDIR /usr/src/
COPY . /usr/src/
CMD ["java","-jar","/usr/src/build/libs/api-0.0.1-SNAPSHOT.jar"]

