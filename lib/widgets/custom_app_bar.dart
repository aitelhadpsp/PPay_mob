import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool showBackButton;

  const CustomAppBar({
    Key? key,
    required this.title,
    this.actions,
    this.showBackButton = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      leading:
          showBackButton
              ? IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Color(0xFF3F5C9E),
                ),
                onPressed: () => Navigator.pop(context),
              )
              : null,
      title: Text(
        title,
        style: const TextStyle(
          color: Color(0xFF3F5C9E),
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: actions,
      centerTitle: false,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56);
}