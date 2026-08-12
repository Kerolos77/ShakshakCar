import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shakshak/features/user/user_home/presentation/view_models/user_home/user_home_cubit.dart';
import 'package:shakshak/generated/l10n.dart';

class ShipmentActiveTripDialog {
  static void show(
    BuildContext context, {
    required int activeOrderId,
    required String message,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => BlocProvider.value(
        value: context.read<UserHomeCubit>(),
        child: AlertDialog(
          title: Text(S.of(context).warning),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                _showCancelConfirmationDialog(context, activeOrderId);
              },
              child: Text(
                S.of(context).cancel,
                style: const TextStyle(color: Colors.red),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                context.read<UserHomeCubit>().getRideDetails(activeOrderId);
              },
              child: Text(S.of(context).resumeYourTrip),
            ),
          ],
        ),
      ),
    );
  }

  static void _showCancelConfirmationDialog(
      BuildContext context, int orderId) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(S.of(context).confirmCancellation),
        content: Text(S.of(context).confirmCancelTripMsg),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(S.of(context).goBack),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<UserHomeCubit>().cancelOrder(orderId: orderId);
            },
            child: Text(
              S.of(context).confirmCancellation,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
