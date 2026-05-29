import 'package:flutter/material.dart';
import 'package:shakshak/core/resources/app_colors.dart';
import 'package:shakshak/core/router/router_helper.dart';
import 'package:shakshak/core/utils/shared_widgets/custom_loading.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

import 'package:shakshak/core/router/routes.dart';
import 'package:shakshak/generated/l10n.dart';

class PaymentView extends StatefulWidget {
  const PaymentView({
    super.key,
    required this.paymentUrl,
  });

  final String paymentUrl;

  @override
  State<PaymentView> createState() => _PaymentViewState();
}

class _PaymentViewState extends State<PaymentView> {
  late WebViewControllerPlus webViewController;
  bool isLoading = true;

  @override
  void initState() {
    webViewController = WebViewControllerPlus()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onUrlChange: (url) {
            debugPrint('onUrlChange ${url.url}');
            if (!(url.url!.contains('failure'))) {
              if (url.url!.contains('error')) {
                navigateTo(context, Routes.walletView);
              } else if (url.url!.contains('success')) {
                navigateTo(context, Routes.walletView);
              }
            }
          },
          onPageStarted: (url) {
            setState(() {
              isLoading = true;
            });
          },
          onPageFinished: (url) {
            setState(() {
              isLoading = false;
            });
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.paymentUrl));

    super.initState();
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
              navigateTo(context, Routes.walletView);
            },
            child: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
          ),
          elevation: 0,
          backgroundColor: AppColors.primaryColor,
          title: Text(
            overflow: TextOverflow.ellipsis,
            S.of(context).pay,
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
                webViewController.clearCache();
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


