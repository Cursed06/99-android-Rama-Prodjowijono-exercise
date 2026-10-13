import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ninety_nine_exercise/core/state/ui_state.dart';
import 'package:ninety_nine_exercise/core/theme/app_theme.dart';
import 'package:ninety_nine_exercise/data/models/listing.dart';
import 'package:ninety_nine_exercise/data/models/listing_detail.dart';
import 'package:ninety_nine_exercise/data/repositories/listing_repository.dart';
import 'package:ninety_nine_exercise/features/listing_detail/listing_detail_page.dart';
import 'package:ninety_nine_exercise/features/listing_detail/listing_detail_view_model.dart';

class MockListingRepository extends Mock implements ListingRepository {}

class FakeListingDetailViewModel extends ListingDetailViewModel {
  FakeListingDetailViewModel(super.repository, super.listingId);

  UiState<ListingDetail> _overrideState = const Loading();

  @override
  UiState<ListingDetail> get state => _overrideState;

  void setState(UiState<ListingDetail> newState) {
    _overrideState = newState;
    notifyListeners();
  }

  bool loadCalled = false;
  @override
  Future<void> load() async {
    loadCalled = true;
  }

  bool _expanded = false;
  @override
  bool get isDescriptionExpanded => _expanded;

  @override
  void toggleDescription() {
    _expanded = !_expanded;
    notifyListeners();
  }
}

void main() {
  late MockListingRepository mockRepository;
  late FakeListingDetailViewModel fakeViewModel;

  const sampleDetail = ListingDetail(
    id: 10,
    projectName: 'Sentosa Cove Villa',
    photoUrl: 'https://example.com/villa.jpg',
    description: 'Breathtaking ocean views and private yacht berth.',
    address: DetailAddress(
      title: 'Ocean Way · Bungalow for Rent',
      subtitle: 'Sentosa Island (D04)',
      mapCoordinates: MapCoordinates(
        lat: 1.248,
        lng: 103.834,
      ),
    ),
    attributes: Attributes(
      areaSize: 5200,
      bathrooms: 5,
      bedrooms: 6,
      price: 28000,
    ),
    propertyDetails: [
      PropertyDetailItem(label: 'Tenure', text: '99-year leasehold'),
      PropertyDetailItem(label: 'Built year', text: '2015'),
    ],
  );

  setUp(() {
    mockRepository = MockListingRepository();
    fakeViewModel = FakeListingDetailViewModel(mockRepository, 10);
  });

  Widget buildTestWidget() {
    return MaterialApp(
      theme: AppTheme.light,
      home: ListingDetailPage(
        listingId: 10,
        viewModel: fakeViewModel,
      ),
    );
  }

  group('ListingDetailPage Widget Tests', () {
    testWidgets('renders LoadingView when state is Loading', (tester) async {
      fakeViewModel.setState(const Loading());

      await tester.pumpWidget(buildTestWidget());

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('renders ErrorView and handles retry tap when state is Failure', (tester) async {
      fakeViewModel.setState(const Failure('Listing not found'));

      await tester.pumpWidget(buildTestWidget());

      expect(find.text('Listing not found'), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);

      await tester.tap(find.text('Retry'));
      await tester.pump();

      expect(fakeViewModel.loadCalled, isTrue);
    });

    testWidgets('renders all sections with formatted values on Success', (tester) async {
      fakeViewModel.setState(const Success(sampleDetail));

      await tester.pumpWidget(buildTestWidget());

      expect(find.text('\$28,000'), findsOneWidget);
      expect(find.text('Sentosa Cove Villa'), findsOneWidget);
      expect(find.text('Ocean Way · Bungalow for Rent'), findsOneWidget);
      expect(find.text('Sentosa Island (D04)'), findsOneWidget);
      expect(find.text('View on map'), findsOneWidget);

      // Stats
      expect(find.text('6 Beds'), findsOneWidget);
      expect(find.text('5 Baths'), findsOneWidget);
      expect(find.text('5,200 sqft'), findsOneWidget);

      // Dynamic Property details
      expect(find.text('Property details'), findsOneWidget);
      expect(find.text('Tenure'), findsOneWidget);
      expect(find.text('99-year leasehold'), findsOneWidget);
      expect(find.text('Built year'), findsOneWidget);
      expect(find.text('2015'), findsOneWidget);

      // Expandable Description
      expect(find.text('Description'), findsOneWidget);
      expect(
        find.text('Breathtaking ocean views and private yacht berth.'),
        findsOneWidget,
      );
      expect(find.text('Read more'), findsOneWidget);
    });

    testWidgets('toggles description expansion when Read more is tapped', (tester) async {
      fakeViewModel.setState(const Success(sampleDetail));

      await tester.pumpWidget(buildTestWidget());

      expect(find.text('Read more'), findsOneWidget);

      await tester.ensureVisible(find.text('Read more'));
      await tester.tap(find.text('Read more'));
      await tester.pump();

      expect(find.text('Show less'), findsOneWidget);
    });
  });
}
