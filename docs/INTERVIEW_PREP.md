# Interview Preparation Guide — 99.co Mobile Exercise

Comprehensive technical questions, architectural reasoning, and trade-offs to ace the interview.

---

## 1. Architectural Q&A

### Q1: Why did you choose MVVM with `provider` and `ChangeNotifier`?
**Answer:** MVVM cleanly separates UI rendering from business logic and data fetching:
- **View (Widgets):** Passive, stateless/observing UI that reacts to state changes via `context.watch<VM>()`. Contains zero HTTP calls or JSON parsing.
- **ViewModel (`ChangeNotifier`):** Manages UI state (`Loading`, `Success`, `Failure`) and handles user intent. Communicates with data repositories and notifies subscribers via `notifyListeners()`.
- **Repository:** Abstraction providing clean domain models (`Listing`, `ListingDetail`) while encapsulating caching and network data sources.
- **Why `provider`:** It is Flutter's official, lightweight state management recommendation. For a two-screen application, it provides MVVM with minimal boilerplate and clear lifecycle semantics. If the app grew into multi-team modules with complex derived state, I would consider Riverpod or Bloc.

### Q2: How does `ChangeNotifier` compare to Android Jetpack ViewModel?
**Answer:** In Android, `ViewModel` survives configuration changes and exposes observable streams like `StateFlow` or `LiveData`. In Flutter, `ChangeNotifier` acts as an observable subject that emits notifications whenever `notifyListeners()` is invoked, which `provider` translates into widget rebuilds for listening widgets.

### Q3: Why use Dependency Injection (`get_it`)?
**Answer:** Dependency Injection decouples classes from concrete implementations:
- ViewModels receive repositories via their constructor (`SearchResultsViewModel(ListingRepository)`), making them trivial to unit test with mocks (`MockListingRepository`).
- `get_it` acts as a lightweight Service Locator at the composition root (`di/service_locator.dart`), registering singletons for HTTP clients/services and factories for ViewModels. ViewModels **never** query `getIt` directly.

---

## 2. Async & Resilience Q&A

### Q4: How is asynchronous operations and error resilience handled?
**Answer:**
- Network requests use `async`/`await` with explicit `10`-second timeouts.
- Exceptions (`SocketException`, `TimeoutException`, HTTP error codes, JSON malformation) are caught at the data source/repository level and mapped into domain-level exceptions (`NetworkException`, `ParseException`, `NotFoundException`).
- The ViewModel catches domain exceptions and transitions `UiState` to `Failure(message)`, allowing the UI to present a clear error view with a **Retry** button without throwing unhandled exceptions.

### Q5: How do you handle Firebase returning HTTP 200 with `null` body?
**Answer:** Firebase Realtime Database returns HTTP status 200 with a body string of `"null"` when querying a non-existent document key (e.g. `/details/999.json`). Our `ListingApiService` explicitly decodes the body and checks if `data == null`, throwing a `NotFoundException` which maps to a friendly "Listing not found" UI state.

---

## 3. Known Quirks & Data Contracts (PRD §3.3)
1. **Figma Copy vs. Live API Contract:** Figma frames show mock values like `$5,700/mo`, `Exec Condo`, and static floor level copy. In production software, API data is the single source of truth; our app renders API values directly.
2. **Dynamic Property Details:** The detail screen does not hardcode table rows. Instead, it dynamically iterates through `property_details[]` (`label` and `text`), adapting to whichever attributes the backend returns.
3. **Defensive Type Casting:** API number values may arrive as integers or floating-point doubles; we cast via `(json['field'] as num).toInt()` or `.toDouble()`. Dates and tenure strings/integers use explicit `.toString()` conversions to prevent runtime type mismatch crashes.

---

## 4. "What I'd Do Next" (Production Evolution)
If continuing this project in a production engineering team, the next priorities would be:
1. **Offline Caching & Persistence:** Introduce a local database (e.g., `sqflite` or `drift`) in the repository layer to cache listings for offline viewing and instant startup.
2. **Infinite Pagination & Filtering:** Add infinite scroll / pagination on the Search Results page with query filters (price range, bedroom count, property type).
3. **Enhanced Navigation:** Implement declarative routing using `go_router` for deep linking (e.g., opening a listing directly via URL `myapp://listings/12`).
4. **Accessibility (a11y) & Localization (i18n):** Add semantic labels (`Semantics`), test with Screen Readers (TalkBack/VoiceOver), and extract hardcoded strings into `l10n` ARB files.
5. **Interactive In-App Maps:** Embed Google Maps or Mapbox inside the detail screen with custom pins for nearby MRT stations and schools.
