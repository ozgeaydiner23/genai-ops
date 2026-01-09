package com.vodafone.genaiops.controller;

import com.vodafone.genaiops.dto.LoginRequest;
import com.vodafone.genaiops.dto.LoginResponse;
import com.vodafone.genaiops.service.AuthService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/auth")
@RequiredArgsConstructor
@Slf4j
public class AuthController {

    private final AuthService authService;

    @PostMapping("/login")
    public ResponseEntity<LoginResponse> login(@RequestBody LoginRequest request) {
        log.info("Login request received for username: {}", request.getUsername());
        
        try {
            LoginResponse response = authService.login(
                    request.getUsername(),
                    request.getPassword()
            );
            
            return ResponseEntity.ok(response);
        } catch (IllegalArgumentException e) {
            log.warn("Login failed: {}", e.getMessage());
            return ResponseEntity.badRequest().build();
        } catch (Exception e) {
            log.error("Login error", e);
            return ResponseEntity.internalServerError().build();
        }
    }
}
