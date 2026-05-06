FROM eclipse-temurin:17-jdk

WORKDIR /app

COPY target/payment-service-1.0.0.jar payment-service.jar

ENV PORT=8084 \
    DB_USERNAME=postgres \
    DB_PASSWORD=postgres \
    RABBITMQ_HOST=rabbitmq \
    RABBITMQ_PORT=5672

EXPOSE 8084

ENTRYPOINT ["java", "-jar", "payment-service.jar"]
