import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart';

class MapAdress with ChangeNotifier {
  static Future<void> openMap(String adress) async {
    final googleMapUrl =
        Uri.parse('https://www.google.com/maps/search/?api=1&query=$adress');

    if (await canLaunchUrl(googleMapUrl)) {
      await launchUrl(googleMapUrl, mode: LaunchMode.externalApplication);
    } else {
      throw '';
    }
  }
}
