import 'package:ffwpu_flutter_view/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:ffwpu_flutter_view/pages/member_detail_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const MemberDetailPage(
        memberID: "12",
      ),
    );
  }
}

// class RootPage extends StatefulWidget {
//   const RootPage({super.key});

//   @override
//   State<RootPage> createState() => _RootPageState();
// }

// class _RootPageState extends State<RootPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("FFWPU"),
//       ),
//
//       body: const Center(
//         child: Text('Hello World'),
//       ),
//     );
//   }
// }
