class TownModel {
  final String id;
  final String name;
  final String cityId;

  TownModel({required this.id, required this.name, required this.cityId});

  factory TownModel.fromJson(Map<String, dynamic> json) {
    return TownModel(
      id: '${json['id']}',
      name: '${json['name']}',
      cityId: '${json['city_id']}',
    );
  }
}
