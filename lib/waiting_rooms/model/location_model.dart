class LocationModel{

  final String id;
  final String name;
  final String gate;

  const LocationModel({required this.id, required this.name, required this.gate});

  Map<String,dynamic> toJson(){
    return {
      'id': id,
      'name': name,
      'gate': gate
    };
  }

  static LocationModel fromJson(Map<String,dynamic> json){
    return LocationModel(
        id: json['_id'] ?? json['id'],
        name: json['name'],
        gate: json['gate'],
    );
  }

  static List<LocationModel> fromJsonArray(List<dynamic> dataList){
    return dataList.map((e) => LocationModel.fromJson(e)).toList();
  }

}