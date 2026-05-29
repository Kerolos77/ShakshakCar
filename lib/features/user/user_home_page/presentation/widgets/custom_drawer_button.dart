import 'package:flutter/material.dart';

import 'drawer_button.dart';

class CustomDrawerButton extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const CustomDrawerButton({required this.scaffoldKey});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: MyDrawerButton(
        onPressed: () {
          scaffoldKey.currentState?.openDrawer();
        },
      ),
    );
  }
}
