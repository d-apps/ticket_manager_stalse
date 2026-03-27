import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_ce/hive.dart';
import 'package:ticket_manager_stalse/core/dependencies/register_deps.dart';
import 'package:ticket_manager_stalse/core/design/app_theme.dart';
import 'package:ticket_manager_stalse/features/base/presentation/base_page.dart';
import 'package:ticket_manager_stalse/features/tickets/presentation/tickets_cubit.dart';
import 'features/tickets/presentation/tickets_page.dart';
import 'package:path_provider/path_provider.dart';

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
    return BlocProvider(
      create: (context) => GetIt.instance.get<TicketsCubit>()..getTickets(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightThemeData(),
        darkTheme: AppTheme.darkThemeData(),
        themeMode: ThemeMode.system,
        home: const BasePage(),
      ),
    );
  }
}
