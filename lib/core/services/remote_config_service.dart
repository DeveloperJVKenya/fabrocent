import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'app_logger.dart';

class RemoteConfigService {
  static Future<void> initialize() async {
    AppLogger.config('Initializing Remote Config');
    final rc = FirebaseRemoteConfig.instance;

    // Defaults used when offline or before first fetch
    await rc.setDefaults({
      'paybill_directory':
          '{"888880":"Kenya Power","400222":"NHIF","601300":"NSSF",'
          '"400200":"KRA","247247":"Equity Bank","545454":"KCB Mpesa",'
          '"111225":"Airtel Money","777777":"T-Kash","200555":"Stanbic",'
          '"400555":"Co-op Bank","998800":"Zuku","880100":"Faiba",'
          '"510200":"KPlc Tokens","200220":"NHIF Corporate"}',
      'parser_version': '1',
      'maintenance_mode': 'false',
      'min_app_version': '1.0.0',
    });
    AppLogger.config('Defaults set — fetching latest values (timeout 10s)');

    await rc.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(seconds: 10),
      minimumFetchInterval: const Duration(hours: 1),
    ));

    try {
      final activated = await rc.fetchAndActivate();
      AppLogger.config(
        '✅ Remote Config fetched — activated=$activated '
        'parser_version=${rc.getString("parser_version")} '
        'maintenance=${rc.getString("maintenance_mode")}',
      );
    } catch (e) {
      AppLogger.warn('⚙  CONFIG', 'Fetch failed — using defaults ($e)');
    }
  }

  static bool get isMaintenanceMode {
    final val = FirebaseRemoteConfig.instance.getString('maintenance_mode');
    return val.toLowerCase() == 'true';
  }

  static int get parserVersion {
    return int.tryParse(
            FirebaseRemoteConfig.instance.getString('parser_version')) ??
        1;
  }
}
