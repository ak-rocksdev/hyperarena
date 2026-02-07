# HyperArena — Design System Overview

> **Review document.** Once approved, this will be translated into Flutter/Dart files.

---

## 1. COLOR PALETTE

### 1.1 Brand Colors

#### Primary: Electric Blue
The core brand identity. Bold, trustworthy, energetic.
Used for: primary buttons, active states, links, key navigation elements.

| Token          | Hex       | Usage                                      |
|----------------|-----------|--------------------------------------------|
| primary50      | `#EFF6FF` | Tinted backgrounds, highlight surfaces     |
| primary100     | `#DBEAFE` | Hover/pressed light states, containers     |
| primary200     | `#BFDBFE` | Light chips, progress backgrounds          |
| primary300     | `#93C5FD` | Disabled primary elements                  |
| primary400     | `#60A5FA` | Secondary icons, lighter CTAs              |
| primary500     | `#3B82F6` | Sub-headers, secondary buttons             |
| **primary600** | **#2563EB** | **← Main primary. Buttons, links, icons**|
| primary700     | `#1D4ED8` | Pressed/hover state for primary            |
| primary800     | `#1E40AF` | Dark header backgrounds                    |
| primary900     | `#1E3A8A` | Darkest — text on light primary bg         |

#### Secondary: Teal
Fresh, active, health-oriented.
Used for: secondary actions, success-adjacent states, health/activity indicators, tags.

| Token          | Hex       | Usage                                      |
|----------------|-----------|--------------------------------------------|
| secondary50    | `#F0FDFA` | Tinted secondary backgrounds               |
| secondary100   | `#CCFBF1` | Light containers                           |
| secondary200   | `#99F6E4` | Chips, light badges                        |
| secondary300   | `#5EEAD4` | Decorative accents                         |
| secondary400   | `#2DD4BF` | Icons, progress rings                      |
| secondary500   | `#14B8A6` | Icons, tags, decorative accents            |
| **secondary600** | **#0D9488** | **← Main secondary. Buttons, fills**   |
| secondary700   | `#0F766E` | Pressed/hover state                        |
| secondary800   | `#115E59` | Dark text/icons                            |
| secondary900   | `#134E4A` | Darkest                                    |

#### Accent: Vivid Orange
Energy, urgency, call-to-action.
Used for: special CTAs, promotions, highlights, notification badges, XP bars.

| Token       | Hex       | Usage                                         |
|-------------|-----------|-----------------------------------------------|
| accent50    | `#FFF7ED` | Tinted accent backgrounds                     |
| accent100   | `#FFEDD5` | Light containers                              |
| accent200   | `#FED7AA` | Light badges, chips                           |
| accent300   | `#FDBA74` | Decorative                                    |
| accent400   | `#FB923C` | Icons, secondary CTAs                         |
| **accent500** | **#F97316** | **← Main accent. Special CTAs, highlights** |
| accent600   | `#EA580C` | Pressed/hover state                           |
| accent700   | `#C2410C` | Text on light accent bg                       |
| accent800   | `#9A3412` | Dark text                                     |
| accent900   | `#7C2D12` | Darkest                                       |

### 1.2 Neutral Palette (Slate)
Clean, professional. For text, borders, structural UI.

| Token       | Hex       | Usage                                         |
|-------------|-----------|-----------------------------------------------|
| neutral50   | `#F8FAFC` | Page backgrounds, subtle surfaces             |
| neutral100  | `#F1F5F9` | Card variant bg, dividers, surface variant    |
| neutral200  | `#E2E8F0` | Borders, dividers, disabled bg                |
| neutral300  | `#CBD5E1` | Disabled text, placeholder, border medium     |
| neutral400  | `#94A3B8` | Tertiary text, icons, hints                   |
| neutral500  | `#64748B` | Secondary text, labels                        |
| neutral600  | `#475569` | Body text secondary, subheadings              |
| neutral700  | `#334155` | Strong body text                              |
| neutral800  | `#1E293B` | Headings, high-emphasis text                  |
| neutral900  | `#0F172A` | Primary text, maximum contrast                |

### 1.3 Semantic Colors

| Semantic  | Main        | Light Bg    | Dark/Text   | Usage                          |
|-----------|-------------|-------------|-------------|--------------------------------|
| Success   | `#22C55E`   | `#DCFCE7`   | `#16A34A`  | Confirmed, completed, positive |
| Warning   | `#F59E0B`   | `#FEF3C7`   | `#D97706`  | Pending, caution, alerts       |
| Error     | `#EF4444`   | `#FEE2E2`   | `#DC2626`  | Rejected, failed, destructive  |
| Info      | `#6366F1`   | `#E0E7FF`   | `#4F46E5`  | Tips, neutral information      |

### 1.4 Surface & Background

| Token              | Hex       | Usage                                    |
|--------------------|-----------|------------------------------------------|
| background         | `#F8FAFC` | Main scaffold background                 |
| backgroundPure     | `#FFFFFF` | Pure white when needed                   |
| surface            | `#FFFFFF` | Cards, modals, sheets                    |
| surfaceVariant     | `#F1F5F9` | Alternate card bg, tab backgrounds       |
| surfaceHighlight   | `#EFF6FF` | Primary-tinted surface (selected states) |
| surfaceSecondary   | `#F0FDFA` | Secondary-tinted surface                 |
| surfaceAccent      | `#FFF7ED` | Accent-tinted surface (promotions)       |

### 1.5 Text Colors

| Token          | Hex       | Usage                                      |
|----------------|-----------|--------------------------------------------|
| textPrimary    | `#0F172A` | Headings, body text, high emphasis         |
| textSecondary  | `#475569` | Descriptions, secondary labels             |
| textTertiary   | `#94A3B8` | Captions, timestamps, hints                |
| textDisabled   | `#CBD5E1` | Disabled states                            |
| textOnPrimary  | `#FFFFFF` | Text on primary-colored backgrounds        |
| textOnSecondary| `#042F2E` | Text on secondary-colored backgrounds      |
| textOnAccent   | `#FFFFFF` | Text on accent-colored backgrounds         |
| textOnDark     | `#FFFFFF` | Text on dark backgrounds (snackbar, tooltip)|
| textLink       | `#2563EB` | Tappable links                             |

### 1.6 Border & Divider

| Token         | Hex       | Usage                                       |
|---------------|-----------|---------------------------------------------|
| border        | `#E2E8F0` | Default card/input borders                  |
| borderLight   | `#F1F5F9` | Subtle dividers                             |
| borderMedium  | `#CBD5E1` | Emphasized borders                          |
| borderStrong  | `#94A3B8` | High-contrast borders                       |
| borderFocused | `#2563EB` | Focused input fields                        |
| borderError   | `#EF4444` | Error state inputs                          |
| divider       | `#E2E8F0` | List dividers, section separators           |

### 1.7 Sport-Specific Colors

Each sport gets a triad: icon/foreground color, background tint, and text-on-bg color.

| Sport         | Color     | Background  | Text        |
|---------------|-----------|-------------|-------------|
| Tennis        | `#65A30D` | `#F5FAD1`  | `#3F6212`   |
| Padel         | `#7C3AED` | `#EDE9FE`  | `#5B21B6`   |
| Badminton     | `#0EA5E9` | `#E0F2FE`  | `#0369A1`   |
| Futsal        | `#EF4444` | `#FEE2E2`  | `#B91C1C`   |
| Basketball    | `#F97316` | `#FFF7ED`  | `#C2410C`   |
| Volleyball    | `#EC4899` | `#FCE7F3`  | `#BE185D`   |
| Table Tennis  | `#14B8A6` | `#F0FDFA`  | `#0F766E`   |

Helper functions: `sportColor(Sport)`, `sportBgColor(Sport)`, `sportTextColor(Sport)`

### 1.8 Booking Status Colors

Each status gets: badge color, background tint, and text color.

| Status                | Badge     | Background  | Text        | Maps to       |
|-----------------------|-----------|-------------|-------------|---------------|
| Pending Payment       | `#F59E0B` | `#FEF3C7`  | `#D97706`   | warning       |
| Waiting Confirmation  | `#F97316` | `#FFF7ED`  | `#C2410C`   | accent        |
| Confirmed             | `#22C55E` | `#DCFCE7`  | `#16A34A`   | success       |
| Rejected              | `#EF4444` | `#FEE2E2`  | `#DC2626`   | error         |
| Cancelled             | `#94A3B8` | `#F1F5F9`  | `#475569`   | neutral       |
| Completed             | `#3B82F6` | `#DBEAFE`  | `#2563EB`   | primary       |
| Expired               | `#64748B` | `#F1F5F9`  | `#334155`   | neutral       |

Helper functions: `bookingStatusColor(BookingStatus)`, `bookingStatusBgColor(BookingStatus)`, `bookingStatusTextColor(BookingStatus)`

### 1.9 Level Tier Colors (Gamification)

| Tier          | Badge Color | Background  | Text        |
|---------------|-------------|-------------|-------------|
| Rookie        | `#CD7F32`   | `#FDF2E3`  | `#8B5E20`   |
| Amateur       | `#94A3B8`   | `#F1F5F9`  | `#64748B`   |
| Intermediate  | `#F59E0B`   | `#FEF3C7`  | `#B45309`   |
| Advanced      | `#38BDF8`   | `#E0F2FE`  | `#0369A1`   |
| Pro           | `#A78BFA`   | `#EDE9FE`  | `#6D28D9`   |

Helper functions: `levelColor(LevelTier)`, `levelBgColor(LevelTier)`, `levelTextColor(LevelTier)`

### 1.10 Rating

| Token            | Hex       | Usage              |
|------------------|-----------|--------------------|
| ratingStar       | `#FFC107` | Filled star        |
| ratingStarHalf   | `#FFD54F` | Half star          |
| ratingStarEmpty  | `#E2E8F0` | Empty star outline |

### 1.11 Overlay & Effects

| Token            | Value             | Usage                        |
|------------------|-------------------|------------------------------|
| overlay          | `#000000` 50%     | Modal overlay                |
| overlayLight     | `#000000` 20%     | Subtle dimming               |
| overlayDark      | `#000000` 80%     | Heavy overlay (text on image)|
| scrim            | `#000000` 32%     | Bottom sheet scrim           |
| shimmerBase      | `#E2E8F0`         | Skeleton loading base        |
| shimmerHighlight | `#F8FAFC`         | Skeleton loading shimmer     |
| ripple           | `#2563EB` 10%     | Tap ripple effect            |

### 1.12 Gradients

| Name              | Colors                         | Direction          | Usage                          |
|-------------------|--------------------------------|--------------------|--------------------------------|
| primaryGradient   | `#1D4ED8` → `#60A5FA`         | top-left → btm-right | Hero sections, primary CTAs  |
| energyGradient    | `#F97316` → `#FBBF24`         | left → right         | XP bars, streak indicators   |
| darkOverlay       | `transparent` → `#000000` 80% | top → bottom         | Text-on-image overlays       |
| surfaceGradient   | `#FFFFFF` → `#F1F5F9`         | top → bottom         | Subtle card backgrounds      |

> **Design guideline:** Prefer solid colors over gradients for most UI elements. Gradients are reserved for hero sections, XP bars, and image overlays only. Overusing gradients creates visual noise and hurts readability.

### 1.13 Dark Mode

All tokens in Sections 1.4–1.6 are light-mode defaults. Dark mode overrides are defined below.
The app detects system preference via `MediaQuery.platformBrightnessOf(context)` and allows manual toggle stored in shared preferences.

#### Dark Surfaces

| Token              | Light         | Dark          | Notes                          |
|--------------------|---------------|---------------|--------------------------------|
| background         | `#F8FAFC`     | `#0F172A`     | neutral900                     |
| backgroundPure     | `#FFFFFF`     | `#020617`     | neutral950                     |
| surface            | `#FFFFFF`     | `#1E293B`     | neutral800                     |
| surfaceVariant     | `#F1F5F9`     | `#334155`     | neutral700                     |
| surfaceHighlight   | `#EFF6FF`     | `#1E3A5F`     | Dark primary tint              |
| surfaceSecondary   | `#F0FDFA`     | `#134E4A`     | Dark secondary tint            |
| surfaceAccent      | `#FFF7ED`     | `#431407`     | Dark accent tint               |

#### Dark Text

| Token          | Light         | Dark          |
|----------------|---------------|---------------|
| textPrimary    | `#0F172A`     | `#F1F5F9`     |
| textSecondary  | `#475569`     | `#94A3B8`     |
| textTertiary   | `#94A3B8`     | `#64748B`     |
| textDisabled   | `#CBD5E1`     | `#475569`     |
| textOnDark     | `#FFFFFF`     | `#FFFFFF`     |
| textLink       | `#2563EB`     | `#60A5FA`     |

#### Dark Borders

| Token         | Light         | Dark          |
|---------------|---------------|---------------|
| border        | `#E2E8F0`     | `#334155`     |
| borderLight   | `#F1F5F9`     | `#1E293B`     |
| borderMedium  | `#CBD5E1`     | `#475569`     |
| borderStrong  | `#94A3B8`     | `#64748B`     |
| borderFocused | `#2563EB`     | `#60A5FA`     |
| borderError   | `#EF4444`     | `#F87171`     |
| divider       | `#E2E8F0`     | `#334155`     |

#### Dark Overlays & Shimmer

| Token            | Light             | Dark              |
|------------------|-------------------|-------------------|
| shimmerBase      | `#E2E8F0`         | `#334155`         |
| shimmerHighlight | `#F8FAFC`         | `#475569`         |

> **Brand colors** (primary, secondary, accent) remain the same in dark mode. Semantic colors (success, warning, error) also remain the same. Only surfaces, text, and borders adapt.

---

## 2. TYPOGRAPHY

### 2.1 Font Family
- **Primary:** `Plus Jakarta Sans` (via google_fonts package or bundled asset)
  - Geometric, modern, excellent readability — popular in top-tier app UIs
- **Monospace (optional):** `JetBrains Mono` — for booking codes, prices if needed

### 2.2 Type Scale

| Style          | Size | Weight     | Line Height | Letter Spacing | Usage                                    |
|----------------|------|------------|-------------|----------------|------------------------------------------|
| displayLarge   | 40px | ExtraBold (800) | 1.2     | -0.5           | Splash headlines, hero numbers           |
| displayMedium  | 32px | Bold (700)      | 1.25    | -0.5           | Section heroes                           |
| displaySmall   | 28px | Bold (700)      | 1.3     | -0.5           | Page titles                              |
| headingLarge   | 24px | Bold (700)      | 1.3     | -0.5           | Screen titles                            |
| headingMedium  | 20px | SemiBold (600)  | 1.35    | 0              | Section headers                          |
| headingSmall   | 18px | Bold (700)      | 1.4     | 0              | Card titles, subsections                 |
| titleLarge     | 18px | Medium (500)    | 1.4     | 0              | Dialog titles, prominent labels          |
| titleMedium    | 16px | SemiBold (600)  | 1.45    | 0              | List item titles, bold labels            |
| titleSmall     | 14px | SemiBold (600)  | 1.45    | 0              | Small titles, bold metadata              |
| bodyLarge      | 16px | Regular (400)   | 1.5     | 0              | Primary body text                        |
| bodyMedium     | 14px | Regular (400)   | 1.5     | 0              | Default body text                        |
| bodySmall      | 12px | Regular (400)   | 1.5     | 0              | Secondary descriptions, metadata         |
| labelLarge     | 14px | SemiBold (600)  | 1.4     | 0.5            | Button text, input labels, tabs          |
| labelMedium    | 12px | Medium (500)    | 1.4     | 0.5            | Chip labels, small buttons               |
| labelSmall     | 11px | Medium (500)    | 1.4     | 0.5            | Tiny labels, footnotes                   |
| caption        | 12px | Regular (400)   | 1.4     | 0              | Timestamps, captions                     |
| overline       | 10px | SemiBold (600)  | 1.4     | 1.0            | ALL-CAPS category labels, overlines      |

### 2.3 Special Text Styles

| Style          | Size | Weight          | Usage                                    |
|----------------|------|-----------------|------------------------------------------|
| numberLarge    | 36px | ExtraBold (800) | Dashboard hero numbers, XP total         |
| numberMedium   | 24px | Bold (700)      | Card statistics, scores                  |
| numberSmall    | 16px | Bold (700)      | Inline numbers, counts                   |
| priceLarge     | 24px | Bold (700)      | Primary price display (color: primary)   |
| price          | 18px | Bold (700)      | Standard price (color: primary)          |
| priceSmall     | 14px | SemiBold (600)  | Small price tags (color: primary)        |
| button         | 15px | SemiBold (600)  | Standard button text                     |
| buttonSmall    | 13px | SemiBold (600)  | Compact button text                      |
| badge          | 10px | SemiBold (600)  | Badge labels, status chips               |
| badgeLarge     | 12px | SemiBold (600)  | Larger badge labels                      |

All text styles default to `textPrimary` color (or `textSecondary` for body small/captions).

---

## 3. SPACING & DIMENSIONS

### 3.1 Spacing Scale (Base: 4px)

| Token | Value | Usage                                              |
|-------|-------|----------------------------------------------------|
| xxs   | 2px   | Tight inner gaps, icon-to-text micro spacing       |
| xs    | 4px   | Compact padding, small gaps                        |
| sm    | 8px   | Chip padding, tight list gaps                      |
| md    | 12px  | Standard inner padding, list item gaps             |
| base  | 16px  | Default padding/margins, card padding              |
| lg    | 20px  | Section gaps, comfortable padding                  |
| xl    | 24px  | Screen horizontal padding, section spacing         |
| xxl   | 32px  | Large section separators                           |
| xxxl  | 40px  | Major section breaks                               |
| huge  | 48px  | Top-level separators                               |
| massive | 64px | Hero section padding, splash spacing             |

> **Scale pattern:** Doubling (2→4→8), linear +4 (12→16→20→24), linear +8 (32→40→48), then 64. Intentionally mixed progression — tight control at small sizes, larger jumps where precision matters less.

### 3.2 Screen Padding

| Token                | Value              | Usage                            |
|----------------------|--------------------|----------------------------------|
| screenHorizontal     | 20px (= `lg`)      | Left/right screen margins        |
| screenTop            | 16px               | Below app bar                    |
| screenBottom         | 24px               | Above bottom nav                 |

### 3.3 Border Radius

| Token    | Value | Usage                                             |
|----------|-------|----------------------------------------------------|
| none     | 0px   | No rounding                                        |
| xs       | 4px   | Subtle rounding (tags, small badges)               |
| sm       | 8px   | Buttons, input fields, small cards                 |
| md       | 12px  | Standard cards, dialogs                            |
| lg       | 16px  | Large cards, bottom sheets                         |
| xl       | 20px  | Feature cards, hero elements                       |
| xxl      | 24px  | Large modals, image containers                     |
| full     | 999px | Pills, circles, fully-rounded chips/badges         |

### 3.4 Component Sizes

| Token                 | Value  | Usage                                    |
|-----------------------|--------|------------------------------------------|
| buttonHeightLg        | 56px   | Primary CTA buttons                     |
| buttonHeightMd        | 48px   | Standard buttons                        |
| buttonHeightSm        | 36px   | Compact buttons, filter chips           |
| buttonHeightXs        | 28px   | Tiny action buttons                     |
| inputHeight           | 52px   | Text fields, dropdowns                  |
| appBarHeight          | 56px   | Top app bar                             |
| bottomNavHeight       | 72px   | Bottom navigation bar                   |
| chipHeight            | 32px   | Filter/selection chips                  |
| chipHeightSm          | 24px   | Small inline chips                      |
| avatarXs              | 24px   | Tiny inline avatars                     |
| avatarSm              | 32px   | List item avatars                       |
| avatarMd              | 48px   | Card avatars                            |
| avatarLg              | 64px   | Profile header, detail page             |
| avatarXl              | 96px   | Profile page hero avatar               |
| iconXs                | 16px   | Tiny inline icons                       |
| iconSm                | 20px   | Standard small icons                    |
| iconMd                | 24px   | Default icon size                       |
| iconLg                | 32px   | Feature icons, nav icons               |
| iconXl                | 48px   | Hero/empty state icons                 |
| badgeSize             | 20px   | Notification count badge               |
| badgeDot              | 8px    | Unread dot indicator                   |
| dividerThickness      | 1px    | Standard divider                       |
| strokeWidth           | 1.5px  | Default border/stroke                  |
| strokeWidthThick      | 2px    | Active/focused borders                 |
| cardMinHeight         | 80px   | Minimum card height                    |
| imageAspectVenue      | 16:9   | Venue/court photo ratio                |
| imageAspectAvatar     | 1:1    | Avatar ratio                           |
| maxContentWidth       | 600px  | Content max width (tablet)             |

---

## 4. SHADOWS / ELEVATION

| Token      | Offset      | Blur  | Spread | Color              | Usage                             |
|------------|-------------|-------|--------|--------------------|------------------------------------|
| none       | —           | —     | —      | —                  | Flat elements                     |
| xs         | (0, 1)      | 2px   | 0      | `#0F172A` 5%      | Subtle card lift                  |
| sm         | (0, 1)      | 3px   | 0      | `#0F172A` 10%     | Default cards, list items         |
| md         | (0, 4)      | 6px   | -1px   | `#0F172A` 10%     | Elevated cards, dropdowns         |
| lg         | (0, 10)     | 15px  | -3px   | `#0F172A` 10%     | Modals, floating buttons          |
| xl         | (0, 20)     | 25px  | -5px   | `#0F172A` 10%     | Popovers, toasts                  |
| bottomNav  | (0, -4)     | 12px  | 0      | `#0F172A` 8%      | Bottom navigation bar             |
| button     | (0, 2)      | 4px   | 0      | `#2563EB` 25%     | Primary button glow               |
| colored    | (0, 4)      | 12px  | 0      | `#2563EB` 20%     | Branded elevation (active FAB)    |
| focusRing  | (0, 0)      | 0     | 3px    | `#2563EB` 25%     | Focus ring for accessibility      |

---

## 5. ANIMATION / MOTION TOKENS

| Token          | Duration | Usage                                          |
|----------------|----------|-------------------------------------------------|
| instant        | 100ms    | Micro interactions (checkbox, toggle)          |
| fast           | 200ms    | Button presses, color changes, fades           |
| normal         | 300ms    | Standard transitions, page slides              |
| slow           | 400ms    | Complex animations, drawer open/close          |
| xSlow          | 600ms    | Celebration effects, onboarding transitions    |

| Curve          | Flutter Curve        | Usage                                    |
|----------------|----------------------|------------------------------------------|
| standard       | `easeInOut`          | Default for most transitions             |
| decelerate     | `easeOut`            | Elements entering screen                 |
| accelerate     | `easeIn`             | Elements leaving screen                  |
| sharp          | `easeInOutCubic`     | Emphasized transitions                   |
| bounce         | `bounceOut`          | Celebratory (badge earned, level up)     |
| elastic        | `elasticOut`         | Playful micro-interactions               |

### 5.1 Reduced Motion (Accessibility)

When `MediaQuery.of(context).disableAnimations` is `true` or the platform requests reduced motion:

| Behavior                  | Normal                  | Reduced Motion              |
|---------------------------|-------------------------|-----------------------------|
| Duration                  | As specified            | `Duration.zero` (instant)   |
| Curves (bounce, elastic)  | As specified            | `easeInOut` (no overshoot)  |
| Page transitions          | Slide/fade              | Instant cut or simple fade  |
| Looping animations        | Continuous              | Static frame or single pass |
| Progress indicators       | Animated                | Static or determinate only  |

Implementation: Wrap animated widgets with a `reduceMotion` check and provide a static fallback.

---

## 6. COMPONENT THEMES (applied via ThemeData)

### 6.1 AppBar
- Background: `surface` (white), elevation: 0
- Title: `headingMedium`, `textPrimary`
- Icon color: `textPrimary`
- Surface tint: transparent (no Material 3 tint)
- Bottom border: 1px `borderLight`

### 6.2 Bottom Navigation Bar
- Background: `surface`, shadow: `bottomNav`
- Selected: `primary` icon + label (labelMedium weight)
- Unselected: `neutral400` icon + label
- Height: 72px
- Type: fixed (no shifting)
- Indicator: pill-shaped, color `primary50`

### 6.3 Cards
- Background: `surface`
- Border radius: `md` (12px)
- Border: 1px `border`
- Shadow: `sm`
- Padding: `base` (16px)
- Margin between cards: `md` (12px)

### 6.4 Buttons

**Elevated (Primary CTA)**
- Background: `primary`, text: `textOnPrimary`
- Height: 56px (lg) or 48px (md)
- Radius: `sm` (8px)
- Shadow: `button`
- Pressed: `primary700` bg
- Disabled: `neutral200` bg, `textDisabled` text

**Outlined (Secondary action)**
- Background: transparent, border: 1.5px `primary`
- Text/icon: `primary`
- Height: 48px
- Radius: `sm` (8px)
- Pressed: `primary50` bg
- Disabled: `neutral200` border, `textDisabled` text

**Text Button (Tertiary/link)**
- Background: transparent
- Text: `primary`
- Padding: 12px horizontal
- Pressed: `primary50` bg

**Filled Tonal (Soft action)**
- Background: `primary50`
- Text: `primary700`
- Height: 48px
- Radius: `sm` (8px)
- Pressed: `primary100` bg

**Icon Button**
- Size: 48x48 (touch target)
- Icon: `neutral600`
- Pressed: `neutral100` splash

**Floating Action Button**
- Background: `primary`
- Icon: `textOnPrimary`
- Size: 56px
- Radius: 16px
- Shadow: `colored`

### 6.5 Input Fields
- Background: `surfaceVariant` (or `surface` with border)
- Border: 1.5px `border`, radius `sm` (8px)
- Focused border: 2px `borderFocused`
- Error border: 2px `borderError`
- Label: `labelMedium`, color `textSecondary`
- Hint: `bodyMedium`, color `textDisabled`
- Text: `bodyLarge`, color `textPrimary`
- Content padding: 16px horizontal, 14px vertical
- Height: 52px
- Prefix/suffix icon: `neutral400`
- Focused prefix/suffix icon: `primary`

### 6.6 Chips (Filter, Selection, Sport)
- Height: 32px (standard), 24px (small)
- Radius: `full` (pill)
- Default: bg `surfaceVariant`, border `border`, text `textSecondary`
- Selected: bg `primary50`, border `primary`, text `primary700`
- Padding: 12px horizontal, 6px vertical
- Font: `labelMedium`
- Sport chip: bg from `sportBgColor`, text from `sportTextColor`

### 6.7 Tab Bar
- Background: transparent
- Selected: `primary`, indicator underline 3px
- Unselected: `textTertiary`
- Label: `labelLarge`
- Indicator: rounded pill underline

### 6.8 Dialog
- Background: `surface`
- Radius: `lg` (16px)
- Shadow: `lg`
- Title: `headingSmall`
- Body: `bodyMedium`
- Action buttons: Text button style

### 6.9 Bottom Sheet
- Background: `surface`
- Top radius: `xl` (20px)
- Handle: 36x4px, `neutral300`, centered, radius `full`
- Shadow: `lg`

### 6.10 Snackbar / Toast
- Background: `neutral800`
- Text: `textOnDark`, `bodyMedium`
- Radius: `sm` (8px)
- Action text: `primary300`
- Margin: 16px from edges, 16px from bottom

### 6.11 Switch / Toggle
- Active track: `primary`
- Active thumb: white
- Inactive track: `neutral200`
- Inactive thumb: `neutral400`

### 6.12 Checkbox & Radio
- Active: `primary`
- Inactive border: `borderMedium`
- Check color: white
- Shape: 4px radius (checkbox), circle (radio)

### 6.13 Slider
- Active: `primary`
- Inactive: `neutral200`
- Thumb: `primary`, 20px diameter
- (For coach assessment: 1-10 skill sliders)

### 6.14 Progress Indicator
- Linear: `primary` on `neutral200` track, 4px height, rounded
- Circular: `primary`, 3px stroke
- XP bar special: uses `energyGradient` on `neutral200` track

### 6.15 Badge (notification count)
- Background: `error`
- Text: white, `badge` style
- Size: 20px circle (with count) or 8px dot

### 6.16 Divider
- Color: `divider`
- Thickness: 1px
- Light variant: `dividerLight`

### 6.17 Tooltip
- Background: `neutral800`
- Text: white, `bodySmall`
- Radius: `xs` (4px)

### 6.18 Search Bar
- Background: `surfaceVariant`
- Border: none
- Radius: `full` (pill)
- Icon: `neutral400`
- Hint: `textDisabled`
- Height: 48px

---

## 7. CUSTOM COMPONENT STYLES (Reusable Decorations)

These are not part of ThemeData but are reusable BoxDecoration / style factory methods
for domain-specific components used throughout HyperArena.

### 7.1 Status Badge
- Pill shape (radius: full)
- Padding: 8px H, 4px V
- Background: `bookingStatusBgColor(status)`
- Text: `bookingStatusTextColor(status)`, `badge` style

### 7.2 Sport Badge
- Pill shape (radius: full)
- Background: `sportBgColor(sport)`
- Text/Icon: `sportTextColor(sport)`, `badgeLarge` style
- Optional sport emoji prefix

### 7.3 Level Badge
- Pill shape with subtle shimmer (pro tier)
- Background: `levelBgColor(tier)`
- Icon: tier-specific (bronze circle, silver, gold, platinum, diamond)
- Text: `levelTextColor(tier)`

### 7.4 XP Progress Bar
- Height: 8px (compact) or 12px (featured)
- Track: `neutral200`, radius `full`
- Fill: `energyGradient`, radius `full`, animated width
- Label above: "320 / 600 XP", `labelSmall`

### 7.5 Venue Card
- Radius: `md` (12px)
- Image top (aspect 16:9) with `darkOverlayGradient` at bottom
- Sport badge positioned top-right
- Price tag positioned bottom-right of image
- Content padding: 12px
- Shadow: `sm`

### 7.6 Coach Card
- Radius: `md` (12px)
- Horizontal layout: avatar left (48px) + info right
- Rating stars inline
- Sport chips below name
- "Verified" check icon if verified

### 7.7 Session Card
- Radius: `md` (12px)
- Left accent strip (4px wide, sport color)
- Participant count bar ("7/10 spots") as mini progress
- Organizer mini-avatar bottom-right

### 7.8 Booking Card
- Radius: `md` (12px)
- Status badge top-right
- Left color strip (booking status color)
- Date/time prominent

### 7.9 Glass Effect (subtle)
- Background: white 70% opacity
- Border: 1px white 30%
- Backdrop blur: 10px
- Use sparingly for overlaid elements

### 7.10 Gradient Card
- Uses `primaryGradient`
- Text: white
- Radius: `lg` (16px)
- For featured/promoted items only — use sparingly

### 7.11 QRIS Display Container
- Background: white
- Border: 2px dashed `border`
- Radius: `md` (12px)
- Min-height: 300px
- Supports pinch-to-zoom

### 7.12 Assessment Radar Chart
- Background: `surfaceVariant`
- Grid lines: `borderLight`
- Current assessment fill: `primary` 20% opacity, border `primary`
- Previous assessment fill: `neutral300` 15% opacity, border `neutral400` dashed
- Scale: 0-10
- Axis labels: `labelSmall`, `textSecondary`

### 7.13 Skeleton / Shimmer Loading

Placeholder components shown while content loads. Skeleton shapes match the content they replace.

- Base color: `shimmerBase`
- Highlight color: `shimmerHighlight`
- Animation: shimmer sweep left → right, `normal` (300ms) duration, repeating
- Border radius: match the target element (e.g., `md` for cards, `full` for avatars)
- Respects reduced motion: static base color only when motion disabled

| Skeleton Type     | Height         | Width           | Radius           |
|-------------------|----------------|-----------------|------------------|
| Text line         | 12px           | 60%–100% random | `xs` (4px)       |
| Title line        | 16px           | 40%–70% random  | `xs` (4px)       |
| Avatar circle     | avatar token   | avatar token    | `full`           |
| Card              | `cardMinHeight`| 100%            | `md` (12px)      |
| Image             | aspect ratio   | 100%            | `md` (12px)      |
| Button            | button height  | 120px           | `sm` (8px)       |
| Badge             | 20px           | 60px            | `full`           |

---

## 8. THEME EXTENSIONS

Custom `ThemeExtension` classes so domain-specific colors/styles can be accessed
via `Theme.of(context).extension<T>()`. This is Flutter's official approach for
custom theme properties.

All extensions must implement `copyWith()` and `lerp()` for animated theme transitions between light/dark.

### 8.1 SportThemeExtension
Provides quick access to sport colors via type-safe enum.
Uses `Sport` enum: `tennis`, `padel`, `badminton`, `futsal`, `basketball`, `volleyball`, `tableTennis`.
- `color(Sport sport)` → foreground
- `backgroundColor(Sport sport)` → tint
- `textColor(Sport sport)` → text on tint

### 8.2 BookingStatusThemeExtension
Status-based styling for booking cards/badges.
Uses `BookingStatus` enum: `pendingPayment`, `waitingConfirmation`, `confirmed`, `rejected`, `cancelled`, `completed`, `expired`.
- `color(BookingStatus status)` → badge foreground
- `backgroundColor(BookingStatus status)` → badge background
- `textColor(BookingStatus status)` → label

### 8.3 GamificationThemeExtension
XP, level, and badge styling.
Uses `LevelTier` enum: `rookie`, `amateur`, `intermediate`, `advanced`, `pro`.
- `levelColor(LevelTier tier)` → tier foreground
- `levelBackgroundColor(LevelTier tier)` → tier tint
- `xpBarGradient` → energy gradient
- `badgeEarnedDecoration` → gold border glow
- `badgeLockedDecoration` → grayscale, 50% opacity

### 8.4 RatingThemeExtension
Star rating styling for coaches and venues.
- `starColor` → filled star color (`ratingStar`)
- `halfStarColor` → half-filled star color (`ratingStarHalf`)
- `emptyStarColor` → empty star outline color (`ratingStarEmpty`)

---

## 9. FILE STRUCTURE

When implemented, the design system will live in:

```
hyperarena/lib/core/theme/
├── app_colors.dart              # Brand, neutral, semantic colors (Sections 1.1–1.6)
├── app_domain_colors.dart       # Sport, booking, level, rating colors (Sections 1.7–1.10)
├── app_surfaces.dart            # Surface, overlay, gradient tokens (Sections 1.4, 1.11–1.13)
├── app_typography.dart           # Font family, type scale, special styles (Section 2)
├── app_dimensions.dart           # Spacing, radius, component sizes (Section 3)
├── app_shadows.dart              # Shadow/elevation tokens (Section 4)
├── app_animations.dart           # Duration and curve tokens (Section 5)
├── app_theme.dart                # Light ThemeData builder with all component themes (Section 6)
├── app_theme_dark.dart           # Dark ThemeData builder (Section 1.13 + Section 6)
├── app_component_styles.dart     # Reusable decoration factories (Section 7)
├── app_enums.dart                # Sport, BookingStatus, LevelTier enums
├── app_theme_extensions.dart     # Custom ThemeExtension classes (Section 8)
└── theme.dart                    # Barrel export file
```

---

## 10. USAGE EXAMPLES (Preview)

```dart
// Access colors
Container(color: AppColors.primary)
Container(color: AppColors.sportColor(Sport.tennis))

// Access typography
Text('Hello', style: AppTypography.headingLarge)
Text('Rp 150.000', style: AppTypography.price)

// Access dimensions
Padding(padding: EdgeInsets.all(AppDimensions.base))
BorderRadius.circular(AppDimensions.radiusMd)

// Access shadows
Container(decoration: BoxDecoration(boxShadow: AppShadows.sm))

// Access theme extensions
final sportTheme = Theme.of(context).extension<SportThemeExtension>()!;
final color = sportTheme.color(Sport.tennis);

// Reusable component decorations
Container(decoration: AppComponentStyles.statusBadge(BookingStatus.confirmed))
Container(decoration: AppComponentStyles.venueCard())
```

---

## 11. ACCESSIBILITY

### 11.1 Touch Targets
- Minimum touch target: **48×48px** (Material Design guideline)
- All interactive elements (buttons, icons, chips) must meet this minimum
- Spacing between adjacent touch targets: minimum `sm` (8px)

### 11.2 Color Contrast (WCAG AA)
- Normal text (< 18px): minimum **4.5:1** contrast ratio
- Large text (≥ 18px bold or ≥ 24px regular): minimum **3:1** contrast ratio
- UI components and graphical objects: minimum **3:1** contrast ratio
- Decorative elements (sport colors, tier badges) are exempt but should aim for 3:1

### 11.3 Font Scaling
- All text must respect `MediaQuery.textScaleFactorOf(context)`
- Layout must not break at **200%** system font scale
- Minimum font size: 11px at 1.0x scale (see `overline`)
- Test at 1.0x, 1.3x, 1.5x, and 2.0x scale factors
- Use `maxLines` + `overflow: TextOverflow.ellipsis` for constrained areas

### 11.4 Screen Reader Support
- All images: provide `semanticsLabel`
- Icon buttons: provide `tooltip` or `Semantics` label
- Decorative elements: mark with `excludeFromSemantics: true`
- Status badges: announce status text, not just color
- Custom widgets: wrap with `Semantics` providing `label`, `value`, `hint`

### 11.5 Focus & Navigation
- Focus ring: `focusRing` shadow token (3px spread, primary 25% opacity)
- Tab order: logical reading order, top-to-bottom, left-to-right
- Focus indicators must be visible on both light and dark themes

---

## 12. INTERNATIONALIZATION

HyperArena supports **Indonesian (id)** as the primary locale and **English (en)** as secondary.

### 12.1 Text Expansion
Indonesian and English have different average word lengths. Design layouts that accommodate text expansion:

| Language    | Avg. expansion vs English | Example                              |
|-------------|---------------------------|--------------------------------------|
| Indonesian  | +20% to +35%              | "Booking" → "Pemesanan"             |
| English     | Baseline                  | —                                    |

**Rules:**
- Buttons: use flexible width (min-width, not fixed width)
- Labels and headers: allow 2 lines or use `TextOverflow.ellipsis`
- Tab labels: keep short (1-2 words) in both languages
- Toast/snackbar: test with longest Indonesian string

### 12.2 Layout Direction
Both Indonesian and English use **LTR** (left-to-right). No RTL layout adjustments needed.

### 12.3 Number & Currency Formatting
- Currency: Indonesian Rupiah (`Rp`) — use `NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ')`
- No decimal places for Rupiah (e.g., `Rp 150.000` not `Rp 150.000,00`)
- Thousand separator: period (Indonesian) or comma (English) — follow active locale
- Date format: `dd MMM yyyy` (e.g., `07 Feb 2026`) — universal for both locales
- Time format: 24-hour (`HH:mm`) as default, with 12-hour option

### 12.4 Font Considerations
- Plus Jakarta Sans supports full Latin Extended for Indonesian characters
- No special character set needed beyond standard Latin
- Test with Indonesian long words: "Pertandingan", "Ketersediaan", "Pembayaran"

---

*Review this document. When approved, all sections will be implemented as Dart files.*
