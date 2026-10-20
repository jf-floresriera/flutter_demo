# Purdue Maize — los temas de la materia en una app real

**Expositor:** Jesús · **Duración sugerida:** 6–7 minutos
**Repositorio:** [github.com/jf-floresriera/purdue-maize](https://github.com/jf-floresriera/purdue-maize)

Cada diapositiva tiene:

- **Tema de la materia** que se demuestra.
- **Pantallazo** — en qué pantalla de la app tomarlo (ruta de navegación).
- **Nube de código** — fragmento corto, real, del repositorio (recortado con `…`).
- **Explicación** — 1–2 líneas para la diapositiva.
- **Qué digo**.

> **Regla para no saturar:** una diapositiva = un pantallazo a la izquierda + **una** nube de
> código a la derecha (máximo ~12 líneas) + una frase. El backend solo aparece en dos
> diapositivas (★ 6 y ★ 9), en una nube pequeña al lado del código Flutter.

Las diapositivas marcadas con ★ son las imprescindibles. Las demás, solo si sobra tiempo.

---

## Mapa general (una diapositiva)

| Tema de la materia | Dónde está en Purdue Maize | Reto relacionado |
|---|---|---|
| Prototipado · GUI · Material Design | Tema Purdue, `NavigationBar`, `Card` | — |
| Arquitectura · MVVM | Carpetas `data / domain / presentation` + Riverpod | — |
| Activity · Splash · Navigation | `MainActivity` única, `SplashScreen`, `go_router` | Reto 0 |
| RecyclerView · CardView · Adapter | `ListView.builder` + `Card` en *Data Capture* | — |
| Diálogos y envío de datos | `showDialog<bool>` | Reto 4 |
| Gráficos y sonidos | `fl_chart`, `record`, `just_audio`, `image_picker` | Reto 5 |
| Persistencia local (SQLite) | Drift sobre SQLite | **Reto 8** |
| Persistencia en la nube | FastAPI + PostgreSQL/PostGIS (en lugar de Firebase) | Reto 7 |
| Webservices · Open Data | Dio, NASA POWER, Sentinel-2 | Reto 10 |
| Mapas | `flutter_map` + OpenStreetMap | — |
| GPS | `geolocator` | **Reto 9** |
| Autenticación | JWT + almacenamiento cifrado | Reto 12 |
| IA generativa | Transcripción de audio + subproyecto LLM | Reto 11 |

**Qué digo**

> "Purdue Maize es la aplicación de mi tesis de maestría: sirve para muestrear cultivos de maíz,
> registrar enfermedades en campo, aunque no haya internet, y luego analizarlas. En esta tabla
> está cada tema de la materia y dónde aparece en la app. Voy a mostrar los más importantes."

---

## ★ 1. Presentación de la app

**Pantallazo:** pantalla de **splash** (logo y logos de Purdue, UNAL y USDA) y la de **login**,
lado a lado.

**Explicación para la diapositiva**

> App Flutter offline-first para monitorear enfermedades del maíz.
> Frontend: Flutter + Riverpod + Drift · Backend: FastAPI + PostgreSQL/PostGIS · Docker

**Qué digo**

> "La app arranca con un splash y un login. Lo importante es que está pensada para trabajar en
> el campo, donde casi nunca hay señal: todo se guarda primero en el teléfono y se sincroniza
> cuando vuelve la conexión."

---

## ★ 2. Material Design, tema y BottomNavigationView

**Tema de la materia:** Material Design y Material Components · Shapes · AppBar · BottomNavigationView

**Pantallazo:** pestaña **Data** (pantalla principal con las tarjetas *Sampling*, *Data
Capture*, *Data Explorer*…) mostrando la barra inferior con **Data · Modeling · Decisions**.

**Nube de código** — `purdue_maize_app/lib/shared/widgets/main_scaffold.dart`

```dart
return Scaffold(
  body: child,
  bottomNavigationBar: NavigationBar(
    selectedIndex: _indexFromPath(location),
    onDestinationSelected: (i) => _navigate(context, i),
    destinations: const [
      NavigationDestination(icon: Icon(Icons.storage_outlined),   label: 'Data'),
      NavigationDestination(icon: Icon(Icons.analytics_outlined), label: 'Modeling'),
      NavigationDestination(icon: Icon(Icons.fact_check_outlined), label: 'Decisions'),
    ],
  ),
);
```

*Opcional, segunda nube pequeña* — `lib/core/theme/purdue_theme.dart`

```dart
cardTheme: CardThemeData(
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
),
```

**Explicación:** `NavigationBar` es el `BottomNavigationView` de Material 3. Las *Shapes* se
definen una vez en el tema y aplican a toda la app.

**Qué digo**

> "En la materia hicimos el `BottomNavigationView` con un menú en XML. En Flutter es un widget
> más: `NavigationBar`, con sus tres destinos. Y la personalización con *Shapes* se hace en un
> solo lugar, el tema: aquí todas las tarjetas tienen esquinas de 12 píxeles."

---

## ★ 3. Arquitectura MVVM

**Tema de la materia:** Paradigma MVVM · Carga de datos desde el ViewModel · Estructura de una app

**Pantallazo:** el árbol de carpetas de `lib/features/data_explorer/` en Android Studio
(`data/` y `presentation/`), junto a la pantalla **Data → Data Explorer**.

**Nube de código** — `lib/features/data_explorer/data/data_explorer_provider.dart` y su pantalla

```dart
// ViewModel: obtiene los datos de la base local
final dataExplorerObservationsProvider =
    FutureProvider.family<List<DataExplorerRow>, DataExplorerFilter>((ref, filter) async {
  final observations = await ref.watch(observationRepositoryProvider).query(
        diseaseId: filter.diseaseId, from: filter.from, to: filter.to);
  …
});

// View: observa al ViewModel y se redibuja sola
observationsAsync.when(
  loading: () => const Center(child: CircularProgressIndicator()),
  error:   (e, _) => Center(child: Text('$e')),
  data:    (rows) => TabBarView(children: [_ChartsTab(rows: rows), _TableTab(rows: rows)]),
);
```

**Explicación**

| MVVM en Android | En Purdue Maize |
|---|---|
| Model / Repository | `ObservationRepository` + Drift |
| ViewModel | *Provider* de Riverpod |
| LiveData / StateFlow + `observe` | `ref.watch(...)` |
| View (Activity / Fragment) | Widget de la pantalla |

**Qué digo**

> "La app sigue MVVM. Cada funcionalidad tiene su carpeta `data`, con repositorios y la lógica,
> y `presentation`, con las pantallas. El papel del ViewModel lo hace un *provider* de Riverpod.
> La pantalla lo observa con `ref.watch` y con `.when` maneja los tres estados: cargando, error y
> datos. Es exactamente la idea de `LiveData` y `observe`, pero sin escribir el observador a mano."

---

## ★ 4. RecyclerView, CardView y Adapter

**Tema de la materia:** RecyclerView · CardView · Adaptadores · ViewBinding

**Pantallazo:** **Data → Data Capture**, con la lista de observaciones (tarjetas con el punto
naranja = pendiente de sincronizar, verde = sincronizada).

**Nube de código** — `lib/features/data_capture/presentation/screens/data_capture_screen.dart`

```dart
return ListView.builder(
  padding: const EdgeInsets.all(16),
  itemCount: observations.length,
  itemBuilder: (context, i) => _ObservationTile(obs: observations[i]),
);

// _ObservationTile: el "ViewHolder"
return Card(
  child: ListTile(
    leading: … color: obs.syncStatus == 'pending'
        ? PurdueColors.riskMedium : PurdueColors.riskLow,
    title: Text(obs.variableName ?? …),
  ),
);
```

**Explicación:** `ListView.builder` recicla elementos como `RecyclerView`; `itemBuilder`
reemplaza al `Adapter` + `ViewHolder`, y no hace falta `ViewBinding` porque no hay XML.

**Qué digo**

> "Esta es la lista de observaciones. En Android necesitábamos el `RecyclerView`, un `Adapter`,
> un `ViewHolder`, el layout del `CardView` y el `ViewBinding`. En Flutter son cinco líneas:
> `ListView.builder` recibe cuántos elementos hay y una función que construye cada tarjeta.
> También recicla, solo construye lo que se ve en pantalla."

---

## ★ 5. Persistencia local con SQLite (Reto 8)

**Tema de la materia:** Persistencia local

**Pantallazo:** **Data → Data Capture** con el banner de sincronización y varias observaciones
pendientes (tomarlo con el **modo avión activado** para que se vea que funciona sin internet).

**Nube de código** — `lib/core/database/tables/observation_tables.dart` y `daos/observation_dao.dart`

```dart
// Tabla SQLite, definida en Dart
class LocalObservations extends Table {
  TextColumn get id => text()();                       // UUID
  RealColumn get incidencePct => real().nullable()();  // % plantas afectadas
  DateTimeColumn get observedAt => dateTime()();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();
  @override Set<Column> get primaryKey => {id};
}

// DAO: consultas tipadas, sin SQL a mano
Future<List<LocalObservation>> getPending() =>
    (select(localObservations)..where((t) => t.syncStatus.equals('pending'))).get();
```

**Explicación:** Drift es a Flutter lo que Room es a Android: tablas y DAOs en código, SQLite
por debajo.

**Qué digo**

> "Esto se conecta directamente con el reto 8. La app usa SQLite a través de Drift, que es el
> equivalente de Room. La tabla se define en Dart, y el DAO hace las consultas sin escribir SQL a
> mano. Fíjense en `syncStatus`: todo registro nace como `pending`. Por eso puedo tomar datos
> en modo avión, como en este pantallazo."

---

## ★ 6. Persistencia en la nube y sincronización

**Tema de la materia:** Persistencia en la nube · Firebase / Cloud Firestore

**Pantallazo:** el banner de sincronización pasando a "sincronizado" (o la hoja inferior que se
abre al tocar el indicador de sincronización), y si se quiere, **Adminer** en el navegador
(`localhost:8080`) mostrando la tabla `observations` en el servidor.

**Nube de código (Flutter)** — `lib/core/sync/sync_service.dart`

```dart
// Al recuperar conexión, sube lo pendiente
connectivity.onConnectivityChanged.listen((results) {
  final isOnline = results.any((r) => r != ConnectivityResult.none);
  if (isOnline) syncAll();
});
…
final pendingObs = await obsRepo.getPendingObservations();
for (final obs in pendingObs) {
  await obsRepo.syncObservation(obs);
}
```

**Nube de código (backend, pequeña)** — `purdue_maize_api/app/api/v1/endpoints/observations.py`

```python
@router.post("/", response_model=ObservationOut, status_code=201)
async def create_observation(payload: ObservationCreate,
                             user_id: str = Depends(get_current_user_id), …):
    quality_status, quality_flags = evaluate_observation(payload, …)
```

**Explicación:** en vez de Firebase, un backend propio (FastAPI + PostgreSQL/PostGIS en Docker).
El servidor clasifica cada dato como `valid / dubious / discarded` y **nunca lo borra**.

**Qué digo**

> "En la materia usamos Firebase y Firestore para la nube. Aquí hice lo mismo con un backend
> propio, porque necesitaba datos geográficos. Cuando el teléfono recupera la conexión, el
> servicio de sincronización sube lo pendiente. En el servidor, cada observación pasa un control
> de calidad automático. La idea de fondo es la misma que Firestore con caché offline: primero
> local, después nube."

---

## ★ 7. Consumo de Webservices y Open Data

**Tema de la materia:** Integración con iniciativas Open Data · Consumo de Webservices

**Pantallazo:** **Modeling → Tar Spot** (simulador) mostrando datos de clima, o **Data →
Satellite** con la lista de escenas Sentinel-2.

**Nube de código** — `lib/core/network/api_client.dart`

```dart
final dio = Dio(BaseOptions(
  baseUrl: baseUrl,                       // http://10.0.2.2:8000/api/v1 en el emulador
  connectTimeout: const Duration(seconds: 10),
  headers: {
    if (token != null) 'Authorization': 'Bearer $token',
    'Content-Type': 'application/json',
  },
));

Future<List<ApiFieldSummary>> getFields() async { … }
Future<Map<String, dynamic>> getWeatherPoint({ … }) async { … }
```

**Explicación:** Dio es el Retrofit de Flutter. El servidor, a su vez, consume datos abiertos
de **NASA POWER** (clima) y **Sentinel-2** (satélite, vía Microsoft Planetary Computer).

**Qué digo**

> "Para consumir servicios web uso Dio, que cumple el papel de Retrofit. Un detalle que
> aprendimos en clase: desde el emulador, `localhost` es el propio emulador, por eso la
> dirección es `10.0.2.2`. Y la app sí usa datos abiertos: el clima viene de NASA POWER y las
> imágenes de satélite de Sentinel-2, ambos gratuitos y públicos."

---

## ★ 8. Mapas con OpenStreetMap + GPS (Reto 9)

**Tema de la materia:** API Open Street Maps · Acceso al GPS

**Pantallazo:** **Data → Sampling → nuevo campo** (*New field*), con el polígono del lote
dibujado sobre el mapa y el marcador de la ubicación actual. Segunda opción: **Data → Sampling
→ mapa** con los puntos de muestreo.

**Nube de código** — `lib/features/fields/presentation/screens/field_editor_screen.dart`

```dart
FlutterMap(
  options: MapOptions(onTap: (_, point) => _handleTap(point)),
  children: [
    TileLayer(urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png'),
    PolygonLayer(polygons: [Polygon(points: _vertices, borderStrokeWidth: 3)]),
  ],
);

// GPS: recorrer el borde del lote caminando
Geolocator.getPositionStream(
  locationSettings: const LocationSettings(accuracy: LocationAccuracy.high, distanceFilter: 5),
).listen((p) => setState(() => _vertices.add(LatLng(p.latitude, p.longitude))));
```

**Explicación:** mapa con OpenStreetMap (sin llave de Google). El borde del lote se dibuja
tocando el mapa o **caminando**: el GPS agrega un vértice cada 5 metros.

**Qué digo**

> "Para mapas usé OpenStreetMap, que vimos como alternativa a Google Maps y no necesita llave de
> API. Con el GPS, que es el reto 9, se puede caminar alrededor del lote: cada cinco metros se
> agrega un vértice y al final queda dibujado el polígono del campo."

---

## ★ 9. Autenticación (Reto 12)

**Tema de la materia:** Delegando la autenticación

**Pantallazo:** pantalla de **login**, y el menú de cuenta (cajón lateral) con el usuario
conectado y la opción *Sign out*.

**Nube de código (Flutter)** — `lib/core/auth/auth_provider.dart`

```dart
final _storage = const FlutterSecureStorage(
  aOptions: AndroidOptions(encryptedSharedPreferences: true),
);
…
final token = await _storage.read(key: _kTokenKey);
if (token == null) return const AuthState();      // → pantalla de login
```

**Nube de código (backend, pequeña)** — `purdue_maize_api/app/core/security.py`

```python
def create_access_token(subject: str) -> str:
    expire = datetime.now(timezone.utc) + timedelta(minutes=…)
    return jwt.encode({"sub": subject, "exp": expire}, SECRET_KEY, algorithm=ALGORITHM)
```

**Explicación:** el servidor emite un token JWT; el teléfono lo guarda cifrado y lo envía en
cada petición. Si el token vence (401), la app vuelve sola al login.

**Qué digo**

> "La autenticación funciona con tokens JWT. El servidor firma un token con fecha de vencimiento,
> y el teléfono lo guarda cifrado. Si el servidor responde 401, la app cierra la sesión y vuelve
> al login automáticamente. Es lo mismo que haremos en el reto 12 delegando en un proveedor."

---

## Si sobra tiempo

### 10. Diálogos y envío de datos (Reto 4)

**Pantallazo:** **Data → Data Capture → ícono de subir archivo** en la barra superior
(*Import CSV / Excel*), con el diálogo abierto.

```dart
final result = await showDialog<bool>(
  context: context,
  builder: (context) => const _ImportCsvModalDialog(),
);
if (result == true) {
  ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('CSV imported successfully!')));
}
```

> "El diálogo devuelve un valor con `Navigator.of(context).pop(true)` y la pantalla lo recibe con
> `await`. Es el envío y recepción de datos a diálogos, sin interfaces de callback."

### 11. Splash screen y ciclo de vida

**Pantallazo:** el splash.

```dart
// Mantiene el splash el tiempo suficiente para leerse
final splashMinimumProvider = FutureProvider<void>((ref) async {
  await Future<void>.delayed(const Duration(milliseconds: 3000));
});
```

> "Toda la app vive en una sola `MainActivity`; el splash y las demás pantallas son widgets que
> `go_router` intercambia, como el componente Navigation de Jetpack."

### 12. Gráficos y sonidos (Reto 5)

**Pantallazo:** **Data → Data Explorer → pestaña de gráficas**, y el formulario de observación
con el grabador de audio.

> "Las gráficas usan `fl_chart`; en campo se pueden adjuntar fotos con `image_picker` y notas de
> voz con `record`, que luego se reproducen con `just_audio`."

### 13. IA generativa (Reto 11)

**Pantallazo:** la app todavía no muestra la transcripción en pantalla, así que aquí va el
grabador de audio del formulario de observación, o la carpeta `purdue_maize_llm/` en Android
Studio.

> "Las notas de voz se transcriben en el servidor con un modelo de reconocimiento de voz, y el
> proyecto incluye un subproyecto de investigación para entrenar un modelo de lenguaje pequeño
> que dé recomendaciones fitosanitarias dentro del mismo teléfono."

---

## Cierre (≈ 20 s)

**Diapositiva**

> **Lo mismo que vimos en Kotlin, en Flutter:**
> Activity → Widget · ViewModel → Provider · RecyclerView → ListView.builder
> Room → Drift · Retrofit → Dio · BottomNavigationView → NavigationBar
> **Un solo código para Android, iOS, web y escritorio.**

**Qué digo**

> "Para cerrar: todos los conceptos de la materia siguen existiendo en Flutter, solo cambian de
> nombre. Lo que cambia de verdad es que la interfaz se escribe como código, que el hot reload
> acelera muchísimo el desarrollo, y que el mismo código sirve para varias plataformas.
> Muchas gracias."

---

## Sugerencias para la exposición

1. **Pantallazos en un marco de teléfono.** Se ven más profesionales y del mismo tamaño. Tomarlos
   todos con el mismo emulador y el mismo tema (claro u oscuro).
2. **Resaltar 1–2 líneas por nube de código.** Ponga el resto del código en gris o con menor
   opacidad, y la línea clave en negrita o con un recuadro: el público lee lo que se resalta.
3. **Fuente monoespaciada de 18 pt o más** en las nubes de código; si no cabe, recorte más.
4. **Una tabla de equivalencias Kotlin ↔ Flutter** ayuda a todo el grupo: Diego la puede usar en
   la comparación Dart vs Kotlin y usted la retoma en el cierre.
5. **Coordine con Luis:** si él explica *hot reload* en ventajas, usted solo lo **demuestra**, sin
   repetir la teoría.
6. **Ensaye con cronómetro.** Demo ≤ 6 min y Purdue ≤ 7 min; si se pasa, salte directamente de la
   diapositiva ★ 5 a la ★ 8.
7. **No muestre `.env`, llaves ni contraseñas** en pantalla ni en los pantallazos (el correo y la
   contraseña del usuario demo tampoco hacen falta).
8. **Lleve preguntas probables preparadas:** ¿Flutter es más lento que nativo? (no en release:
   compila a código máquina). ¿Se puede usar código Kotlin? (sí, con *platform channels*).
   ¿Qué tan grande queda el APK? (más que uno nativo, porque incluye el motor de Flutter).
