import 'package:fluent_ui/fluent_ui.dart';
class OrderPage extends StatelessWidget {
  const OrderPage({super.key});
  @override
  Widget build(BuildContext context) => ScaffoldPage(
    header: const PageHeader(title: Text('주문 관리')),
    content: const Center(child: Text('주문 관리 화면')),
  );
}
