package com.vodafone.genaiops.dto;

import lombok.Data;

@Data
public class FeedbackRequest {
    private String messageId;
    private String feedback; // "like" or "dislike"
    private String comment;
}
