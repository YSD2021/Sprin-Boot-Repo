FROM maven:3.6.3-jdk-11 AS build-env
WORKDIR /app

COPY pom.xml ./
RUN mvn dependency:go-offline


COPY . ./
RUN ./mvnw package -DskipTests
RUN mvn package -DfinalName=application

FROM openjdk:11
EXPOSE 8080
WORKDIR /app

COPY --from=build-env /app/target/application.jar ./application.jar
CMD ["/usr/bin/java", "-jar", "/app/application.jar"]


