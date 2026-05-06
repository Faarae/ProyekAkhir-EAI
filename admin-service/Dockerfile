FROM openjdk:17-jdk-slim

WORKDIR /app

COPY target/admin-service-1.0.0.jar admin-service.jar

ENV PORT=8081 \
    DB_USERNAME=postgres \
    DB_PASSWORD=postgres \
    RABBITMQ_HOST=rabbitmq \
    RABBITMQ_PORT=5672

EXPOSE 8081

ENTRYPOINT ["java", "-jar", "admin-service.jar"]
