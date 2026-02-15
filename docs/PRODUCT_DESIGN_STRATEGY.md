# Vision Exercise — Product Design Strategy

## 1. Problem Definition: Crossed Eyes (Strabismus)

### 1.1 What is Strabismus?

**Strabismus** is a condition where the eyes do not align properly. One eye may turn inward (esotropia), outward (exotropia), upward (hypertropia), or downward (hypotropia) while the other focuses on a target. This disrupts **binocular vision** — the brain’s ability to fuse images from both eyes into a single 3D view.

### 1.2 Impact

| Area | Impact |
|------|--------|
| **Depth perception** | Limited or absent 3D vision; difficulty with stairs, sports, driving |
| **Reading** | Eye strain, fatigue, double vision, reduced concentration |
| **Daily life** | Self-consciousness, social discomfort, reduced confidence |
| **Child development** | Risk of amblyopia (lazy eye), learning difficulties, motor delays |
| **Adults** | Often stable; can worsen with fatigue, illness, or stress |

### 1.3 Key Sub-Problems

1. **Convergence insufficiency** — Difficulty bringing both eyes inward for near work  
2. **Divergence excess** — Eyes drift outward when looking far away  
3. **Accommodation problems** — Difficulty shifting focus between near and far  
4. **Saccade and pursuit deficits** — Uneven or jerky eye movement when tracking

### 1.4 User Segments

| Segment | Age | Needs |
|---------|-----|-------|
| **Parents of young children** | 25–45 | Simple, reliable exercises; progress feedback; home use |
| **School-age children** | 6–12 | Engaging, game-like UI; short sessions; clear instructions |
| **Teens / young adults** | 13–25 | Non-stigmatizing; minimal “medical” feel; easy daily use |
| **Adults with strabismus** | 25+ | Flexibility; control over difficulty and duration; evidence-based approach |

---

## 2. Solution Strategy

### 2.1 Vision Therapy

Vision therapy (orthoptics) uses structured eye exercises to improve alignment, convergence, accommodation, and eye tracking. Evidence supports its role, especially for convergence insufficiency.

### 2.2 Brock String as Core Exercise

The **Brock String** is a proven tool:

- Real physical string with beads
- Encourages both eyes to converge on a single bead
- Moves the bead along the string to train dynamic convergence and divergence
- Low-cost and easy to use at home

### 2.3 Digital Adaptation

The app mirrors the Brock String experience:

- **Bead on screen** — Replaces physical bead; eyes converge on it
- **Multiple paths** — Horizontal, vertical, diagonal, ellipse, circle, infinity
- **Controlled speed** — Mimics slow/fast bead movement
- **Repeatable and measurable** — Sessions can be logged and adjusted

### 2.4 Product Principles

1. **Evidence-based** — Align with standard vision therapy practices  
2. **Accessible** — Usable across age, ability, and device (mobile, tablet, web)  
3. **Low friction** — Quick start, minimal setup, works offline  
4. **Calm and focused** — No distractions; visual comfort prioritized  
5. **Progressive** — Pathways to more advanced or harder exercises

---

## 3. UI/UX Design

### 3.1 Design Principles

| Principle | Description |
|-----------|-------------|
| **Reduce glare** | Soft, muted surfaces; avoid pure white and harsh contrast |
| **High contrast for targets** | Bead and path clearly stand out from background |
| **Minimal clutter** | Focus on the bead; controls secondary and unobtrusive |
| **Consistent layout** | Exercise area prominent; controls always in the same place |
| **Responsive touch targets** | Large tap areas for mobile; adequate spacing between controls |
| **Forgiving interaction** | Start/Pause, undo, easy exit; no penalties for mistakes |

### 3.2 Information Architecture

```
Vision Exercise App
├── Splash / Onboarding (mobile)
│   ├── Brief intro
│   └── Rotate to landscape prompt
├── Exercise Screen (primary)
│   ├── Instruction / context
│   ├── Canvas (string + bead)
│   ├── Controls
│   │   ├── Start / Pause
│   │   ├── Speed (1×–4×)
│   │   └── Movement mode (Horizontal, Vertical, Diagonal, etc.)
│   └── Optional: Session timer, progress hint
└── [Future] Settings, History, Progress
```

### 3.3 User Flows

**First-time user (mobile)**  
1. App opens → Splash with brief animation  
2. “Rotate to landscape” prompt  
3. Tap to continue → Exercise screen  
4. Focus on bead; adjust speed and mode as needed

**Returning user (mobile)**  
1. App opens → Splash (or direct to exercise)  
2. Rotate to landscape → Exercise screen  
3. Choose mode and start

**Web user**  
1. Open URL → Exercise screen  
2. Choose mode and speed; start immediately

### 3.4 Layout Guidelines

- **Exercise area**: 60–70% of viewport; centered  
- **Controls**: Fixed at bottom; grouped by function  
- **Padding**: Safe-area aware; no content under notch or system UI  
- **Landscape preferred**: Mirrors physical Brock String; better horizontal space for paths  

### 3.5 Accessibility Considerations

| Concern | Approach |
|---------|----------|
| **Low vision** | High contrast bead and path; scalable text; accessible motion (no seizure risk) |
| **Motion sensitivity** | Option to slow or pause; respect `prefers-reduced-motion` where possible |
| **Motor control** | Large touch targets; swipe alternatives where appropriate |
| **Cognition** | Clear labels; simple hierarchy; few choices per screen |
| **Screen readers** | Descriptive labels for controls; state announced (playing/paused, mode, speed) |

### 3.6 Interaction Patterns

- **Start/Pause** — Single, obvious primary action  
- **Speed** — Chips or segmented control; current value clearly shown  
- **Mode** — Chips or grid; current mode highlighted  
- **Feedback** — Subtle confirmation (e.g. slight highlight) when changing mode or speed  

### 3.7 Error States & Edge Cases

- **Portrait on mobile** — Clear “rotate to landscape” with icon  
- **Very small screen** — Layout scales; bead remains visible  
- **Animation interrupted** — Resume cleanly on return  
- **Web orientation** — No rotate requirement; works in any orientation  

---

## 4. Design System

### 4.1 Color Palette

#### Primary (Calming Green)

Supports focus and reduces harsh contrast.

| Token | Hex | Usage |
|-------|-----|-------|
| `primary` | `#2E7D32` | Primary actions, selected states, accents |
| `primaryDark` | `#1B5E20` | Selected chips, hover/pressed |
| `primaryLight` | `#4CAF50` | Optional highlights, success states |

#### Neutral / Surface

| Token | Hex | Usage |
|-------|-----|-------|
| `surface` | `#F5F5F0` | Main background (slightly warm gray) |
| `surfaceVariant` | `#EEEEE8` | Cards, elevated surfaces |
| `outline` | `#BDBDBD` | Borders, dividers |
| `onSurface` | `#212121` | Primary text |
| `onSurfaceVariant` | `#757575` | Secondary text, hints |

#### Exercise Canvas

| Token | Hex | Usage |
|-------|-----|-------|
| `string` | `#333333` | Path / string stroke |
| `bead` | `#1565C0` | Moving bead (high contrast vs surface) |
| `canvasBackground` | `#FFFFFF` or `surface` | Canvas area behind path |

#### Semantic

| Token | Hex | Usage |
|-------|-----|-------|
| `success` | `#2E7D32` | Confirmations |
| `error` | `#C62828` | Errors, warnings |
| `info` | `#1565C0` | Informational messages |

### 4.2 Typography

| Role | Size | Weight | Usage |
|------|------|--------|-------|
| `display` | 24–28sp | 600 | Screen titles |
| `title` | 18–20sp | 600 | Section headers |
| `titleMedium` | 16–18sp | 500 | Instructions, card titles |
| `body` | 14–16sp | 400 | Body text |
| `bodySmall` | 12–14sp | 400 | Secondary text, hints |
| `label` | 14sp | 600 | Buttons, chips |

**Font family**  
- Use system fonts (e.g. SF Pro, Roboto) for readability and consistency.  
- Avoid decorative fonts; prioritize legibility.

### 4.3 Spacing

| Token | Value | Usage |
|-------|-------|-------|
| `xs` | 4px | Tight spacing, icon gaps |
| `sm` | 8px | Related elements |
| `md` | 16px | Between sections |
| `lg` | 24px | Major sections |
| `xl` | 32px | Screen padding |
| `xxl` | 48px | Hero spacing |

### 4.4 Corner Radius

| Token | Value | Usage |
|-------|-------|-------|
| `radiusSm` | 8px | Small buttons, tags |
| `radiusMd` | 12px | Cards, inputs |
| `radiusLg` | 20px | Chips, large buttons |
| `radiusFull` | 9999px | Pills, circular buttons |

### 4.5 Elevation & Shadows

- Keep elevation low to avoid distraction.  
- Use subtle shadows for floating controls (e.g. FAB).  
- Canvas area: flat; no shadows unless needed for depth.

### 4.6 Components

#### Mode Chip

- Padding: 16h × 10v  
- Border radius: 20px (pill)  
- Unselected: `primary`  
- Selected: `primaryDark`  
- Text: white, 14sp, weight 600  

#### Speed Chip

- Same style as mode chip  
- Shows “1×”, “2×”, “3×”, “4×”  

#### Primary Button (Start/Pause)

- Extended FAB  
- Background: `primary`  
- Foreground: white  
- Icon + label  
- Border radius: 8px (or default FAB)  

#### Bead

- Radius: 18px (36px diameter)  
- Color: `bead` (`#1565C0`)  
- Solid fill; no stroke unless needed for contrast  

#### String / Path

- Stroke width: 3px  
- Color: `string`  
- Stroke cap: round  
- Style: stroke (no fill)  

### 4.7 Motion

| Element | Behavior |
|---------|----------|
| **Bead** | `easeInOut`; repeat reverse; duration driven by speed (e.g. 5s base) |
| **Mode / speed change** | Instant; no transition |
| **Screen transitions** | Fade or slide; 200–300ms |
| **Splash** | Gentle bounce; 1–1.5s cycle |

**Principles**

- Bead motion should feel smooth, not abrupt.  
- Avoid rapid flashing or strobe effects.  
- Provide controls to slow or pause for motion-sensitive users.

### 4.8 Iconography

- Use Material Icons or similar for consistency.  
- Key icons: `play_arrow`, `pause`, `screen_rotation`.  
- 24dp default; 20dp for inline with text.

---

## 5. Future Considerations

### 5.1 Product Roadmap

- **Session logging** — Track duration, mode, speed  
- **Progress dashboard** — Simple stats, streaks  
- **Guided programs** — Preset sequences for different conditions  
- **Custom paths** — User-defined or prescribed paths  
- **Reminders** — Gentle daily practice nudges  
- **Dark mode** — For low-light or evening use  

### 5.2 Validation

- **User testing** — With people who have strabismus or convergence issues  
- **Professional input** — Optometrists, orthoptists, vision therapists  
- **Metrics** — Session length, return rate, mode usage  

### 5.3 Compliance & Safety

- Disclaimer: “Not a replacement for professional care.”  
- Encourage users to consult an eye care professional.  
- Document intended use and limitations.  

---

## 6. Summary

Vision Exercise uses the Brock String as the core pattern to support convergence and eye coordination in people with strabismus. The product design centers on:

- A clear **problem-solution** link  
- **UI/UX** focused on calm, accessible, low-distraction interaction  
- A **design system** that supports consistency, readability, and focus  

The design system is implemented in the app today and can be extended as new features and screens are added.
