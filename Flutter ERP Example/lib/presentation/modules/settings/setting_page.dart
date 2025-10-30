import 'package:fluent_ui/fluent_ui.dart';
class SettingPage extends StatelessWidget {
  const SettingPage({super.key});
  @override
  Widget build(BuildContext context) => ScaffoldPage(
    header: const PageHeader(title: Text('설정')),
    content: const Center(child: Text('환경 설정 페이지')),
  );
}
