class Message {
  final String messageId;
  final String datetime;
  final String description;

  Message({
    this.messageId = '',
    required this.datetime,
    required this.description,
  });
}
