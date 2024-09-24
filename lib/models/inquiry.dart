// To parse this JSON data, do
//
//     final inquiry = inquiryFromJson(jsonString);

import 'dart:convert';

Inquiry inquiryFromJson(String str) => Inquiry.fromJson(json.decode(str));

String inquiryToJson(Inquiry data) => json.encode(data.toJson());

class Inquiry {
    String id;
    String name;
    String email;
    String phone;
    String message;
    String productInfo;
    String status;
    DateTime createdAt;
    int v;

    Inquiry({
        required this.id,
        required this.name,
        required this.email,
        required this.phone,
        required this.message,
        required this.productInfo,
        required this.status,
        required this.createdAt,
        required this.v,
    });

    factory Inquiry.fromJson(Map<String, dynamic> json) => Inquiry(
        id: json["_id"],
        name: json["name"],
        email: json["email"],
        phone: json["phone"],
        message: json["message"],
        productInfo: json["productInfo"],
        status: json["status"],
        createdAt: DateTime.parse(json["createdAt"]),
        v: json["__v"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "email": email,
        "phone": phone,
        "message": message,
        "productInfo": productInfo,
        "status": status,
        "createdAt": createdAt.toIso8601String(),
        "__v": v,
    };
}
