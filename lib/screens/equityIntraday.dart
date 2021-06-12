import 'package:brokerage_calculator/providers/intradayProvider.dart';
import 'package:brokerage_calculator/screens/widgets/heading.dart';
import 'package:brokerage_calculator/helpers/enums.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EquityIntraday extends StatefulWidget {
  @override
  _EquityIntradayState createState() => _EquityIntradayState();
}

class _EquityIntradayState extends State<EquityIntraday> {
  @override
  Widget build(BuildContext context) {
    final intradayProvider =
        Provider.of<IntradayProvider>(context, listen: true);

    //intradayProvider.setBuyPrice(price: "");
    //intradayProvider.setSellPrice(price: "");
    //intradayProvider.setQuantity(quantity: "");

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            //Heading
            heading(heading: 'Equity Intraday'),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0),
            ),
            //Market Radio Button
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: ListTile(
                    title: Text('NSE'),
                    leading: Radio(
                      value: Market.NSE,
                      groupValue: intradayProvider.selectedMarket,
                      onChanged: (value) {
                        intradayProvider.selectMarket(market: value as Market);
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: ListTile(
                    title: Text('BSE'),
                    leading: Radio(
                      value: Market.BSE,
                      groupValue: intradayProvider.selectedMarket,
                      onChanged: (value) {
                        intradayProvider.selectMarket(market: value as Market);
                      },
                    ),
                  ),
                ),
              ],
            ),
            Divider(),
            //Buy Sell Quantity
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: TextField(
                    enabled: true,
                    keyboardType: TextInputType.number,
                    style: TextStyle(
                      color: Colors.grey.shade800,
                      fontSize: 12.0,
                    ),
                    decoration: InputDecoration(
                      labelText: "Buy",
                      labelStyle: TextStyle(color: Colors.purple),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (String value) {
                      intradayProvider.setBuyPrice(price: value);
                      intradayProvider.calcCharges();
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                ),
                Expanded(
                  child: TextField(
                    enabled: true,
                    keyboardType: TextInputType.number,
                    style: TextStyle(
                      color: Colors.grey.shade800,
                      fontSize: 12.0,
                    ),
                    decoration: InputDecoration(
                      labelText: "Sell",
                      labelStyle: TextStyle(color: Colors.purple),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (String value) {
                      intradayProvider.setSellPrice(price: value);
                      intradayProvider.calcCharges();
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                ),
                Expanded(
                  child: TextField(
                    enabled: true,
                    keyboardType: TextInputType.number,
                    style: TextStyle(
                      color: Colors.grey.shade800,
                      fontSize: 12.0,
                    ),
                    decoration: InputDecoration(
                      labelText: "Quantity",
                      labelStyle: TextStyle(color: Colors.purple),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (String value) {
                      intradayProvider.setQuantity(quantity: value);
                      intradayProvider.calcCharges();
                    },
                  ),
                )
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 7.0),
            ),
            //Min Sell Price
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Minimum Profit Sell: ${intradayProvider.minSellPrice}',
                  style: TextStyle(
                    color: Colors.green.shade400,
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 5.0),
            ),
            Divider(),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 5.0),
            ),
            //Net P&L
            Column(
              children: <Widget>[
                Text(
                  'Net P&L',
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.black54,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 5.0),
                ),
                Text(
                  intradayProvider.netProfit.toString(),
                  style: TextStyle(
                    fontSize: 25.0,
                    color: intradayProvider.netProfit.isNegative
                        ? Colors.red
                        : Colors.green,
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 5.0),
            ),
            Divider(),
            ListTile(
              title: Text('Total Tax & Charge'),
              trailing: Text(intradayProvider.totalCharge.toString()),
            ),
            Divider(),
            //Charges Expanded
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: ExpansionPanelList.radio(
                    expansionCallback: (int index, bool _isExpanded) {},
                    children: <ExpansionPanel>[
                      //Brokerage
                      ExpansionPanelRadio(
                        value: 1,
                        headerBuilder:
                            (BuildContext context, bool _isExpanded) {
                          return ListTile(
                            title: Text('Total Brokerage'),
                            trailing: Text(
                                intradayProvider.totalBrokerage.toString()),
                          );
                        },
                        body: Column(
                          children: <ListTile>[
                            ListTile(
                              title: Text('Buy Brokerage'),
                              trailing: Text(
                                  intradayProvider.buyBrokerage.toString()),
                            ),
                            ListTile(
                              title: Text('Sell Brokerage'),
                              trailing: Text(
                                  intradayProvider.sellBrokerage.toString()),
                            ),
                          ],
                        ),
                        canTapOnHeader: true,
                      ),
                      //STT
                      ExpansionPanelRadio(
                        value: 2,
                        headerBuilder:
                            (BuildContext context, bool _isExpanded) {
                          return ListTile(
                            title: Text('STT'),
                            trailing:
                                Text(intradayProvider.totalSTT.toString()),
                          );
                        },
                        body: ListTile(
                          subtitle: Text(
                              'Securities Transaction Tax(STT) is only applied while selling the equity.'),
                        ),
                        canTapOnHeader: true,
                      ),
                      //Transaction Charge
                      ExpansionPanelRadio(
                        value: 3,
                        headerBuilder:
                            (BuildContext context, bool _isExpanded) {
                          return ListTile(
                            title: Text('Transaction Charge'),
                            trailing: Text(
                                intradayProvider.totalTxnCharge.toString()),
                          );
                        },
                        body: Column(
                          children: <ListTile>[
                            ListTile(
                              title: Text('Buy Transaction Charge'),
                              trailing: Text(
                                  intradayProvider.buyTxnCharge.toString()),
                            ),
                            ListTile(
                              title: Text('Sell Transaction Charge'),
                              trailing: Text(
                                  intradayProvider.sellTxnCharge.toString()),
                            ),
                          ],
                        ),
                        canTapOnHeader: true,
                      ),
                      //GST
                      ExpansionPanelRadio(
                        value: 4,
                        headerBuilder:
                            (BuildContext context, bool _isExpanded) {
                          return ListTile(
                            title: Text('GST'),
                            trailing:
                                Text(intradayProvider.totalGST.toString()),
                          );
                        },
                        body: Column(
                          children: <ListTile>[
                            ListTile(
                              title: Text('Buy GST'),
                              trailing:
                                  Text(intradayProvider.buyGST.toString()),
                            ),
                            ListTile(
                              title: Text('Sell GST'),
                              trailing:
                                  Text(intradayProvider.sellGST.toString()),
                            ),
                          ],
                        ),
                        canTapOnHeader: true,
                      ),
                      //Sebi Charges
                      ExpansionPanelRadio(
                        value: 5,
                        headerBuilder:
                            (BuildContext context, bool _isExpanded) {
                          return ListTile(
                            title: Text('Sebi Charge'),
                            trailing: Text(
                                intradayProvider.totalSebiCharge.toString()),
                          );
                        },
                        body: Column(
                          children: <ListTile>[
                            ListTile(
                              title: Text('Buy Sebi Charge'),
                              trailing: Text(
                                  intradayProvider.buySebiCharge.toString()),
                            ),
                            ListTile(
                              title: Text('Sell Sebi Charge'),
                              trailing: Text(
                                  intradayProvider.sellSebiCharge.toString()),
                            ),
                          ],
                        ),
                        canTapOnHeader: true,
                      ),
                      //Stamp Duty
                      ExpansionPanelRadio(
                        value: 6,
                        headerBuilder:
                            (BuildContext context, bool _isExpanded) {
                          return ListTile(
                            title: Text('Stamp Duty'),
                            trailing:
                                Text(intradayProvider.stampDuty.toString()),
                          );
                        },
                        body: ListTile(
                          subtitle: Text('Stamp charges on buying side.'),
                        ),
                        canTapOnHeader: true,
                      ),
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
