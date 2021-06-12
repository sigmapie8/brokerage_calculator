import 'package:flutter/material.dart';
import 'package:brokerage_calculator/helpers/enums.dart';

class IntradayProvider extends ChangeNotifier {
  Market _selectedMarket = Market.NSE;
  double _buyPrice = 0, _sellPrice = 0;
  int _quantity = 0;

  double _buyBrokerage = 0, _sellBrokerage = 0, _totalBrokerage = 0;
  double _buySTT = 0, _sellSTT = 0, _totalSTT = 0;
  double _buyTxnCharge = 0, _sellTxnCharge = 0, _totalTxnCharge = 0;
  double _buyGST = 0, _sellGST = 0, _totalGST = 0;
  double _buySebiCharge = 0, _sellSebiCharge = 0, _totalSebiCharge = 0;
  double _stampDuty = 0;
  double _totalCharge = 0;
  double _netProfit = 0;
  double _minSellPrice = 0;

  //<<<<<<<<<<<<<<<<<<<< Getters >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

  Market get selectedMarket => _selectedMarket;
  double get buyPrice => _buyPrice;
  double get sellPrice => _sellPrice;
  int get quantity => _quantity;
  double get buyBrokerage => _buyBrokerage;
  double get sellBrokerage => _sellBrokerage;
  double get totalBrokerage => _totalBrokerage;
  double get buySTT => _buySTT;
  double get sellSTT => _sellSTT;
  double get totalSTT => _totalSTT;
  double get buyTxnCharge => _buyTxnCharge;
  double get sellTxnCharge => _sellTxnCharge;
  double get totalTxnCharge => _totalTxnCharge;
  double get buyGST => _buyGST;
  double get sellGST => _sellGST;
  double get totalGST => _totalGST;
  double get buySebiCharge => _buySebiCharge;
  double get sellSebiCharge => _sellSebiCharge;
  double get totalSebiCharge => _totalSebiCharge;
  double get stampDuty => _stampDuty;
  double get totalCharge => _totalCharge;
  double get netProfit => _netProfit;
  double get minSellPrice => _minSellPrice;

  //<<<<<<<<<<<<<<<<<<<< Setters >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

  void selectMarket({required Market market}) {
    _selectedMarket = market;
    calcMinSell();
    notifyListeners();
  }

  void setBuyPrice({required String price}) {
    if (price == "") {
      _buyPrice = 0;
    } else {
      _buyPrice = double.parse(price);
    }
    notifyListeners();
  }

  void setSellPrice({required String price}) {
    if (price == "") {
      _sellPrice = 0;
    } else {
      _sellPrice = double.parse(price);
    }
    notifyListeners();
  }

  void setQuantity({required String quantity}) {
    if (quantity == "") {
      _quantity = 0;
    } else {
      _quantity = int.parse(quantity);
    }

    notifyListeners();
  }

  void calcMinSell() {
    double buyPrice = _buyPrice;
    int quantity = _quantity;

    if (buyPrice == 0 || quantity == 0) {
      _minSellPrice = 0;
      notifyListeners();
      return;
    }
    double minSellPriceInc = 0;
    if (_selectedMarket == Market.NSE) {
      minSellPriceInc = 0.05;
    } else {
      minSellPriceInc = 0.01;
    }
    double totalBuyCharges = round(
        num: (_buyGST +
            _buySTT +
            _buySebiCharge +
            _buyTxnCharge +
            _stampDuty +
            _buyBrokerage),
        n: 2);

    _minSellPrice = round(num: ((totalBuyCharges / quantity) + buyPrice), n: 2);
    double totalSellCharges =
        calcMinSellCharges(sellPrice: _minSellPrice, quantity: quantity);

    double net = ((_minSellPrice - buyPrice) * quantity) -
        totalBuyCharges -
        totalSellCharges;

    while (net <= 0) {
      _minSellPrice += minSellPriceInc;
      totalSellCharges =
          calcMinSellCharges(sellPrice: _minSellPrice, quantity: quantity);
      net = ((_minSellPrice - buyPrice) * quantity) -
          totalBuyCharges -
          totalSellCharges;
    }
    _minSellPrice = round(num: _minSellPrice, n: 2);
    notifyListeners();
  }

  void calcBuyCharges() {
    double buyPrice = _buyPrice;
    int quantity = _quantity;
    double buyAmount = buyPrice * quantity;
    _buyBrokerage =
        (0.0003 * buyAmount) > 20 ? 20 : round(num: 0.0003 * buyAmount, n: 3);
    _buySTT = 0;
    _buyTxnCharge = round(num: 0.0000345 * buyAmount, n: 3);
    _buyGST = round(num: 0.18 * (_buyTxnCharge + _buyBrokerage), n: 3);
    _buySebiCharge = round(num: 0.0000001 * buyAmount, n: 3);
    _stampDuty = (0.00003 * buyAmount) < 300
        ? round(num: (0.00003 * buyAmount), n: 2)
        : 300;
    notifyListeners();
  }

  void calcSellCharges() {
    double sellPrice = _sellPrice;
    int quantity = _quantity;
    double sellAmount = sellPrice * quantity;
    _sellBrokerage =
        (0.0003 * sellAmount) > 20 ? 20 : round(num: 0.0003 * sellAmount, n: 3);
    _sellSTT = round(num: 0.00025 * sellAmount, n: 3);
    _sellTxnCharge = round(num: 0.0000345 * sellAmount, n: 3);
    _sellGST = round(num: 0.18 * (_sellTxnCharge + _sellBrokerage), n: 3);
    _sellSebiCharge = round(num: 0.0000001 * sellAmount, n: 3);
    notifyListeners();
  }

  void calcCharges() {
    double buyPrice = _buyPrice;
    double sellPrice = _sellPrice;
    int quantity = _quantity;

    calcBuyCharges();
    calcSellCharges();
    _totalBrokerage = (_buyBrokerage + _sellBrokerage) > 20
        ? 20
        : round(num: (_buyBrokerage + _sellBrokerage), n: 2);
    _totalSTT = round(num: _buySTT + _sellSTT, n: 2);
    _totalGST = round(num: _buyGST + _sellGST, n: 2);
    _totalSebiCharge = round(num: _buySebiCharge + _sellSebiCharge, n: 2);
    _totalTxnCharge = round(num: _buyTxnCharge + _sellTxnCharge, n: 2);
    _totalCharge = round(
        num: (_totalBrokerage +
            _totalGST +
            _totalSTT +
            _totalSebiCharge +
            _totalTxnCharge +
            _stampDuty),
        n: 2);
    _netProfit =
        round(num: (((sellPrice - buyPrice) * quantity) - _totalCharge), n: 2);
    calcMinSell();
    notifyListeners();
  }

  void initializeValues() {
    _selectedMarket = Market.NSE;
    _buyPrice = 0;
    _sellPrice = 0;
    _quantity = 0;

    _buyBrokerage = 0;
    _sellBrokerage = 0;
    _totalBrokerage = 0;
    _buySTT = 0;
    _sellSTT = 0;
    _totalSTT = 0;
    _buyTxnCharge = 0;
    _sellTxnCharge = 0;
    _totalTxnCharge = 0;
    _buyGST = 0;
    _sellGST = 0;
    _totalGST = 0;
    _buySebiCharge = 0;
    _sellSebiCharge = 0;
    _totalSebiCharge = 0;
    _stampDuty = 0;
    _totalCharge = 0;
    _netProfit = 0;
    _minSellPrice = 0;
  }
  //<<<<<<<<<<<<<<<<<<<<< functions >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

  double round({required double num, required int n}) {
    return double.parse(num.toStringAsFixed(n));
  }

  double calcMinSellCharges(
      {required double sellPrice, required int quantity}) {
    double sellAmount = sellPrice * quantity;
    double sellBrokerage =
        (0.0003 * sellAmount) > 20 ? 20 : round(num: 0.0003 * sellAmount, n: 3);
    _sellSTT = round(num: 0.00025 * sellAmount, n: 3);
    _sellTxnCharge = round(num: 0.0000345 * sellAmount, n: 3);
    _sellGST = round(num: 0.18 * (_sellTxnCharge + _sellBrokerage), n: 3);
    _sellSebiCharge = round(num: 0.0000001 * sellAmount, n: 3);

    double totalSellCharge =
        sellSTT + sellTxnCharge + sellGST + sellSebiCharge + sellBrokerage;

    return round(num: totalSellCharge, n: 3);
  }
}
