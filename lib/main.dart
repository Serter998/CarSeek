import 'package:car_seek/core/themes/app_theme.dart';
import 'package:car_seek/di.dart';
import 'package:car_seek/features/auth/presentation/blocs/auth_bloc.dart';
import 'package:car_seek/features/auth/presentation/screens/auth_screen.dart';
import 'package:car_seek/features/home/presentation/screens/home_screen.dart';
import 'package:car_seek/supabase_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';

import 'core/constants/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Cargar las variables de entorno desde el archivo .env
  await dotenv.load(fileName: ".env");

  // Inicializar Supabase (configuración de backend) antes de iniciar la app
  await SupabaseConfig.init();

  // Inicializar dependencias de GetIt
  await init();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => GetIt.instance.get<AuthBloc>())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme(selectedColor: 0).theme(),
        title: "CarSeek",
        routes: {
          AppRoutes.initial: (context) => const AuthScreen(),
          AppRoutes.home: (context) => const HomeScreen(),
        },
        initialRoute: AppRoutes.initial,
      ),
    );
  }
}
