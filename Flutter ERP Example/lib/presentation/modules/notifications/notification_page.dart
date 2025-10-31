import 'package:fluent_ui/fluent_ui.dart';
import '../../../core/notification_service.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    final notifications = NotificationService().history;

    return ScaffoldPage(
      header: const PageHeader(title: Text('알림 내역')),
      content: notifications.isEmpty
          ? const Center(child: Text('아직 받은 알림이 없습니다.'))
          : ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (_, i) {
                final n = notifications[i];
                return Card(
                  child: ListTile(
                    title: Text(n.title),
                    subtitle: Text(n.message),
                    trailing: Text(
                      '${n.timestamp.hour.toString().padLeft(2, '0')}:${n.timestamp.minute.toString().padLeft(2, '0')}',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
