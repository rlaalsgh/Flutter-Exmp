import 'package:fluent_ui/fluent_ui.dart';
import 'presentation/layout/main_layout.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;

// 🔔 전역 알림 플러그인 선언
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 🔔 타임존 초기화
  tz.initializeTimeZones();

  // 🔔 알림 초기화 설정
  const AndroidInitializationSettings androidInit =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings initSettings =
      InitializationSettings(android: androidInit);

  await flutterLocalNotificationsPlugin.initialize(initSettings);

  // 🚀 앱 실행
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
