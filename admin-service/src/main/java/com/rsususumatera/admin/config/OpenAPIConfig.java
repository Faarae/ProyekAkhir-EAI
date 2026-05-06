package com.rsususumatera.admin.config;

import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.Info;
import io.swagger.v3.oas.models.info.Contact;
import io.swagger.v3.oas.models.security.SecurityScheme;
import io.swagger.v3.oas.models.security.SecurityRequirement;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class OpenAPIConfig {
    
    @Bean
    public OpenAPI customOpenAPI() {
        return new OpenAPI()
            .info(new Info()
                .title("Admin Service API")
                .version("1.0.0")
                .description("Admin Service for RSU Sumatera - Manajemen Pasien, User, Poli, Jadwal & Antrean")
                .contact(new Contact()
                    .name("RSU Sumatera")
                    .email("admin@rsu-sumatera.id")))
            .addSecurityItem(new SecurityRequirement().addList("Bearer"))
            .components(new io.swagger.v3.oas.models.Components()
                .addSecuritySchemes("Bearer", new SecurityScheme()
                    .type(SecurityScheme.Type.HTTP)
                    .scheme("bearer")
                    .bearerFormat("JWT")
                    .description("JWT Auth Bearer Token")));
    }
}
