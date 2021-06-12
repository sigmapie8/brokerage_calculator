import 'package:flutter/material.dart';
import 'package:brokerage_calculator/screens/equityIntraday.dart';
import 'package:brokerage_calculator/screens/equityDelivery.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Center(
              child: Text('Brokerage Calculator For Zerodha'),
            ),
            bottom: TabBar(
              tabs: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text('Equity Intraday'),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text('Equity Delivery'),
                )
              ],
            ),
          ),
          body: TabBarView(
            children: <Widget>[
              EquityIntraday(),
              EquityDelivery(),
            ],
          ),
        ),
      ),
    );
  }
}
