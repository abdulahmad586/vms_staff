enum ReminderCategory {
  personal,
  official,
  familyAndFriends,
}

class ReminderModel {
  final String id;
  final String title;
  final String description;
  final String calendarModelType;
  final DateTime date;
  final DateTime createdAt;
  final bool sms;
  final bool fsms;
  final bool ring;
  final bool tts;
  final bool email;
  final bool voice;
  final bool conferencing;
  final String? voiceData; //base64 encoded wav mono 8khz

  ReminderModel({
    required this.id,
    required this.title,
    required this.description,
    required this.calendarModelType,
    required this.date,
    required this.createdAt,
    this.sms = false,
    this.fsms = false,
    this.ring = false,
    this.tts = false,
    this.email = false,
    this.voice = false,
    this.conferencing = false,
    this.voiceData,
  });

  factory ReminderModel.fromJson(Map<String, dynamic> json) {
    return ReminderModel(
      id: json['_id'],
      title: json['title'],
      description: json['description'],
      calendarModelType: json['calendarType'] ?? json['type'],
      date: DateTime.parse(json['date']),
      sms: json['sms'] ?? false,
      fsms: json["fsms"] ?? json['fSms'] ?? false,
      ring: json['ring'] ?? false,
      tts: json['tts'] ?? false,
      email: json['email'] ?? false,
      voice: json['voice'] ?? false,
      conferencing: json['conferencing'] ?? false,
      voiceData: json['voiceData'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
