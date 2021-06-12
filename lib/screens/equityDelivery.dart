import 'package:brokerage_calculator/screens/widgets/heading.dart';
import 'package:brokerage_calculator/providers/deliveryProvider.dart';
import 'package:brokerage_calculator/helpers/enums.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EquityDelivery extends StatefulWidget {
  @override
  _EquityDeliveryState createState() => _EquityDeliveryState();
}

class _EquityDeliveryState extends State<EquityDelivery> {
  @override
  Widget build(BuildContext context) {
    final deliveryProvider =
        Provider.of<DeliveryProvider>(context, listen: true);

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            //Heading
            heading(heading: 'Equity Delivery'),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: ListTile(
                    title: Text('NSE'),
                    leading: Radio(
                      value: Market.NSE,
                      groupValue: deliveryProvider.selectedMarket,
                      onChanged: (value) {
                        deliveryProvider.selectMarket(market: value as Market);
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: ListTile(
                    title: Text('BSE'),
                    leading: Radio(
                      value: Market.BSE,
                      groupValue: deliveryProvider.selectedMarket,
                      onChanged: (value) {
                        deliveryProvider.selectMarket(market: value as Market);
                      },
                    ),
                  ),
                ),
              ],
            ),
            Divider(),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 5.0),
            ),
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
                      deliveryProvider.setBuyPrice(price: value);
                      deliveryProvider.calcBuyCharges();
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
                      deliveryProvider.setSellPrice(price: value);
                      deliveryProvider.calcCharges();
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
                      deliveryProvider.setQuantity(quantity: value);
                      deliveryProvider.calcCharges();
                    },
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 5.0),
            ),
            //Minimum Profit Sell
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Minimum Profit Sell: ${deliveryProvider.minSellPrice}',
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
            Column(
              //Net P&L
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
                  deliveryProvider.netProfit.toString(),
                  style: TextStyle(
                    fontSize: 25.0,
                    color: deliveryProvider.netProfit.isNegative
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
            //Total Charges
            ListTile(
              title: Text('Total Tax & Charge'),
              trailing: Text(deliveryProvider.totalCharge.toString()),
            ),
            Divider(),
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
                                deliveryProvider.totalBrokerage.toString()),
                          );
                        },
                        body: ListTile(
                          trailing: Text('Zerodha charges 0 brokerage.'),
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
                                Text(deliveryProvider.totalSTT.toString()),
                          );
                        },
                        body: Column(
                          children: <ListTile>[
                            ListTile(
                              title: Text('Buy STT'),
                              trailing:
                                  Text(deliveryProvider.buySTT.toString()),
                            ),
                            ListTile(
                              title: Text('Sell STT'),
                              trailing:
                                  Text(deliveryProvider.sellSTT.toString()),
                            ),
                          ],
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
                                deliveryProvider.totalTxnCharge.toString()),
                          );
                        },
                        body: Column(
                          children: <ListTile>[
                            ListTile(
                              title: Text('Buy Transaction Charge'),
                              trailing: Text(
                                  deliveryProvider.buyTxnCharge.toString()),
                            ),
                            ListTile(
                              title: Text('Sell Transaction Charge'),
                              trailing: Text(
                                  deliveryProvider.sellTxnCharge.toString()),
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
                                Text(deliveryProvider.totalGST.toString()),
                          );
                        },
                        body: Column(
                          children: <ListTile>[
                            ListTile(
                              title: Text('Buy GST'),
                              trailing:
                                  Text(deliveryProvider.buyGST.toString()),
                            ),
                            ListTile(
                              title: Text('Sell GST'),
                              trailing:
                                  Text(deliveryProvider.sellGST.toString()),
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
                                deliveryProvider.totalSebiCharge.toString()),
                          );
                        },
                        body: Column(
                          children: <ListTile>[
                            ListTile(
                              title: Text('Buy Sebi Charge'),
                              trailing: Text(
                                  deliveryProvider.buySebiCharge.toString()),
                            ),
                            ListTile(
                              title: Text('Sell Sebi Charge'),
                              trailing: Text(
                                  deliveryProvider.sellSebiCharge.toString()),
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
                                Text(deliveryProvider.stampDuty.toString()),
                          );
                        },
                        body: ListTile(
                          subtitle: Text('Stamp charges on buying side.'),
                        ),
                        canTapOnHeader: true,
                      ),
                      ExpansionPanelRadio(
                        value: 7,
                        headerBuilder:
                            (BuildContext context, bool _isExpanded) {
                          return ListTile(
                            title: Text('DP Charge'),
                            trailing:
                                Text(deliveryProvider.dpcharge.toString()),
                          );
                        },
                        body: ListTile(
                          subtitle: Text(
                              '₹13.5 + GST per scrip (irrespective of quantity), on the day, is debited from the trading account when stocks are sold. This is charged by the depository (CDSL) and depository participant (Zerodha).'),
                        ),
                        canTapOnHeader: true,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
