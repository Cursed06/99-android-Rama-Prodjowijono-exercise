# Architecture — 99.co Mobile Exercise

## 1. Decisions at a glance
| Concern | Choice | Why (interview talking point) |
|---|---|---|
| Framework | Flutter 3.x / Dart 3 | README allows a Flutter project; one codebase, fast iteration |
| Pattern | **MVVM** | Required. View is dumb; ViewModel holds state + logic; Model/Repository fetch data |
| State mgmt | `provider` + `ChangeNotifier` | Smallest idiomatic MVVM in Flutter; easy to explain. `ChangeNotifier` ≈ Android `ViewModel` + `StateFlow` |
| Async | `Future` / `async` / `await` | Dart's equivalent of Kotlin coroutines / Swift `Task` — satisfies requirement #5 |
| HTTP | `http` package | Minimal, readable; no code generation |
| DI | `get_it` (service locator) | Bonus point. Registers services once at startup, ViewModels receive deps via constructor |
| Images | `cached_network_image` | Caching, placeholder, error widget |
| Maps | `url_launcher` | Opens external maps via `geo:`/Google Maps URL; avoids an API key |
| Formatting | `intl` | Thousands separators |
| Tests | `flutter_test` + `mocktail` | Bonus point; mock the repository |
| Navigation | `Navigator.push` with `MaterialPageRoute` | Two screens only; a router package is overkill |

> **Why not Riverpod/Bloc?** Fine tools, but for two screens `provider` shows MVVM clearly with the least ceremony. Be ready to say: "In a larger app I'd consider Riverpod or Bloc for testability and scoping."

## 2. Layered structure

```
┌───────────── View (widgets) ─────────────┐
│ SearchResultsPage   ListingDetailPage    │  only UI; reads state, calls ViewModel methods
└───────────────▲──────────────────────────┘
                │ notifyListeners / context.watch
┌───────────── ViewModel ──────────────────┐
│ SearchResultsViewModel  ListingDetailVM  │  holds UiState, calls repository, maps errors
└───────────────▲──────────────────────────┘
                │ Future<T>
┌───────────── Repository ─────────────────┐
│ ListingRepository (abstract)             │  single source of truth interface
│ ListingRepositoryImpl                    │  calls API service, parses to models
└───────────────▲──────────────────────────┘
                │
┌───────────── Data source ────────────────┐
│ ListingApiService (http)                 │  raw HTTP + JSON decoding
└──────────────────────────────────────────┘
```
Dependency rule: arrows only point **downward**. Widgets never import `http`; the service never imports Flutter widgets.

## 3. Folder structure
```
lib/
├── main.dart                     # runApp, calls setupLocator()
├── app.dart                      # MaterialApp + theme + home
├── di/
│   └── service_locator.dart      # get_it registrations
├── core/
│   ├── constants/api_constants.dart
│   ├── error/app_exception.dart  # NetworkException, ParseException, NotFoundException
│   ├── theme/                    # app_colors.dart, app_text_styles.dart, app_spacing.dart, app_theme.dart
│   ├── utils/formatters.dart
│   └── widgets/                  # loading_view.dart, error_view.dart, empty_view.dart
├── data/
│   ├── models/
│   │   ├── listing.dart          # Listing, Address, Attributes
│   │   └── listing_detail.dart   # ListingDetail, DetailAddress, MapCoordinates, PropertyDetailItem
│   ├── services/listing_api_service.dart
│   └── repositories/
│       ├── listing_repository.dart        # abstract
│       └── listing_repository_impl.dart
└── features/
    ├── search_results/
    │   ├── search_results_view_model.dart
    │   ├── search_results_page.dart
    │   └── widgets/listing_card.dart
    └── listing_detail/
        ├── listing_detail_view_model.dart
        ├── listing_detail_page.dart
        └── widgets/ (detail_hero.dart, price_header.dart, property_details_section.dart, expandable_description.dart)
test/
├── data/ (listing_model_test.dart, listing_repository_impl_test.dart)
└── features/ (search_results_view_model_test.dart, listing_detail_view_model_test.dart)
```

## 4. Models
Plain immutable Dart classes with `fromJson` factories (hand-written, no `json_serializable`, so it is easy to explain).

```dart
class Listing {
  final int id;
  final String projectName;
  final String photoUrl;
  final String category;
  final String completedAt;   // API sends a String
  final int tenure;
  final Address address;
  final Attributes attributes;
  const Listing({...});
  factory Listing.fromJson(Map<String, dynamic> json) => Listing(
    id: json['id'] as int,
    projectName: json['project_name'] as String,
    photoUrl: json['photo'] as String,
    category: json['category'] as String,
    completedAt: json['completed_at'].toString(),
    tenure: (json['tenure'] as num).toInt(),
    address: Address.fromJson(json['address']),
    attributes: Attributes.fromJson(json['attributes']),
  );
}
```
Parsing rules: cast numbers via `(x as num).toInt()`; use `.toString()` for fields that might change type; throw `ParseException` (wrapping the cause) on bad shape.

`ListingDetail` has `address` with `title`, `subtitle`, `MapCoordinates(lat, lng)`; `attributes`; `description`; `photoUrl`; `projectName`; `List<PropertyDetailItem>(label, text)`.

## 5. Networking
```dart
class ListingApiService {
  ListingApiService(this._client);
  final http.Client _client;

  Future<List<Listing>> fetchListings() async {
    final res = await _get('${ApiConstants.baseUrl}/listings.json');
    final data = jsonDecode(res.body);
    if (data is! List) throw const ParseException('Expected a list');
    return data.map((e) => Listing.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<ListingDetail> fetchListingDetail(int id) async {
    final res = await _get('${ApiConstants.baseUrl}/details/$id.json');
    final data = jsonDecode(res.body);
    if (data == null) throw const NotFoundException();   // Firebase returns 200 + "null"
    return ListingDetail.fromJson(data as Map<String, dynamic>);
  }

  Future<http.Response> _get(String url) async {
    try {
      final res = await _client.get(Uri.parse(url)).timeout(const Duration(seconds: 10));
      if (res.statusCode != 200) throw NetworkException('HTTP ${res.statusCode}');
      return res;
    } on SocketException { throw const NetworkException('No internet'); }
      on TimeoutException { throw const NetworkException('Request timed out'); }
  }
}
```
Firebase tip: the `.json` suffix is required; Firebase may return `null` for missing keys — handled above.

## 6. Repository
```dart
abstract class ListingRepository {
  Future<List<Listing>> getListings();
  Future<ListingDetail> getListingDetail(int id);
}
```
`ListingRepositoryImpl` simply delegates to the service today. It exists so ViewModels depend on an **abstraction** (testable with a fake) and so a cache can be added later without touching UI.

## 7. ViewModels & UI state
Model screen state as a small sealed class so the UI has to handle every case:

```dart
sealed class UiState<T> { const UiState(); }
class Loading<T> extends UiState<T> { const Loading(); }
class Success<T> extends UiState<T> { final T data; const Success(this.data); }
class Failure<T> extends UiState<T> { final String message; const Failure(this.message); }
```

```dart
class SearchResultsViewModel extends ChangeNotifier {
  SearchResultsViewModel(this._repo);
  final ListingRepository _repo;

  UiState<List<Listing>> _state = const Loading();
  UiState<List<Listing>> get state => _state;

  Future<void> load() async {
    _state = const Loading();
    notifyListeners();
    try {
      _state = Success(await _repo.getListings());
    } on AppException catch (e) {
      _state = Failure(e.message);
    } catch (_) {
      _state = const Failure('Something went wrong');
    }
    notifyListeners();
  }
}
```
`ListingDetailViewModel(repo, listingId)` mirrors this with `UiState<ListingDetail>`, plus `bool descriptionExpanded` + `toggleDescription()`.

Empty list is `Success([])` and the **View** shows `EmptyView`.

## 8. Dependency injection (get_it)
```dart
final getIt = GetIt.instance;

void setupLocator() {
  getIt.registerLazySingleton<http.Client>(() => http.Client());
  getIt.registerLazySingleton(() => ListingApiService(getIt()));
  getIt.registerLazySingleton<ListingRepository>(() => ListingRepositoryImpl(getIt()));
  getIt.registerFactory(() => SearchResultsViewModel(getIt()));
  getIt.registerFactoryParam<ListingDetailViewModel, int, void>(
      (id, _) => ListingDetailViewModel(getIt(), id));
}
```
Pages create their ViewModel via `ChangeNotifierProvider(create: (_) => getIt<SearchResultsViewModel>()..load())`. **ViewModels never call `getIt` themselves** — they receive dependencies by constructor so tests can pass mocks.

## 9. View rules
- Pages are `StatelessWidget`s using `context.watch<VM>()` and a `switch` over `UiState`.
- Extract widgets that exceed ~60 lines.
- Navigation: `Navigator.push(MaterialPageRoute(builder: (_) => ListingDetailPage(listingId: l.id)))`.
- Optional polish: `Hero(tag: 'photo-$id')` for a photo transition list → detail.
- Map: build `https://www.google.com/maps/search/?api=1&query=$lat,$lng`, `launchUrl(uri, mode: LaunchMode.externalApplication)`; catch failure → SnackBar. Android needs a `<queries>` intent entry in `AndroidManifest.xml` for `https` view intents (Flutter's `url_launcher` docs list this); iOS needs nothing for https.

## 10. Error handling matrix
| Situation | Thrown | UI message |
|---|---|---|
| No internet / DNS | `NetworkException('No internet')` | "No internet connection" + Retry |
| Timeout | `NetworkException` | "Request timed out" + Retry |
| Non-200 | `NetworkException('HTTP x')` | "Server error (x)" + Retry |
| Bad JSON shape | `ParseException` | "Unexpected data from server" |
| Detail `null` | `NotFoundException` | "Listing not found" |

## 11. Testing plan
| Test | Verifies |
|---|---|
| `Listing.fromJson` | Maps sample JSON; handles int/double; throws `ParseException` on missing key |
| `ListingDetail.fromJson` | Coordinates, dynamic `property_details` list |
| `ListingRepositoryImpl` | Delegates to service (mocked) |
| `SearchResultsViewModel` | `Loading → Success`, `Loading → Failure`, retry works (mock repo) |
| `ListingDetailViewModel` | Same + `toggleDescription` |
| Formatters | `$2,561/mo`, `1 Bed` vs `2 Beds` |
| (stretch) widget test | `ListingCard` renders formatted texts |

Run: `flutter test`.

## 12. Packages (`pubspec.yaml`)
```yaml
dependencies:
  flutter: { sdk: flutter }
  provider: ^6.1.0
  get_it: ^7.7.0
  http: ^1.2.0
  cached_network_image: ^3.3.0
  url_launcher: ^6.2.0
  intl: ^0.19.0
  google_fonts: ^6.2.0
dev_dependencies:
  flutter_test: { sdk: flutter }
  mocktail: ^1.0.0
  flutter_lints: ^4.0.0
```
(Let `flutter pub add` choose the newest compatible versions.)

## 13. Android notes
- `AndroidManifest.xml`: `<uses-permission android:name="android.permission.INTERNET"/>` (present in debug by default but **must** be in main for release).
- Build: `flutter build apk --release` → `build/app/outputs/flutter-apk/app-release.apk`.

## 14. Kotlin ↔ Flutter cheat sheet (for the interview)
| Android/Kotlin | Flutter/Dart here |
|---|---|
| `ViewModel` + `StateFlow` | `ChangeNotifier` + `notifyListeners()` |
| `suspend fun` / coroutines | `Future` / `async`-`await` |
| `Retrofit` | `http` + `ListingApiService` |
| `Hilt/Koin` | `get_it` |
| `Coil` | `cached_network_image` |
| Sealed `UiState` | Dart 3 `sealed class` + `switch` |
| Compose `@Composable` | `Widget` `build()` |
| Compose recomposition | widget rebuild via `context.watch` |
