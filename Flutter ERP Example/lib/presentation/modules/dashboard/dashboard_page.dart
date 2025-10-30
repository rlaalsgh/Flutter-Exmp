import 'package:fluent_ui/fluent_ui.dart';
class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});
  @override
  Widget build(BuildContext context) => ScaffoldPage(
    header: const PageHeader(title: Text('대시보드')),
    content: const Center(child: Text('ERP 개요 / 통계 / 그래프 자리')),
  );
}
