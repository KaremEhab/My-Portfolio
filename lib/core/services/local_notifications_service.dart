import 'dart:developer';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:dio/dio.dart';

class LocalNotificationHelper {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static const String _groupKey = 'com.ramla_school.notifications';
  static const String _groupChannelId = 'ramla_high_priority_channel';
  static const String _groupChannelName = 'High Priority Notifications';

  static final Dio _dio = Dio();

  /// ✅ تهيئة النظام المحلي للإشعارات
  static Future<void> init() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');

    const settings = InitializationSettings(android: android);

    await _plugin.initialize(
      settings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // 👇 نستدعي الكول باك اللي اتحفظ عند العرض
        final payload = response.payload;
        if (payload != null && _pendingTapHandlers.containsKey(payload)) {
          _pendingTapHandlers[payload]!();
          _pendingTapHandlers.remove(payload);
        }
      },
    );
  }

  /// ✅ تحميل الصورة من الإنترنت باستخدام Dio
  static Future<Uint8List?> _downloadImage(String url) async {
    try {
      final response = await _dio.get<List<int>>(
        url,
        options: Options(responseType: ResponseType.bytes),
      );
      if (response.statusCode == 200 && response.data != null) {
        return Uint8List.fromList(response.data!);
      }
    } catch (e) {
      log('❌ Error downloading image for local notification: $e');
    }
    return null;
  }

  // 🧠 خريطة لتخزين الأحداث اللي المفروض تحصل عند الضغط
  static final Map<String, VoidCallback> _pendingTapHandlers = {};

  /// ✅ عرض الإشعار في الـ foreground مع الصورة والتجميع + onTap handler
  static Future<void> show({
    required String title,
    required String body,
    String? imageUrl,
    VoidCallback? onTap,
  }) async {
    BigPictureStyleInformation? styleInfo;

    // 🖼️ تحميل الصورة البعيدة لو موجودة
    if (imageUrl != null && imageUrl.isNotEmpty) {
      final imageBytes = await _downloadImage(imageUrl);
      if (imageBytes != null) {
        styleInfo = BigPictureStyleInformation(
          ByteArrayAndroidBitmap(imageBytes),
          contentTitle: title,
          summaryText: body,
          largeIcon: ByteArrayAndroidBitmap(imageBytes),
          hideExpandedLargeIcon: true,
        );
      }
    }

    // 🔔 إعداد تفاصيل الإشعار
    final android = AndroidNotificationDetails(
      _groupChannelId,
      _groupChannelName,
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
      icon: '@mipmap/ic_launcher',
      groupKey: _groupKey,
      channelShowBadge: true,
      styleInformation: styleInfo,
    );

    final notificationDetails = NotificationDetails(android: android);
    final int notificationId = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    final payload = 'notification_id_$notificationId';

    // 🧩 حفظ onTap handler مؤقتًا
    if (onTap != null) {
      _pendingTapHandlers[payload] = onTap;
    }

    // ✅ عرض الإشعار نفسه
    await _plugin.show(
      notificationId,
      title,
      body,
      notificationDetails,
      payload: payload,
    );

    // 📦 إشعار التجميع الرئيسي (summary)
    const summaryAndroid = AndroidNotificationDetails(
      _groupChannelId,
      _groupChannelName,
      styleInformation: InboxStyleInformation(
        [],
        contentTitle: 'إشعارات مدرسة أم المؤمنين',
        summaryText: 'عرض جميع الإشعارات',
      ),
      groupKey: _groupKey,
      setAsGroupSummary: true,
      importance: Importance.low,
      priority: Priority.low,
      playSound: false,
      icon: '@mipmap/ic_launcher',
    );

    const summaryDetails = NotificationDetails(android: summaryAndroid);

    await _plugin.show(0, '', '', summaryDetails);

    // 🧠 لو التطبيق في foreground ومحتاج تنفذ onTap فوراً:
    if (onTap != null) {
      // ما نفتحش الصفحة إلا لما المستخدم فعلاً يضغط
      // ✅ نخلي الفتح فقط عند الضغط
      // (يعني نلغي onTap() الفوري)
    }
  }
}
