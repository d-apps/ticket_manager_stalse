import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ticket_manager_stalse/features/ticket/tickets/domain/entities/ticket_entity.dart';
import 'package:ticket_manager_stalse/features/ticket/tickets/domain/enums/ticket_priority.dart';
import 'package:ticket_manager_stalse/features/ticket/tickets/domain/enums/ticket_status.dart';
import 'package:ticket_manager_stalse/features/ticket/tickets/presentation/ticket_state.dart';
import 'package:ticket_manager_stalse/features/ticket/tickets/presentation/tickets_cubit.dart';
import 'package:ticket_manager_stalse/features/ticket/tickets/presentation/tickets_page.dart';

class MockTicketsCubit extends MockCubit<TicketState> implements TicketsCubit {}

void main() {
  late MockTicketsCubit mockTicketsCubit;

  setUpAll(() {
    registerFallbackValue(TicketStatus.all);
    registerFallbackValue(SortBy.date);
  });

  setUp(() {
    mockTicketsCubit = MockTicketsCubit();
    GetIt.I.registerSingleton<TicketsCubit>(mockTicketsCubit);

    // Configura comportamentos padrão para os getters e métodos usados no build
    when(() => mockTicketsCubit.currentStatus).thenReturn(TicketStatus.all);
    when(() => mockTicketsCubit.sortBy).thenReturn(SortBy.date);
    when(() => mockTicketsCubit.getTickets()).thenAnswer((_) async {});
  });

  tearDown(() {
    GetIt.I.reset();
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: const TicketsPage(),
    );
  }

  testWidgets('deve exibir o indicador de carregamento quando o estado for TicketLoadingState', (tester) async {
    when(() => mockTicketsCubit.state).thenReturn(TicketLoadingState());

    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('deve exibir a mensagem de vazio quando o estado for TicketEmptyState', (tester) async {
    when(() => mockTicketsCubit.state).thenReturn(TicketEmptyState());

    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.text('Nenhum ticket encontrado'), findsOneWidget);
  });

  testWidgets('deve exibir a lista de tickets quando o estado for TicketLoadedState', (tester) async {
    final tickets = [
      TicketEntity(
        id: '1',
        customerName: 'Cliente Teste',
        message: 'Mensagem de erro no sistema',
        status: TicketStatus.open,
        priority: TicketPriority.high,
        createdAt: DateTime.now(),
        category: 'Suporte',
      ),
    ];
    when(() => mockTicketsCubit.state).thenReturn(TicketLoadedState(tickets));

    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.text('Cliente Teste'), findsOneWidget);
    expect(find.text('Mensagem de erro no sistema'), findsOneWidget);
  });
}
