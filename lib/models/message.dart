class Message {
  final String id;
  final String content;
  final String senderId;
  final String? senderNickname;
  final bool fromMe;
  final DateTime createdAt;
  final String? profileImg;

  Message({
    required this.id,
    required this.content,
    required this.senderId,
    this.senderNickname,
    required this.fromMe,
    required this.createdAt,
    this.profileImg,
  });
}
