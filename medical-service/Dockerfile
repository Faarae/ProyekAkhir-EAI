FROM eclipse-temurin:17-jdk

WORKDIR /app

COPY target/medical-service-1.0.0.jar medical-service.jar

ENV PORT=8082 \
    DB_USERNAME=postgres \
    DB_PASSWORD=postgres \
    RABBITMQ_HOST=rabbitmq \
    RABBITMQ_PORT=5672

EXPOSE 8082

ENTRYPOINT ["java", "-jar", "medical-service.jar"]
