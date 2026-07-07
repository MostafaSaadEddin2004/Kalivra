class AssociationRequestAddress {
  AssociationRequestAddress({
    this.capitalId,
    this.cityId,
    this.townId,
    this.village = '',
    this.streetName = '',
    this.streetNumber = '',
    this.building = '',
    this.label = '',
    this.type = '',
  });

  final String? capitalId;
  final String? cityId;
  final String? townId;
  final String village;
  final String streetName;
  final String streetNumber;
  final String building;
  final String label;
  final String type;

  Map<String, dynamic> toMap({bool includeDetails = false}) {
    final map = <String, dynamic>{
      'capital_id': capitalId,
      'city_id': cityId,
      'town_id': townId,
      'village': village,
      'street_name': streetName,
      'street_number': streetNumber,
      'building': building,
    };

    if (includeDetails) {
      map['label'] = label;
      map['type'] = type;
    }

    map.removeWhere(
      (_, value) => value == null || (value is String && value.isEmpty),
    );
    return map;
  }
}
