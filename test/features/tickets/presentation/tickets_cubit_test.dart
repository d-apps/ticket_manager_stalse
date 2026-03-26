
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ticket_manager_stalse/core/error/failure.dart';
import 'package:ticket_manager_stalse/features/tickets/domain/entities/ticket_entity.dart';
import 'package:ticket_manager_stalse/features/tickets/domain/enums/ticket_priority.dart';
import 'package:ticket_manager_stalse/features/tickets/domain/enums/ticket_status.dart';
import 'package:ticket_manager_stalse/features/tickets/domain/usecases/add_ticket_usecase.dart';
import 'package:ticket_manager_stalse/features/tickets/domain/usecases/get_tickets_usecase.dart';
import 'package:ticket_manager_stalse/features/tickets/domain/usecases/update_ticket_usecase.dart';
import 'package:ticket_manager_stalse/features/tickets/presentation/ticket_state.dart';
import 'package:ticket_manager_stalse/features/tickets/presentation/tickets_cubit.dart';

class MockGetTicketsUseCase extends Mock implements IGetTicketsUseCase {}
class MockAddTicketUseCase extends Mock implements IAddTicketUseCase {}
class MockUpdateTicketUseCase extends Mock implements IUpdateTicketUseCase {}
class FakeTicketEntity extends Fake implements TicketEntity {}

void main() {
  late TicketsCubit sut;
  late MockGetTicketsUseCase mockGetTicketsUseCase;
  late MockAddTicketUseCase mockAddTicketUseCase;
  late MockUpdateTicketUseCase mockUpdateTicketUseCase;

  setUpAll(() {
    registerFallbackValue(FakeTicketEntity());
  });

  setUp(() {
    mockGetTicketsUseCase = MockGetTicketsUseCase();
    mockAddTicketUseCase = MockAddTicketUseCase();
    mockUpdateTicketUseCase = MockUpdateTicketUseCase();
    sut = TicketsCubit(
      getTicketsUseCase: mockGetTicketsUseCase,
      addTicketUseCase: mockAddTicketUseCase,
      updateTicketUseCase: mockUpdateTicketUseCase,
    );
  });

  tearDown(() {
    sut.close();
  });

  final tTicket = TicketEntity(
    id: '1',
    createdAt: DateTime.now(),
    customerName: 'Customer 1',
    message: 'Message 1',
    status: TicketStatus.open,
    priority: TicketPriority.low,
    category: 'Category 1',
  );

  final tTickets = [tTicket];

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
      'should emit [TicketLoadingState] and then call getTickets when successful',
      build: () {
        when(() => mockAddTicketUseCase(any())).thenAnswer((_) async => const Right(null));
        when(() => mockGetTicketsUseCase()).thenAnswer((_) async => Right(tTickets));
        return sut;
      },
      act: (cubit) => cubit.addTicket(tTicket),
      expect: () => [
        isA<TicketLoadingState>(),
        isA<TicketLoadingState>(),
        isA<TicketLoadedState>(),
      ],
      verify: (_) {
        verify(() => mockAddTicketUseCase(tTicket)).called(1);
      },
    );

    blocTest<TicketsCubit, TicketState>(
      'should emit [TicketLoadingState, TicketErrorState] when unsuccessful',
      build: () {
        when(() => mockAddTicketUseCase(any())).thenAnswer((_) async => Left(Failure('error')));
        return sut;
      },
      act: (cubit) => cubit.addTicket(tTicket),
      expect: () => [
        isA<TicketLoadingState>(),
        isA<TicketErrorState>(),
      ],
    );
  });

  group('filtering and sorting', () {
    final tTicketClosed = TicketEntity(
      id: '2',
      createdAt: DateTime.now().add(const Duration(days: 1)),
      customerName: 'Customer 2',
      message: 'Message 2',
      status: TicketStatus.closed,
      priority: TicketPriority.high,
      category: 'Category 2',
    );
    
    final allTickets = [tTicket, tTicketClosed];

    blocTest<TicketsCubit, TicketState>(
      'filterByStatus should emit TicketLoadedState with filtered tickets',
      build: () {
        when(() => mockGetTicketsUseCase()).thenAnswer((_) async => Right(allTickets));
        return sut;
      },
      act: (cubit) async {
        await cubit.getTickets();
        cubit.filterByStatus(TicketStatus.closed);
      },
      skip: 2, // Skip getTickets emissions
      expect: () => [
        isA<TicketLoadedState>().having((s) => s.tickets.length, 'length', 1)
            .having((s) => s.tickets.first.status, 'status', TicketStatus.closed),
      ],
    );

    blocTest<TicketsCubit, TicketState>(
      'clearFilters should emit TicketLoadedState with all tickets',
      build: () {
        when(() => mockGetTicketsUseCase()).thenAnswer((_) async => Right(allTickets));
        return sut;
      },
      act: (cubit) async {
        await cubit.getTickets();
        cubit.filterByStatus(TicketStatus.closed);
        cubit.clearFilters();
      },
      skip: 3, 
      expect: () => [
        isA<TicketLoadedState>().having((s) => s.tickets.length, 'length', 2),
      ],
    );

    blocTest<TicketsCubit, TicketState>(
      'sortByPriority should sort tickets correctly',
      build: () {
        when(() => mockGetTicketsUseCase()).thenAnswer((_) async => Right(allTickets));
        return sut;
      },
      act: (cubit) async {
        await cubit.getTickets();
        cubit.sortByPriority(descending: true);
      },
      skip: 2,
      expect: () => [
        isA<TicketLoadedState>().having((s) => s.tickets.first.priority, 'highest priority', TicketPriority.high),
      ],
    );
  });
}
