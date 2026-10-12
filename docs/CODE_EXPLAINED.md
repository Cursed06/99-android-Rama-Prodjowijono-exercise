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
