# Architectural & Design Decisions — 99.co Mobile Exercise

Record of technical trade-offs, architecture selections, and intentional design system deviations.

---

## 1. State Management: Provider + ChangeNotifier over Riverpod / Bloc
- **Context:** The exercise calls for MVVM and clean state separation for two screens.
- **Decision:** Use `provider` + `ChangeNotifier`.
- **Rationale:** `ChangeNotifier` provides the smallest and most idiomatic MVVM representation in Flutter with zero code generation. It maps 1:1 to Android's `ViewModel` and `StateFlow` concepts, making it easy to explain in an interview.
- **Trade-off:** Lacks compile-time safety across providers and auto-dispose mechanisms found in Riverpod, but perfectly suited for a focused 2-screen application.

## 2. Dependency Injection: Constructor Injection with `get_it` Service Locator
- **Context:** DI is a bonus evaluation criterion.
- **Decision:** Register singletons and factories in `di/service_locator.dart` and pass all dependencies into ViewModels and Services strictly via constructors.
- **Rationale:** ViewModels never directly reference `getIt`. This keeps them completely decoupled and straightforward to unit test using `mocktail`.

## 3. Data Source Truth: API Data Trumps Figma Mock Copy
- **Context:** Figma frames contain static placeholders (e.g. `$5,700/mo`, `Exec Condo`, specific TOP years), whereas the live Firebase REST endpoints return different values (e.g. `$2,561/mo`, `Condo`).
- **Decision:** Display the live endpoint values faithfully as described in `PRD.md §3.3`.
- **Rationale:** Production mobile applications must dynamically render server-provided contracts.

## 4. Typography: Avenir Next with Cross-Platform Fallback
- **Context:** The Figma design specifically specifies **Avenir Next** as the design typography.
- **Decision:** Configure `AppTextStyles` and `AppTheme` to use `Avenir Next` as the primary font family (`fontFamily: 'Avenir Next'`) with `fontFamilyFallback: ['Nunito Sans', 'sans-serif']`.
- **Rationale:** Avenir Next is pre-installed natively on iOS and macOS, giving authentic 1:1 rendering on Apple devices. On Android and web environments where proprietary Avenir Next is not pre-installed, Flutter smoothly cascades to the clean geometric sans fallbacks without crashing or breaking layout dimensions.

## 5. Standardization of Property Details & Dynamic Price/sqft Calculation
- **Context:** The Figma design requires an exact 9-row property details table (`Price/sqft`, `Floor level`, `Furnishing`, `Facing`, `Overlooking View`, `Built year (TOP)`, `Tenure`, `Property type`, `Last updated`). The mock API returns only an incomplete subset, and its static `Price/sqft` (`$1,420 psf`) does not match the listing's actual price and area.
- **Decision:** Standardize the 9 rows in `PropertyDetailsSection`:
  - Calculate `Price/sqft` dynamically via `attributes.price / attributes.area_size` (yielding `$1.00 psf` for rental listing 0).
  - Dynamically derive `Property type` from `address.title` (e.g. `"Condo for Rent"` $\rightarrow$ `"Condo"`).
  - Fall back to `'Unavailable'` for attributes absent from backend data (such as `Furnishing` and `Overlooking View`).
- **Rationale:** Ensures exact visual fidelity with the Figma design requirements while calculating mathematically correct metrics from real listing attributes.

## 6. Exact Figma Dev Mode Typography & Weight Alignment
- **Context:** Figma Dev Mode inspection revealed 4 distinct font variants of the Avenir Next family: Regular (400), Medium (500), Demi Bold (600), and Bold (700) with specific line heights (`100%` for titles, stats, links, and detail labels; `28px` for description body).
- **Decision:** Align all `AppTextStyles` tokens with verified Figma specifications:
  - `screenTitle` (16px/600/16)
  - `cardTitle` (16px/600/16)
  - `cardPrice` (16px/700/16)
  - `priceLarge` (23px/700/23)
  - `titleLarge` (19px/600/19)
  - `detailAddress` (14px/400/14)
  - `detailStat` (16px/400/16)
  - `sectionHeading` (19px/600/19)
  - `propertyDetailLabel` (16px/500/16)
  - `propertyDetailValue` (16px/400/16)
  - `body` (16px/400/28)
- **Rationale:** Guarantees pixel-perfect typography matching Figma Dev Mode while preserving readability and hierarchy.

## 7. Contrast-Safe Photo Linear Gradient Overlays
- **Context:** Photos uploaded for property cards and hero images vary widely in brightness and color; white text or icons placed directly over pure white or noisy backgrounds fail WCAG contrast guidelines.
- **Decision:**
  - Added a 60px bottom linear gradient (`AppColors.photoOverlay`: 40% black $\rightarrow$ transparent) on `ListingCard` photos.
  - Added 90px top and bottom linear gradients (`AppColors.heroOverlay`: 50% black $\rightarrow$ transparent) on `DetailHero`.
- **Rationale:** Ensures guaranteed contrast for the white back button at the top of the hero image, visual grounding for preview images, and seamless transitions into white card surfaces.
