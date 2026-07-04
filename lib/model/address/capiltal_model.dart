class CapitalModel {
  final String id;
  final String name;

  CapitalModel({required this.id, required this.name});

  factory CapitalModel.fromJson(Map<String, dynamic> json) {
    return CapitalModel(id: '${json['id']}', name: '${json['name']}');
  }
}
