import 'dart:convert';

class AdsModel {
  final int id;
  final String name;
  final int sortOrder;
  final List<AdsInfoModel> adsInfo;

  AdsModel({
    required this.id,
    required this.name,
    required this.sortOrder,
    required this.adsInfo,
  });

  factory AdsModel.fromJson(Map<String, dynamic> json) {
    return AdsModel(
      id: json['id'],
      name: json['name'],
      sortOrder: json['sort_order'],
      adsInfo: (jsonDecode(json['adsInfo']) as List)
          .map((e) => AdsInfoModel.fromJson(e))
          .toList(),
    );
  }
}

class AdsInfoModel {
  final String title;
  final String? link;
  final String image;

  AdsInfoModel({required this.title, required this.link, required this.image});

  factory AdsInfoModel.fromJson(Map<String, dynamic> json) {
    return AdsInfoModel(
      title: json['title'],
      link: json['link'] ?? '',
      image: json['image'],
    );
  }
}
