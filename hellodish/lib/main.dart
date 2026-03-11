import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'features/home/HomeViewModel.dart';
import 'features/location/AddressViewModel.dart';
import 'features/menu/viewmodel/MenuViewModel.dart';
import 'features/splash/view/splash_screen.dart';

import 'features/auth/login/viewmodel/login_viewmodel.dart';
import 'features/splash/viewmodel/splash_view_model.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const HellodishApp());
}

class HellodishApp extends StatelessWidget {
  const HellodishApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SplashViewModel()),
        ChangeNotifierProvider(create: (_) => LoginViewModel()),
        ChangeNotifierProvider(create: (_) => MenuViewModel()),
        ChangeNotifierProvider(create: (_) => AddressViewModel()),
        ChangeNotifierProvider(create: (_) => HomeViewModel()),
      ],
      child: MaterialApp(
        title: 'Hellodish',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Poppins',
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFFDB1D1D),
          ),
          useMaterial3: true,
        ),
        home: const SplashScreen(),
      ),
    );
  }
}