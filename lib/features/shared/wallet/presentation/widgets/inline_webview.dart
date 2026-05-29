import 'package:flutter/material.dart';
import 'package:shakshak/core/resources/app_colors.dart';
import 'package:shakshak/core/utils/shared_widgets/custom_loading.dart';
import 'package:shakshak/generated/l10n.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

class InlineWebView extends StatefulWidget {
  final String url;
  final VoidCallback onFinish;

  const InlineWebView({
    Key? key,
    required this.url,
    required this.onFinish,
  }) : super(key: key);

  @override
  State<InlineWebView> createState() => _InlineWebViewState();
}

class _InlineWebViewState extends State<InlineWebView> {
  late WebViewControllerPlus webViewController;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    webViewController = WebViewControllerPlus()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onUrlChange: (url) {
            debugPrint('Inline WebView onUrlChange ${url.url}');
            if (url.url != null) {
               if (url.url!.contains('success=true') || url.url!.contains('success=false') || url.url!.contains('error')) {
                 widget.onFinish();
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
      );
      
    if (widget.url.isNotEmpty) {
      final String validUrl = widget.url.startsWith('http') ? widget.url : 'https://${widget.url}';
      webViewController.loadRequest(Uri.parse(validUrl));
    } else {
      // If the URL is somehow empty, finish immediately
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.onFinish();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: widget.onFinish,
            ),
            Text(
              S.of(context).pay,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                webViewController.reload();
              },
            ),
          ],
        ),
        Expanded(
          child: Stack(
            children: [
              WebViewWidget(controller: webViewController),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 65, // Explicit height to cover the grey area
                  decoration: BoxDecoration(
                    color: AppColors.primaryLightColor,
                    border: Border(
                      bottom: BorderSide(
                        color: AppColors.primaryColor.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                  ),
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.info_outline,
                        color: AppColors.primaryColor,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          S.of(context).deductedAmountAddedToWallet,
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (isLoading)
                Container(
                  color: Colors.white.withOpacity(0.9),
                  child: const Center(
                    child: CustomLoading(),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
