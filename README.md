# 99.co Mobile Engineering Exercise — Property Listings App

A cross-platform Flutter application built as a take-home technical evaluation for the 99.co mobile engineering internship. Implements a clean **MVVM architecture** with separation of concerns, defensive data parsing, responsive design system tokens, and dependency injection.

---

## 📱 Features

- **Search Results Screen:**
  - Live property listings retrieved via Firebase REST API (`GET /listings.json`).
  - Pixel-accurate property cards with 16:9 cached preview images, soft elevation shadows, and formatted stats.
  - Pull-to-refresh (`RefreshIndicator`) and interactive ripple effects.
  - Responsive layout constrained to `600px` max width for tablet viewports.
  - Complete feedback states: `LoadingView`, `ErrorView` with retry action, and `EmptyView`.

- **Listing Detail Screen:**
  - Full-width hero photograph with `Hero` transition animation connected to the search card.
  - Overlaid contrast-safe back navigation over a subtle dark gradient scrim.
  - Formatted pricing, project title, and dual address subtitles.
  - **"View on map"** action launching external device maps at precise coordinates with `url_launcher`.
  - Dynamic **"Property details"** specification table adapting to backend fields.
  - **"Description"** section clamped to 5 lines with an interactive "Read more / Show less" toggle.

---

## 🏗 Architecture & Design Pattern

The application strictly follows the **MVVM (Model-View-ViewModel)** architectural pattern with unidirectional data flow:

```
┌────────────────────────────────────────────────────────┐
│                   View (UI Layer)                      │
│      SearchResultsPage         ListingDetailPage       │
│      ListingCard, DetailHero, PriceHeader, ...         │
└───────────────────────────▲────────────────────────────┘
                            │ context.watch / notifyListeners
┌───────────────────────────┴────────────────────────────┐
│                  ViewModel Layer                       │
│    SearchResultsViewModel    ListingDetailViewModel    │
│    - Manages UiState<T> (Loading, Success, Failure)   │
│    - Coordinates user intent and business logic        │
└───────────────────────────▲────────────────────────────┘
                            │ Future<T>
┌───────────────────────────┴────────────────────────────┐
│                 Repository Layer                       │
│    ListingRepository (interface)                       │
│    ListingRepositoryImpl (delegation & caching facade) │
└───────────────────────────▲────────────────────────────┘
                            │
┌───────────────────────────┴────────────────────────────┐
│              Remote Data Source Layer                  │
│    ListingApiService (http.Client with 10s timeout)    │
│    Firebase Realtime Database REST Endpoints           │
└────────────────────────────────────────────────────────┘
```

### Architectural Decisions & Trade-offs
1. **State Management (`provider` + `ChangeNotifier`):**
   - Idiomatic, lightweight, and zero code generation.
   - Maps 1:1 to Android's `ViewModel` + `StateFlow` architecture, making it easy to explain in a live technical interview.
2. **Dependency Injection (`get_it`):**
   - Used strictly at the application composition root (`di/service_locator.dart`).
   - ViewModels receive dependencies exclusively through constructors, enabling headless unit testing with mocks.
3. **Sealed `UiState<T>` Pattern:**
   - Visual states (`Loading`, `Success`, `Failure`) are modeled using Dart 3 sealed classes.
   - Eliminates invalid visual states (e.g., loading spinner and error banner simultaneously) and provides compile-time exhaustiveness checking.
4. **Defensive Parsing:**
   - Numbers are parsed with `(json['field'] as num).toInt()` or `.toDouble()` to safely handle int-vs-double variations from backend JSON.
   - Missing nodes in Firebase return HTTP 200 with string `"null"`, which our service maps to a typed `NotFoundException`.
5. **API Data Trumps Figma Copy:**
   - Real backend data takes precedence over Figma placeholder copy (e.g. `$2,561/mo` vs `$5,700/mo`, and dynamic `property_details[]` rows).

---

## 🎨 Design System & Theming

- **Typography:** Primary font family set to **Avenir Next** (matching Figma specifications) with fallback to `['Nunito Sans', 'sans-serif']` for cross-platform safety.
- **Palette:** Centralized in `lib/core/theme/app_colors.dart` (Primary Navy `#1A2258`, Text Secondary `#787D9C`, Accent Blue `#216BFF`, Surfaces, and subtle dividers).
- **Spacing:** Standard 4-point design scale (`xs=4`, `sm=8`, `md=12`, `lg=16`, `xl=24`, `xxl=32`).

---

## 🚀 Getting Started

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (v3.24.0 or newer)
- Android Studio / Android SDK with an Android Virtual Device (AVD) emulator configured

### Installation
Clone or navigate to the workspace directory:
```bash
git clone <repository-url>
cd "99 Group Project"
```

Fetch dependencies:
```bash
flutter pub get
```

### Running on Android Emulator
1. Start your Android Emulator from Android Studio or via CLI:
   ```bash
   emulator -list-avds
   emulator -avd <your-emulator-name>
   ```
2. Verify Flutter detects the running emulator:
   ```bash
   flutter devices
   ```
3. Run the application in debug mode:
   ```bash
   flutter run
   ```

### Running Tests & Static Analysis
Run all 47 unit, widget, and integration tests:
```bash
flutter test
```

Run Dart static analysis to verify zero linter warnings:
```bash
flutter analyze
```

### Building the Release APK (When Ready)
Whenever you are ready to produce the production binary:
```bash
flutter build apk --release
```
The resulting APK will be located at:
`build/app/outputs/flutter-apk/app-release.apk`

---

## 🧪 Test Coverage Summary

The project includes **47 comprehensive automated tests**:
- **Data & Models (`test/data/`):** Happy path JSON deserialization, defensive double/int type coercion, missing field exceptions (`ParseException`).
- **Network & Service (`test/data/`):** Mock HTTP client simulating HTTP 200, HTTP 500, network timeouts, offline `SocketException`, and Firebase `null` response detection (`NotFoundException`).
- **Repository (`test/data/`):** Verifies clean contract delegation using `mocktail`.
- **ViewModels (`test/features/`):** State transitions (`Loading` $\rightarrow$ `Success`, `Loading` $\rightarrow$ `Failure`), retry recovery, description expansion toggle.
- **Widgets & Navigation (`test/features/`):** Verifies `LoadingView`, `ErrorView`, `EmptyView`, `ListingCard` rendering, responsive text clamping, and full navigation flow from list to detail and back.

---

## 🔮 What I'd Do Next (Production Evolution)

If expanding this application for a full commercial launch:
1. **Offline Persistence & Caching:** Integrate a local database (`sqflite` or `drift`) into the repository layer to cache listing payloads and enable offline browsing.
2. **Infinite Pagination & Filtering:** Implement cursor/page-based query pagination and interactive filter sheets (price range, bedroom count, property type).
3. **Declarative Deep Linking (`go_router`):** Support URL deep linking (e.g. `myapp://listings/12`) and browser history for Flutter Web.
4. **Accessibility (a11y) & Localization (i18n):** Add semantic labels (`Semantics`), verify screen reader navigability (TalkBack / VoiceOver), and extract strings into `.arb` files with `flutter_localizations`.
5. **Interactive In-App Maps:** Embed native Google Maps with custom markers for surrounding transport and amenities.
