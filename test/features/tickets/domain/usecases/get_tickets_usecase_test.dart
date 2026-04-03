import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ticket_manager_stalse/core/error/failure.dart';
import 'package:ticket_manager_stalse/features/ticket/tickets/domain/entities/ticket_entity.dart';
import 'package:ticket_manager_stalse/features/ticket/tickets/domain/enums/ticket_priority.dart';
import 'package:ticket_manager_stalse/features/ticket/tickets/domain/enums/ticket_status.dart';
import 'package:ticket_manager_stalse/features/ticket/tickets/domain/repositories/i_ticket_repository.dart';
import 'package:ticket_manager_stalse/features/ticket/tickets/domain/usecases/get_tickets_usecase.dart';

class MockTicketRepository extends Mock implements ITicketRepository {}

void main() {
  late GetTicketsUseCase sut;
  late MockTicketRepository mockRepository;

  setUp(() {
    mockRepository = MockTicketRepository();
    sut = GetTicketsUseCase(repository: mockRepository);
  });

  final tTickets = [
    TicketEntity(
      id: '1',
      createdAt: DateTime(2023, 1, 1),
      customerName: 'Customer 1',
      message: 'Message 1',
      status: TicketStatus.open,
      priority: TicketPriority.low,
      category: 'Category 1',
    ),
  ];

  test('should get tickets from the repository', () async {
    // arrange
    when(() => mockRepository.getAll())
        .thenAnswer((_) async => Right(tTickets));

    // act
    final result = await sut();

    // assert
    expect(result, Right(tTickets));
    verify(() => mockRepository.getAll()).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return failure when repository fails', () async {
    // arrange
    final failure = Failure('Error message');
    when(() => mockRepository.getAll())
        .thenAnswer((_) async => Left(failure));

    // act
    final result = await sut();

    // assert
    expect(result, Left(failure));
    verify(() => mockRepository.getAll()).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}
