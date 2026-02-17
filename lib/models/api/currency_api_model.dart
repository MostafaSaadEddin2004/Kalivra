/// GET /api/shop/v1/currencies – currencies and rates.
class CurrencyApiModel {
  const CurrencyApiModel({
    required this.id,
    required this.code,
    this.name,
    this.symbol,
    this.decimal,
    this.exchangeRate,
  });

  final int id;
  final String code;
  final String? name;
  final String? symbol;
  final int? decimal;
  final double? exchangeRate;

  factory CurrencyApiModel.fromJson(Map<String, dynamic> json) {
    return CurrencyApiModel(
      id: json['id'] as int,
      code: json['code'] as String,
      name: json['name'] as String?,
      symbol: json['symbol'] as String?,
      decimal: json['decimal'] as int?,
      exchangeRate: (json['exchange_rate'] as num?)?.toDouble(),
    );
  }
}
