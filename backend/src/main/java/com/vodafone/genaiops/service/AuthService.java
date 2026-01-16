package com.vodafone.genaiops.service;

import com.vodafone.genaiops.dto.LoginResponse;
import com.vodafone.genaiops.dto.UserDTO;
import com.vodafone.genaiops.util.JwtUtil;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.ldap.core.LdapTemplate;
import org.springframework.ldap.core.support.LdapContextSource;
import org.springframework.ldap.filter.AndFilter;
import org.springframework.ldap.filter.EqualsFilter;
import org.springframework.stereotype.Service;

import javax.naming.directory.DirContext;
import java.util.Arrays;
import java.util.List;
import java.util.UUID;

@Service
@Slf4j
@RequiredArgsConstructor
public class AuthService {

    private final JwtUtil jwtUtil;

    @Value("${admin.username}")
    private String adminUsername;

    @Value("${admin.password}")
    private String adminPassword;

    @Value("${admin.enabled}")
    private boolean adminEnabled;

    @Value("${ldap.url}")
    private String ldapUrl;

    @Value("${ldap.base-dn}")
    private String ldapBaseDn;

    @Value("${ldap.bind-dn}")
    private String ldapBindDn;

    @Value("${ldap.bind-password}")
    private String ldapBindPassword;

    @Value("${ldap.user-search-base}")
    private String userSearchBase;

    @Value("${ldap.user-search-filter}")
    private String userSearchFilter;

    @Value("${ldap.auth-group}")
    private String authGroup;

    /**
     * Authenticate user with admin credentials or LDAP (Vpara Active Directory)
     */
    public LoginResponse login(String username, String password) {
        log.info("Login attempt for user: {}", username);

        // Validate input
        if (username == null || username.trim().isEmpty()) {
            throw new IllegalArgumentException("Username is required");
        }

        if (password == null || password.trim().isEmpty()) {
            throw new IllegalArgumentException("Password is required");
        }

        // Clean username (remove domain prefix/suffix if present)
        String cleanUsername = cleanUsername(username);
        log.debug("Cleaned username: {} (original: {})", cleanUsername, username);

        // Check admin credentials first
        if (adminEnabled && adminUsername.equals(cleanUsername) && adminPassword.equals(password)) {
            log.info("Admin login successful for user: {}", cleanUsername);
            return createLoginResponse(cleanUsername, Arrays.asList("admin", "vepas_genaiops_edit"));
        }

        // Try LDAP authentication
        try {
            if (authenticateWithLdap(cleanUsername, password)) {
                log.info("LDAP login successful for user: {}", cleanUsername);
                return createLoginResponse(cleanUsername, Arrays.asList("vepas_genaiops_edit"));
            }
        } catch (Exception e) {
            log.error("LDAP authentication failed for user {}: {}", cleanUsername, e.getMessage());
        }

        // Authentication failed
        log.warn("Login failed for user: {}", cleanUsername);
        throw new IllegalArgumentException("Invalid username or password");
    }

    /**
     * Clean username - remove domain prefix/suffix
     * Supports formats: username, DOMAIN\\username, username@domain.com
     */
    private String cleanUsername(String username) {
        if (username == null) {
            return null;
        }

        String cleaned = username.trim();

        // Remove domain prefix (VPARA\\username -> username)
        if (cleaned.contains("\\")) {
            cleaned = cleaned.substring(cleaned.indexOf("\\") + 1);
        }

        // Remove domain suffix (username@Vpara.local -> username)
        if (cleaned.contains("@")) {
            cleaned = cleaned.substring(0, cleaned.indexOf("@"));
        }

        return cleaned.trim();
    }

    /**
     * Authenticate user with Vpara Active Directory LDAP
     * Uses service account bind for user search, then verifies user password
     * Falls back to direct user bind if service account is not configured
     */
    private boolean authenticateWithLdap(String username, String password) {
        try {
            log.debug("LDAP Authentication - URL: {}, Base DN: {}, Search Base: {}", 
                     ldapUrl, ldapBaseDn, userSearchBase);

            // Check if service account bind is configured
            if (ldapBindDn != null && !ldapBindDn.trim().isEmpty() && 
                ldapBindPassword != null && !ldapBindPassword.trim().isEmpty()) {
                log.info("Using service account bind for user: {}", username);
                return authenticateWithServiceAccount(username, password);
            } else {
                log.info("Service account not configured, using direct user bind for: {}", username);
                return authenticateWithDirectBind(username, password);
            }

        } catch (Exception e) {
            log.error("LDAP authentication error for user {}: {}", username, e.getMessage(), e);
            return false;
        }
    }

    /**
     * Authenticate using service account bind
     */
    private boolean authenticateWithServiceAccount(String username, String password) {
        try {
            log.debug("LDAP Authentication - URL: {}, Base DN: {}, Search Base: {}", 
                     ldapUrl, ldapBaseDn, userSearchBase);

            // Step 1: Create LDAP context source with service account
            LdapContextSource contextSource = new LdapContextSource();
            contextSource.setUrl(ldapUrl);
            contextSource.setBase(ldapBaseDn);
            contextSource.setUserDn(ldapBindDn);
            contextSource.setPassword(ldapBindPassword);
            contextSource.afterPropertiesSet();

            log.debug("Service account bind DN: {}", ldapBindDn);

            // Step 2: Create LDAP template with service account
            LdapTemplate ldapTemplate = new LdapTemplate(contextSource);

            // Step 3: Build search filter for sAMAccountName
            String searchFilter = userSearchFilter.replace("{0}", username);
            log.debug("Searching for user with filter: {} in base: {}", searchFilter, userSearchBase);

            // Step 4: Search for user and get DN
            List<String> userDns = ldapTemplate.search(
                userSearchBase,
                searchFilter,
                (javax.naming.directory.Attributes attrs) -> {
                    try {
                        // Get distinguishedName attribute
                        if (attrs.get("distinguishedName") != null) {
                            return attrs.get("distinguishedName").get().toString();
                        }
                        return null;
                    } catch (Exception e) {
                        log.error("Error extracting DN: {}", e.getMessage());
                        return null;
                    }
                }
            );

            if (userDns.isEmpty() || userDns.get(0) == null) {
                log.warn("User not found in LDAP: {}", username);
                return false;
            }

            String userDn = userDns.get(0);
            log.info("User found in LDAP - DN: {}", userDn);

            // Step 5: Verify user password by binding with user DN
            try {
                LdapContextSource userContextSource = new LdapContextSource();
                userContextSource.setUrl(ldapUrl);
                userContextSource.setBase(ldapBaseDn);
                userContextSource.setUserDn(userDn);
                userContextSource.setPassword(password);
                userContextSource.afterPropertiesSet();

                // Test authentication by getting context
                DirContext ctx = userContextSource.getContext(userDn, password);
                ctx.close();
                
                log.info("Password verified successfully for user: {}", username);
            } catch (Exception e) {
                log.warn("Password verification failed for user {}: {}", username, e.getMessage());
                return false;
            }

            // Step 6: Check group membership (optional - can be disabled if not needed)
            if (authGroup != null && !authGroup.isEmpty()) {
                if (!checkGroupMembership(ldapTemplate, userDn)) {
                    log.warn("User {} is not member of required group: {}", username, authGroup);
                    return false;
                }
                log.debug("User {} is member of required group", username);
            }

            log.info("LDAP authentication successful for user: {}", username);
            return true;

        } catch (Exception e) {
            log.error("Service account LDAP authentication error for user {}: {}", username, e.getMessage());
            return false;
        }
    }

    /**
     * Authenticate using direct user bind (fallback method)
     * Tries multiple DN formats: username@domain, DOMAIN\username, CN=username,base
     */
    private boolean authenticateWithDirectBind(String username, String password) {
        try {
            // Try different user DN formats
            String[] userDnFormats = {
                username + "@" + ldapDomain,  // username@Vpara.local
                ldapDomain.split("\\.")[0].toUpperCase() + "\\" + username,  // VPARA\username
                "CN=" + username + "," + ldapBaseDn  // CN=username,DC=vpara,DC=local
            };

            for (String userDn : userDnFormats) {
                try {
                    log.debug("Trying direct bind with DN format: {}", userDn);
                    
                    LdapContextSource contextSource = new LdapContextSource();
                    contextSource.setUrl(ldapUrl);
                    contextSource.setBase(ldapBaseDn);
                    contextSource.setUserDn(userDn);
                    contextSource.setPassword(password);
                    contextSource.afterPropertiesSet();

                    // Test authentication by getting context
                    DirContext ctx = contextSource.getContext(userDn, password);
                    ctx.close();
                    
                    log.info("Direct bind successful with format: {}", userDn);
                    return true;
                    
                } catch (Exception e) {
                    log.debug("Direct bind failed with format {}: {}", userDn, e.getMessage());
                    continue;
                }
            }
            
            log.warn("Direct bind failed for user {} with all DN formats", username);
            return false;

        } catch (Exception e) {
            log.error("Direct bind error for user {}: {}", username, e.getMessage());
            return false;
        }
    }

    /**
     * Check if user is member of required group
     */
    private boolean checkGroupMembership(LdapTemplate ldapTemplate, String userDn) {
        try {
            AndFilter filter = new AndFilter();
            filter.and(new EqualsFilter("objectClass", "groupOfNames"));
            filter.and(new EqualsFilter("cn", authGroup));
            filter.and(new EqualsFilter("member", userDn));

            List<String> groups = ldapTemplate.search(
                "",
                filter.encode(),
                (javax.naming.directory.Attributes attrs) -> {
                    try {
                        return attrs.get("cn") != null ? attrs.get("cn").get().toString() : null;
                    } catch (Exception e) {
                        return null;
                    }
                }
            );

            return !groups.isEmpty();
        } catch (Exception e) {
            log.error("Error checking group membership: {}", e.getMessage());
            return false;
        }
    }

    /**
     * Create login response with JWT token
     */
    private LoginResponse createLoginResponse(String username, List<String> groups) {
        UserDTO user = UserDTO.builder()
                .id(UUID.randomUUID().toString())
                .username(username)
                .groups(groups)
                .build();

        String token = jwtUtil.generateToken(user);

        return LoginResponse.builder()
                .token(token)
                .user(user)
                .build();
    }

    /**
     * Mock authentication - Phase 1.1 (deprecated, kept for backward compatibility)
     */
    @Deprecated
    public LoginResponse mockLogin(String username, String password) {
        log.warn("Using deprecated mockLogin method, use login() instead");
        return login(username, password);
    }

    /**
     * Validate JWT token
     */
    public boolean validateToken(String token) {
        try {
            return jwtUtil.validateToken(token);
        } catch (Exception e) {
            log.error("Token validation failed", e);
            return false;
        }
    }

    /**
     * Extract username from token
     */
    public String getUsernameFromToken(String token) {
        return jwtUtil.extractUsername(token);
    }
}
