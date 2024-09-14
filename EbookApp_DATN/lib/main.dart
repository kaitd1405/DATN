
import 'package:ebookapp/view/login/ebook_login.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

void main() {
  return runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return MaterialApp(
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const EbookLogin(),
      );
    });
  }
}
