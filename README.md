# StudyCards 📚

Una aplicación móvil de flashcards interactiva para estudiar de manera eficiente y organizada. Desarrollada con Flutter, permite crear, gestionar y sincronizar tarjetas de aprendizaje con seguimiento del progreso en tiempo real.

## ✨ Características

- **Crear y gestionar flashcards**: Añade nuevas tarjetas de estudio con preguntas y respuestas.
- **Seguimiento de progreso**: Marca flashcards como aprendidas y visualiza tu avance.
- **Sincronización bidireccional**: Los cambios se sincronizan automáticamente entre el dispositivo y Firebase.
- **Persistencia local robusta**: Almacenamiento local con Drift (SQLite) para acceso offline.
- **Sincronización en la nube**: Integración con Firebase Firestore para respaldar y sincronizar datos.
- **Interfaz intuitiva**: Diseño moderno y responsive optimizado para móviles.

## 🛠️ Tecnologías Utilizadas

- **Flutter**: Framework para desarrollo de aplicaciones móviles multiplataforma.
- **Dart**: Lenguaje de programación principal.
- **Firebase Firestore**: Base de datos en la nube para sincronización de datos.
- **Firebase Core**: Configuración y inicialización de Firebase.
- **Drift**: ORM para SQLite con generación de código automática.


## 📋 Requisitos Previos

Antes de ejecutar la aplicación, asegúrate de tener instalado:

- [Flutter SDK](https://flutter.dev/docs/get-started/install) (versión 3.0 o superior)
- [Dart SDK](https://dart.dev/get-dart)
- Un editor de código como [Visual Studio Code](https://code.visualstudio.com/) con extensiones de Flutter
- Un emulador Android/iOS o dispositivo físico conectado
- Una cuenta de [Firebase](https://firebase.google.com/) con un proyecto configurado

## 🚀 Instalación y Configuración

### 1. Clona el repositorio
```bash
git clone https://github.com/aaronHenao/studycards.git
cd studycards
```

### 2. Instala las dependencias
```bash
flutter pub get
```

### 3. Configura Firebase

Asegúrate de tener un proyecto Firebase configurado con:
- **Firestore Database** habilitado
- **Reglas de seguridad** permitiendo lectura/escritura (o configuradas según tus necesidades)
- **Archivo google-services.json** configurado en `android/app/`

### 4. Verifica la configuración
```bash
flutter doctor
```

### 5. Ejecuta la aplicación
```bash
flutter run
```

## 📖 Uso

### Primera Ejecución
- La app inicializará Firestore automáticamente.
- Si es la primera vez, descargará las flashcards de la nube.
- Con conexión offline, usará los datos locales guardados.

### Crear una Nueva Flashcard
1. Toca el botón flotante "+" en la pantalla principal.
2. Ingresa la pregunta en el campo de texto.
3. Ingresa la respuesta en el segundo campo.
4. Toca "Guardar".
5. La flashcard se guardará localmente y se sincronizará con Firebase automáticamente.

### Estudiar Flashcards
1. Selecciona una flashcard de la lista.
2. Presiona para ver la respuesta.
3. Marca como aprendida usando el switch.
4. Tu progreso se guarda y sincroniza automáticamente.

## 🏗️ Arquitectura

### Capas

- **Presentación** (`pages/`, `widgets/`): UI y gestión de estado
- **Dominio** (`services/`): Lógica de negocio
- **Datos** (`data/`): Acceso a base de datos (Drift) y servicios remotos (Firebase)
- **Modelo** (`model/`): Estructuras de datos

### Sincronización

La app mantiene dos fuentes de datos sincronizadas:

1. **Drift (SQLite Local)**: Almacenamiento offline-first
2. **Firebase Firestore**: Sincronización en la nube

Los cambios se replican automáticamente entre ambas capas cuando hay conexión.

## 📁 Estructura del Proyecto

```
lib/
├── main.dart                           # Punto de entrada
├── firebase_options.dart               # Configuración de Firebase
├── data/
│   ├── app_database.dart               # Definición de Drift database
│   ├── app_database.g.dart             # Generated Drift code
│   └── seed.dart                       # Datos iniciales
├── model/
│   └── flashcard.dart                  # Modelo Flashcard
├── pages/
│   ├── flashcards_home_page.dart       # Pantalla principal
│   └── flashcard_form_dialog.dart      # Diálogo para crear flashcards
├── services/
│   ├── flashcard_repository.dart       # Repositorio central
│   ├── flashcard_service.dart          # Lógica de negocio
│   ├── flashcards_remote_service.dart  # Servicio de Firebase
│   └── app_logger.dart                 # Sistema de logging
└── widgets/
    └── flashcard_card.dart             # Widget de tarjeta
```

## 🔧 Configuración de Firestore

Las reglas de seguridad permiten acceso completo en desarrollo:

```firestore
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if true;
    }
  }
}
```

> ⚠️ **Nota**: Para producción, reemplaza `if true` con reglas de autenticación apropiadas.

## 🐛 Solución de Problemas

### "Permission denied" en Firestore
- Verifica que las reglas de seguridad están desplegadas correctamente:
  ```bash
  firebase deploy --only firestore:rules
  ```

### La aplicación no sincroniza cambios
- Verifica que tienes conexión a internet
- Comprueba en Firebase Console que los datos se están guardando
- Revisa los logs en la app (usa el sistema AppLogger)

### Base de datos corrupta
- Limpia el proyecto: `flutter clean`
- Reconstruye: `flutter run`


## 👤 Autor

Desarrollado como herramienta de estudio interactiva.

