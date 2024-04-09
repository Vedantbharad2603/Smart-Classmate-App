class EventData {
  final String event_description;
  final String event_date;
  final int shiftdatumId;

  EventData({
    required this.event_description,
    required this.event_date,
    required this.shiftdatumId,
  });

  Map<String, dynamic> toJson() {
    return {
      'description': event_description,
      'date': event_date,
      'shiftid': shiftdatumId,
    };
  }

  factory EventData.fromJson(Map<String, dynamic> json) {
    return EventData(
      event_description: json['event_description'],
      event_date: json['event_date'],
      shiftdatumId: json['shiftdatumId'],
    );
  }
}
