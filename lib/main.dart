import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/cuts_provider.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CutsProvider()),
      ],
      child: MaterialApp(
        title: 'App Cortes',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: LoginScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
