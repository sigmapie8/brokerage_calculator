enum Market {
  NSE,
  BSE,
}

extension marketExtension on Market {
  String? asString() => {
        Market.NSE: "NSE",
        Market.BSE: "BSE",
      }[this];
}
