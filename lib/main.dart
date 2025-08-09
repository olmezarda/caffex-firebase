import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(CaffeX());
}

class CaffeX extends StatelessWidget {
  const CaffeX({super.key});

  @override
  Widget build(BuildContext context) {
    return App();
  }
}
