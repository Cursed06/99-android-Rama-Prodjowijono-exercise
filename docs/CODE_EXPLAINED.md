# Code Explained — 99.co Mobile Exercise

Study notes for explaining every file in the codebase during a technical interview.

---

## Milestone 1: Scaffold, Theme & Architecture Foundations

### 📘 Walkthrough: `lib/core/theme/app_colors.dart`
**Role in the architecture:** Design token layer (`core/theme`); provides a single source of truth for all application colors across widgets.
**How it works (step by step):**
1. Declares an `abstract final class AppColors` containing compile-time constant (`static const Color`) definitions.
2. Encodes brand and semantic colors (primary Navy `#1A2258`, muted lavender-grey `#787D9C`, link/accent blue `#216BFF`, surfaces, dividers, and overlays).
3. Ensures widgets never reference raw hex colors, making design system adjustments one-line changes.
**Key Dart/Flutter concepts used:**
- `abstract final class`: A class that can neither be instantiated nor extended/implemented, serving purely as a static namespace.
- `Color(0x...)`: 32-bit ARGB hex color representation in Flutter.
**Kotlin/Android analogy:** Equivalent to `res/values/colors.xml` or Compose's `Color` constants inside a theme object.
**Why this way (and the alternative):** Hardcoding hex codes in widgets creates tight coupling and makes UI redesigns painful; a centralized token class provides zero-cost compile-time consistency.
**Likely interview question:** "How do you handle theming and color updates in Flutter?" → "By encapsulating brand tokens into a centralized theme class or `ThemeExtension`, ensuring widgets reference semantic tokens rather than raw hex values."

---

### 📘 Walkthrough: `lib/core/theme/app_spacing.dart`
**Role in the architecture:** Design token layer (`core/theme`); enforces visual rhythm using a standard 4-point spacing scale and layout dimensions.
**How it works (step by step):**
1. Defines standard scale steps (`xs=4`, `sm=8`, `md=12`, `lg=16`, `xl=24`, `xxl=32`).
2. Provides component-specific tokens (`radiusCard=12`, `radiusImage=8`, `cardGap=16`, `detailHeroHeight=280`).
3. Defines layout constraints like `maxContentWidth = 600` for tablet responsiveness.
**Key Dart/Flutter concepts used:**
- `static const double`: Compile-time constant doubles that Flutter can optimize without runtime allocation.
**Kotlin/Android analogy:** Equivalent to `dimens.xml` or Compose `Dp` constants.
**Why this way (and the alternative):** Magic numbers in padding/margin make code harder to maintain; tokenizing spacing ensures visual consistency and pixel-accurate adherence to Figma.
**Likely interview question:** "Why not just write `16.0` directly in `EdgeInsets.all(16)`?" → "Centralizing spacing tokens eliminates magic numbers, guarantees adherence to the design grid, and allows global scaling or adjustments if design requirements change."

---

### 📘 Walkthrough: `lib/core/theme/app_text_styles.dart`
**Role in the architecture:** Design token layer (`core/theme`); defines typography hierarchy matching Figma specifications with Avenir Next.
**How it works (step by step):**
1. Configures `Avenir Next` as the primary font family (`fontFamily: 'Avenir Next'`) with fallback to `['Nunito Sans', 'sans-serif']`.
2. Uses an internal helper `_base` to convert Figma line-heights to Flutter's proportional `height` factor (`lineHeight / fontSize`).
3. Declares semantic styles (`screenTitle`, `priceLarge`, `titleLarge`, `cardTitle`, `body`, `caption`, `stat`, `link`).
**Key Dart/Flutter concepts used:**
- `fontFamily` & `fontFamilyFallback`: Directs Flutter to render Avenir Next on systems where it is natively installed (iOS/macOS), falling back gracefully on Android without missing glyphs.
- `TextStyle.height`: In Flutter, `height` is a multiplier of `fontSize` rather than absolute pixels (e.g., 24px line height on 16px font is `24 / 16 = 1.5`).
**Kotlin/Android analogy:** Equivalent to `Typography` in Jetpack Compose Material 3 theme with system font fallback chains.
**Why this way (and the alternative):** Avenir Next is the exact Figma typography; setting it with fallback gives native 1:1 fidelity on Apple platforms while ensuring cross-platform safety on Android.
**Likely interview question:** "How do you handle proprietary fonts like Avenir Next in cross-platform Flutter?" → "By setting `fontFamily: 'Avenir Next'` with a robust `fontFamilyFallback` list (or bundling the licensed TTF in assets), allowing native resolution on platforms where it's pre-installed while falling back gracefully on others."

---

### 📘 Walkthrough: `lib/core/theme/app_theme.dart`
**Role in the architecture:** Core theme assembly (`core/theme`); generates Flutter's `ThemeData` to configure global Material 3 styling.
**How it works (step by step):**
1. Constructs a light `ThemeData` specifying `useMaterial3: true`.
2. Configures default `fontFamily: AppTextStyles.fontFamily` and `fontFamilyFallback: AppTextStyles.fontFallback`.
3. Connects `AppColors` to `ColorScheme.light`.
4. Overrides default `AppBarTheme` to provide flat, white, centered navigation headers with 0 elevation and dark status-bar icons.
5. Overrides `DividerThemeData` with subtle 1px dividers matching Figma.
**Key Dart/Flutter concepts used:**
- `ThemeData`: Root configuration object that controls color scheme, typography, and component styling throughout the widget tree.
- `SystemUiOverlayStyle`: Controls status bar and navigation bar icon brightness (dark vs light).
**Kotlin/Android analogy:** Equivalent to `@Composable MaterialTheme(...)` or `Theme.Material3.Light` in XML.
**Why this way (and the alternative):** Configuring component themes globally means individual screens do not need repeated boilerplate for app bar colors or divider thicknesses.
**Likely interview question:** "What is the benefit of Material 3's `ColorScheme` over older Flutter theming?" → "`ColorScheme` provides unified semantic color slots (primary, surface, error, onSurface) that automatically cascade to all Material components consistently."

---

### 📘 Walkthrough: `lib/app.dart` & `lib/main.dart`
**Role in the architecture:** Root application entry point and MaterialApp configuration.
**How it works (step by step):**
1. `main()` calls `WidgetsFlutterBinding.ensureInitialized()` and mounts `NinetyNineApp`.
2. `NinetyNineApp` creates `MaterialApp` configuring title, banner, light theme from `AppTheme.light`, and initial home route.
3. Sets up initial scaffolding ready to host ViewModels and screens in upcoming milestones.
**Key Dart/Flutter concepts used:**
- `WidgetsFlutterBinding.ensureInitialized()`: Ensures Flutter engine channels and bindings are ready before running asynchronous services or plugins.
- `StatelessWidget`: An immutable widget that describes part of the UI by building other widgets.
**Kotlin/Android analogy:** `Application` class or `MainActivity.onCreate` initializing the app root.
**Why this way (and the alternative):** Separating `app.dart` from `main.dart` allows testing `NinetyNineApp` in widget tests without invoking startup platform-specific logic in `main()`.
**Likely interview question:** "Why separate `app.dart` from `main.dart`?" → "Separating the application widget into `app.dart` facilitates headless widget testing and dependency injection setup without coupling to `main()` entry-point execution."

---

## Milestone 2: Models, Networking, Repository & Unit Tests

### 📘 Walkthrough: `lib/core/constants/api_constants.dart`
**Role in the architecture:** Constants layer (`core/constants`); defines the central base URL, endpoint routes, and timeout limits.
**How it works (step by step):**
1. Holds `baseUrl` pointing to Firebase Realtime Database.
2. Provides `listingsPath` (`/listings.json`) and `detailPath(id)` (`/details/$id.json`).
3. Defines a standard 10-second `timeout` Duration.
**Key Dart/Flutter concepts used:**
- `abstract final class`: Static utility namespace preventing instantiation.
- `static const Duration`: Compile-time constant duration.
**Kotlin/Android analogy:** Companion object or `Constants.kt` object.
**Why this way (and the alternative):** Prevents hardcoded URLs across service classes and makes changing staging/production endpoints trivial.
**Likely interview question:** "Why centralize endpoint paths?" → "Centralizing URLs prevents scattered magic strings and simplifies environment switching or backend contract changes."

---

### 📘 Walkthrough: `lib/core/error/app_exception.dart`
**Role in the architecture:** Domain error model (`core/error`); encapsulates all failure modes into a typed hierarchy.
**How it works (step by step):**
1. Declares a `sealed class AppException` that implements Dart's `Exception`.
2. Specializes into `NetworkException` (connectivity, timeout, non-200), `ParseException` (JSON schema errors), and `NotFoundException` (null responses).
3. Preserves underlying causes (`Object? cause`) for debuggability while providing clean user-facing `message` strings.
**Key Dart/Flutter concepts used:**
- `sealed class`: Pattern matching ensures the compiler knows all possible subclasses at compile time.
- `Exception`: Standard Dart contract for recoverable runtime errors.
**Kotlin/Android analogy:** Sealed class `sealed class AppException : Exception()` or `Result<T>` error hierarchy.
**Why this way (and the alternative):** Catching raw `SocketException` or `FormatException` in the UI couples widgets to network implementations; a typed domain exception abstracts platform details cleanly.
**Likely interview question:** "Why use a sealed class for exceptions in Dart 3?" → "A sealed class restricts inheritance to the current library, enabling exhaustive switch pattern matching in ViewModels and preventing unhandled error cases."

---

### 📘 Walkthrough: `lib/data/models/listing.dart` & `listing_detail.dart`
**Role in the architecture:** Domain model layer (`data/models`); converts raw JSON maps into immutable domain objects.
**How it works (step by step):**
1. Classes declare `final` fields with `const` constructors for immutability.
2. `fromJson` factories defensively convert incoming numbers via `(json['field'] as num).toInt()` or `.toDouble()` to withstand int-vs-double variations.
3. String conversions use `.toString()` for fields like `completed_at` that might arrive as integers or strings.
4. If parsing fails, wraps errors into a clean `ParseException`.
**Key Dart/Flutter concepts used:**
- `factory` constructor: A constructor that can perform validation, parsing logic, and return an instance.
- `Object.hash`: Combines field hash codes for robust `==` and `hashCode` equality contracts.
**Kotlin/Android analogy:** Kotlin `@Serializable data class` with custom deserializers.
**Why this way (and the alternative):** Hand-written `fromJson` eliminates code generation (`build_runner` / `json_serializable`), making the logic completely visible and easy to explain in a live coding interview.
**Likely interview question:** "Why cast numbers with `(x as num).toInt()` instead of `x as int`?" → "JSON decoders parse numbers without decimal points as `int` and numbers with decimals as `double`; casting to `num` first prevents runtime `type 'double' is not a subtype of type 'int'` exceptions."

---

### 📘 Walkthrough: `lib/data/services/listing_api_service.dart`
**Role in the architecture:** Remote data source (`data/services`); executes HTTP requests, applies timeouts, and decodes JSON payloads.
**How it works (step by step):**
1. Receives `http.Client` via constructor injection.
2. `_get(url)` sets a 10s timeout, verifies HTTP 200, and catches `SocketException`, `TimeoutException`, and `http.ClientException`, mapping them into `NetworkException`.
3. In `fetchListingDetail`, inspects if decoded body is `null` (Firebase's 200 response for non-existent nodes) and throws `NotFoundException`.
4. Returns typed domain models (`List<Listing>` and `ListingDetail`).
**Key Dart/Flutter concepts used:**
- `http.Client`: Abstract HTTP client from `package:http` that can be easily mocked in tests.
- `async`/`await`: Dart's asynchronous concurrency model.
**Kotlin/Android analogy:** Retrofit interface or Ktor HTTP client service.
**Why this way (and the alternative):** Isolating raw network calls in a dedicated service keeps the repository focused on business orchestration and caching.
**Likely interview question:** "How does the service handle Firebase's null response for missing keys?" → "Firebase returns HTTP 200 with string `null` rather than a 404; the service decodes the response, checks `if (data == null)`, and throws `NotFoundException`."

---

### 📘 Walkthrough: `lib/data/repositories/listing_repository.dart` & `listing_repository_impl.dart`
**Role in the architecture:** Repository layer (`data/repositories`); provides an abstract facade for data access.
**How it works (step by step):**
1. `ListingRepository` declares an abstract contract (`getListings()`, `getListingDetail(id)`).
2. `ListingRepositoryImpl` implements the contract and delegates to `ListingApiService`.
3. ViewModels depend solely on `ListingRepository`, never on `ListingApiService` or `http.Client`.
**Key Dart/Flutter concepts used:**
- `abstract class`: Interface definition in Dart.
- Delegation pattern: Forwards execution to underlying collaborators.
**Kotlin/Android analogy:** Repository interface and repository implementation in Android Clean Architecture.
**Why this way (and the alternative):** An abstract repository decouples the presentation layer from the network layer, allowing unit tests to substitute mocks easily and future caching to be added without touching ViewModels.
**Likely interview question:** "Why have both a Service and a Repository if the Repository only delegates today?" → "Separation of concerns: the service handles raw HTTP communication and deserialization, while the repository provides a domain abstraction where caching, offline persistence, and data transformation can be added later without modifying UI or ViewModels."
