// ─────────────────────────────────────────────────────────────────────────────
//  Hola Mundo en Flutter — demo para la exposición "Dart y Flutter"
//  Universidad Nacional de Colombia · Desarrollo de Aplicaciones Móviles
//
//  Idea central: en Flutter TODO es un widget. La app es un árbol de widgets
//  que se vuelve a dibujar cuando cambia el estado.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';

/// 1. PUNTO DE ENTRADA
/// Igual que `main` en Kotlin o Java: es lo primero que se ejecuta.
/// `runApp` recibe el widget raíz y lo pinta en la pantalla completa.
void main() {
  runApp(const HolaMundoApp());
}

/// 2. WIDGET RAÍZ (StatelessWidget = no cambia por sí mismo)
/// Configura el tema (Material Design 3) y cuál es la pantalla inicial.
/// Equivale al `AndroidManifest` + `themes.xml` de un proyecto nativo.
class HolaMundoApp extends StatelessWidget {
  const HolaMundoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hola Mundo Flutter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1E5AA8)),
      ),
      home: const PantallaInicio(),
    );
  }
}

/// 3. PANTALLA CON ESTADO (StatefulWidget = puede cambiar en el tiempo)
/// Equivale a una Activity / Fragment con su ViewModel, pero sin XML:
/// la interfaz se declara en código Dart.
class PantallaInicio extends StatefulWidget {
  const PantallaInicio({super.key});

  @override
  State<PantallaInicio> createState() => _PantallaInicioState();
}

class _PantallaInicioState extends State<PantallaInicio> {
  // Estado de la pantalla: cuántas veces se ha saludado.
  int _saludos = 0;

  // Idiomas para mostrar que el texto cambia con el estado.
  static const List<String> _idiomas = [
    '¡Hola, Mundo!',
    'Hello, World!',
    'Olá, Mundo!',
    'Bonjour, le Monde!',
  ];

  /// 4. setState: avisa a Flutter que el estado cambió.
  /// Flutter vuelve a ejecutar `build` y redibuja solo lo necesario.
  /// (En Android nativo esto sería: LiveData/StateFlow + observe + binding).
  void _saludar() {
    setState(() {
      _saludos++;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colores = Theme.of(context).colorScheme;
    final mensaje = _idiomas[_saludos % _idiomas.length];

    // 5. ÁRBOL DE WIDGETS
    // Scaffold = estructura Material (AppBar, cuerpo, botón flotante).
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hola Mundo · Flutter'),
        backgroundColor: colores.primaryContainer,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.phone_android, size: 72, color: colores.primary),
              const SizedBox(height: 24),
              Text(
                mensaje,
                key: const Key('mensaje'),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 12),
              Text(
                'Saludos enviados: $_saludos',
                key: const Key('contador'),
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 32),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'Un solo código en Dart  →  Android, iOS, Web y Escritorio',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: colores.onSurfaceVariant),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _saludar,
        icon: const Icon(Icons.waving_hand),
        label: const Text('Saludar'),
      ),
    );
  }
}
