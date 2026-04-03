import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ticket_manager_stalse/features/ticket/tickets/domain/entities/ticket_entity.dart';
import 'package:ticket_manager_stalse/features/ticket/tickets/domain/enums/ticket_priority.dart';
import 'package:ticket_manager_stalse/features/ticket/tickets/domain/enums/ticket_status.dart';
import 'package:ticket_manager_stalse/features/ticket/tickets/domain/usecases/add_or_update_ticket_usecase.dart';
import 'package:ticket_manager_stalse/features/ticket/tickets/domain/usecases/get_tickets_usecase.dart';
import 'package:ticket_manager_stalse/features/ticket/tickets/presentation/ticket_state.dart';
import 'package:ticket_manager_stalse/features/ticket/tickets/presentation/tickets_cubit.dart';

class MockGetTicketsUseCase extends Mock implements IGetTicketsUseCase {}
class MockAddOrUpdateTicketUseCase extends Mock implements IAddOrUpdateTicketUseCase {}

void main() {
  late TicketsCubit cubit;
  late MockGetTicketsUseCase mockGetTicketsUseCase;
  late MockAddOrUpdateTicketUseCase mockAddOrUpdateTicketUseCase;

  setUp(() {
    mockGetTicketsUseCase = MockGetTicketsUseCase();
    mockAddOrUpdateTicketUseCase = MockAddOrUpdateTicketUseCase();
    cubit = TicketsCubit(
      getTicketsUseCase: mockGetTicketsUseCase,
      addOrUpdateTicketUseCase: mockAddOrUpdateTicketUseCase,
    );
  });

  final tTickets = [
    TicketEntity(
      id: '1',
      customerName: 'Test Ticket 1',
      message: 'Description 1',
      status: TicketStatus.open,
      priority: TicketPriority.low,
      createdAt: DateTime(2023, 1, 1),
      category: ""
    ),
    TicketEntity(
      id: '2',
      customerName: 'Test Ticket 2',
      message: 'Description 2',
      status: TicketStatus.closed,
      priority: TicketPriority.high,
      createdAt: DateTime(2023, 1, 2),
      category: ""
    ),
  ];

  test('initial state should be TicketEmptyState', () {
    expect(cubit.state, isA<TicketEmptyState>());
  });

  blocTest<TicketsCubit, TicketState>(
    'emits [TicketLoadingState, TicketLoadedState] when getTickets is successful',
    build: () {
      when(() => mockGetTicketsUseCase()).thenAnswer((_) async => Right(tTickets));
      return cubit;
    },
    act: (cubit) => cubit.getTickets(),
    expect: () => [
      isA<TicketLoadingState>(),
      isA<TicketLoadedState>(),
    ],
  );

  blocTest<TicketsCubit, TicketState>(
    'emits [TicketLoadingState, TicketEmptyState] when getTickets returns empty list',
    build: () {
      when(() => mockGetTicketsUseCase()).thenAnswer((_) async => const Right([]));
      return cubit;
    },
    act: (cubit) => cubit.getTickets(),
    expect: () => [
      isA<TicketLoadingState>(),
      isA<TicketEmptyState>(),
    ],
  );

  blocTest<TicketsCubit, TicketState>(
    'filters tickets by status',
    build: () {
      when(() => mockGetTicketsUseCase()).thenAnswer((_) async => Right(tTickets));
      return cubit;
    },
    act: (cubit) async {
      await cubit.getTickets();
      cubit.filterByStatus(TicketStatus.open);
    },
    skip: 2,
    expect: () => [
      isA<TicketLoadedState>().having((s) => s.tickets.length, 'tickets length', 1),
    ],
  );
}
