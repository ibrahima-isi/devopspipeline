# FROM maven:3.9.0-eclipse-temurin-17 as build
# WORKDIR /app
# COPY . .
# RUN mvn clean install

# FROM eclipse-eclipse-temurin:17.0.10_10-jdk
# WORKDIR /app
# COPY --from=build /app/target/demoapp.jar /app/
# EXPOSE 8080
# CMD ["java", "-jar", "demoapp.jar"]
FROM openjdk:8-jre
ADD target/boweplus-1.0-SNAPSHOT.jar app.jar
ADD bowe.yml config.yml
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]