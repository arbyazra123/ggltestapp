import 'package:flutter/material.dart';
import 'package:ggltestapp/main_page.dart';

import 'database.dart';

void main() async {
  await ProductDB.open();
  await ProductDB.batchInput();
  await runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "GGL App",
      home: MainPage(),
    );
  }
}
