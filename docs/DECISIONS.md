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

## 4. Typography: Google Fonts Nunito Sans
- **Context:** Figma designs use a clean geometric humanist sans typography (Nunito Sans / Mulish).
- **Decision:** Utilize `google_fonts` (`GoogleFonts.nunitoSans`) across `AppTextStyles` and `AppTheme`.
- **Rationale:** Consistent typography rendering across iOS, Android, and macOS without needing to manually bundle multi-weight TTF assets.
