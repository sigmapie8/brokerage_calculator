import 'package:brokerage_calculator/providers/deliveryProvider.dart';
import 'package:brokerage_calculator/providers/intradayProvider.dart';
import 'package:flutter/material.dart';
import 'package:brokerage_calculator/screens/homePage.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => IntradayProvider()),
        ChangeNotifierProvider(create: (_) => DeliveryProvider()),
      ],
      child: MaterialApp(
        title: 'Brokerage Calculator For Zerodha',
        theme: ThemeData(
          primarySwatch: Colors.purple,
        ),
        home: HomePage(),
      ),
    );
  }
}
