# Uygulamanın çaliması için JDK lazım.
# FROM amazoncorretto:21
FROM openjdk:21

# Projemizin Jar dosyasının konumu
ARG JAR_FILE=target/*.jar

#  Projenin Jar halini Docker'ın içine şu isimle kopyala
COPY ${JAR_FILE} my-application.jar

# terminalden çalıştırmak istediğin komutları CMD ile kullaniyorsunuz.
CMD apt-get update
CMD apt-get upgrade -y

# iç portu sabitlemek için 
EXPOSE 8083

# Uygulamanın çalışacağı komut
ENTRYPOINT ["java","-jar","my-application.jar"]
