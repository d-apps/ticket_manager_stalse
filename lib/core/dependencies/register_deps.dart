import 'package:get_it/get_it.dart';
import 'package:hive_ce/hive.dart';
import 'package:ticket_manager_stalse/core/services/hive_persistence_service.dart';
import 'package:ticket_manager_stalse/core/services/persistence_service.dart';
import 'package:ticket_manager_stalse/features/tickets/data/datasources/i_ticket_data_source.dart';
import 'package:ticket_manager_stalse/features/tickets/data/datasources/ticket_local_data_source.dart';

import '../../features/tickets/data/repositories/ticket_repository.dart';
import '../../features/tickets/domain/repositories/i_ticket_repository.dart';
import '../../features/tickets/domain/usecases/add_ticket_usecase.dart';
import '../../features/tickets/domain/usecases/get_tickets_usecase.dart';
import '../../features/tickets/domain/usecases/update_ticket_usecase.dart';
import '../../features/tickets/presentation/tickets_cubit.dart';

final getIt = GetIt.instance;

Future<void> registerDeps() async {
  final box = await Hive.openBox('tickets');
  getIt.registerSingleton<IPersistenceService>(HivePersistenceService(box: box));
  final ticketLocalDataSource = TicketLocalDataSource(persistence: getIt.get());
  await ticketLocalDataSource.seed();
  getIt.registerLazySingleton<ITicketDataSource>(() => ticketLocalDataSource);
  getIt.registerLazySingleton<ITicketRepository>(() => TicketRepository(
    dataSource: getIt.get(),
  ));
  getIt.registerLazySingleton<IAddTicketUseCase>(() => AddTicketUseCase(
    repository: getIt.get(),
  ));
  getIt.registerLazySingleton<IGetTicketsUseCase>(() => GetTicketsUseCase(
    repository: getIt.get() 
  ));
  getIt.registerLazySingleton<IUpdateTicketUseCase>(() => UpdateTicketUseCase(
    repository: getIt.get()
  ));
  getIt.registerLazySingleton<TicketsCubit>(() => TicketsCubit(
   getTicketsUseCase: getIt.get(),
   addTicketUseCase: getIt.get(),
   updateTicketUseCase: getIt.get(),
  ));

}
