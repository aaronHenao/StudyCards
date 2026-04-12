# StudyCards 📚

Una aplicación móvil de flashcards interactiva para estudiar de manera eficiente y organizada. Desarrollada con Flutter, permite crear, gestionar y estudiar tarjetas de aprendizaje con seguimiento del progreso.

## ✨ Características

- **Interfaz intuitiva**: Navegación sencilla entre flashcards con diseño moderno y responsive.
- **Seguimiento de progreso**: Marca flashcards como aprendidas y visualiza tu avance.
- **Persistencia local**: Guarda tu progreso usando SharedPreferences.
- **Sincronización con servidor**: Carga flashcards desde un servidor remoto (MockAPI) con fallback a datos locales.
- **Actualización en tiempo real**: Cambia el estado de aprendizaje de cada flashcard individualmente.

## 🛠️ Tecnologías Utilizadas

- **Flutter**: Framework para desarrollo de aplicaciones móviles multiplataforma.
- **Dart**: Lenguaje de programación principal.
- **SharedPreferences**: Para almacenamiento local de datos.
- **HTTP**: Para comunicación con APIs REST.
- **MockAPI**: Servicio externo para datos de flashcards.

## 📋 Requisitos Previos

Antes de ejecutar la aplicación, asegúrate de tener instalado:

- [Flutter SDK](https://flutter.dev/docs/get-started/install) (versión 3.0 o superior)
- [Dart SDK](https://dart.dev/get-dart)
- Un editor de código como [Visual Studio Code](https://code.visualstudio.com/) con extensiones de Flutter
- Un emulador Android/iOS o dispositivo físico conectado

## 🚀 Instalación y Configuración

1. **Clona el repositorio**:
   ```bash
   git clone https://github.com/tu-usuario/studycards.git
   cd studycards
   ```

2. **Instala las dependencias**:
   ```bash
   flutter pub get
   ```

3. **Verifica la configuración**:
   ```bash
   flutter doctor
   ```

4. **Ejecuta la aplicación**:
   ```bash
   flutter run
   ```

## 📖 Uso

### Primera Ejecución
- La app cargará automáticamente las flashcards desde el servidor.
- Si no hay conexión, usará datos locales como respaldo.

### Navegación
- **Pantalla principal**: Lista todas las flashcards disponibles.
- **Tarjeta individual**: Toca una flashcard para ver la respuesta y marcar como aprendida.
- **Estado de aprendizaje**: Usa el switch para marcar/desmarcar flashcards como aprendidas.

### Funcionalidades
- **Marcar como aprendida**: Cambia el estado de una flashcard específica.
- **Persistencia**: Tu progreso se guarda automáticamente.
- **Sincronización**: Los cambios se envían al servidor cuando hay conexión.

## 📁 Estructura del Proyecto

```
lib/
├── main.dart                 # Punto de entrada de la aplicación
├── data/
│   └── flashcards_data.dart  # Datos locales de flashcards
├── model/
│   └── flashcard.dart        # Modelo de datos Flashcard
├── pages/
│   ├── flashcards_home_page.dart    # Pantalla principal
│   └── flashcard_answer_page.dart   # Pantalla de respuesta
├── services/
│   └── flashcards_service.dart      # Servicio de API y datos
└── widgets/
    └── flashcard_card.dart          # Widget de tarjeta
```

