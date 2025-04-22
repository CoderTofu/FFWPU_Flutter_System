import 'package:flutter/material.dart';

class MemberDetailPage extends StatelessWidget {
  final String name;
  final String email;
  final String role;

  const MemberDetailPage({
    required this.name,
    required this.email,
    required this.role,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(name)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: $name'),
            Text('Email: $email'),
            Text('Role: $role'),
          ],
        ),
      ),
    );
  }
}
