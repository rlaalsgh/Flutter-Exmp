import 'package:fluent_ui/fluent_ui.dart';
import 'presentation/layout/main_layout.dart';

class ERPApp extends StatelessWidget {
  const ERPApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FluentApp(
      title: 'ERP System',
      debugShowCheckedModeBanner: false,
      theme: FluentThemeData(
        accentColor: Colors.blue,
      ),
      home: const MainLayout(),
    );
  }
}
