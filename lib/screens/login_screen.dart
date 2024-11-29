import 'package:flutter/material.dart';
import '../controllers/auth_controller.dart';
import '../services/api_service.dart';
import 'menu_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthController authController = AuthController(ApiService());

  void _login() async {
    try {
      final user = await authController.login(
        _usernameController.text,
        _passwordController.text,
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MenuScreen(),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al iniciar sesión")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Iniciar Sesión')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _usernameController, decoration: InputDecoration(labelText: 'Usuario')),
            TextField(controller: _passwordController, decoration: InputDecoration(labelText: 'Contraseña'), obscureText: true),
            SizedBox(height: 20),
            ElevatedButton(onPressed: _login, child: Text('Ingresar')),
          ],
        ),
      ),
    );
  }
}
