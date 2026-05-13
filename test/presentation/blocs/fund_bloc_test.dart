import 'package:btg_manager/domain/entities/fund.dart';
import 'package:btg_manager/domain/repositories/fund_repository.dart';
import 'package:btg_manager/presentation/blocs/fund_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFundRepository extends Mock implements FundRepository {}

void main() {
  late MockFundRepository mockFundRepo;
  late FundBloc fundBloc;

  setUp(() {
    mockFundRepo = MockFundRepository();
    fundBloc = FundBloc(fundRepository: mockFundRepo);
  });

  tearDown(() {
    fundBloc.close();
  });

  final dummyFund = const Fund(id: '1', name: 'Test Fund', minimumAmount: 10000.0, category: 'FPV');

  group('FundBloc Tests -', () {
    test('Initial state is FundInitial', () {
      expect(fundBloc.state, isA<FundInitial>());
    });

    blocTest<FundBloc, FundState>(
      'emits [FundLoading, FundLoaded] when LoadFunds is added and succeeds',
      build: () {
        when(() => mockFundRepo.getAvailableFunds()).thenAnswer((_) async => [dummyFund]);
        when(() => mockFundRepo.getSubscribedFunds()).thenAnswer((_) async => []);
        return fundBloc;
      },
      act: (bloc) => bloc.add(LoadFunds()),
      expect: () => [
        isA<FundLoading>(),
        isA<FundLoaded>(),
      ],
      verify: (_) {
        verify(() => mockFundRepo.getAvailableFunds()).called(1);
        verify(() => mockFundRepo.getSubscribedFunds()).called(1);
      },
    );

    blocTest<FundBloc, FundState>(
      'emits [FundLoading, FundOperationSuccess] and triggers LoadFunds when SubscribeToFund succeeds',
      build: () {
        when(() => mockFundRepo.subscribeToFund('1', 50000.0, notifyEmail: false, notifySms: false)).thenAnswer((_) async => {});
        when(() => mockFundRepo.getAvailableFunds()).thenAnswer((_) async => [dummyFund]);
        when(() => mockFundRepo.getSubscribedFunds()).thenAnswer((_) async => []);
        return fundBloc;
      },
      act: (bloc) => bloc.add(const SubscribeToFund(fundId: '1', amount: 50000.0)),
      expect: () => [
        isA<FundLoading>(),
        isA<FundOperationSuccess>(),
        isA<FundLoading>(), // From inner LoadFunds() event
        isA<FundLoaded>(), // From inner LoadFunds() event
      ]
    );

    blocTest<FundBloc, FundState>(
      'emits [FundLoading, FundError] and triggers LoadFunds when SubscribeToFund fails',
      build: () {
        when(() => mockFundRepo.subscribeToFund('1', 500.0, notifyEmail: false, notifySms: false)).thenThrow(Exception('El monto mínimo es 10000'));
        when(() => mockFundRepo.getAvailableFunds()).thenAnswer((_) async => [dummyFund]);
        when(() => mockFundRepo.getSubscribedFunds()).thenAnswer((_) async => []);
        return fundBloc;
      },
      act: (bloc) => bloc.add(const SubscribeToFund(fundId: '1', amount: 500.0)),
      expect: () => [
        isA<FundLoading>(),
        isA<FundError>(),
        isA<FundLoading>(), // From inner LoadFunds() event
        isA<FundLoaded>(), // From inner LoadFunds() event
      ]
    );
  });
}
