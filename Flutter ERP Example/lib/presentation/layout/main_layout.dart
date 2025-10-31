import 'package:fluent_ui/fluent_ui.dart';
import '../modules/dashboard/dashboard_page.dart';
import '../modules/customers/customer_page.dart';
import '../modules/orders/order_page.dart';
import '../modules/settings/setting_page.dart';
import '../modules/notifications/notification_page.dart';

class MainLayout extends StatefulWidget {
  final Function(ThemeMode)? onThemeChanged;
  final Function(AccentColor)? onAccentChanged;

  const MainLayout({
    super.key,
    this.onThemeChanged,
    this.onAccentChanged,
  });

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _selectedIndex = 0;

  final List<NavigationPaneItem> items = [];

  @override
  void initState() {
    super.initState();
    items.addAll([
      PaneItem(
        icon: const Icon(FluentIcons.home),
        title: const Text('대시보드'),
        body: const DashboardPage(),
      ),
      PaneItem(
        icon: const Icon(FluentIcons.health),
        title: const Text('거래처 관리'),
        body: const CustomerPage(),
      ),
      PaneItem(
        icon: const Icon(FluentIcons.contact),
        title: const Text('주문 관리'),
        body: const OrderPage(),
      ),
      PaneItem(
        icon: const Icon(FluentIcons.settings),
        title: const Text('설정'),
        body: SettingPage(
          onThemeChanged: widget.onThemeChanged,
          onAccentChanged: widget.onAccentChanged,
        ),
      ),
      PaneItem(
        icon: const Icon(FluentIcons.ringer),
        title: const Text('알림'),
        body: const NotificationPage(),
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return NavigationView(
      pane: NavigationPane(
        selected: _selectedIndex,
        onChanged: (i) => setState(() => _selectedIndex = i),
        displayMode: PaneDisplayMode.auto,
        items: items,
      ),
    );
  }
}
