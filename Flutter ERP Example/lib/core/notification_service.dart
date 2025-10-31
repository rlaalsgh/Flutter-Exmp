import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import '../models/notification_item.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final _plugin = FlutterLocalNotificationsPlugin();
  final List<NotificationItem> _history = [];

  List<NotificationItem> get history => List.unmodifiable(_history);

  Future<void> init() async {
    tz.initializeTimeZones();
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidInit);
    await _plugin.initialize(initSettings);
  }

  Future<void> showInstantNotification(String title, String message) async {
    const androidDetails = AndroidNotificationDetails(
      'erp_channel',
      'ERP 알림',
      importance: Importance.max,
      priority: Priority.high,
    );
    const details = NotificationDetails(android: androidDetails);

    await _plugin.show(0, title, message, details);

    // 내부 알림 기록 추가
    _history.insert(
      0,
      NotificationItem(
          title: title, message: message, timestamp: DateTime.now()),
    );
  }
}
