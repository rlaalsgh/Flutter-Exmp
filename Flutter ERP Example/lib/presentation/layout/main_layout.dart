import 'package:fluent_ui/fluent_ui.dart';
import '../modules/dashboard/dashboard_page.dart';
import '../modules/customers/customer_page.dart';
import '../modules/orders/order_page.dart';
import '../modules/settings/setting_page.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return NavigationView(
      appBar: const NavigationAppBar(
        title: Text('ERP System', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      pane: NavigationPane(
        selected: index,
        onChanged: (i) => setState(() => index = i),
        displayMode: PaneDisplayMode.auto,
        items: [
          PaneItem(icon: const Icon(FluentIcons.home), title: const Text('대시보드'), body: const DashboardPage()),
          PaneItem(icon: const Icon(FluentIcons.contact), title: const Text('거래처 관리'), body: const CustomerPage()),
          PaneItem(icon: const Icon(FluentIcons.shopping_cart), title: const Text('주문 관리'), body: const OrderPage()),
          PaneItem(icon: const Icon(FluentIcons.settings), title: const Text('설정'), body: const SettingPage()),
        ],
      ),
    );
  }
}
