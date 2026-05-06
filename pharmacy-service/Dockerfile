FROM openjdk:17-jdk-slim

WORKDIR /app

COPY target/pharmacy-service-1.0.0.jar pharmacy-service.jar

ENV PORT=8083 \
    DB_USERNAME=postgres \
    DB_PASSWORD=postgres \
    RABBITMQ_HOST=rabbitmq \
    RABBITMQ_PORT=5672

EXPOSE 8083

ENTRYPOINT ["java", "-jar", "pharmacy-service.jar"]
