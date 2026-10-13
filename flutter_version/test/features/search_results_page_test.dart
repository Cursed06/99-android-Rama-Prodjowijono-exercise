import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ninety_nine_exercise/core/state/ui_state.dart';
import 'package:ninety_nine_exercise/core/theme/app_theme.dart';
import 'package:ninety_nine_exercise/data/models/listing.dart';
import 'package:ninety_nine_exercise/data/repositories/listing_repository.dart';
import 'package:ninety_nine_exercise/features/search_results/search_results_page.dart';
import 'package:ninety_nine_exercise/features/search_results/search_results_view_model.dart';

class MockListingRepository extends Mock implements ListingRepository {}

class FakeSearchResultsViewModel extends SearchResultsViewModel {
  FakeSearchResultsViewModel(super.repository);

  UiState<List<Listing>> _overrideState = const Loading();

  @override
  UiState<List<Listing>> get state => _overrideState;

  void setState(UiState<List<Listing>> newState) {
    _overrideState = newState;
    notifyListeners();
  }

  bool loadCalled = false;
  @override
  Future<void> load() async {
    loadCalled = true;
  }
}

void main() {
  late MockListingRepository mockRepository;
  late FakeSearchResultsViewModel fakeViewModel;

  const sampleListing = Listing(
    id: 42,
    projectName: 'Marina Bay Suites',
    photoUrl: 'https://example.com/photo.jpg',
    category: 'Condo',
    completedAt: '2022',
    tenure: 99,
    address: Address(
      district: 'D01',
      streetName: '2 Keppel Way',
    ),
    attributes: Attributes(
      areaSize: 1800,
      bathrooms: 2,
      bedrooms: 3,
      price: 6500,
    ),
  );

  setUp(() {
    mockRepository = MockListingRepository();
    fakeViewModel = FakeSearchResultsViewModel(mockRepository);
  });

  Widget buildTestWidget({ValueChanged<int>? onListingSelected}) {
    return MaterialApp(
      theme: AppTheme.light,
      home: SearchResultsPage(
        viewModel: fakeViewModel,
        onListingSelected: onListingSelected,
      ),
    );
  }

  group('SearchResultsPage Widget Tests', () {
    testWidgets('renders LoadingView when state is Loading', (tester) async {
      fakeViewModel.setState(const Loading());

      await tester.pumpWidget(buildTestWidget());

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Search Results'), findsOneWidget);
    });

    testWidgets('renders ErrorView and triggers retry on button tap', (tester) async {
      fakeViewModel.setState(const Failure('Failed to connect to network'));

      await tester.pumpWidget(buildTestWidget());

      expect(find.text('Failed to connect to network'), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);

      await tester.tap(find.text('Retry'));
      await tester.pump();

      expect(fakeViewModel.loadCalled, isTrue);
    });

    testWidgets('renders EmptyView when data list is empty', (tester) async {
      fakeViewModel.setState(const Success(<Listing>[]));

      await tester.pumpWidget(buildTestWidget());

      expect(find.text('No listings found'), findsOneWidget);
    });

    testWidgets('renders ListingCard with formatted information on Success', (tester) async {
      fakeViewModel.setState(const Success([sampleListing]));

      int? selectedId;
      await tester.pumpWidget(buildTestWidget(
        onListingSelected: (id) => selectedId = id,
      ));

      expect(find.text('Marina Bay Suites'), findsOneWidget);
      expect(find.text('2 Keppel Way · D01'), findsOneWidget);
      expect(find.text('Condo · 2022 · 99 yrs'), findsOneWidget);
      expect(find.text('3 Beds · 2 Baths · 1,800 sqft'), findsOneWidget);
      expect(find.text('\$6,500/mo'), findsOneWidget);

      await tester.tap(find.text('Marina Bay Suites'));
      await tester.pump();

      expect(selectedId, 42);
    });
  });
}
