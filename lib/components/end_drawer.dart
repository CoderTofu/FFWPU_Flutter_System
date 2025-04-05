import 'package:ffwpu_flutter_view/pages/blessings_page.dart';
import 'package:ffwpu_flutter_view/pages/donations_page.dart';
import 'package:ffwpu_flutter_view/pages/login_page.dart';
import 'package:ffwpu_flutter_view/pages/members_page.dart';
import 'package:ffwpu_flutter_view/pages/reporting_page.dart';
import 'package:ffwpu_flutter_view/pages/worship_page.dart';
import 'package:flutter/material.dart';

class EndDrawer extends StatelessWidget {
  const EndDrawer({super.key});

  void _navigateTo(BuildContext context, Widget page) {
    Navigator.pop(context);
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(),
      ),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 1, 67, 143),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Icon(Icons.account_circle, size: 50, color: Colors.white),
                SizedBox(height: 10),
                Text(
                  "User Name",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                Text(
                  "user@example.com",
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),

          ListTile(
            leading: const Icon(Icons.people),
            title: const Text("Members"),
            onTap: () => _navigateTo(context, const MembersPage()),
          ),
          ListTile(
            leading: const Icon(Icons.church),
            title: const Text("Worship"),
            onTap: () => _navigateTo(context, const WorshipPage()),
          ),
          ListTile(
            leading: const Icon(Icons.health_and_safety),
            title: const Text("Blessings"),
            onTap: () => _navigateTo(context, const BlessingsPage()),
          ),
          ListTile(
            leading: const Icon(Icons.volunteer_activism),
            title: const Text("Donations"),
            onTap: () => _navigateTo(context, const DonationsPage()),
          ),
          ListTile(
            leading: const Icon(Icons.bar_chart),
            title: const Text("Reporting"),
            onTap: () => _navigateTo(context, const ReportingPage()),
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text("Logout"),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
                (route) => false, // Clear the whole stack
              );
            },
          ),
        ],
      ),
    );
  }
}
