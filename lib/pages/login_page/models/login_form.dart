// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class LoginForm {
  final String username;
  final String password;
  LoginForm({
    required this.username,
    required this.password,
  });

  LoginForm copyWith({
    String? username,
    String? password,
  }) {
    return LoginForm(
      username: username ?? this.username,
      password: password ?? this.password,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'username': username,
      'password': password,
    };
  }

  factory LoginForm.fromMap(Map<String, dynamic> map) {
    return LoginForm(
      username: map['username'] as String,
      password: map['password'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory LoginForm.fromJson(String source) =>
      LoginForm.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'LoginModel(username: $username, password: $password)';

  @override
  bool operator ==(covariant LoginForm other) {
    if (identical(this, other)) return true;

    return other.username == username && other.password == password;
  }

  @override
  int get hashCode => username.hashCode ^ password.hashCode;

  String? validateForm() {
    if (username.isEmpty) {
      return 'يرجى ملئ حقل اسم المستخدم';
    }
    if (password.isEmpty) {
      return 'يرجى ملئ حقل كلمة المرور';
    }
    return null;
  }
}
