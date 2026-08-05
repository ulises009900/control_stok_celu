import 'package:logging/logging.dart';

class AppLogger {
  static final Logger _logger = Logger('control_stok_celu');
  static bool _initialized = false;

  static Logger get instance {
    if (!_initialized) {
      _init();
    }
    return _logger;
  }

  static void _init() {
    Logger.root.level = Level.INFO;
    Logger.root.onRecord.listen((record) {
      // Centralized logging hook for future persistent diagnostics.
      // ignore: avoid_print
      print('[${record.level.name}] ${record.time.toIso8601String()} ${record.message}');
    });
    _initialized = true;
  }
}
