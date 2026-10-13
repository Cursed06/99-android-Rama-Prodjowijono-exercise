# PRD — 99.co Mobile Exercise (Search Results + Listing Detail)

## 1. Purpose
A take-home interview exercise for an internship at 99.co. Build **two screens** that show property listings fetched from a REST endpoint. This is **not** a full app: no login, search input, filters, favourites, or tabs.

**Success criteria (from the README):**
1. Follows the Figma design as closely as possible.
2. Runnable project; an installable APK is delivered.
3. MVVM pattern.
4. Async work handled with async/await.
5. *(Bonus)* Dependency injection.
6. *(Bonus)* Unit tests.
7. Where something isn't finished, a code comment explains the intent.

> **Stack decision:** Flutter (Dart). The README's "Getting Started" explicitly allows a Flutter project, even though requirement #2 mentions Kotlin/Swift. The README's MVVM, async and DI requirements are mapped to their Flutter equivalents in `Architecture.md`. If the interviewers insist on Kotlin/Swift, the architecture ports 1:1 (ViewModel → ViewModel, `Future` → coroutine).

---

## 2. Screens

### 2.1 Search Result Page (home screen)
Title bar: centered **"Search Results"**, white background, thin bottom divider.

Body: vertically scrolling list of listing cards.

**Card contents (top to bottom):**
| Element | Source field | Format |
|---|---|---|
| Photo (rounded corners, ~16:9) | `photo` | network image with placeholder + 40% black bottom gradient |
| Project name (bold, navy) | `project_name` | `16px`, Demi Bold (w600), line height 16px |
| Address (small, muted) | `address.street_name` + `address.district` | `12 Meyappa Chettiar Rd · D13` (`12px`, w500) |
| Meta line (small, muted) | `category`, `completed_at`, `tenure` | `Condo · 2020 · 99 yrs` (`12px`, w500) |
| Stats | `attributes.bedrooms/bathrooms/area_size` | `3 Beds · 2 Baths · 2,561 sqft` (`14px`, w400) |
| Price (bold) | `attributes.price` | `$2,561/mo` (`16px`, w700 Bold) |

Card: white, 4px radius, soft drop shadow, 8px gap between cards.

**Behaviour**
- On open: show a loading indicator, fetch listings.
- Success: render list. Tapping a card pushes the Detail page, passing the listing `id`.
- Empty list: friendly empty state.
- Error (no network, bad JSON, non-200): error message + **Retry** button.
- Pull-to-refresh (`RefreshIndicator`).
- Singular/plural: `1 Bed`, `2 Beds`, `1 Bath`, `2 Baths`.

### 2.2 Listing Detail Page
Opened from a card. Fetches `details/{id}.json`.

**Layout (top to bottom):**
1. **Hero photo** full-width (~280px tall), with top and bottom 50% opacity linear gradients (`heroOverlay`) and a **back chevron** overlaid at top-left within `SafeArea`.
2. **Price** — large, bold navy (`priceLarge`: `23px`, w700 Bold, line height 23px).
3. **Project name** — semibold navy (`titleLarge`: `19px`, w600 Demi Bold, line height 19px).
4. **Address block** — `address.title` and `address.subtitle` (`detailAddress`: `14px`, w400 Regular, line height 14px, muted).
5. **"View on map"** — blue text with pin icon (`link`: `14px`, w600 Demi Bold). Opens the device maps app at `address.map_coordinates` (lat/lng).
6. **Quick stats row** — badges for beds, baths, sqft (`detailStat`: `16px`, w400 Regular, line height 16px).
7. Divider.
8. **"Property details"** heading (`sectionHeading`: `19px`, w600), followed by the **9 standardized specification rows**:
   - `Price/sqft` (calculated: `price / area_size` $\rightarrow$ `$1.00 psf`)
   - `Floor level` (API `Floor Level` value $\rightarrow$ `Mid`)
   - `Furnishing` (`Unavailable`)
   - `Facing` (API `Facing` value $\rightarrow$ `North`)
   - `Overlooking View` (`Unavailable`)
   - `Built year (TOP)` (API `Built year` value $\rightarrow$ `2004`)
   - `Tenure` (API `Tenure` value $\rightarrow$ `99-year leasehold`)
   - `Property type` (derived from listing title $\rightarrow$ `Condo`)
   - `Last updated` (API `Last updated` value $\rightarrow$ `seconds ago`)
   Labels: `16px`, w500 Medium, line height 16px, navy. Values: `16px`, w400 Regular, line height 16px, navy. Proportions: equal 50/50 flex split.
9. Divider.
10. **"Description"** heading + body text (`body`: `16px`, w400 Regular, line height 28px). Clamped to 5 lines when collapsed with an expandable "Read more / Show less" toggle.

**Behaviour**
- Loading state while fetching; error state with Retry.
- Back chevron pops to the list (list state/scroll position preserved).
- "View on map" failure (no maps app) → floating SnackBar, no crash.

---

## 3. Data contracts

### 3.1 `GET /listings.json` → array
```json
{
  "address": { "district": "D13", "street_name": "12 Meyappa Chettiar Rd" },
  "attributes": { "area_size": 2561, "bathrooms": 2, "bedrooms": 3, "price": 2561 },
  "category": "Condo",
  "completed_at": "2020",
  "id": 0,
  "photo": "https://picsum.photos/id/10/450/300",
  "project_name": "Parkview Apartments",
  "tenure": 99
}
```
Base URL: `https://ninetyninedotco-b7299.asia-southeast1.firebasedatabase.app`

### 3.2 `GET /details/{id}.json` → object
```json
{
  "address": {
    "map_coordinates": { "lat": 1.3884286902614, "lng": 103.87432292478 },
    "subtitle": "Telok Blangah / Harbourfront (D4)",
    "title": "1 Keppel Bay View · Condo for Rent"
  },
  "attributes": { "area_size": 2561, "bathrooms": 2, "bedrooms": 3, "price": 2561 },
  "description": "Sit back and enjoy panorama views...",
  "id": 0,
  "photo": "https://picsum.photos/id/10/450/300",
  "project_name": "Parkview Apartments",
  "property_details": [
    { "label": "Price/sqft", "text": "$1,420 psf" },
    { "label": "Floor Level", "text": "Mid" },
    { "label": "No. of bedrooms", "text": "3" },
    { "label": "Facing", "text": "North" },
    { "label": "Built year", "text": "2004" },
    { "label": "Tenure", "text": "99-year leasehold" },
    { "label": "Property type", "text": "HDB 5 Rooms" },
    { "label": "Last updated", "text": "seconds ago" }
  ]
}
```

### 3.3 Data Handling & Specification Rules
- **Price/sqft Calculation:** Calculated dynamically in code via `attributes.price / attributes.area_size`. For monthly rental listings, yields `$1.00 psf` (for 2561/2561) rather than the static `$1,420 psf` mock value.
- **Property Type Derivation:** Extracted dynamically from `address.title` (e.g. `"1 Keppel Bay View · Condo for Rent"` $\rightarrow$ `"Condo"`), ensuring accuracy over mismatched mock labels like `"HDB 5 Rooms"`.
- **Standardized Specification Order:** Guarantees the 9 rows specified in the Figma design, gracefully falling back to `'Unavailable'` for attributes not present in the backend.

---

## 4. Non-functional requirements
- **Runnable:** `flutter pub get && flutter run` works cleanly; release APK ready via `flutter build apk --release`.
- **Responsive:** works from 360px to tablet widths without overflow.
- **Resilience:** no unhandled exceptions; 10s network timeout.
- **Readability:** clean layered architecture, clear naming, and comments explaining intent.
- **Git:** meaningful commit history tracking each milestone and design alignment step.

---

## 5. Acceptance checklist
- [x] List loads from live endpoint and matches the card design
- [x] Tapping a card opens detail for that id
- [x] Detail renders all sections incl. 9 standardized property rows with calculations
- [x] "View on map" opens maps at correct coordinates with `if (context.mounted)` safety
- [x] Loading, error + retry, and empty states exist on both screens
- [x] MVVM separation: widgets contain no networking or parsing
- [x] DI used for repository/service via `get_it`
- [x] 51 automated unit, widget, and integration tests passing
- [x] README and architectural documentation complete
- [ ] Release APK built (pending user instruction)
