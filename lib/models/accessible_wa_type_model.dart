import 'package:whatsapp_gadgets/constants/whatsapp_types.dart';

class AccessibleWATypeModel {
  String whatsAppType;
  String? updatedAt;

  AccessibleWATypeModel({required this.whatsAppType, this.updatedAt});

  factory AccessibleWATypeModel.fromJson(Map<String, dynamic> json) =>
      AccessibleWATypeModel(
        whatsAppType: json['whatsAppType'],
        updatedAt: json['updatedAt'].toString(),
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'whatsAppType': whatsAppType,
        'updatedAt': updatedAt.toString(),
      };

  @override
  String toString() {
    return "================================================================================\n"
        "WhatsApp Type =====> $whatsAppType\n"
        "Updated At ========> $updatedAt";
  }
}
