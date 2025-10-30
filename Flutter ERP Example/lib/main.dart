import 'package:fluent_ui/fluent_ui.dart';
import 'presentation/layout/main_layout.dart';

void main() {
  runApp(const FlutterErpApp());
}

class FlutterErpApp extends StatefulWidget {
  const FlutterErpApp({super.key});

  @override
  State<FlutterErpApp> createState() => _FlutterErpAppState();
}

class _FlutterErpAppState extends State<FlutterErpApp> {
  final themeMode = ValueNotifier<ThemeMode>(ThemeMode.light);
  final accentColor = ValueNotifier<AccentColor>(Colors.blue);

  @override
  Widget build(BuildContext context) {
    return FluentApp(
      title: 'ERP System',
      debugShowCheckedModeBanner: false,
      themeMode: themeMode.value,
      color: accentColor.value,
      theme: FluentThemeData(
        accentColor: accentColor.value,
        brightness: Brightness.light,
      ),
      darkTheme: FluentThemeData(
        accentColor: accentColor.value,
        brightness: Brightness.dark,
      ),
      home: MainLayout(
        onThemeChanged: (mode) => setState(() => themeMode.value = mode),
        onAccentChanged: (color) => setState(() => accentColor.value = color),
      ),
    );
  }
}
