import 'package:flutter/material.dart';

import 'package:shakshak/core/utils/common_use.dart';
import 'package:shakshak/features/shared/authentication/presentation/widgets/register_view_body.dart';

class RegisterView extends StatelessWidget {
  RegisterView({super.key, required this.phoneNumber});

  String phoneNumber;

  @override
  Widget build(BuildContext context) {
    print("${phoneNumber}aa=============================");

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: buildAppBar(context,
          color: Colors.transparent, iconColor: Colors.white),
      body: RegisterViewBody(
        phoneNumber: phoneNumber,
      ),
    );
  }
}
