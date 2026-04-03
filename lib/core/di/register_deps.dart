import 'package:get_it/get_it.dart';
import 'package:hive_ce/hive.dart';
import 'package:ticket_manager_stalse/core/services/hive_persistence_service.dart';
import 'package:ticket_manager_stalse/core/services/persistence_service.dart';
import 'package:ticket_manager_stalse/features/ticket/add/presentation/add_ticket_cubit.dart';
import 'package:ticket_manager_stalse/features/ticket/detail/domain/usecases/delete_ticket_usecase.dart';
import 'package:ticket_manager_stalse/features/ticket/detail/presentation/ticket_detail_cubit.dart';
import 'package:ticket_manager_stalse/features/ticket/update/presentation/update_ticket_cubit.dart';
import '../../features/ticket/tickets/data/datasources/i_ticket_data_source.dart';
import '../../features/ticket/tickets/data/datasources/ticket_local_data_source.dart';
import '../../features/ticket/tickets/data/repositories/ticket_repository.dart';
import '../../features/ticket/tickets/domain/repositories/i_ticket_repository.dart';
import '../../features/ticket/tickets/domain/usecases/add_or_update_ticket_usecase.dart';
import '../../features/ticket/tickets/domain/usecases/get_tickets_usecase.dart';
import '../../features/ticket/tickets/presentation/tickets_cubit.dart';

final getIt = GetIt.instance;

Future<void> registerDeps() async {
  final box = await Hive.openBox('tickets');
  getIt.registerSingleton<IPersistenceService>(HivePersistenceService(box: box));

  final ticketLocalDataSource = TicketLocalDataSource(persistence: getIt());
  await ticketLocalDataSource.seed();
  getIt.registerLazySingleton<ITicketDataSource>(() => ticketLocalDataSource);

  getIt.registerLazySingleton<ITicketRepository>(() => TicketRepository(
    dataSource: getIt(),
  ));
  getIt.registerLazySingleton<IAddOrUpdateTicketUseCase>(() => AddOrUpdateTicketUseCase(
    repository: getIt()
  ));
  getIt.registerLazySingleton<IGetTicketsUseCase>(() => GetTicketsUseCase(
    repository: getIt()
  ));
  getIt.registerLazySingleton<TicketsCubit>(() => TicketsCubit(
   getTicketsUseCase: getIt(),
   addOrUpdateTicketUseCase: getIt(),
  ));

  getIt.registerFactory<AddTicketCubit>( () => AddTicketCubit(
    addOrUpdateTicketUseCase: getIt(),
  ));
  getIt.registerFactory<UpdateTicketCubit>( () => UpdateTicketCubit(
    addOrUpdateTicketUseCase: getIt(),
  ));

  getIt.registerLazySingleton<IDeleteTicketUseCase>(() => DeleteTicketUseCase(
      repository: getIt()
  ));
  getIt.registerFactory<TicketDetailCubit>( () => TicketDetailCubit(
    deleteTicketUseCase: getIt(),
  ));
}
