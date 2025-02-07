# Krit Text Suite

Krit Text Suite is a Flutter-based mobile application that allows users to search for words and retrieve definitions, synonyms, antonyms, pronunciations, syllables, examples, and rhymes using the API.

## 📌 Features
- Search for words and fetch meanings, synonyms, antonyms, and more.
- API integration.
- Dark mode support with theme switching.
- Smooth and responsive UI.

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (latest stable version) - [Download Flutter](https://flutter.dev/docs/get-started/install)
- Dart SDK
- Android Studio or VS Code (with Flutter & Dart plugins installed)
- API Key from [WordsAPI](https://www.wordsapi.com/)

### 📥 Installation
1. Clone the repository:
   ```sh
   git clone https://github.com/CodeDiscoverer/KritTextSuite.git
   cd krit-text-suite
   ```
2. Install dependencies:
   ```sh
   flutter pub get
   ```
3. Run the app:
   ```sh
   flutter run
   ```

---

## 🔑 API Setup
To use the WordsAPI, update the API key in `main.dart`:
```dart
final response = await http.get(Uri.parse(url), headers: {
  'x-rapidapi-key': 'YOUR_API_KEY_HERE',
  'x-rapidapi-host': 'wordsapiv1.p.rapidapi.com',
});
```
Replace `'YOUR_API_KEY_HERE'` with your actual API key.

---

## 🌐 Permissions

### Android
Modify `AndroidManifest.xml` to include internet permission:
```xml
<uses-permission android:name="android.permission.INTERNET"/>
```

### iOS
Ensure `Info.plist` has the following:
```xml
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <true/>
</dict>
```

---

## 🎨 Theme Switching
A theme switch button has been implemented using `ChangeNotifierProvider`.
Theme data is stored in `constants.dart`.

---

## 📜 Folder Structure
```
krit-text-suite/
│-- lib/
│   │-- main.dart          # Main app entry point
│   └── constants.dart     # Theme settings and constants
│-- android/
│-- ios/
│-- web/
│-- pubspec.yaml          # Dependencies
│-- README.md             # Documentation
```

---

## 📌 Future Improvements
- Offline word storage
- Speech-to-text support
- UI/UX enhancements

---

## 🛠 Built With
- **Flutter** - UI Framework
- **Dart** - Programming Language
- **WordsAPI** - Dictionary API

---

## 👨‍💻 Author
Suriya Prasath S - CodeDiscoverer

Feel free to contribute by creating pull requests! 🚀

