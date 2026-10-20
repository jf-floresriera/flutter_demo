# Guion del demo — Hola Mundo en Flutter

**Expositor:** Jesús · **Duración sugerida:** 5–6 minutos · **Herramienta:** Android Studio

Cada momento tiene tres partes:

- **Diapositiva** — texto corto para copiar y pegar.
- **En pantalla** — qué hacer en Android Studio.
- **Qué digo** — el texto para decir, en voz natural. No hay que memorizarlo palabra por palabra.

---

## Antes de empezar (checklist del día)

Lo que más falla en un demo en vivo es el primer build de Gradle, que puede tardar varios
minutos. Todo esto se hace **antes** de entrar al salón:

- [ ] `flutter doctor` sin errores.
- [ ] Proyecto abierto en Android Studio y **ya ejecutado una vez** (el segundo build es rápido).
- [ ] Emulador **encendido** desde *Device Manager* (arrancarlo en vivo toma tiempo).
- [ ] Modo presentación para que el código se lea desde atrás:
      *View → Appearance → Enter Presentation Mode*.
- [ ] Plan B: el APK descargado de GitHub Actions instalado en el celular, y un video corto
      del demo grabado con el emulador.
- [ ] Terminal de Android Studio abierta en la carpeta del proyecto.

---

## Momento 1 — ¿Qué se necesita? (≈ 40 s)

**Diapositiva**

> **Para desarrollar en Flutter se necesita:**
> 1. Flutter SDK (incluye Dart)
> 2. Android Studio + plugins Flutter y Dart
> 3. Un emulador o un celular con depuración USB
> 4. `flutter doctor` en verde
>
> **Dónde se compila:** Android Studio · terminal · GitHub Actions (nube) · DartPad (navegador)

**En pantalla:** la diapositiva; luego la terminal con `flutter doctor` ya ejecutado.

**Qué digo**

> "Mis compañeros ya explicaron qué es Dart y qué es Flutter. Ahora vamos a ver qué hace falta
> para pasar de una línea de código a una app instalada en el teléfono.
> Son cuatro cosas: el SDK de Flutter, que ya trae Dart adentro; Android Studio con dos plugins,
> Flutter y Dart; un emulador o un celular; y este comando, `flutter doctor`, que revisa que
> todo esté bien conectado. Si todo sale en verde, estamos listos para programar."

---

## Momento 2 — Estructura del proyecto (≈ 50 s)

**Diapositiva**

> **Un proyecto Flutter**
> `lib/main.dart` → la app completa
> `pubspec.yaml` → dependencias (como `build.gradle`)
> `android/` → proyecto Android anfitrión con **una sola Activity**
> `test/` → pruebas

**En pantalla:** panel *Project* a la izquierda. Expandir y señalar, en este orden:
`lib/main.dart` → `pubspec.yaml` → `android/app/src/main/java/.../MainActivity.java` → `test/`.

**Qué digo**

> "Así se ve un proyecto recién creado con `flutter create`. Lo importante está en `lib`: todo
> el código de la app está en `main.dart`.
> `pubspec.yaml` cumple el papel de `build.gradle`: aquí van el nombre, la versión y las
> librerías.
> Y miren esto, que conecta con lo que vimos en la materia: dentro de `android` hay un proyecto
> Android normal, con Gradle y con **una sola** Activity, `MainActivity`, que está vacía. Flutter
> no usa layouts XML ni Fragments: dibuja toda la interfaz dentro de esa única Activity con su
> propio motor gráfico."

---

## Momento 3 — El código, en cuatro bloques (≈ 1 min 30 s)

**Diapositiva**

> **En Flutter todo es un widget**
> `main()` → `runApp()` → `MaterialApp` → `Scaffold` → `Column` → `Text`
> **StatelessWidget:** no cambia · **StatefulWidget:** cambia con `setState()`

**En pantalla:** abrir `lib/main.dart` y bajar bloque por bloque.

| Bloque | Líneas a señalar | Qué digo |
|---|---|---|
| **1. Entrada** | `void main()` y `runApp(...)` | "Como en Kotlin, todo empieza en `main`. `runApp` recibe el widget raíz y lo pinta en toda la pantalla." |
| **2. Widget raíz** | `class HolaMundoApp extends StatelessWidget` y `ThemeData(useMaterial3: true …)` | "Este widget no cambia, por eso es *Stateless*. Aquí se define el tema con Material Design 3 a partir de un solo color. Es lo que en Android hacíamos con `themes.xml`." |
| **3. Pantalla con estado** | `class PantallaInicio extends StatefulWidget` y `int _saludos = 0;` | "Esta pantalla sí cambia: guarda cuántas veces hemos saludado. Es el equivalente a una Activity con su ViewModel." |
| **4. setState y build** | `_saludar()` con `setState(...)` y luego `Scaffold`, `AppBar`, `Column`, `FloatingActionButton` | "Cuando toco el botón, `setState` le avisa a Flutter que el estado cambió, y Flutter vuelve a ejecutar `build`. La interfaz no se modifica a mano como con `findViewById`: se describe cómo debe verse según el estado, y Flutter se encarga del resto." |

---

## Momento 4 — Ejecutar en el emulador (≈ 40 s)

**En pantalla:** seleccionar el emulador en la lista de dispositivos (barra superior) → **Run ▶**.
Mientras compila, mostrar la pestaña *Run* abajo.

**Qué digo** (mientras compila)

> "Ahora le doy Run. Por debajo, Android Studio está ejecutando `flutter run`: Gradle construye
> el proyecto Android, empaqueta el código Dart y lo instala en el emulador.
> En modo debug, Dart corre sobre una máquina virtual que permite cambiar el código en caliente;
> en modo release se compila a código máquina nativo, por eso las apps de Flutter son rápidas."

Cuando aparezca la app, tocar **Saludar** tres veces.

> "Ahí está. Cada vez que toco Saludar, cambia el idioma y sube el contador."

---

## Momento 5 — Hot reload, el momento fuerte (≈ 1 min)

**Diapositiva**

> **Hot reload:** el cambio aparece en menos de un segundo y **conserva el estado**
> `r` hot reload · `R` hot restart (reinicia el estado)

**En pantalla**

1. Con el contador en 3, ir a `main.dart` y, dentro del `AppBar`, cambiar
   `'Hola Mundo · Flutter'` por `'Hola UNAL · Flutter'`.
2. Cambiar `seedColor: const Color(0xFF1E5AA8)` por `seedColor: Colors.green`.
3. Guardar con **Ctrl + S**.
4. Señalar el emulador: el color cambió y **el contador sigue en 3**.
5. Pulsar el botón **Hot Restart** (flecha circular) → el contador vuelve a 0.

**Qué digo**

> "Esto es lo que más llama la atención de Flutter. Tengo el contador en 3. Cambio el título y el
> color del tema… guardo… y en menos de un segundo el cambio está en el teléfono, **sin perder el
> contador**. En Android nativo tendríamos que recompilar y volver a navegar hasta esta pantalla.
> Si quiero empezar desde cero, uso hot restart, y ahí sí el estado se reinicia."

---

## Momento 6 — Probar, compilar y desplegar (≈ 1 min)

**Diapositiva**

> **Del código al teléfono**
> `flutter test` → pruebas sin emulador
> `flutter build apk --release` → APK instalable
> `flutter build appbundle` → Google Play
> GitHub Actions → compila en la nube en cada push

**En pantalla**

1. Terminal: `flutter test` → mostrar `All tests passed!`.
2. Terminal: `flutter build apk --release` (si toma mucho, mostrar el APK ya generado en
   `build/app/outputs/flutter-apk/`).
3. Navegador: `github.com/jf-floresriera/flutter_demo` → pestaña **Actions** → último run →
   sección **Artifacts** → `hola-flutter-apk`.

**Qué digo**

> "Flutter también trae pruebas: esta prueba toca el botón sin emulador y verifica que el texto
> cambie. Con `flutter build apk` obtenemos el APK para instalar en cualquier celular, y con
> `appbundle` el formato que pide Google Play.
> Y la respuesta a dónde compilar: además de Android Studio, este repositorio compila solo en la
> nube. Cada vez que subo un cambio a GitHub, GitHub Actions instala Flutter, corre las pruebas y
> deja el APK listo para descargar. No hace falta tener nada instalado para obtenerlo."

---

## Momento 7 — Transición a la app real (≈ 15 s)

**Qué digo**

> "Esto fue un Hola Mundo. Ahora les muestro cómo se ven estas mismas ideas en una aplicación
> real que estoy desarrollando, y cómo se relacionan con cada tema que vimos en la materia."

→ Continuar con [`PURDUE_MAIZE_EN_LA_MATERIA.md`](PURDUE_MAIZE_EN_LA_MATERIA.md).

---

## Si algo falla en vivo

| Problema | Qué hacer |
|---|---|
| El build tarda demasiado | Seguir hablando del Momento 3 y volver al emulador después. |
| El emulador no arranca | Usar el celular con el APK de Actions ya instalado. |
| Error de Gradle | No depurar en vivo: mostrar el video de respaldo y seguir. |
| Hot reload no refleja el cambio | Cambios en `main()` o en el `initState` requieren **hot restart**: decirlo como parte de la explicación. |
