// Prueba de widget: Flutter puede "tocar" la interfaz sin emulador.
// Se ejecuta con:  flutter test

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_demo/main.dart';

void main() {
  testWidgets('El botón Saludar cambia el mensaje y el contador',
      (WidgetTester tester) async {
    // Construye la app en memoria.
    await tester.pumpWidget(const HolaMundoApp());

    // Estado inicial.
    expect(find.text('¡Hola, Mundo!'), findsOneWidget);
    expect(find.text('Saludos enviados: 0'), findsOneWidget);

    // Toca el botón y redibuja.
    await tester.tap(find.byIcon(Icons.waving_hand));
    await tester.pump();

    // El estado cambió.
    expect(find.text('Hello, World!'), findsOneWidget);
    expect(find.text('Saludos enviados: 1'), findsOneWidget);
  });
}
