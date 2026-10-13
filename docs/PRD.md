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

## 2. Screens

### 2.1 Search Result Page (home screen)
Title bar: centered **"Search Results"**, white background, thin bottom divider.

Body: vertically scrolling list of listing cards.

**Card contents (top to bottom):**
| Element | Source field | Format |
|---|---|---|
| Photo (rounded corners, ~16:9) | `photo` | network image with placeholder + error state |
| Project name (bold, navy) | `project_name` | as is |
| Address (small, muted) | `address.street_name` + `address.district` | `12 Meyappa Chettiar Rd · D13` |
| Meta line (small, muted) | `category`, `completed_at`, `tenure` | `Condo · 2020 · 99 yrs` |
| Stats | `attributes.bedrooms/bathrooms/area_size` | `3 Beds · 2 Baths · 2,561 sqft` |
| Price (bold) | `attributes.price` | `$2,561/mo` (thousands separator) |

Card: white, ~12px radius, soft shadow, 16px gap between cards.

**Behaviour**
- On open: show a loading indicator, fetch listings.
- Success: render list. Tapping a card pushes the Detail page, passing the listing `id`.
- Empty list: friendly empty state.
- Error (no network, bad JSON, non-200): error message + **Retry** button.
- Pull-to-refresh (nice to have).
- Singular/plural: `1 Bed`, `2 Beds`, `1 Bath`, `2 Baths`.

### 2.2 Listing Detail Page
Opened from a card. Fetches `details/{id}.json`.

**Layout (top to bottom):**
1. **Hero photo** full-width (~280px tall), with a **back chevron** overlaid at top-left (white, over a subtle dark gradient for legibility). Content scrolls; image may scroll with it.
2. **Price** — large, bold navy, e.g. `$2,561`.
3. **Project name** — semibold navy.
4. **Address block** — `address.title` (e.g. "1 Keppel Bay View · Condo for Rent") and `address.subtitle` (e.g. "Telok Blangah / Harbourfront (D4)"), muted.
5. **"View on map"** — blue text with pin icon. Opens the device maps app at `address.map_coordinates` (lat/lng).
6. **Stats row** — icon + text: `3 Beds`, `2 Baths`, `2,561 sqft`.
7. Divider.
8. **"Property details"** heading, then a two-column list rendered **dynamically** from `property_details[]` (`label` left, `text` right). Do not hardcode rows; the API decides which rows exist.
9. Divider.
10. **"Description"** heading + body text. Design shows it truncated with an ellipsis (`…`); implement as 5-line clamp with an expandable "Read more / Show less" toggle (nice to have; plain clamp is acceptable).

**Behaviour**
- Loading state while fetching; error state with Retry.
- Back chevron pops to the list (list state/scroll position preserved).
- "View on map" failure (no maps app) → SnackBar, no crash.

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
    { "label": "Floor Level", "text": "Mid" }
  ]
}
```
Only `details/0.json` is documented. For other ids the endpoint may return `null` (Firebase returns HTTP 200 with body `null` for missing nodes) → treat as "Listing not found" error state.

### 3.3 Known data quirks (handle, don't "fix")
- Sample `price` equals `area_size` (2561) — use the API value as-is; the Figma shows `$5,700` as placeholder copy.
- Figma shows "Floor level: High (40 total)" and "Built year (TOP)"; the API returns different labels/values. **API wins; render what it returns.**
- Figma Search card says "Exec Condo"; API `category` is "Condo"/"Apartment". Render the API value.
- Treat every field defensively: `completed_at` is a **string**, `tenure` an int, numbers may arrive as int or double.

## 4. Non-functional requirements
- **Runnable:** `flutter pub get && flutter run` works on a clean machine; release APK via `flutter build apk --release`.
- **Responsive:** works from 360px to tablet widths without overflow.
- **Resilience:** no unhandled exceptions; 10s network timeout.
- **Readability:** small files, clear names, comments where intent isn't obvious (the interviewers read the code).
- **Git:** frequent commits with meaningful messages (they look at the history).

## 5. Out of scope
Search/filter, pagination, auth, favourites, maps embedded in-app, offline caching, localization, dark mode. (Mention them in the README as "what I'd do next".)

## 6. Milestones
1. Project scaffold + theme + folder structure
2. Models + remote data source + repository (with unit tests)
3. Search Results screen (ViewModel + UI)
4. Listing Detail screen (ViewModel + UI)
5. Navigation, error/loading/empty states, polish against Figma
6. DI wiring, remaining tests, README, APK

## 7. Acceptance checklist
- [ ] List loads from live endpoint and matches the card design
- [ ] Tapping a card opens detail for that id
- [ ] Detail renders all sections incl. dynamic property rows
- [ ] "View on map" opens maps at correct coordinates
- [ ] Loading, error + retry, and empty states exist on both screens
- [ ] MVVM separation: widgets contain no networking or parsing
- [ ] DI used for repository/service
- [ ] Unit tests: parsing, repository, both ViewModels
- [ ] README has setup + design decisions + "what I'd do next"
- [ ] APK built
