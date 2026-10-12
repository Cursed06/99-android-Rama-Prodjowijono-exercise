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
