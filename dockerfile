#### Stage 1: Build the application
FROM openjdk:8-jdk as build

# Set the current working directory inside the image
WORKDIR /app

# Copy maven executable to the image
COPY mvnw .
COPY .mvn .mvn

# COPY THE JSON and WebPack files
COPY package.json .
COPY webpack.config.js .

# Copy the pom.xml file
COPY pom.xml .

# Build all the dependencies in preparation to go offline. 
# This is a separate step so the dependencies will be cached unless 
# the pom.xml file has changed.
RUN chmod +x mvnw
RUN ./mvnw dependency:go-offline -B

# Copy the project source
COPY src/main src/main

# Package the application
RUN ./mvnw package -DfinalName=application
# RUN mkdir -p target-DfinalName=petclinic

#### Stage 2: A minimal docker image with command to run the app 
FROM openjdk:8-jdk

FROM openjdk:11
EXPOSE 8080
WORKDIR /app

COPY --from=build-env /app/target/application.jar ./application.jar
CMD ["/usr/bin/java", "-jar", "/app/application.jar"]


