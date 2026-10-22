import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app.dart';
import 'core/store.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  LicenseRegistry.addLicense(() async* {
    yield LicenseEntryWithLineBreaks([
      'Lato',
    ], await rootBundle.loadString('assets/fonts/Lato-OFL.txt'));
    yield LicenseEntryWithLineBreaks([
      'Josefin Sans',
    ], await rootBundle.loadString('assets/fonts/JosefinSans-OFL.txt'));
  });
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
  final store = ShopStore(await SharedPreferences.getInstance())..restore();
  runApp(BrightApp(store: store));
}
