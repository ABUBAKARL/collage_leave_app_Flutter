import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import '../Screens/splash.dart';
import 'package:path_provider/path_provider.dart';
import 'firebase_options.dart';
import 'settings/colors.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final dir = await getApplicationDocumentsDirectory();
  Hive.init(dir.path);
  Hive.openBox("Auth");
  runApp(const leave_app());
}
class leave_app extends StatefulWidget {
  const leave_app({super.key});
  @override
  State<leave_app> createState() => _leave_appState();
}
class _leave_appState extends State<leave_app> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          color: Colors.lightBlue,
        ),
        useMaterial3: true,
        tabBarTheme: TabBarTheme(
          labelColor: custom_Colors.labelColor,
          unselectedLabelColor: custom_Colors.labelColor,
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const splash(),
    );
  }
}
