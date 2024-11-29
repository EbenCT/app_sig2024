import 'package:flutter/material.dart';
import '../controllers/auth_controller.dart';
import '../services/api_service.dart';
import '../models/user.dart';
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
      final User user = await authController.login(
        _usernameController.text,
        _passwordController.text,
      );

      if (user.status == 'OK') {
        // Usuario autenticado correctamente, navegar al menú principal.
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MenuScreen(user: user),
          ),
        );
      } else {
        // Manejo de errores según el estado devuelto.
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: ${user.status}")),
        );
      }
    } catch (e) {
      print(e);
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Usuario'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Contraseña'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              child: Text('Ingresar'),
            ),
          ],
        ),
      ),
    );
  }
}
