import 'package:flutter/material.dart';
import 'package:shakshak/core/resources/app_colors.dart';
import 'package:shakshak/core/router/router_helper.dart';
import 'package:shakshak/core/utils/shared_widgets/custom_loading.dart';
import 'package:shakshak/features/user/user_home/data/models/new-ride/new_ride_data.dart';
import 'package:go_router/go_router.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';
import 'package:shakshak/core/services/service_locator.dart';
import 'package:shakshak/core/services/real_time/realtime_manager.dart';
import 'package:shakshak/core/router/routes.dart';
import 'package:shakshak/core/router/route_args.dart';
import 'package:shakshak/generated/l10n.dart';

class RidePaymentWebViewScreen extends StatefulWidget {
  final String checkoutUrl;
  final int orderId;
  final bool isAddingCard;

  const RidePaymentWebViewScreen({
    super.key,
    required this.checkoutUrl,
    required this.orderId,
    this.isAddingCard = false,
  });

  @override
  State<RidePaymentWebViewScreen> createState() =>
      _RidePaymentWebViewScreenState();
}

class _RidePaymentWebViewScreenState extends State<RidePaymentWebViewScreen> {
  late WebViewControllerPlus webViewController;
  bool isLoading = true;
  String? _tripStatusToken;

  @override
  void initState() {
    super.initState();
    _listenToPaymentSuccess();

    webViewController = WebViewControllerPlus()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            setState(() {
              isLoading = true;
            });
          },
          onPageFinished: (url) {
            setState(() {
              isLoading = false;
            });
            // If it's adding card, check if the payment is concluded (success or failed via Paymob query params)
            if (widget.isAddingCard &&
                (url.contains('success=true') ||
                    url.contains('success=false'))) {
              // Card added process completed. Redirect to Wallet.
              context.pushReplacement(Routes.walletView);
            }
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.checkoutUrl));
  }

  void _listenToPaymentSuccess() {
    if (widget.isAddingCard)
      return; // Don't listen to trip sockets for card adding

    final realtimeManager = sl<RealtimeManager>();
    final channelName = "trip-${widget.orderId}";

    // We already subscribe to this channel in UserHomeCubit when the trip is created / offer is accepted
    // So we just need to listen to the status update event here

    _tripStatusToken = realtimeManager.addListener(
      channel: channelName,
      event: 'TripStatusUpdated',
      callback: (data) {
        debugPrint("📥 WebView got TripStatusUpdated: $data");
        final status = data['status'];
        final orderData = data['order'];

        if (status == 'assigned') {
          // Payment Success!
          final tripModel = NewRideData.fromJson(orderData);

          // Clear listener
          _removeListener();

          // Close Webview and navigate to drive details
          Navigator.of(context).pop();
          navigateTo(context, Routes.driveDetailsView,
              extra: DriveDetailsViewArgs(ride: tripModel));
        }
      },
    );
  }

  void _removeListener() {
    if (_tripStatusToken != null) {
      sl<RealtimeManager>().removeListener(_tripStatusToken!);
      _tripStatusToken = null;
    }
  }

  @override
  void dispose() {
    _removeListener();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Scaffold(
        appBar: AppBar(
          leading: InkWell(
            onTap: () {
              // If going back manually, just pop.
              // Payment might not be complete.
              Navigator.of(context).pop();
            },
            child: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
          ),
          elevation: 0,
          backgroundColor: AppColors.primaryColor,
          title: Text(
            S.of(context).electronicPayment,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.refresh,
                color: Colors.white,
              ),
              onPressed: () {
                webViewController.reload();
              },
            ),
          ],
        ),
        body: Stack(
          children: [
            WebViewWidget(
              controller: webViewController,
            ),
            Visibility(
              visible: isLoading,
              child: Container(
                color: Colors.white.withOpacity(0.9),
                child: const Center(
                  child: CustomLoading(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
