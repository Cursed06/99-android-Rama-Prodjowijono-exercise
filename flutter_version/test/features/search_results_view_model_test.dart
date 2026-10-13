import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ninety_nine_exercise/core/error/app_exception.dart';
import 'package:ninety_nine_exercise/core/state/ui_state.dart';
import 'package:ninety_nine_exercise/data/models/listing.dart';
import 'package:ninety_nine_exercise/data/repositories/listing_repository.dart';
import 'package:ninety_nine_exercise/features/search_results/search_results_view_model.dart';

class MockListingRepository extends Mock implements ListingRepository {}

void main() {
  late MockListingRepository mockRepository;
  late SearchResultsViewModel viewModel;

  const sampleListing = Listing(
    id: 0,
    projectName: 'Parkview Apartments',
    photoUrl: 'https://picsum.photos/id/10/450/300',
    category: 'Condo',
    completedAt: '2020',
    tenure: 99,
    address: Address(
      district: 'D13',
      streetName: '12 Meyappa Chettiar Rd',
    ),
    attributes: Attributes(
      areaSize: 2561,
      bathrooms: 2,
      bedrooms: 3,
      price: 2561,
    ),
  );

  setUp(() {
    mockRepository = MockListingRepository();
    viewModel = SearchResultsViewModel(mockRepository);
  });

  group('SearchResultsViewModel', () {
    test('initial state is Loading', () {
      expect(viewModel.state, isA<Loading<List<Listing>>>());
    });

    test('emits Success when repository returns listings successfully', () async {
      when(() => mockRepository.getListings())
          .thenAnswer((_) async => [sampleListing]);

      final states = <UiState<List<Listing>>>[];
      viewModel.addListener(() => states.add(viewModel.state));

      await viewModel.load();

      expect(viewModel.state, isA<Success<List<Listing>>>());
      final successState = viewModel.state as Success<List<Listing>>;
      expect(successState.data, [sampleListing]);
      expect(states.first, isA<Loading<List<Listing>>>());
      expect(states.last, isA<Success<List<Listing>>>());
    });

    test('emits Failure when repository throws NetworkException', () async {
      when(() => mockRepository.getListings())
          .thenThrow(const NetworkException('No internet connection'));

      await viewModel.load();

      expect(viewModel.state, isA<Failure<List<Listing>>>());
      final failureState = viewModel.state as Failure<List<Listing>>;
      expect(failureState.message, 'No internet connection');
    });

    test('emits Failure when repository throws ParseException', () async {
      when(() => mockRepository.getListings())
          .thenThrow(const ParseException('Failed to parse'));

      await viewModel.load();

      expect(viewModel.state, isA<Failure<List<Listing>>>());
      final failureState = viewModel.state as Failure<List<Listing>>;
      expect(failureState.message, 'Failed to parse');
    });

    test('retry via load recovers to Success after previous Failure', () async {
      when(() => mockRepository.getListings())
          .thenThrow(const NetworkException('Server timeout'));

      await viewModel.load();
      expect(viewModel.state, isA<Failure<List<Listing>>>());

      when(() => mockRepository.getListings())
          .thenAnswer((_) async => [sampleListing]);

      await viewModel.load();
      expect(viewModel.state, isA<Success<List<Listing>>>());
      expect((viewModel.state as Success<List<Listing>>).data, [sampleListing]);
    });

    test('refresh updates state to Success without resetting to Loading', () async {
      when(() => mockRepository.getListings())
          .thenAnswer((_) async => [sampleListing]);

      await viewModel.refresh();

      expect(viewModel.state, isA<Success<List<Listing>>>());
      expect((viewModel.state as Success<List<Listing>>).data, [sampleListing]);
    });
  });
}
