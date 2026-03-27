import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ticket_manager_stalse/features/tickets/domain/entities/ticket_entity.dart';
import 'package:ticket_manager_stalse/features/tickets/domain/enums/ticket_priority.dart';
import 'package:ticket_manager_stalse/features/tickets/domain/enums/ticket_status.dart';
import 'package:ticket_manager_stalse/features/tickets/presentation/ticket_state.dart';
import 'package:ticket_manager_stalse/features/tickets/presentation/tickets_cubit.dart';
import 'package:ticket_manager_stalse/features/tickets/presentation/tickets_page.dart';
import 'package:ticket_manager_stalse/features/tickets/presentation/widgets/ticket_tile.dart';

class MockTicketsCubit extends MockCubit<TicketState> implements TicketsCubit {}

void main() {
  late MockTicketsCubit mockTicketsCubit;

  setUp(() {
    mockTicketsCubit = MockTicketsCubit();
    // Stub the getters used in the AppBar
    when(() => mockTicketsCubit.currentStatus).thenReturn(TicketStatus.all);
    when(() => mockTicketsCubit.sortBy).thenReturn(SortBy.none);
  });

  Widget makeTestableWidget() {
    return MaterialApp(
      home: BlocProvider<TicketsCubit>.value(
        value: mockTicketsCubit,
        child: const TicketsPage(),
      ),
    );
  }

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

  testWidgets('should display CircularProgressIndicator when state is TicketLoadingState', (tester) async {
    when(() => mockTicketsCubit.state).thenReturn(TicketLoadingState());

    await tester.pumpWidget(makeTestableWidget());

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('should display "Nenhum ticket encontrado" when state is TicketEmptyState', (tester) async {
    when(() => mockTicketsCubit.state).thenReturn(TicketEmptyState());

    await tester.pumpWidget(makeTestableWidget());

    expect(find.text("Nenhum ticket encontrado"), findsOneWidget);
  });

  testWidgets('should display list of tickets when state is TicketLoadedState', (tester) async {
    when(() => mockTicketsCubit.state).thenReturn(TicketLoadedState(tTickets));

    await tester.pumpWidget(makeTestableWidget());

    expect(find.byType(ListView), findsOneWidget);
    expect(find.byType(TicketTile), findsOneWidget);
    expect(find.text('Customer 1'), findsOneWidget);
  });

}
