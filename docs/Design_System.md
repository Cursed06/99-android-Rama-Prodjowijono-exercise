# Design System — 99.co Mobile Exercise

**Figma source:** https://www.figma.com/file/4ms9vSCpUcHRqqLTaVcbYY/Mobile-Team-Home-Assignment?node-id=0%3A1&mode=dev

> ⚠️ Token values below were **estimated from the exported screenshots** (375px-wide frames). Before finalizing, open the Figma file in Dev Mode (or use the Figma MCP in Antigravity) and replace any value that differs. All tokens live in **one place** in code (`lib/core/theme/`), so corrections are a one-file change.

## 1. Foundations

### Colors
| Token | Hex (est.) | Usage |
|---|---|---|
| `primary` / `textPrimary` | `#1A2258` | Titles, price, headings, property labels (deep navy) |
| `textSecondary` | `#787D9C` | Address, "Condo · 2020 · 99 yrs" meta line (muted lavender-grey) |
| `textBody` | `#1A2258` | Stats text, property values, description |
| `accent` | `#216BFF` | "View on map" text + pin icon (link blue) |
| `surface` | `#FFFFFF` | Cards, detail page background, app bar |
| `background` | `#FFFFFF` | Search page background behind cards, detail page bottom strip |
| `divider` | `#DDDEE6` | App bar bottom border, section dividers |
| `shadow` | `#0B1134` @ 15% | Card elevation |
| `overlayScrim` | `#000000` @ 35% → 0% | Gradient behind the back chevron on hero image |
| `error` | `#D32F2F` | Error messages |

### Typography
Font: **Avenir Next** (primary design spec). Uses `'Avenir Next'` (native on iOS/macOS) with fallback to `['Nunito Sans', 'sans-serif']` on platforms where Avenir Next is not pre-installed.

| Token | Size / Weight / Line height | Used for |
|---|---|---|
| `screenTitle` | 16 / 600 / 24 | "Search Results" (centered) |
| `priceLarge` | 26 / 700 / 32 | Detail page price |
| `titleLarge` | 18 / 600 / 24 | Detail project name |
| `sectionHeading` | 17 / 600 / 24 | "Property details", "Description" |
| `cardTitle` | 16 / 700 / 22 | Card project name |
| `cardPrice` | 16 / 700 / 22 | Card `$x/mo` |
| `body` | 14 / 400 / 24 | Description paragraph (airy line height) |
| `bodyStrong` | 14 / 600 / 20 | Property detail labels |
| `caption` | 12 / 400 / 18 | Card address & meta line |
| `stat` | 14 / 400 / 20 | Beds/Baths/sqft |
| `link` | 14 / 600 / 20 | "View on map" |

### Spacing (4-pt scale)
`xs=4  sm=8  md=12  lg=16  xl=24  xxl=32`
- Screen horizontal padding: **16** (detail page), **12** around cards on list.
- Gap between cards: **16**.
- Inside card: padding **12** around photo; **12** between text rows.
- Section vertical padding on detail: **16–24**.

### Radius & elevation
| Token | Value |
|---|---|
| `radiusCard` | 12 |
| `radiusImage` (card photo) | 8 |
| Card elevation | blur 12, offset (0,2), 8% black |
| Hero image | no radius (full-bleed) |

### Iconography
Use `Icons.*` from Material (rounded variants) or `lucide_icons`:
- Back: `chevron_left`, white, 28px
- Map pin: `location_on`, accent blue, 16px
- Beds: `bed_outlined`, 18px, textSecondary
- Baths: `bathtub_outlined`, 18px
- Area: dashed-square → `crop_square` (or a custom `CustomPaint` dashed rect if time allows)

## 2. Components

### 2.1 `ListingCard` (Search Results)
```
┌───────────────────────────────┐  radius 12, white, shadow
│ ┌───────────────────────────┐ │
│ │        PHOTO  (16:9)      │ │  radius 8, BoxFit.cover
│ └───────────────────────────┘ │
│ Parkview Apartments           │  cardTitle / primary
│ 12 Meyappa Chettiar Rd · D13  │  caption / textSecondary
│ Condo · 2020 · 99 yrs         │  caption / textSecondary
│                               │
│ 3 Beds · 2 Baths · 2,561 sqft │  stat / textBody   (separator "·" with spaces)
│                               │
│ $2,561/mo                     │  cardPrice / primary
└───────────────────────────────┘
```
States: pressed (ripple/slight scale), image loading (grey shimmer/placeholder), image error (grey box + broken-image icon).

### 2.2 `AppTopBar` (Search Results)
Height 56 + status bar. White. Centered title `screenTitle`. 1px bottom `divider`. No back button.

### 2.3 `DetailHero`
Full-width image, height ≈ 280. Back button: circular tap target 44×44, chevron white, over `overlayScrim` gradient at top. Respect the status-bar safe area.

### 2.4 `PriceHeader` block (Detail)
```
$2,561                     priceLarge / primary
Parkview Apartments        titleLarge / primary
1 Keppel Bay View · ...    body-small 14 / textSecondary-dark
Telok Blangah / ... (D4)   same
📍 View on map             link / accent
🛏 3 Beds  🛁 2 Baths  ⬚ 2,561 sqft   (Row, 16px gap between groups)
```

### 2.5 `SectionDivider`
1px `divider`, full-width within padding.

### 2.6 `PropertyDetailRow`
Two columns: label (`bodyStrong`, primary) takes ~40% width; value (`body` 14, textBody) fills rest. Row vertical padding 8–10. Rows are generated from `property_details[]`.

### 2.7 `ExpandableDescription`
Heading `sectionHeading`; text `body`, `maxLines: 5`, `TextOverflow.ellipsis`; toggle "Read more / Show less" in `accent`.

### 2.8 Feedback states
- `LoadingView`: centered `CircularProgressIndicator` in `accent`.
- `ErrorView`: icon + message (`body`, textSecondary) + `FilledButton("Retry")` in primary.
- `EmptyView`: icon + "No listings found".

## 3. Layout rules
- Max content width on tablets: 600, centered.
- Use `SafeArea`, but let hero image extend under the status bar (`extendBodyBehindAppBar`).
- Never hardcode pixel sizes in widgets; reference tokens (`AppSpacing.lg`, `AppTextStyles.cardTitle`).
- Text must tolerate 1.3× system font scaling without overflow (use `Flexible`/`Wrap` in stat rows).

## 4. Formatting rules (shared helpers in `core/utils/formatters.dart`)
| Input | Output |
|---|---|
| `2561` price (card) | `$2,561/mo` |
| `2561` price (detail) | `$2,561` |
| `2561` area | `2,561 sqft` |
| bedrooms `1` / `3` | `1 Bed` / `3 Beds` |
| bathrooms `1` / `2` | `1 Bath` / `2 Baths` |
| tenure `99` | `99 yrs` |
| street + district | `12 Meyappa Chettiar Rd · D13` |

Use `intl` `NumberFormat.decimalPattern()` for thousands separators.

## 5. Flutter theme skeleton
```dart
// lib/core/theme/app_colors.dart
class AppColors {
  static const primary = Color(0xFF1B1B5E);
  static const textSecondary = Color(0xFF8A8CA8);
  static const textBody = Color(0xFF2B2D5A);
  static const accent = Color(0xFF2F6BF2);
  static const surface = Colors.white;
  static const background = Color(0xFFF4F4F7);
  static const divider = Color(0xFFE8E8EF);
  static const error = Color(0xFFD32F2F);
}
```
`AppTheme.light` builds a `ThemeData` using these (Material 3, `scaffoldBackgroundColor: background`, `GoogleFonts.nunitoSansTextTheme`). Widgets read colours from `AppColors` / `Theme.of(context)` — never raw hex.

## 6. Design QA checklist
- [ ] Overlay screenshot at 375×812 and compare card spacing to Figma
- [ ] Fonts/weights match
- [ ] Muted vs. navy text colours correct on both screens
- [ ] Shadow is subtle, not Material default heavy
- [ ] Back chevron legible on bright photos
- [ ] No overflow at 320px width or large font scale
