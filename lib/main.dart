import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_todo_c9_mon/auth/login/login_screen.dart';
import 'package:flutter_app_todo_c9_mon/auth/register/register_screen.dart';
import 'package:flutter_app_todo_c9_mon/home/home_screen.dart';
import 'package:flutter_app_todo_c9_mon/my_theme.dart';
import 'package:flutter_app_todo_c9_mon/providers/auth_provider.dart';
import 'package:flutter_app_todo_c9_mon/providers/list_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // FirebaseFirestore.instance.settings =
  //     Settings(cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED);
  // await FirebaseFirestore.instance.disableNetwork();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => ListProvider()),
      ChangeNotifierProvider(create: (context) => AuthProvider()),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: LoginScreen.routeName,
      routes: {
        HomeScreen.routeName: (context) => HomeScreen(),
        LoginScreen.routeName: (context) => LoginScreen(),
        RegisterScreen.routeName: (context) => RegisterScreen(),
      },
      theme: MyTheme.lightTheme,
    );
  }
}
