class CityModel {
  final String id;
  final String name;
  final String capitalId;
  
  CityModel({required this.id, required this.name, required this.capitalId});

  factory CityModel.fromJson(Map<String, dynamic> json) {
    return CityModel(
      id: '${json['id']}',
      name: '${json['name']}',
      capitalId: '${json['capital_id']}',
    );
  }
}
