class SenderModel {
  late int id;
  late String sender;
  late String date;

  SenderModel({required this.id, required this.sender, required this.date});

  SenderModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int;
    sender = json['sender'].toString();
    date = json['update_at'].toString();
  }

  @override
  String toString() {
    return "Id : $id\nSender : $sender";
  }
}

class MessageModel {
  late int id;
  late int senderId;
  late String message;

  MessageModel({
    required this.id,
    required this.senderId,
    required this.message,
  });

  MessageModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int;
    senderId = json['sender_id'] as int;
    message = json['message'].toString();
  }

  @override
  String toString() {
    return "Id : $id\nSender Id : $senderId\n Message : $message";
  }
}

class GroupModel {
  late int id;
  late String name;
  late String date;

  GroupModel({required this.id, required this.name, required this.date});

  GroupModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int;
    name = json['name'].toString();
    date = json['update_at'].toString();
  }

  @override
  String toString() {
    return "Id : $id Group Name : $name";
  }
}

class GroupMessageModel {
  late int id;
  late int groupId;
  late String sender;
  late String message;

  GroupMessageModel({
    required this.id,
    required this.groupId,
    required this.sender,
    required this.message,
  });

  GroupMessageModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int;
    groupId = json['group_id'] as int;
    sender = json['sender'].toString();
    message = json['message'].toString();
  }
}
