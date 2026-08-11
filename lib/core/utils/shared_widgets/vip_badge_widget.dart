import 'package:flutter/material.dart';

class VipBadgeWidget extends StatelessWidget {
  final bool isVip;
  final String? title;

  const VipBadgeWidget({
    super.key,
    required this.isVip,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    if (!isVip) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFD700), Color(0xFFD4AF37)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x40D4AF37),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.star_rounded,
            color: Colors.black,
            size: 14,
          ),
          const SizedBox(width: 4),
          Text(
            title ?? 'VIP',
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}
