import 'dart:async';

import 'package:flutter/material.dart';
import 'package:loccar_agency/models/rent.dart';
import 'package:loccar_agency/services/rent.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:workmanager/workmanager.dart';

class RentNotificationService {
  // Singleton pattern
  static final RentNotificationService _instance =
      RentNotificationService._internal();
  factory RentNotificationService() => _instance;
  RentNotificationService._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final String _lastRentIdKey = 'last_rent_id';
  final String _processedRentsKey = 'processed_rents';

  Timer? _timer;

  // Initialisation des notifications
  Future<void> initialize() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _notificationsPlugin.initialize(initializationSettings);

    // Démarrer la vérification régulière des rents toutes les 30 secondes
    _startRentCheckTimer();
  }

  // Démarrer la vérification toutes les 30 secondes avec un Timer

  void _startRentCheckTimer() {
    _timer = Timer.periodic(const Duration(seconds: 30), (timer) async {
      await checkForNewRents();
    });
  }

  // Vérifier les nouvelles locations (pour appel direct)
  Future<void> checkForNewRents() async {
    try {
      final List<RentModel> rents = (await RentService().fetchRents()).$1;

      await _processNewRents(rents);
    } catch (e) {
      debugPrint('Exception lors de la vérification des locations: $e');
    }
  }

  // Traiter les nouvelles rents
  Future<void> _processNewRents(List<RentModel> rents) async {
    final prefs = await SharedPreferences.getInstance();
    final int lastRentId = prefs.getInt(_lastRentIdKey) ?? 0;
    final List<String> processedIds =
        prefs.getStringList(_processedRentsKey) ?? [];
    Set<String> processedIdsSet = processedIds.toSet();

    bool hasNewRent = false;
    int newMaxId = lastRentId;

    for (var rent in rents) {
      // Mise à jour de l'ID max
      if (rent.id > newMaxId) {
        newMaxId = rent.id;
      }

      // Vérifier si c'est une nouvelle rent qui n'a pas encore été traitée
      if (rent.id > lastRentId &&
          !processedIdsSet.contains(rent.id.toString())) {
        hasNewRent = true;
        processedIdsSet.add(rent.id.toString());
        await _showNotification(rent);
      }
    }

    // Sauvegarder le dernier ID traité et la liste des IDs traités
    await prefs.setInt(_lastRentIdKey, newMaxId);
    await prefs.setStringList(_processedRentsKey, processedIdsSet.toList());
  }

  // Afficher une notification
  Future<void> _showNotification(RentModel rent) async {
    debugPrint("Affichage de la notification pour la rent ${rent.id}");
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'rent_channel',
      'Nouvelles Locations',
      channelDescription: 'Notifications pour les nouvelles rents de voitures',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      sound: RawResourceAndroidNotificationSound('mixkit_notif'),
      enableVibration: true,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: DarwinNotificationDetails(
        presentSound: true,
        sound: 'mixkit_notif.aiff',
      ),
    );

    await _notificationsPlugin.show(
      rent.id,
      'Nouvelle Location',
      'Vous avez reçu une nouvelle demande de location pour la voiture #${rent.car!.brand} ${rent.car!.model} ${rent.car!.year}.',
      notificationDetails,
    );
  }

  // Arrêter le timer si nécessaire (par exemple, lors de la fermeture de l'application)
  void stopRentCheckTimer() {
    _timer?.cancel();
  }
}

// Fonction de rappel à exécuter en arrière-plan
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    debugPrint('Exécution de la tâche en arrière-plan: $task');

    final FlutterLocalNotificationsPlugin notificationsPlugin =
        FlutterLocalNotificationsPlugin();

    // Initialiser les notifications
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await notificationsPlugin.initialize(initializationSettings);

    try {
      final List<RentModel> rents = (await RentService().fetchRents()).$1;

      if (rents.isNotEmpty) {
        final prefs = await SharedPreferences.getInstance();
        final int lastRentId = prefs.getInt('last_rent_id') ?? 0;
        final List<String> processedIds =
            prefs.getStringList('processed_rents') ?? [];
        Set<String> processedIdsSet = processedIds.toSet();

        bool hasNewRent = false;
        int newMaxId = lastRentId;

        for (var rent in rents) {
          // Mise à jour de l'ID max
          if (rent.id > newMaxId) {
            newMaxId = rent.id;
          }

          // Vérifier si c'est une nouvelle location
          if (rent.id > lastRentId &&
              !processedIdsSet.contains(rent.id.toString())) {
            hasNewRent = true;
            processedIdsSet.add(rent.id.toString());

            // Afficher la notification
            const AndroidNotificationDetails androidDetails =
                AndroidNotificationDetails(
              'rent_channel',
              'Nouvelles Locations',
              channelDescription:
                  'Notifications pour les nouvelles locations de voitures',
              importance: Importance.high,
              priority: Priority.high,
              playSound: true,
              sound: RawResourceAndroidNotificationSound('mixkit_notif'),
              enableVibration: true,
            );

            const NotificationDetails notificationDetails = NotificationDetails(
              android: androidDetails,
              iOS: DarwinNotificationDetails(
                presentSound: true,
                sound: 'mixkit_notif.aiff',
              ),
            );

            await notificationsPlugin.show(
              rent.id,
              'Nouvelle Location',
              'Vous avez reçu une nouvelle demande de location pour la voiture #${rent.car!.brand} ${rent.car!.model} ${rent.car!.year}.',
              notificationDetails,
            );
          }
        }

        // Sauvegarder le dernier ID traité et la liste des IDs traités
        await prefs.setInt('last_rent_id', newMaxId);
        await prefs.setStringList('processed_rents', processedIdsSet.toList());
      }
    } catch (e) {
      debugPrint('Erreur dans la tâche en arrière-plan: $e');
    }

    // Si c'est une tâche unique, programmer la prochaine
    if (task != 'rentCheckTask') {
      await Workmanager().registerOneOffTask(
        'rent_check_immediate_${DateTime.now().millisecondsSinceEpoch}',
        'rentCheckTask',
        initialDelay: const Duration(seconds: 30),
      );
    }

    return Future.value(true);
  });
}
