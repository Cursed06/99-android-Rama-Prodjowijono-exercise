# 99.co Mobile Engineering Exercise — Property Listings App

A high-performance Android application built as a take-home technical evaluation for the 99.co mobile engineering internship. 

This repository contains **two complete, production-grade implementations** of the assignment, both sharing the exact same architecture, design tokens, and business logic:
1. **Native Android (Kotlin + Jetpack Compose)** located at the **project root** (`app/`).
2. **Cross-Platform (Flutter + Dart 3)** located in the standalone [**`flutter_version/`**](flutter_version/) directory.

---

## 📱 Features

- **Search Results Screen:**
  - Live property listings retrieved via Firebase REST API (`GET /listings.json`).
  - Pixel-accurate property cards with 16:9 cached preview images (`Coil`), soft elevation shadows, 60dp bottom photo gradient overlay (`PhotoOverlay`), and formatted statistics.
  - Responsive layout constrained to `600dp` max width for tablet viewports.
  - Complete feedback states: `LoadingView`, `ErrorView` with retry action, and `EmptyView`.

- **Listing Detail Screen:**
  - Full-width hero photograph with custom back navigation inside status bar insets.
  - Dual 90dp top & bottom gradient overlays (`HeroOverlay`) ensuring high contrast and photographic depth.
  - Formatted pricing, project title, and dual address subtitles.
  - **"View on map"** action launching external device maps via Intent (`https://www.google.com/maps/...`) with error handling.
  - Standardized **"Property details"** specification section with 9 exact rows matching Figma:
    - `Price/sqft` calculated dynamically from `price / area_size` (e.g. `$1.00 psf`)
    - `Floor level`, `Furnishing`, `Facing`, `Overlooking View`, `Built year (TOP)`, `Tenure`, `Property type` (derived from listing title), `Last updated`
    - Equal 50/50 flex split (`weight(0.5f)` each) with labels in 16sp w500 and values in 16sp w400.
  - **"Description"** section clamped to 5 lines with an interactive "Read more / Show less" toggle.

---

## 🏗 Architecture & Design Pattern (MVVM)

Both implementations strictly adhere to the **Model-View-ViewModel (MVVM)** architectural pattern with unidirectional data flow:

```
┌────────────────────────────────────────────────────────┐
│              View (Jetpack Compose UI)                 │
│      SearchResultsScreen       ListingDetailScreen     │
│      ListingCard, DetailHero, PriceHeader, ...         │
└───────────────────────────▲────────────────────────────┘
                            │ collectAsStateWithLifecycle()
┌───────────────────────────┴────────────────────────────┐
│                  ViewModel Layer                       │
│    SearchResultsViewModel    ListingDetailViewModel    │
│    - Exposes StateFlow<UiState<T>>                     │
│    - Executes asynchronous coroutines in viewModelScope│
└───────────────────────────▲────────────────────────────┘
                            │ suspend fun
┌───────────────────────────┴────────────────────────────┐
│                 Repository Layer                       │
│    ListingRepository (interface)                       │
│    ListingRepositoryImpl (delegation & error mapping)  │
└───────────────────────────▲────────────────────────────┘
                            │
┌───────────────────────────┴────────────────────────────┐
│              Remote Data Source Layer                  │
│    ListingApi (Retrofit + OkHttp with 10s timeout)     │
│    Firebase Realtime Database REST Endpoints           │
└────────────────────────────────────────────────────────┘
```

### Architectural Parity Matrix
| Concern | Native Kotlin (Root) | Flutter ([`flutter_version/`](flutter_version/)) |
|---|---|---|
| **UI Framework** | Jetpack Compose + Material 3 | Flutter Widgets + Material 3 |
| **State Machine** | `sealed interface UiState<out T>` | `sealed class UiState<T>` |
| **ViewModel** | `androidx.lifecycle.ViewModel` | `ChangeNotifier` |
| **Observability** | `StateFlow<UiState<T>>` | `notifyListeners()` + `context.watch()` |
| **HTTP Client** | Retrofit 2 + OkHttp (10s timeout) | `http.Client` (10s timeout) |
| **Image Cache** | Coil (`AsyncImage`) | `cached_network_image` |
| **DI** | `ServiceLocator` | `get_it` Service Locator |
| **Unit Testing** | JUnit 4 + MockK + Turbine | `flutter_test` + `mocktail` |

---

## 🚀 Getting Started

### 1. Native Android Version (Root)
Ensure you have the Android SDK (API 34/35) and JDK 17 or 21 configured.

#### Run Unit Tests:
```bash
./gradlew test
```
Runs unit tests covering formatters, repository delegation, and ViewModels.

#### Build Debug & Release APKs:
```bash
# Debug APK
./gradlew assembleDebug
# Output: app/build/outputs/apk/debug/app-debug.apk

# Release APK
./gradlew assembleRelease
# Output: app/build/outputs/apk/release/app-release.apk
```

#### Install and Run on Connected Emulator:
```bash
./gradlew installDebug
adb shell am start -n com.ninetynine.exercise/.MainActivity
```

---

### 2. Flutter Version (`flutter_version/`)
To inspect or run the Flutter implementation:
```bash
cd flutter_version
flutter pub get
flutter test
flutter run
```

---

## 🧪 Test Coverage Summary

- **Native Kotlin Tests (`app/src/test/java/`):**
  - `FormattersTest`: Price format, bedroom/bathroom pluralization, tenure, dynamic PSF calculation, and property type derivation.
  - `ListingRepositoryImplTest`: MockK verification of Retrofit calls, `IOException` mapping to `NetworkException`, and Firebase `null` response detection mapping to `NotFoundException`.
  - `SearchResultsViewModelTest`: State transitions using Turbine (`Loading` $\rightarrow$ `Success`, `Loading` $\rightarrow$ `Failure`).
  - `ListingDetailViewModelTest`: Loading, success, error handling, and `toggleDescription()` state mutations.
- **Flutter Tests (`flutter_version/test/`):**
  - 51 automated unit, widget, and integration tests across data, models, viewmodels, and full navigation flows.

---

## 📚 Project Documentation

The specifications, design tokens, and decisions are maintained in the `docs/` folder:

| Document | Description |
|---|---|
| [docs/PRD.md](docs/PRD.md) | Product Requirements Document, endpoints, data contracts, and checklist |
| [docs/Architecture.md](docs/Architecture.md) | Layered architecture, MVVM implementation, state management, and testing strategy |
| [docs/Design_System.md](docs/Design_System.md) | Color palette, typography scale (Avenir Next), 4pt grid spacing, and component specs |
| [docs/DECISIONS.md](docs/DECISIONS.md) | Log of architectural trade-offs, package choices, and font selections |
