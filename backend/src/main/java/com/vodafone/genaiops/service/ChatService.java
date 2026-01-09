package com.vodafone.genaiops.service;

import com.vodafone.genaiops.dto.ChatMessageResponse;
import com.vodafone.genaiops.dto.FeedbackResponse;
import com.vodafone.genaiops.util.JwtUtil;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.time.Instant;
import java.util.UUID;

@Service
@Slf4j
@RequiredArgsConstructor
public class ChatService {

    private final LLMService llmService;
    private final JwtUtil jwtUtil;

    /**
     * Process chat message - Phase 1.1
     * Sends message to LLM and returns response
     */
    public ChatMessageResponse processMessage(String message, String token) {
        log.info("Processing chat message");

        // Validate token
        if (!jwtUtil.validateToken(token)) {
            throw new IllegalArgumentException("Invalid token");
        }

        String username = jwtUtil.extractUsername(token);
        log.info("Message from user: {}", username);

        // Generate unique message ID
        String messageId = UUID.randomUUID().toString();

        try {
            // Send message to LLM service
            String llmResponse = llmService.sendMessage(message);

            // Log to console (Phase 1.1 - no database yet)
            log.info("=== CHAT LOG ===");
            log.info("User: {}", username);
            log.info("Message ID: {}", messageId);
            log.info("Request: {}", message);
            log.info("Response: {}", llmResponse);
            log.info("Timestamp: {}", Instant.now());
            log.info("================");

            return ChatMessageResponse.builder()
                    .response(llmResponse)
                    .messageId(messageId)
                    .timestamp(Instant.now().toString())
                    .build();

        } catch (Exception e) {
            log.error("Error processing message", e);
            throw new RuntimeException("Failed to process message: " + e.getMessage());
        }
    }

    /**
     * Process feedback - Phase 1.1
     * Logs feedback to console
     */
    public FeedbackResponse processFeedback(
            String messageId,
            String feedback,
            String comment,
            String token) {
        
        log.info("Processing feedback for message: {}", messageId);

        // Validate token
        if (!jwtUtil.validateToken(token)) {
            throw new IllegalArgumentException("Invalid token");
        }

        String username = jwtUtil.extractUsername(token);

        // Log feedback to console (Phase 1.1 - no database yet)
        log.info("=== FEEDBACK LOG ===");
        log.info("User: {}", username);
        log.info("Message ID: {}", messageId);
        log.info("Feedback: {}", feedback);
        log.info("Comment: {}", comment);
        log.info("Timestamp: {}", Instant.now());
        log.info("====================");

        return FeedbackResponse.builder()
                .success(true)
                .message("Feedback recorded successfully")
                .build();
    }
}
