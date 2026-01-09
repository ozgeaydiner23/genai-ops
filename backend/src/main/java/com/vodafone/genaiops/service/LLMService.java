package com.vodafone.genaiops.service;

import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.*;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.time.Duration;
import java.util.HashMap;
import java.util.Map;

@Service
@Slf4j
public class LLMService {

    @Value("${llm.endpoint-base-url}")
    private String llmEndpointBaseUrl;

    @Value("${llm.model-name}")
    private String llmModelName;

    @Value("${llm.mode}")
    private String llmMode;

    @Value("${llm.api-token}")
    private String llmApiToken;  // JWT token or API key from ConfigMap/Secret

    @Value("${llm.timeout}")
    private Long timeout;

    @Value("${llm.system-prompt}")
    private String systemPrompt;

    private final RestTemplate restTemplate;

    public LLMService() {
        this.restTemplate = new RestTemplate();
        // Configure timeout
        this.restTemplate.getInterceptors().add((request, body, execution) -> {
            request.getHeaders().set(HttpHeaders.CONTENT_TYPE, MediaType.APPLICATION_JSON_VALUE);
            return execution.execute(request, body);
        });
    }

    /**
     * Send message to Vodafone Practicus LLM service
     * Uses Vodafone's LLM as a Service API format
     * Falls back to mock response if LLM endpoint is not available
     */
    public String sendMessage(String message) {
        log.info("Sending message to Vodafone LLM: {}", message);

        try {
            // Build full API URL: base_url/models/model_name/
            String fullApiUrl = String.format("%s/models/%s/", llmEndpointBaseUrl, llmModelName);
            log.debug("LLM API URL: {}", fullApiUrl);

            // Prepare request headers
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_JSON);
            // Add Bearer token authentication (JWT token from Secret)
            headers.set("Authorization", "Bearer " + llmApiToken);

            // Prepare request body according to Vodafone API format
            Map<String, Object> requestBody = new HashMap<>();
            requestBody.put("mode", llmMode);  // "llm_as_service"
            requestBody.put("system_prompt", systemPrompt);  // LLM role and instructions
            requestBody.put("user_prompt", message);  // User's actual message

            HttpEntity<Map<String, Object>> request = new HttpEntity<>(requestBody, headers);

            log.debug("Request body: mode={}, system_prompt length={}, user_prompt length={}", 
                     llmMode, systemPrompt.length(), message.length());

            // Send request to Vodafone LLM
            ResponseEntity<Map> response = restTemplate.exchange(
                    fullApiUrl,
                    HttpMethod.POST,
                    request,
                    Map.class
            );

            // Parse Vodafone API response
            if (response.getStatusCode() == HttpStatus.OK && response.getBody() != null) {
                Map<String, Object> responseBody = response.getBody();
                
                // Check status fields
                String statusCode = (String) responseBody.get("status_code");
                String status = (String) responseBody.get("status");
                String responseMessage = (String) responseBody.get("message");
                
                log.debug("LLM Response - status_code: {}, status: {}, message: {}", 
                         statusCode, status, responseMessage);

                // Check if response is successful
                if ("200".equals(statusCode) && "success".equals(status)) {
                    String llmResponse = (String) responseBody.get("answer");
                    
                    if (llmResponse != null) {
                        // Trim whitespace and newlines
                        llmResponse = llmResponse.trim();
                        log.info("LLM response received successfully (length: {})", llmResponse.length());
                        return llmResponse;
                    } else {
                        log.warn("LLM response missing 'answer' field");
                        return getMockResponse(message);
                    }
                } else {
                    log.warn("LLM returned non-success status: {} - {}", statusCode, status);
                    return getMockResponse(message);
                }
            } else {
                log.warn("LLM returned non-OK HTTP status: {}", response.getStatusCode());
                return getMockResponse(message);
            }

        } catch (Exception e) {
            log.error("Error calling Vodafone LLM service: {}", e.getMessage(), e);
            log.info("Returning mock response due to error");
            return getMockResponse(message);
        }
    }

    /**
     * Generate mock response for testing
     * Used when LLM service is not available
     */
    private String getMockResponse(String message) {
        log.info("Generating mock response for: {}", message);

        // Simple mock responses based on keywords
        String lowerMessage = message.toLowerCase();

        if (lowerMessage.contains("error") || lowerMessage.contains("issue")) {
            return "I understand you're experiencing an issue. Based on the information provided, here are some troubleshooting steps:\n\n" +
                   "1. Check the system logs for any error messages\n" +
                   "2. Verify that all services are running properly\n" +
                   "3. Review recent configuration changes\n\n" +
                   "If the issue persists, please provide more details about the error message you're seeing.";
        }

        if (lowerMessage.contains("database") || lowerMessage.contains("connection")) {
            return "For database connection issues, I recommend:\n\n" +
                   "```python\n" +
                   "import database_connector as db\n" +
                   "# Increase the pool size and add a timeout\n" +
                   "db.configure(\n" +
                   "    pool_size=20,\n" +
                   "    connection_timeout=30\n" +
                   ")\n" +
                   "print(\"Database connection settings updated.\")\n" +
                   "```\n\n" +
                   "This should resolve timeout errors by increasing the connection pool size.";
        }

        if (lowerMessage.contains("help") || lowerMessage.contains("how")) {
            return "I'm GENAI-OPS, your AI operations assistant. I can help you with:\n\n" +
                   "• Troubleshooting system issues\n" +
                   "• Analyzing error logs\n" +
                   "• Suggesting fixes for common problems\n" +
                   "• Providing code examples\n" +
                   "• Answering technical questions\n\n" +
                   "What would you like assistance with?";
        }

        // Default response
        return "Thank you for your message. I'm analyzing your request and here's what I can suggest:\n\n" +
               "Based on the information provided, I recommend checking the following:\n" +
               "1. System logs for any recent errors\n" +
               "2. Service status and health checks\n" +
               "3. Recent configuration changes\n\n" +
               "Could you provide more specific details about what you're trying to accomplish?";
    }
}
