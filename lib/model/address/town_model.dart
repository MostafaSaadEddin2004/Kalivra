class TownModel {
  final String id;
  final String name;

  TownModel({required this.id, required this.name});

  factory TownModel.fromJson(Map<String, dynamic> json) {
    return TownModel(id: '${json['id']}', name: '${json['name']}');
  }
}
