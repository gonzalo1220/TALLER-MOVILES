https://github.com/gonzalo1220/TALLER-MOVILES.git
# Taller - Navegación y Widgets (Curso)

**Repositorio:** https://github.com/gonzalo1220/TALLER-MOVILES.git

## Ramas y flujo
- `main` — rama estable.
- `dev` — rama de desarrollo.
- `feature/taller_paso_parametros` — rama del taller (creada desde `dev`).

## Arquitectura y navegación
Se usa `go_router` con rutas:
- `/` → Home (GridView con elementos)
- `/detail/:id` → Detail (recibe `id` como parámetro de ruta)

Se demostró paso de parámetros por la URL (`:id`) y también se puede pasar `state.extra`.

Comportamiento de navegación usado:
- `context.push('/detail/2')` → agrega a la pila (back regresa).
- `context.go('/detail/1')` → navegación declarativa (comportamiento de historial distinto).
- `context.replace('/detail/3')` → reemplaza la ruta actual (no hay historial previo).

## Widgets usados y por qué
- **GridView**: mostrar varios elementos de forma compacta y táctil.
- **TabBar / TabBarView**: dividir la pantalla Detail en secciones.
- **ExpansionTile**: widget adicional para mostrar información plegable (puede sustituirse por otro).
- Otros: `FloatingActionButton`, `AppBar` con título dinámico.

## Ciclo de vida (evidencias)
Se registraron en la consola:
- `initState()` — inicializa controladores y recursos.
- `didChangeDependencies()` — se ejecuta si cambian dependencias heredadas.
- `build()` — renderiza UI.
- `setState()` — usada para actualizar UI.
- `dispose()` — liberar recursos.

## Cómo ejecutar
1. `flutter pub get`
2. `flutter run` (o correr desde VS Code / Android Studio)

## Evidencias entregadas
- PDF con capturas: navegación (go/push/replace), GridView, TabBar, tercer widget, consola con logs lifecycle.
- URL del repositorio al inicio del PDF.
