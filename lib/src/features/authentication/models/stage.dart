class Stage {
  final int stageId;
  final String name;
  final String address;
  final String latitude;
  final String longitude;

  Stage({
    required this.stageId,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
  });

  factory Stage.fromJson(Map<String, dynamic> json) {
    return Stage(
      stageId: json['stage_id'],
      name: json['name'],
      address: json['address'],
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'stage_id': stageId,
      'name': name,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
