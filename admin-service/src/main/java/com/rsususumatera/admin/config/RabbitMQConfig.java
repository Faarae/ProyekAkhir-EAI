package com.rsususumatera.admin.config;

import org.springframework.amqp.core.Binding;
import org.springframework.amqp.core.BindingBuilder;
import org.springframework.amqp.core.DirectExchange;
import org.springframework.amqp.core.Queue;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class RabbitMQConfig {
    
    // Exchanges
    public static final String ADMIN_EXCHANGE = "admin.exchange";
    
    // Queues
    public static final String PASIEN_QUEUE = "admin.pasien.queue";
    public static final String ANTREAN_QUEUE = "admin.antrean.queue";
    
    // Routing Keys
    public static final String PASIEN_ROUTING_KEY = "pasien.terdaftar";
    public static final String ANTREAN_ROUTING_KEY = "antrean.dibuat";
    
    @Bean
    public DirectExchange adminExchange() {
        return new DirectExchange(ADMIN_EXCHANGE, true, false);
    }
    
    @Bean
    public Queue pasienQueue() {
        return new Queue(PASIEN_QUEUE, true);
    }
    
    @Bean
    public Queue antreanQueue() {
        return new Queue(ANTREAN_QUEUE, true);
    }
    
    @Bean
    public Binding pasienBinding() {
        return BindingBuilder.bind(pasienQueue())
            .to(adminExchange())
            .with(PASIEN_ROUTING_KEY);
    }
    
    @Bean
    public Binding antreanBinding() {
        return BindingBuilder.bind(antreanQueue())
            .to(adminExchange())
            .with(ANTREAN_ROUTING_KEY);
    }
}
