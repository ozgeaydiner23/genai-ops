# GENAI-OPS Design System & UI/UX Specification

## Project Overview
GENAI-OPS is an AI-powered operations assistant for handling customer complaints. The interface combines modern enterprise design with Vodafone's corporate identity, featuring a clean, professional aesthetic with AI-driven functionality.

---

## Color Palette

### Primary Colors
- **Vodafone Red**: `#E60000` - Primary brand color, used for CTAs, accents, and highlights
- **Dark Background**: `#1a1a1a` / `#2a2a2a` - Main background for dark theme
- **Charcoal Gray**: `#333333` / `#444444` - Secondary backgrounds, cards

### Secondary Colors
- **White**: `#FFFFFF` - Text, cards, contrast elements
- **Light Gray**: `#F5F5F5` / `#E8E8E8` - Subtle backgrounds, dividers
- **Medium Gray**: `#999999` / `#CCCCCC` - Secondary text, borders

### Status Colors
- **Success/Resolved**: `#4CAF50` / `#00C853` - Green for completed cases
- **Warning/In Progress**: `#FFC107` / `#FFB300` - Yellow/Orange for active cases
- **Error/Escalated**: `#FF5252` / `#F44336` - Red for urgent cases
- **Info/Open**: `#2196F3` / `#42A5F5` - Blue for new cases

### Accent Colors
- **Red Gradient**: `linear-gradient(135deg, #E60000, #FF4444)`
- **Dark Gradient**: `linear-gradient(180deg, #1a1a1a, #2a2a2a)`
- **Glass Effect**: `rgba(255, 255, 255, 0.05)` with backdrop blur

---

## Typography

### Font Family
- **Primary**: Inter, -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif
- **Monospace** (for code blocks): "Fira Code", "Courier New", monospace

### Font Sizes
- **Heading 1**: 32px / 2rem - Bold
- **Heading 2**: 24px / 1.5rem - Bold
- **Heading 3**: 20px / 1.25rem - Semi-bold
- **Body Large**: 16px / 1rem - Regular
- **Body**: 14px / 0.875rem - Regular
- **Small**: 12px / 0.75rem - Regular
- **Tiny**: 10px / 0.625rem - Regular

### Font Weights
- Regular: 400
- Medium: 500
- Semi-bold: 600
- Bold: 700

---

## Spacing System
- **xs**: 4px
- **sm**: 8px
- **md**: 16px
- **lg**: 24px
- **xl**: 32px
- **2xl**: 48px
- **3xl**: 64px

---

## Border Radius
- **Small**: 4px - Badges, tags
- **Medium**: 8px - Buttons, inputs
- **Large**: 12px - Cards, panels
- **XL**: 16px - Modal dialogs
- **Round**: 50% - Avatars, circular buttons

---

## Shadows & Effects

### Box Shadows
- **Small**: `0 2px 4px rgba(0, 0, 0, 0.1)`
- **Medium**: `0 4px 12px rgba(0, 0, 0, 0.15)`
- **Large**: `0 8px 24px rgba(0, 0, 0, 0.2)`
- **Red Glow**: `0 4px 20px rgba(230, 0, 0, 0.3)`

### Glassmorphism
- Background: `rgba(255, 255, 255, 0.05)`
- Backdrop filter: `blur(10px)`
- Border: `1px solid rgba(255, 255, 255, 0.1)`

---

## Page Specifications

### 1. Login Page

#### Layout Structure
- Centered card design on full-screen background
- Minimal, focused interface
- Soft gradient background (light gray to white)

#### Components

**Logo Section**
- GENAI-OPS logo at top center
- Red circular icon with white geometric pattern
- Logo text: Bold, dark gray
- Spacing: 64px from top

**Login Card**
- Width: 400px max
- Background: White
- Border radius: 16px
- Box shadow: Large
- Padding: 48px 40px

**Card Header**
- Title: "Welcome Back" - H2, Bold, Dark gray
- Subtitle: "Sign in to your account" - Body, Medium gray
- Spacing: 8px between title and subtitle

**Form Fields**
- Email Address input
  - Label: "Email Address" - Small, Medium gray
  - Placeholder: "you@company.com"
  - Border: 1px solid light gray
  - Border radius: 8px
  - Height: 44px
  - Focus state: Red border

- Password input
  - Label: "Password" - Small, Medium gray
  - Placeholder: "Enter your password"
  - Type: password with toggle visibility icon
  - Same styling as email

- Spacing between fields: 20px

**Buttons**
- Sign In button
  - Full width
  - Background: Vodafone Red (#E60000)
  - Text: White, Semi-bold
  - Height: 48px
  - Border radius: 8px
  - Hover: Darker red
  - Box shadow: Red glow on hover

- Forgot Password link
  - Center aligned
  - Text: Vodafone Red
  - Font size: Small
  - Margin top: 16px
  - Hover: Underline

---

### 2. Dashboard Page

#### Layout Structure
- Fixed sidebar navigation (left)
- Top navigation bar
- Main content area (right)
- Responsive grid layout

#### Top Navigation Bar
- Height: 64px
- Background: Dark charcoal (#2a2a2a)
- Border bottom: 1px solid rgba(255, 255, 255, 0.1)

**Components:**
- Logo: GENAI-OPS with red icon (left, 24px margin)
- Navigation links: Dashboard, Cases, Analytics, Settings (center-left)
  - Text: White, 14px
  - Active state: Red underline
- Notification bell icon (right)
- Help icon (right)
- User avatar (right, 24px margin)

#### Sidebar Navigation
- Width: 220px
- Background: Dark background (#1a1a1a)
- Fixed position

**Logo Section:**
- GENAI-OPS logo at top
- Padding: 24px 20px

**Menu Items:**
- Dashboard (active - red background)
- Cases
- AI Chat
- Documentation
- Reports

**Menu Item Styling:**
- Height: 44px
- Padding: 12px 20px
- Icon + Text layout
- Icon size: 20px
- Text: White, 14px
- Active state: Red background (#E60000), rounded 8px
- Hover state: rgba(255, 255, 255, 0.05)
- Spacing: 4px between items

#### Main Content Area
- Background: Light gray (#F5F5F5)
- Padding: 32px

**Page Header:**
- Title: "Dashboard" - H1, Dark gray
- Settings icon (right aligned)

**KPI Cards Section:**
- Grid: 3 columns
- Gap: 24px
- Margin bottom: 32px

**KPI Card Structure:**
- Background: White
- Border radius: 12px
- Padding: 24px
- Box shadow: Small

**Card Content:**
- Label: "Total Cases" / "Resolved Cases" / "Avg. Resolution Time"
  - Font: Small, Medium gray
- Value: Large number (32px, Bold, Dark gray)
  - Examples: "1,482" / "1,203" / "4.2 hours"
- Trend indicator:
  - Icon: Arrow up/down
  - Text: "+3% this month" / "+12% this month" / "-3% this month"
  - Color: Green (positive) / Red (negative)
  - Font: 12px

**Charts Section:**
- Grid: 2 columns
- Gap: 24px
- Margin bottom: 32px

**Chart Card 1: Complaints by Category**
- Background: White
- Border radius: 12px
- Padding: 24px
- Title: "Complaints by Category" - H3

**Bar Chart:**
- Categories: Technical, Billing, Service, Account, Other
- Bars: Light pink/red gradient
- Active bar: Vodafone Red
- Labels: Below bars, 12px, Gray
- Grid lines: Light gray, subtle

**Chart Card 2: Case Status Distribution**
- Same card styling
- Title: "Case Status Distribution"

**Donut Chart:**
- Center text: "82% Resolved" - Large, Bold
- Segments:
  - Resolved: Vodafone Red (#E60000)
  - Open/In-Progress: Light pink (#FFE0E0)
- Legend:
  - Dot + Label
  - "Open/In-Progress" - Light pink dot
  - "Resolved" - Red dot

**Recent Cases Table:**
- Background: White
- Border radius: 12px
- Padding: 24px
- Title: "Recent Cases" - H3

**Table Structure:**
- Headers: CASE ID, CATEGORY, DATE, STATUS, ASSIGNED TO
  - Font: 12px, Semi-bold, Medium gray
  - Text transform: Uppercase
  - Padding: 12px 16px

**Table Rows:**
- Height: 56px
- Border bottom: 1px solid light gray
- Hover: Light gray background

**Cell Content:**
- Case ID: "#89234" - Bold, Dark gray
- Category: "Billing" / "Technical" / etc. - Regular
- Date: "2023-10-26" - Regular, Medium gray
- Status: Badge component
  - "Resolved" - Green background, green text
  - "In Progress" - Yellow background, yellow text
  - "Escalated" - Red background, red text
  - "Open" - Blue background, blue text
  - Padding: 4px 12px
  - Border radius: 12px
  - Font: 12px, Semi-bold
- Assigned To: "AI Assistant" / "Jane Doe" - Regular

**Table Footer:**
- "Showing 1-5 of 100" - Left aligned, 12px, Gray
- Pagination: "Previous", "1", "Next" - Right aligned

**Floating Action Button:**
- Position: Fixed, bottom right
- Size: 64px circle
- Background: Vodafone Red
- Icon: Chat bubble (white)
- Box shadow: Red glow
- Hover: Scale 1.05

---

### 3. Case Detail Page

#### Layout Structure
- Top navigation bar (same as dashboard)
- Breadcrumb navigation
- Two-column layout: Left sidebar (info) + Main content area

#### Header Section
- Background: Dark gradient
- Padding: 24px 32px

**Breadcrumb:**
- "Back to All Cases" - Small, White with opacity
- Arrow icon

**Title Row:**
- Case ID: "Case ID: CASE-2024-0815" - H1, White, Bold
- Status Badge: "In Progress" (right aligned)
  - Background: Orange/Yellow
  - Text: Dark gray
  - Padding: 8px 16px
  - Border radius: 20px
  - Icon: Clock/status icon

#### Main Content Area
- Background: Dark background (#1a1a1a)
- Padding: 32px
- Grid: 2 columns (1:2 ratio)

#### Left Panel: Case Information Card
- Width: 280px
- Background: Dark charcoal (#2a2a2a)
- Border radius: 12px
- Padding: 24px

**Card Header:**
- Title: "Case Information" - H3, White, Semi-bold

**Customer Info:**
- Name: "Eleanor Vance" - Large, White, Bold
- Label: "Customer" - Small, Gray

**Divider:** 1px solid rgba(255, 255, 255, 0.1)

**Details List:**
- Date Opened: "Aug 15, 2024"
- Category: "Billing Issue"
- Priority: "High" (Red text)

**List Item Styling:**
- Label: Small, Gray
- Value: Body, White
- Spacing: 16px between items

#### Right Panel: Main Content

**AI Suggested Solution Card:**
- Background: Dark red gradient (very subtle)
- Border: 1px solid red (subtle)
- Border radius: 12px
- Padding: 24px
- Margin bottom: 24px

**Card Header:**
- Icon: AI sparkle icon (red)
- Title: "AI Suggested Solution" - H3, Red
- Spacing: 8px between icon and title

**Solution Text:**
- Font: Body, White
- Line height: 1.6
- Content: AI-generated solution description

**Action Buttons Row:**
- Layout: Flex, space between
- Gap: 12px

**Buttons:**
1. "Apply Solution"
   - Background: Vodafone Red
   - Text: White, Semi-bold
   - Icon: Checkmark
   - Padding: 12px 24px
   - Border radius: 8px

2. "Request Alternative"
   - Background: Transparent
   - Border: 1px solid gray
   - Text: White
   - Icon: Refresh
   - Padding: 12px 24px

3. "Close Case"
   - Background: Transparent
   - Text: Gray
   - Padding: 12px 24px
   - Right aligned

**Tabs Section:**
- Border bottom: 1px solid rgba(255, 255, 255, 0.1)
- Margin bottom: 24px

**Tab Items:**
- "Details" (active), "Documentation Links", "Notes"
- Font: 14px, Semi-bold
- Padding: 12px 24px
- Active state: Red bottom border (3px), White text
- Inactive: Gray text
- Hover: White text

**Tab Content: Details Panel**
- Background: Dark charcoal (#2a2a2a)
- Border radius: 12px
- Padding: 24px

**Section Title:**
- "Original Complaint from Customer" - H4, White

**Divider:** Red line (1px, subtle)

**Complaint Text:**
- Font: Body, Gray
- Line height: 1.6
- Background: Slightly darker
- Padding: 16px
- Border radius: 8px
- Margin top: 16px

---

### 4. AI Chat Assistant Page

#### Layout Structure
- Fixed sidebar (left)
- Main chat area (center-right)
- Full height layout

#### Sidebar
- Width: 240px
- Background: Dark background (#1a1a1a)
- Border right: 1px solid rgba(255, 255, 255, 0.1)

**Header:**
- Logo: GENAI-OPS with icon
- Subtitle: "AI Operations Assistant" - Small, Gray
- Padding: 24px 20px

**New Chat Button:**
- Full width
- Background: Vodafone Red
- Text: White, Semi-bold
- Height: 44px
- Border radius: 8px
- Icon: Plus icon
- Margin bottom: 24px

**Quick Actions Section:**
- Title: "QUICK ACTIONS" - Tiny, Gray, Uppercase
- Margin bottom: 12px

**Action Items:**
- "Analyze Logs"
- "Suggest Fix"
- "View Docs"

**Item Styling:**
- Icon + Text layout
- Icon: 16px, Gray
- Text: 14px, White
- Padding: 10px 12px
- Border radius: 6px
- Hover: rgba(255, 255, 255, 0.05)
- Spacing: 4px between items

**History Section:**
- Title: "HISTORY" - Tiny, Gray, Uppercase
- Margin top: 32px
- Margin bottom: 12px

**History Items:**
- "Customer Ticket #12345 Alert" (active - red background)
- "Database Timeout Error Fix"
- "API Latency Investigation"

**Item Styling:**
- Text: 14px, White
- Padding: 10px 12px
- Border radius: 6px
- Active: Red background
- Hover: rgba(255, 255, 255, 0.05)
- Truncate long text with ellipsis

**User Profile (Bottom):**
- Avatar: 40px circle
- Name: "John Doe" - White, 14px
- Link: "View Profile" - Small, Gray
- Padding: 20px

#### Main Chat Area
- Background: Dark background (#1a1a1a)
- Flex column layout

**Header:**
- Height: 64px
- Border bottom: 1px solid rgba(255, 255, 255, 0.1)
- Padding: 0 32px

**Header Content:**
- Title: "GENAI-OPS" - H3, White
- Subtitle or status indicator

**Chat Messages Container:**
- Flex: 1 (grows to fill space)
- Overflow: Auto scroll
- Padding: 32px
- Max width: 900px (centered)

**Message Bubbles:**

**AI Message (Left):**
- Layout: Flex row
- Avatar: 36px circle with AI icon
- Margin right: 12px

**Message Bubble:**
- Background: Dark charcoal (#2a2a2a)
- Border radius: 12px (sharp corner bottom-left)
- Padding: 16px 20px
- Max width: 70%
- Box shadow: Small

**Message Text:**
- Font: Body, White
- Line height: 1.6

**Code Block (if present):**
- Background: Black (#000000)
- Border: 1px solid rgba(255, 255, 255, 0.1)
- Border radius: 8px
- Padding: 16px
- Margin: 12px 0
- Font: Monospace, 13px

**Code Header:**
- Language label: "python" - Small, Gray
- Copy button: "Copy code" - Right aligned
  - Icon: Copy icon
  - Text: Gray
  - Hover: White

**User Message (Right):**
- Layout: Flex row-reverse
- Avatar: 36px circle (right side)
- Margin left: 12px

**Message Bubble:**
- Background: Vodafone Red (#E60000)
- Border radius: 12px (sharp corner bottom-right)
- Padding: 12px 20px
- Max width: 60%
- Text: White, 14px
- Align: Right

**Message Spacing:**
- Gap between messages: 24px

#### Input Area (Bottom)
- Position: Fixed bottom
- Background: Dark charcoal (#2a2a2a)
- Border top: 1px solid rgba(255, 255, 255, 0.1)
- Padding: 20px 32px
- Max width: 900px (centered)

**Input Container:**
- Background: Darker (#1a1a1a)
- Border: 1px solid rgba(255, 255, 255, 0.1)
- Border radius: 12px
- Padding: 12px 16px
- Display: Flex
- Align items: Center

**Components:**
- Attachment icon (left)
  - Icon: Paperclip
  - Size: 20px
  - Color: Gray
  - Hover: White
  - Margin right: 12px

- Text input
  - Flex: 1
  - Background: Transparent
  - Border: None
  - Color: White
  - Placeholder: "Ask GENAI-OPS anything..."
  - Font: 14px

- Send button (right)
  - Background: Vodafone Red
  - Size: 40px circle
  - Icon: Send arrow (white)
  - Hover: Darker red
  - Box shadow: Red glow

---

## Component Library

### Buttons

**Primary Button:**
- Background: Vodafone Red (#E60000)
- Text: White, Semi-bold
- Padding: 12px 24px
- Border radius: 8px
- Hover: Darker red, scale 1.02
- Active: Even darker, scale 0.98
- Box shadow: Red glow on hover

**Secondary Button:**
- Background: Transparent
- Border: 1px solid gray
- Text: White
- Padding: 12px 24px
- Border radius: 8px
- Hover: Border white, background rgba(255, 255, 255, 0.05)

**Ghost Button:**
- Background: Transparent
- Text: Gray
- Padding: 12px 24px
- Hover: Text white

**Icon Button:**
- Size: 40px circle
- Background: Transparent or red
- Icon: 20px
- Hover: Background change

### Input Fields

**Text Input:**
- Height: 44px
- Background: White (light theme) / Dark (#2a2a2a) (dark theme)
- Border: 1px solid light gray / rgba(255, 255, 255, 0.1)
- Border radius: 8px
- Padding: 12px 16px
- Font: 14px
- Focus: Red border, box shadow

**Label:**
- Font: 12px, Medium gray
- Margin bottom: 6px

**Placeholder:**
- Color: Medium gray
- Opacity: 0.6

### Cards

**Standard Card:**
- Background: White (light) / Dark charcoal (dark)
- Border radius: 12px
- Padding: 24px
- Box shadow: Small
- Border: Optional 1px solid

**Glass Card:**
- Background: rgba(255, 255, 255, 0.05)
- Backdrop filter: blur(10px)
- Border: 1px solid rgba(255, 255, 255, 0.1)
- Border radius: 12px

### Badges

**Status Badge:**
- Padding: 4px 12px
- Border radius: 12px
- Font: 12px, Semi-bold
- Colors based on status (see status colors)

### Avatars

**User Avatar:**
- Size: 36px / 40px circle
- Border: 2px solid white / transparent
- Image or initials

**AI Avatar:**
- Size: 36px circle
- Background: Dark gray
- Icon: AI symbol (white)

### Icons
- Size: 16px / 20px / 24px
- Color: Inherit or specified
- Stroke width: 2px
- Style: Outline/line icons preferred

### Dividers
- Horizontal: 1px solid rgba(255, 255, 255, 0.1)
- Vertical: 1px solid rgba(255, 255, 255, 0.1)
- Accent: 1px solid red (subtle)

---

## Interactions & Animations

### Hover States
- Buttons: Scale 1.02, brightness increase
- Cards: Subtle lift (translateY -2px), shadow increase
- Links: Underline, color change
- Icons: Color change, scale 1.1

### Active States
- Buttons: Scale 0.98
- Inputs: Border color change, shadow

### Transitions
- Duration: 200ms - 300ms
- Easing: ease-in-out / cubic-bezier(0.4, 0, 0.2, 1)
- Properties: all, transform, opacity, color

### Loading States
- Skeleton screens with shimmer effect
- Spinner: Red circular spinner
- Progress bars: Red fill

### Micro-interactions
- Button click: Ripple effect
- Success: Checkmark animation
- Error: Shake animation
- Notification: Slide in from top

---

## Responsive Breakpoints

- **Mobile**: < 768px
- **Tablet**: 768px - 1024px
- **Desktop**: > 1024px
- **Large Desktop**: > 1440px

### Mobile Adaptations
- Sidebar: Collapsible hamburger menu
- Cards: Stack vertically
- Tables: Horizontal scroll or card view
- Font sizes: Slightly reduced
- Padding: Reduced spacing

---

## Accessibility

### Contrast Ratios
- Text on background: Minimum 4.5:1
- Large text: Minimum 3:1
- Interactive elements: Clear focus states

### Focus States
- Outline: 2px solid red
- Offset: 2px
- Visible on keyboard navigation

### ARIA Labels
- All interactive elements
- Icon buttons with descriptive labels
- Form inputs with proper labels

### Keyboard Navigation
- Tab order: Logical flow
- Enter/Space: Activate buttons
- Escape: Close modals/dropdowns

---

## Design Principles

1. **Clarity**: Clear visual hierarchy, easy to scan
2. **Consistency**: Unified design language across all pages
3. **Efficiency**: Minimal clicks, fast access to key features
4. **Intelligence**: AI-first design, smart suggestions prominent
5. **Brand Alignment**: Vodafone red as primary accent, professional yet energetic
6. **Modern Aesthetic**: Glassmorphism, subtle gradients, clean lines
7. **Dark Theme First**: Optimized for extended use, reduced eye strain
8. **Responsive**: Seamless experience across devices

---

## Technical Notes

### CSS Framework Recommendations
- Tailwind CSS or custom CSS with CSS variables
- CSS Grid and Flexbox for layouts
- CSS transitions for animations

### Icon Library
- Lucide Icons / Heroicons / Feather Icons
- Consistent stroke width and style

### Chart Library
- Chart.js / Recharts / ApexCharts
- Custom styling to match design system

### State Management
- React Context / Redux for global state
- Local state for component-specific data

---

## File Structure Recommendation

```
/src
  /components
    /common
      - Button.jsx
      - Input.jsx
      - Card.jsx
      - Badge.jsx
      - Avatar.jsx
    /layout
      - Sidebar.jsx
      - TopNav.jsx
      - PageHeader.jsx
    /dashboard
      - KPICard.jsx
      - ChartCard.jsx
      - CasesTable.jsx
    /case-detail
      - CaseInfo.jsx
      - AISolution.jsx
      - CaseTabs.jsx
    /chat
      - ChatMessage.jsx
      - ChatInput.jsx
      - ChatHistory.jsx
  /pages
    - Login.jsx
    - Dashboard.jsx
    - CaseDetail.jsx
    - AIChat.jsx
  /styles
    - variables.css
    - global.css
    - theme.css
  /utils
    - constants.js
    - helpers.js
```

---

## Next Steps for Implementation

1. Set up project structure and install dependencies
2. Create design system tokens (colors, spacing, typography)
3. Build reusable component library
4. Implement pages following this specification
5. Add responsive behavior
6. Implement animations and interactions
7. Test accessibility compliance
8. Optimize performance

---

**End of Design Specification**
