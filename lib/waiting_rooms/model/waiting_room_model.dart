class WaitingRoomModel{
  final String id;
  final String name;
  final String location;
  final int queueSize;

  const WaitingRoomModel({required this.id, required this.name, required this.location, this.queueSize=0});

  factory WaitingRoomModel.fromJson(Map<String, dynamic> json){
    return WaitingRoomModel(
        id: json['id'],
        name: json['name'],
        location: json['location'],
        queueSize: json['queueSize'],
    );
  }

  Map<String,dynamic> toJson(){
    return {
      'id': id,
      'name': name,
      'location': location,
      'queueSize': queueSize,
    };
  }

}