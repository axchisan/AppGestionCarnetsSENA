import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; // Importamos dotenv
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/registration_screen.dart';
import 'screens/home_screen.dart';
import 'screens/id_card_screen.dart';
import 'screens/device_management_screen.dart';
import 'utils/app_colors.dart';
import 'models/models.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(AprendizAdapter());
  Hive.registerAdapter(DispositivoAdapter());
  await Hive.openBox<Aprendiz>('aprendicesBox');
  
  // Inicializamos las variables de entorno desde el archivo .env
  await dotenv.load(fileName: ".env");
  
  runApp(const SenaApp());
}

class SenaApp extends StatelessWidget {
  const SenaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SENA Carnet Digital', // Actualizado al nombre elegido
      theme: ThemeData(
        primarySwatch: Colors.green,
        primaryColor: AppColors.senaGreen,
        fontFamily: 'Roboto',
        visualDensity: VisualDensity.adaptivePlatformDensity,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.white,
          foregroundColor: AppColors.black,
          elevation: 0,
        ),
      ),
      home: const SplashScreen(),
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/registro': (context) => const RegistrationScreen(),
        '/inicio': (context) {
          final args = ModalRoute.of(context)?.settings.arguments;
          if (args is Aprendiz) {
            return HomeScreen(aprendiz: args);
          }
          return const HomeScreen();
        },
        '/carnet': (context) {
          final args = ModalRoute.of(context)?.settings.arguments;
          if (args is Aprendiz) {
            return IdCardScreen(aprendiz: args);
          }
          return IdCardScreen(aprendiz: null);
        },
        '/dispositivos': (context) {
          final args = ModalRoute.of(context)?.settings.arguments;
          if (args is Aprendiz) {
            return DeviceManagementScreen(aprendiz: args);
          }
          return const DeviceManagementScreen();
        },
      },
      debugShowCheckedModeBanner: false,
    );
  }
}