import 'package:url_launcher/url_launcher.dart' as url_launcher;

class UrlLauncherService {
  static void launchUrl({
    required String url,
  }) async {
    if (!await url_launcher.canLaunchUrl(Uri.parse(url))) {
      return;
    }
    url_launcher.launchUrl(
      Uri.parse(url),
      mode: url_launcher.LaunchMode.externalApplication,
    );
  }

  static void openPhoneDialer({
    String? phoneNumber,
  }) {
    final Uri url = Uri.parse("tel://${phoneNumber ?? ""}");
    url_launcher.launchUrl(
      url,
      mode: url_launcher.LaunchMode.externalApplication,
    );
  }

  static void visitFacebookPage({
    required String userName,
  }) {
    // final Uri url = Uri.parse("tel://${phoneNumber ?? ""}");
    // url_launcher.launchUrl(
    //   url,
    //   mode: url_launcher.LaunchMode.externalApplication,
    // );
  }
  static void visitInstagramPage({
    required String userName,
  }) {
    // final Uri url = Uri.parse("tel://${phoneNumber ?? ""}");
    // url_launcher.launchUrl(
    //   url,
    //   mode: url_launcher.LaunchMode.externalApplication,
    // );
  }

  static void launchGoogleMaps({
    required String latitude,
    required String longitude,
  }) {
    String url =
        'https://www.google.com/maps/dir/?api=1&destination=$latitude,$longitude';
    url_launcher.launchUrl(
      Uri.parse(url),
      mode: url_launcher.LaunchMode.externalApplication,
    );
  }
}
