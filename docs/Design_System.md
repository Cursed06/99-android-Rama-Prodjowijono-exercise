# Design System — 99.co Mobile Exercise

**Figma source:** https://www.figma.com/file/4ms9vSCpUcHRqqLTaVcbYY/Mobile-Team-Home-Assignment?node-id=0%3A1&mode=dev

> ℹ️ All typography tokens and visual values below have been **verified against Figma Dev Mode specifications**. Tokens live in centralized theme files (`lib/core/theme/`), ensuring maintainability and global consistency.

---

## 1. Foundations

### Colors
| Token | Hex / Value | Usage |
|---|---|---|
| `primary` | `#1A2258` | Headings, primary titles, prices, specification labels & values (deep navy) |
| `textSecondary` | `#787D9C` | Address lines, districts, card metadata subtitles (muted lavender-grey) |
| `textBody` | `#1A2258` | Description paragraphs, card stats |
| `accent` | `#216BFF` | "View on map" text + pin icon, interactive links, loaders (vibrant blue) |
| `surface` | `#FFFFFF` | Cards, detail page background, top bar surfaces |
| `background` | `#F4F4F7` | Subtle off-white background behind listing cards |
| `divider` | `#DDDEE6` | App bar bottom border, section dividers |
| `shadow` | `0x260B1134` (15%) | Card drop-shadow |
| `overlayScrim` | `0x59000000` (35%) | Legacy scrim token |
| `photoOverlay` | `0x66000000` (40%) | Bottom linear gradient overlay on listing card photo |
| `heroOverlay` | `0x80000000` (50%) | Top and bottom linear gradient overlays on detail hero photo |
| `error` | `#D32F2F` | Error messages and retry triggers |

---

### Typography (Avenir Next Family)
Font: **Avenir Next** (primary design specification) with fallback to `['Nunito Sans', 'sans-serif']` for cross-platform reliability.

The design incorporates **4 distinct font types/weights** of the `Avenir Next` family:

| Token | Size | Line Height | Weight Variant | Flutter `FontWeight` | Applied Elements in UI |
|---|---|---|---|---|---|
| `screenTitle` | `16px` | `16px` (`100%`) | Demi Bold | `FontWeight.w600` | "Search Results" app bar title |
| `cardTitle` | `16px` | `16px` (`100%`) | Demi Bold | `FontWeight.w600` | Project title on search cards |
| `caption` | `12px` | `12px` (`100%`) | Medium | `FontWeight.w500` | Card address & meta lines (`Condo · 2020 · 99 yrs`) |
| `stat` | `14px` | `14px` (`100%`) | Regular | `FontWeight.w400` | Card stats summary (`3 Beds · 2 Baths · 2,561 sqft`) |
| `cardPrice` | `16px` | `16px` (`100%`) | Bold | `FontWeight.w700` | Card price tag (`$2,561/mo`) |
| `priceLarge` | `23px` | `23px` (`100%`) | Bold | `FontWeight.w700` | Detail price header (`$2,561`) |
| `titleLarge` | `19px` | `19px` (`100%`) | Demi Bold | `FontWeight.w600` | Detail project name (`Parkview Apartments`) |
| `detailAddress` | `14px` | `14px` (`100%`) | Regular | `FontWeight.w400` | Detail address title & subtitle (`Telok Blangah...`) |
| `detailStat` | `16px` | `16px` (`100%`) | Regular | `FontWeight.w400` | Detail quick stats badges (`3 Beds`, `2 Baths`, `2,561 sqft`) |
| `link` | `14px` | `14px` (`100%`) | Demi Bold | `FontWeight.w600` | "View on map", "Read more" / "Show less" links |
| `sectionHeading` | `19px` | `19px` (`100%`) | Demi Bold | `FontWeight.w600` | "Property details", "Description" headings |
| `propertyDetailLabel` | `16px` | `16px` (`100%`) | Medium | `FontWeight.w500` | Property detail specification labels |
| `propertyDetailValue` | `16px` | `16px` (`100%`) | Regular | `FontWeight.w400` | Property detail specification values |
| `body` | `16px` | `28px` | Regular | `FontWeight.w400` | Description paragraphs |

---

### Spacing (4-pt scale)
`xxs=2  xs=4  sm=8  md=12  lg=16  xl=24  xxl=32`
- Screen horizontal padding: **16** (detail page), **12** around cards on list.
- Gap between cards: **8**.
- Inside card padding: **12** around photo and text blocks.
- Section vertical padding on detail: **16–24**.
- Detail hero image default height: **280px**.
- Tablet layout constraint: max content width **600px** centered.

---

### Radius & Elevation
| Token | Value |
|---|---|
| `radiusCard` | 4px (refined card corner radius) |
| `radiusImage` | 4px (card preview image radius) |
| `shadow` | blur 16, offset (0, 4), 15% `#0B1134` |
| Hero image | Full-bleed with 0px radius |

---

### Iconography
- Back navigation: `Icons.chevron_left_rounded`, white, 28px
- Map pin: `Icons.location_on_rounded`, accent blue, 16px
- Beds: `Icons.bed_outlined`, 16px, textSecondary
- Baths: `Icons.bathtub_outlined`, 16px, textSecondary
- Area: `Icons.square_foot_rounded`, 16px, textSecondary

---

## 2. Components

### 2.1 `ListingCard` (Search Results)
- 16:9 cached preview photograph with shimmering loader and broken-image placeholder.
- Bottom linear gradient overlay (`height: 60`, `AppColors.photoOverlay` 40% black).
- Navy bold card title, subtitle address with middot, meta line, stats summary, and `$x/mo` bold price tag.
- Subtle elevation shadow (`blurRadius: 16`, `offset: (0, 4)`).

### 2.2 `DetailHero` (Listing Detail)
- Full-bleed 280px hero photograph connected via `Hero(tag: 'listing-photo-$listingId')`.
- Top linear gradient overlay (`height: 90`, `AppColors.heroOverlay` 50% black $\rightarrow$ transparent).
- Bottom linear gradient overlay (`height: 90`, `AppColors.heroOverlay` 50% black $\rightarrow$ transparent).
- Overlaid back chevron within `SafeArea` with circular 44×44 tap target.

### 2.3 `PriceHeader` (Listing Detail)
- Prominent price header (`priceLarge`, 23px/700).
- Project title (`titleLarge`, 19px/600).
- Dual address subtitle lines (`detailAddress`, 14px/400).
- "View on map" interactive link (`link`, 14px/600) with pin icon.
- Quick stats row (`detailStat`, 16px/400) wrapped to prevent overflow under accessibility font scaling.

### 2.4 `PropertyDetailsSection`
Standardizes the display of **9 key property specifications** in the exact order requested:
1. **Price/sqft**: Calculated via `price / area_size` (`$1.00 psf`).
2. **Floor level**: API `Floor Level` value (`Mid`).
3. **Furnishing**: Design specification (`Unavailable`).
4. **Facing**: API `Facing` value (`North`).
5. **Overlooking View**: Design specification (`Unavailable`).
6. **Built year (TOP)**: API `Built year` value (`2004`).
7. **Tenure**: API `Tenure` value (`99-year leasehold`).
8. **Property type**: Derived from listing title (`Condo`).
9. **Last updated**: API `Last updated` value (`seconds ago`).
- Equal 50/50 flex split (`flex: 6` each) with `AppSpacing.md` horizontal gap.
- Typography: Label `16px/500/16` (`AppColors.primary`), Value `16px/400/16` (`AppColors.primary`).

### 2.5 `ExpandableDescription`
- Section heading (`sectionHeading`, 19px/600).
- Clamped body paragraph (`body`, 16px/400, line height 28px) clamped to 5 lines when collapsed.
- "Read more / Show less" toggle action in `AppColors.accent`.

---

## 3. Formatting Rules (`core/utils/formatters.dart`)
| Input | Output Method | Sample Output |
|---|---|---|
| `2561` price (card) | `formatCardPrice` | `$2,561/mo` |
| `2561` price (detail) | `formatDetailPrice` | `$2,561` |
| `2561` area | `formatArea` | `2,561 sqft` |
| `2561`, `2561` (rental PSF) | `formatPricePerSqft` | `$1.00 psf` |
| `1420000`, `1000` (sale PSF) | `formatPricePerSqft` | `$1,420 psf` |
| `1` / `3` bedrooms | `formatBedrooms` | `1 Bed` / `3 Beds` |
| `1` / `2` bathrooms | `formatBathrooms` | `1 Bath` / `2 Baths` |
| `99` tenure | `formatTenure` | `99 yrs` |
| street + district | `formatAddress` | `12 Meyappa Chettiar Rd · D13` |
