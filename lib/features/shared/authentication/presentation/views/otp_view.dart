import 'package:flutter/material.dart';

import 'package:shakshak/core/utils/common_use.dart';
import 'package:shakshak/features/shared/authentication/presentation/widgets/otp_view_body.dart';

class OtpView extends StatelessWidget {
  const OtpView({
    super.key,
    required this.phoneNumber,
  });

  final String phoneNumber;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: buildAppBar(context,
          color: Colors.transparent, iconColor: Colors.white),
      body: OtpViewBody(phoneNumber: phoneNumber),
    );
  }
}
