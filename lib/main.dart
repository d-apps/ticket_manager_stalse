import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_ce/hive.dart';
import 'package:ticket_manager_stalse/core/di/register_deps.dart';
import 'package:ticket_manager_stalse/core/design/app_theme.dart';
import 'package:ticket_manager_stalse/core/routes/app_routes.dart';
import 'package:ticket_manager_stalse/features/base/presentation/base_page.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ticket_manager_stalse/features/ticket/add/presentation/add_ticket_cubit.dart';
import 'package:ticket_manager_stalse/features/ticket/add/presentation/add_ticket_page.dart';
import 'package:ticket_manager_stalse/features/ticket/detail/presentation/ticket_detail_cubit.dart';
import 'package:ticket_manager_stalse/features/ticket/detail/presentation/ticket_detail_page.dart';
import 'package:ticket_manager_stalse/features/ticket/tickets/domain/entities/ticket_entity.dart';
import 'package:ticket_manager_stalse/features/ticket/tickets/presentation/tickets_cubit.dart';
import 'package:ticket_manager_stalse/features/ticket/update/presentation/update_ticket_cubit.dart';
import 'package:ticket_manager_stalse/features/ticket/update/presentation/update_ticket_page.dart';

Future<void> initHive() async {
  final dir = await getApplicationDocumentsDirectory();
  Hive.init(dir.path);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initHive();
  await registerDeps();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<TicketsCubit>(create: (context) =>
          getIt()
            ..getTickets()),
          BlocProvider<AddTicketCubit>(create: (context) => getIt()),
          BlocProvider<UpdateTicketCubit>(create: (context) => getIt()),
          BlocProvider<TicketDetailCubit>(create: (context) => getIt()),
        ],
        child: MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightThemeData(),
            darkTheme: AppTheme.darkThemeData(),
            themeMode: ThemeMode.system,
            initialRoute: '/',
            routes: AppRoutes.makeRoutes()
        )
    );
  }
}
