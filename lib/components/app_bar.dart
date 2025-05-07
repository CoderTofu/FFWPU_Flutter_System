import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  const CustomAppBar({super.key, this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        "FFWPU${title != null ? ' - $title' : ''}",
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
      ),
      backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
      automaticallyImplyLeading: false,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Image.asset(
          'assets/images/ffwpu_icon.png',
          width: 40,
          height: 40,
          fit: BoxFit.cover,
        ),
      ),
      actions: [
        Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu,
                color: Colors.black), // Set your icon color here
            onPressed: () {
              Scaffold.of(context).openEndDrawer();
            },
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
