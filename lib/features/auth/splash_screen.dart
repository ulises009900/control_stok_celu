import 'package:flutter/material.dart';

/// Pantalla neutra que se muestra brevemente mientras se resuelve si hay una
/// sesión activa guardada en el dispositivo, antes de decidir si mandar al
/// usuario a Inicio o a la pantalla de login.
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
