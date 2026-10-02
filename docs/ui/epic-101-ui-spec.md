# UI Specification — Friday Snack Vote

**Epic**: #101  
**Status**: Implemented

## Design Principles

- **Mobile-first**: Design for small screens, enhance for larger screens
- **Simple**: Minimal UI, clear actions, no unnecessary elements
- **Fast**: Quick load times, immediate feedback
- **Accessible**: Clear labels, good contrast, keyboard navigation

## Pages

### 1. Create Poll Page

**Route**: `/` or `/create`

**Layout:**
```
┌─────────────────────────────┐
│  Friday Snack Vote          │
│                             │
│  Question:                  │
│  ┌───────────────────────┐  │
│  │ What snack for Friday?│  │
│  └───────────────────────┘  │
│                             │
│  Options:                   │
│  ┌───────────────────────┐  │
│  │ Pizza                 │  │
│  └───────────────────────┘  │
│  ┌───────────────────────┐  │
│  │ Tacos                 │  │
│  └───────────────────────┘  │
│  [+ Add Option]             │
│                             │
│  [Create Poll]              │
└─────────────────────────────┘
```

**Elements:**
- Header: "Friday Snack Vote"
- Question input field (text, required)
- Option input fields (text, minimum 2 required)
- "Add Option" button (adds new input field)
- "Create Poll" button (primary action)

**Behavior:**
- Minimum 2 options required to enable "Create Poll" button
- After successful creation, display shareable link
- Show copy-to-clipboard button for share link

**Success State:**
```
┌─────────────────────────────┐
│  Poll Created! ✓            │
│                             │
│  Share this link:           │
│  ┌───────────────────────┐  │
│  │ /polls/123            │  │
│  └───────────────────────┘  │
│  [Copy Link]                │
│                             │
│  [Create Another Poll]      │
└─────────────────────────────┘
```

### 2. Vote Page

**Route**: `/polls/:id`

**Layout:**
```
┌─────────────────────────────┐
│  What snack for Friday?     │
│                             │
│  ○ Pizza                    │
│  ○ Tacos                    │
│  ○ Sushi                    │
│  ○ Burgers                  │
│                             │
│  [Submit Vote]              │
└─────────────────────────────┘
```

**Elements:**
- Poll question as header
- Radio buttons for each option
- "Submit Vote" button (primary action, disabled until option selected)

**Behavior:**
- Load poll data on page load
- Enable submit button when option selected
- After submission, transition to results page
- Show loading state during submission

### 3. Results Page

**Route**: `/polls/:id/results` or shown after voting

**Layout:**
```
┌─────────────────────────────┐
│  What snack for Friday?     │
│                             │
│  Pizza          ████ 29%    │
│  (5 votes)                  │
│                             │
│  Tacos          ██ 18%      │
│  (3 votes)                  │
│                             │
│  Sushi          ██████ 41%  │
│  (7 votes)                  │
│                             │
│  Burgers        █ 12%       │
│  (2 votes)                  │
│                             │
│  Total: 17 votes            │
│                             │
│  [Create New Poll]          │
└─────────────────────────────┘
```

**Elements:**
- Poll question as header
- Each option with:
  - Option text
  - Visual bar showing percentage
  - Vote count
  - Percentage label
- Total vote count
- "Create New Poll" button (secondary action)

**Behavior:**
- Results update in real-time (or on page refresh)
- Options sorted by vote count (highest first)
- Visual bars scale proportionally to percentages

## Responsive Breakpoints

### Mobile (< 768px)
- Single column layout
- Full-width inputs and buttons
- Touch-friendly tap targets (min 44px)
- Stack all elements vertically

### Tablet/Desktop (≥ 768px)
- Centered content with max-width (600px)
- Larger text for readability
- Hover states for interactive elements

## Color Palette

- **Primary**: Blue (#007bff) for buttons and links
- **Success**: Green (#28a745) for confirmation states
- **Background**: White (#ffffff)
- **Text**: Dark gray (#333333)
- **Border**: Light gray (#dddddd)
- **Bar chart**: Blue gradient for visual bars

## Typography

- **Font family**: System font stack (sans-serif)
- **Headers**: 24px, bold
- **Body**: 16px, regular
- **Buttons**: 16px, medium weight

## Accessibility

- Semantic HTML (form, button, label elements)
- ARIA labels for screen readers
- Keyboard navigation support
- Color contrast ratio ≥ 4.5:1
- Focus indicators on interactive elements
