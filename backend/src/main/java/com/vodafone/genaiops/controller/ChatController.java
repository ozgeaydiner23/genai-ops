package com.vodafone.genaiops.controller;

import com.vodafone.genaiops.dto.ChatMessageRequest;
import com.vodafone.genaiops.dto.ChatMessageResponse;
import com.vodafone.genaiops.dto.FeedbackRequest;
import com.vodafone.genaiops.dto.FeedbackResponse;
import com.vodafone.genaiops.service.ChatService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/chat")
@RequiredArgsConstructor
@Slf4j
public class ChatController {

    private final ChatService chatService;

    @PostMapping("/message")
    public ResponseEntity<ChatMessageResponse> sendMessage(
            @RequestHeader("Authorization") String authHeader,
            @RequestBody ChatMessageRequest request) {
        
        log.info("Chat message received: {}", request.getMessage());
        
        try {
            // Extract token from "Bearer <token>"
            String token = authHeader.replace("Bearer ", "");
            
            ChatMessageResponse response = chatService.processMessage(
                    request.getMessage(),
                    token
            );
            
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            log.error("Error processing chat message", e);
            return ResponseEntity.internalServerError().build();
        }
    }

    @PostMapping("/feedback")
    public ResponseEntity<FeedbackResponse> submitFeedback(
            @RequestHeader("Authorization") String authHeader,
            @RequestBody FeedbackRequest request) {
        
        log.info("Feedback received for message {}: {}", 
                request.getMessageId(), request.getFeedback());
        
        try {
            String token = authHeader.replace("Bearer ", "");
            
            FeedbackResponse response = chatService.processFeedback(
                    request.getMessageId(),
                    request.getFeedback(),
                    request.getComment(),
                    token
            );
            
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            log.error("Error processing feedback", e);
            return ResponseEntity.internalServerError().build();
        }
    }
}
