import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ninety_nine_exercise/core/error/app_exception.dart';
import 'package:ninety_nine_exercise/core/state/ui_state.dart';
import 'package:ninety_nine_exercise/data/models/listing.dart';
import 'package:ninety_nine_exercise/data/models/listing_detail.dart';
import 'package:ninety_nine_exercise/data/repositories/listing_repository.dart';
import 'package:ninety_nine_exercise/features/listing_detail/listing_detail_view_model.dart';

class MockListingRepository extends Mock implements ListingRepository {}

void main() {
  late MockListingRepository mockRepository;
  late ListingDetailViewModel viewModel;

  const sampleDetail = ListingDetail(
    id: 0,
    projectName: 'Parkview Apartments',
    photoUrl: 'https://picsum.photos/id/10/450/300',
    description: 'Sit back and enjoy panorama views...',
    address: DetailAddress(
      title: '1 Keppel Bay View · Condo for Rent',
      subtitle: 'Telok Blangah / Harbourfront (D4)',
      mapCoordinates: MapCoordinates(
        lat: 1.3884286902614,
        lng: 103.87432292478,
      ),
    ),
    attributes: Attributes(
      areaSize: 2561,
      bathrooms: 2,
      bedrooms: 3,
      price: 2561,
    ),
    propertyDetails: [
      PropertyDetailItem(label: 'Price/sqft', text: '\$1,420 psf'),
    ],
  );

  setUp(() {
    mockRepository = MockListingRepository();
    viewModel = ListingDetailViewModel(mockRepository, 0);
  });

  group('ListingDetailViewModel', () {
    test('initial state is Loading and description is collapsed', () {
      expect(viewModel.state, isA<Loading<ListingDetail>>());
      expect(viewModel.isDescriptionExpanded, isFalse);
    });

    test('emits Success when repository returns listing detail', () async {
      when(() => mockRepository.getListingDetail(0))
          .thenAnswer((_) async => sampleDetail);

      await viewModel.load();

      expect(viewModel.state, isA<Success<ListingDetail>>());
      final successState = viewModel.state as Success<ListingDetail>;
      expect(successState.data, sampleDetail);
    });

    test('emits Failure when repository throws NotFoundException', () async {
      when(() => mockRepository.getListingDetail(0))
          .thenThrow(const NotFoundException('Listing not found'));

      await viewModel.load();

      expect(viewModel.state, isA<Failure<ListingDetail>>());
      final failureState = viewModel.state as Failure<ListingDetail>;
      expect(failureState.message, 'Listing not found');
    });

    test('emits Failure when repository throws NetworkException', () async {
      when(() => mockRepository.getListingDetail(0))
          .thenThrow(const NetworkException('No internet connection'));

      await viewModel.load();

      expect(viewModel.state, isA<Failure<ListingDetail>>());
      final failureState = viewModel.state as Failure<ListingDetail>;
      expect(failureState.message, 'No internet connection');
    });

    test('toggleDescription toggles expansion boolean and notifies listeners', () {
      var listenerCalls = 0;
      viewModel.addListener(() => listenerCalls++);

      expect(viewModel.isDescriptionExpanded, isFalse);

      viewModel.toggleDescription();
      expect(viewModel.isDescriptionExpanded, isTrue);
      expect(listenerCalls, 1);

      viewModel.toggleDescription();
      expect(viewModel.isDescriptionExpanded, isFalse);
      expect(listenerCalls, 2);
    });

    test('retry via load recovers to Success after previous Failure', () async {
      when(() => mockRepository.getListingDetail(0))
          .thenThrow(const NetworkException('Request timed out'));

      await viewModel.load();
      expect(viewModel.state, isA<Failure<ListingDetail>>());

      when(() => mockRepository.getListingDetail(0))
          .thenAnswer((_) async => sampleDetail);

      await viewModel.load();
      expect(viewModel.state, isA<Success<ListingDetail>>());
      expect((viewModel.state as Success<ListingDetail>).data, sampleDetail);
    });
  });
}
