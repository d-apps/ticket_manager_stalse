import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ticket_manager_stalse/core/error/failure.dart';
import 'package:ticket_manager_stalse/features/ticket/tickets/domain/entities/ticket_entity.dart';
import 'package:ticket_manager_stalse/features/ticket/tickets/domain/enums/ticket_priority.dart';
import 'package:ticket_manager_stalse/features/ticket/tickets/domain/enums/ticket_status.dart';
import 'package:ticket_manager_stalse/features/ticket/tickets/domain/repositories/i_ticket_repository.dart';
import 'package:ticket_manager_stalse/features/ticket/tickets/domain/usecases/add_or_update_ticket_usecase.dart';

class MockTicketRepository extends Mock implements ITicketRepository {}

class FakeTicketEntity extends Fake implements TicketEntity {}

void main() {
  late AddOrUpdateTicketUseCase sut;
  late MockTicketRepository mockRepository;

  setUpAll(() {
    registerFallbackValue(FakeTicketEntity());
  });

  setUp(() {
    mockRepository = MockTicketRepository();
    sut = AddOrUpdateTicketUseCase(repository: mockRepository);
  });

  final tTicket = TicketEntity(
    id: '1',
    createdAt: DateTime(2023, 1, 1),
    customerName: 'Customer 1',
    message: 'Message 1',
    status: TicketStatus.open,
    priority: TicketPriority.low,
    category: 'Category 1',
  );

  test('should add or update ticket to the repository', () async {
    // arrange
    when(() => mockRepository.addOrUpdate(any()))
        .thenAnswer((_) async => const Right(null));

    // act
    final result = await sut(tTicket);

    // assert
    expect(result, const Right(null));
    verify(() => mockRepository.addOrUpdate(tTicket)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return failure when repository fails', () async {
    // arrange
    final failure = Failure('Error message');
    when(() => mockRepository.addOrUpdate(any()))
        .thenAnswer((_) async => Left(failure));

    // act
    final result = await sut(tTicket);

    // assert
    expect(result, Left(failure));
    verify(() => mockRepository.addOrUpdate(tTicket)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}
