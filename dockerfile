FROM maven:3.6.3-jdk-8 AS build-env
WORKDIR /app

COPY pom.xml ./
RUN mvn dependency:go-offline
RUN mvn spring-javaformat:help

COPY . ./
RUN mvn spring-javaformat:apply
RUN mvn package -DfinalName=application

FROM openjdk:8-jre-alpine
EXPOSE 8080
WORKDIR /app

COPY --from=build-env /app/target/application.jar ./application.jar
CMD ["/usr/bin/java", "-jar", "/app/application.jar"]


