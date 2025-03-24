import 'package:url_launcher/url_launcher.dart';

class MapUtils {
  MapUtils._();

  static Future<void> openMap(double latitude, double longitude) async {
    String googleUr =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunchUrl(Uri.parse(googleUr))) {
      await launchUrl(Uri.parse(googleUr));
    } else {
      throw 'ne peut pas ouvrir la Maps';
    }
  }
}
