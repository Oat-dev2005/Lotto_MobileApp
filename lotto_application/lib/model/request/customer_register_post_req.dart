// To parse this JSON data, do
//
//     final customerRegisterPostRequest = customerRegisterPostRequestFromJson(jsonString);

import 'dart:convert';

CustomerRegisterPostRequest customerRegisterPostRequestFromJson(String str) =>
    CustomerRegisterPostRequest.fromJson(json.decode(str));

String customerRegisterPostRequestToJson(CustomerRegisterPostRequest data) =>
    json.encode(data.toJson());

class CustomerRegisterPostRequest {
  String fullname;
  String phone;
  String email;
  String image;
  String password;
  String role;

  CustomerRegisterPostRequest({
    required this.fullname,
    required this.phone,
    required this.email,
    required this.image,
    required this.password,
    required this.role,
  });

  factory CustomerRegisterPostRequest.fromJson(Map<String, dynamic> json) =>
      CustomerRegisterPostRequest(
        fullname: json["fullname"],
        phone: json["phone"],
        email: json["email"],
        image: json["image"],
        password: json["password"],
        role: json["role"],
      );

  Map<String, dynamic> toJson() => {
    "fullname": fullname,
    "phone": phone,
    "email": email,
    "image": image,
    "password": password,
    "role": role,
  };
}
