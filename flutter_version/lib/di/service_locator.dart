import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import '../data/repositories/listing_repository.dart';
import '../data/repositories/listing_repository_impl.dart';
import '../data/services/listing_api_service.dart';
import '../features/listing_detail/listing_detail_view_model.dart';
import '../features/search_results/search_results_view_model.dart';

/// Global service locator instance.
final GetIt getIt = GetIt.instance;

/// Configures dependency injection registrations.
///
/// Registers singletons for network services and repositories,
/// and factories for ViewModels so each page obtains a clean instance.
void setupLocator() {
  // Core / Networking
  getIt.registerLazySingleton<http.Client>(() => http.Client());
  getIt.registerLazySingleton<ListingApiService>(() => ListingApiService(getIt()));

  // Repositories
  getIt.registerLazySingleton<ListingRepository>(
    () => ListingRepositoryImpl(getIt()),
  );

  // ViewModels
  getIt.registerFactory<SearchResultsViewModel>(
    () => SearchResultsViewModel(getIt()),
  );

  getIt.registerFactoryParam<ListingDetailViewModel, int, void>(
    (id, _) => ListingDetailViewModel(getIt(), id),
  );
}
