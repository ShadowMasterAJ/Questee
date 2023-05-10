import 'package:url_launcher/url_launcher.dart';
import 'package:device_apps/device_apps.dart';


Future launchApp(String appName) async{
    try {
  ///checks if the app is installed on your mobile device
  bool isInstalled = await DeviceApps.isAppInstalled(appName);
  if (isInstalled) {
      DeviceApps.openApp(appName);
   } 
   else {
     ///if the app is not installed it launches google play store so you can install it from there
      launchUrl(Uri.parse("market://details?id=" +appName));
   }
} catch (e) {
    print(e);
}
  }
