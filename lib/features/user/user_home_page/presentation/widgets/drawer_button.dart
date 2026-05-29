import 'package:flutter/material.dart';

class MyDrawerButton extends StatelessWidget {
  const MyDrawerButton({super.key, required this.onPressed});

  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: "Drawer",
      mini: true,
      onPressed: onPressed,
      backgroundColor: Theme.of(context).cardColor,
      child: Icon(
        Icons.menu,
        color: Theme.of(context).iconTheme.color,
        size: 25,
      ),
    );
  }
}
