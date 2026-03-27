import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ticket_manager_stalse/core/error/failure.dart';
import 'package:ticket_manager_stalse/features/tickets/domain/entities/ticket_entity.dart';
import 'package:ticket_manager_stalse/features/tickets/domain/enums/ticket_priority.dart';
import 'package:ticket_manager_stalse/features/tickets/domain/enums/ticket_status.dart';
import 'package:ticket_manager_stalse/features/tickets/domain/usecases/add_or_update_ticket_usecase.dart';
import 'package:ticket_manager_stalse/features/tickets/domain/usecases/get_tickets_usecase.dart';
import 'package:ticket_manager_stalse/features/tickets/presentation/ticket_state.dart';
import 'package:ticket_manager_stalse/features/tickets/presentation/tickets_cubit.dart';

class MockGetTicketsUseCase extends Mock implements IGetTicketsUseCase {}
class MockAddOrUpdateTicketUseCase extends Mock implements IAddOrUpdateTicketUseCase {}
class FakeTicketEntity extends Fake implements TicketEntity {}

void main() {
  late TicketsCubit sut;
  late MockGetTicketsUseCase mockGetTicketsUseCase;
  late MockAddOrUpdateTicketUseCase mockAddOrUpdateTicketUseCase;

  setUpAll(() {
    registerFallbackValue(FakeTicketEntity());
  });

  setUp(() {
    mockGetTicketsUseCase = MockGetTicketsUseCase();
    mockAddOrUpdateTicketUseCase = MockAddOrUpdateTicketUseCase();
    sut = TicketsCubit(
      getTicketsUseCase: mockGetTicketsUseCase,
      addOrUpdateTicketUseCase: mockAddOrUpdateTicketUseCase,
    );
  });

  tearDown(() {
    sut.close();
  });

  final tTicket1 = TicketEntity(
    id: '1',
    createdAt: DateTime(2023, 1, 1),
    customerName: 'Customer 1',
    message: 'Message 1',
    status: TicketStatus.open,
    priority: TicketPriority.low,
    category: 'Category 1',
  );

  final tTicket2 = TicketEntity(
    id: '2',
    createdAt: DateTime(2023, 1, 2),
    customerName: 'Customer 2',
    message: 'Message 2',
    status: TicketStatus.closed,
    priority: TicketPriority.high,
    category: 'Category 2',
  );

  final tTickets = [tTicket1, tTicket2];

  test('initial state should be TicketEmptyState', () {
    expect(sut.state, isA<TicketEmptyState>());
  });

  group('getTickets', () {
    blocTest<TicketsCubit, TicketState>(
      'should emit [TicketLoadingState, TicketLoadedState] when successful',
      build: () {
        when(() => mockGetTicketsUseCase()).thenAnswer((_) async => Right(tTickets));
        return sut;
      },
      act: (cubit) => cubit.getTickets(),
      expect: () => [
        isA<TicketLoadingState>(),
        isA<TicketLoadedState>(),
      ],
    );

    blocTest<TicketsCubit, TicketState>(
      'should emit [TicketLoadingState, TicketEmptyState] when successful but empty',
      build: () {
        when(() => mockGetTicketsUseCase()).thenAnswer((_) async => const Right([]));
        return sut;
      },
      act: (cubit) => cubit.getTickets(),
      expect: () => [
        isA<TicketLoadingState>(),
        isA<TicketEmptyState>(),
      ],
    );

    blocTest<TicketsCubit, TicketState>(
      'should emit [TicketLoadingState, TicketErrorState] when unsuccessful',
      build: () {
        when(() => mockGetTicketsUseCase()).thenAnswer((_) async => Left(Failure('error')));
        return sut;
      },
      act: (cubit) => cubit.getTickets(),
      expect: () => [
        isA<TicketLoadingState>(),
        isA<TicketErrorState>(),
      ],
    );
  });

  group('addTicket', () {
    blocTest<TicketsCubit, TicketState>(
      'should emit [TicketLoadingState, TicketLoadedState] when successful',
      build: () {
        when(() => mockAddOrUpdateTicketUseCase(any())).thenAnswer((_) async => const Right(null));
        when(() => mockGetTicketsUseCase()).thenAnswer((_) async => Right(tTickets));
        return sut;
      },
      act: (cubit) => cubit.addTicket(tTicket1),
      expect: () => [
        isA<TicketLoadingState>(), // from getTickets() called inside addTicket
        isA<TicketLoadedState>(),
      ],
    );

    blocTest<TicketsCubit, TicketState>(
      'should emit [TicketErrorState] when unsuccessful',
      build: () {
        when(() => mockAddOrUpdateTicketUseCase(any())).thenAnswer((_) async => Left(Failure('error')));
        return sut;
      },
      act: (cubit) => cubit.addTicket(tTicket1),
      expect: () => [
        isA<TicketErrorState>(),
      ],
    );
  });

  group('filtering and sorting', () {
    blocTest<TicketsCubit, TicketState>(
      'filterByStatus should emit TicketLoadedState with filtered list',
      build: () {
        when(() => mockGetTicketsUseCase()).thenAnswer((_) async => Right(tTickets));
        return sut;
      },
      act: (cubit) async {
        await cubit.getTickets();
        cubit.filterByStatus(TicketStatus.closed);
      },
      skip: 2, // Skip initial loading and loaded states from getTickets
      expect: () => [
        isA<TicketLoadedState>().having((s) => s.tickets.length, 'length', 1)
            .having((s) => s.tickets.first.id, 'id', '2'),
      ],
    );

    blocTest<TicketsCubit, TicketState>(
      'changeSort(priority) should emit TicketLoadedState sorted by priority',
      build: () {
        when(() => mockGetTicketsUseCase()).thenAnswer((_) async => Right(tTickets));
        return sut;
      },
      act: (cubit) async {
        await cubit.getTickets();
        cubit.changeSort(SortBy.priority);
      },
      skip: 2,
      expect: () => [
        isA<TicketLoadedState>().having((s) => s.tickets.first.priority, 'first priority', TicketPriority.high),
      ],
    );
  });
}
