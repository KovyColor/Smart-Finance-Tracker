import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tzlib;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();

  factory NotificationService() {
    return _instance;
  }

  NotificationService._internal();

  late FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;

  Future<void> initialize() async {
    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    
    // Initialize timezone database
    tz.initializeTimeZones();

    // Android initialization
    const AndroidInitializationSettings androidInitSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS initialization
    final DarwinInitializationSettings iosInitSettings =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification:
          (int id, String? title, String? body, String? payload) async {
        // Handle notification on iOS
      },
    );

    final InitializationSettings initSettings = InitializationSettings(
      android: androidInitSettings,
      iOS: iosInitSettings,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        // Handle notification tap
      },
    );
  }

  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'smart_finance_channel',
      'Smart Finance Notifications',
      channelDescription: 'Notifications for Smart Finance Tracker',
      importance: Importance.max,
      priority: Priority.high,
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }

  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
    String? payload,
  }) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'smart_finance_scheduled_channel',
      'Smart Finance Scheduled Notifications',
      channelDescription:
          'Scheduled notifications for Smart Finance Tracker',
      importance: Importance.max,
      priority: Priority.high,
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tzlib.TZDateTime.from(scheduledTime, tzlib.local),
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
      payload: payload,
    );
  }

  Future<void> cancelNotification(int id) async {
    await _flutterLocalNotificationsPlugin.cancel(id);
  }

  Future<void> cancelAllNotifications() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }

  // Budget alert notification
  Future<void> showBudgetAlert({
    required String category,
    required double spent,
    required double budget,
    required double percentageUsed,
  }) async {
    final body =
        'You have spent $percentageUsed% of your $category budget. Spent: \$$spent of \$$budget';

    await showNotification(
      id: 1001,
      title: 'Budget Alert',
      body: body,
      payload: 'budget_alert',
    );
  }

  // Weekly report notification
  Future<void> showWeeklyReport({
    required double weeklySpending,
    required double change,
  }) async {
    final changeText = change > 0 ? '+\$$change' : '-\$${change.abs()}';
    final body =
        'Your weekly spending report: \$$weeklySpending ($changeText compared to last week)';

    await showNotification(
      id: 1002,
      title: 'Weekly Spending Report',
      body: body,
      payload: 'weekly_report',
    );
  }

  // Transaction notification
  Future<void> showTransactionNotification({
    required String type,
    required double amount,
    required String category,
  }) async {
    final body =
        'You $type \$$amount in $category'; // e.g., "You spent $25 in Food"

    await showNotification(
      id: 1003,
      title: 'Transaction Recorded',
      body: body,
      payload: 'transaction',
    );
  }
}
