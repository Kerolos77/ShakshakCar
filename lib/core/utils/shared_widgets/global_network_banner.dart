import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shakshak/core/extentions/glopal_extentions.dart';
import 'package:shakshak/core/network/network_info/network_cubit.dart';
import 'package:shakshak/core/network/network_info/network_state.dart';

import '../../../generated/l10n.dart';
import '../../utils/styles.dart';

class GlobalNetworkBanner extends StatefulWidget {
  final Widget child;

  const GlobalNetworkBanner({super.key, required this.child});

  @override
  State<GlobalNetworkBanner> createState() => _GlobalNetworkBannerState();
}

class _GlobalNetworkBannerState extends State<GlobalNetworkBanner> {
  bool _showBanner = false;
  bool _isConnected = true;

  @override
  Widget build(BuildContext context) {
    return BlocListener<NetworkCubit, NetworkState>(
      listener: (context, state) {
        if (state is NetworkDisconnected) {
          setState(() {
            _showBanner = true;
            _isConnected = false;
          });
        } else if (state is NetworkConnected) {
          // If we were showing the disconnected state, turn it green then hide
          if (_showBanner && !_isConnected) {
            setState(() {
              _isConnected = true;
            });
            // Hide after 2.5 seconds
            Future.delayed(const Duration(milliseconds: 2500), () {
              if (mounted && _isConnected) {
                setState(() {
                  _showBanner = false;
                });
              }
            });
          }
        }
      },
      child: Stack(
        children: [
          // The Main Application Child
          widget.child,

          // The Animated Banner Overlay
          AnimatedPositioned(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOutBack,
            top: _showBanner ? 0 : -100.h,
            left: 0,
            right: 0,
            child: SafeArea(
              bottom: false,
              child: Material(
                color: Colors.transparent,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                  decoration: BoxDecoration(
                    color: _isConnected
                        ? Colors.green.withOpacity(0.9)
                        : Colors.redAccent.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(16.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      )
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _isConnected
                            ? Icons.wifi_rounded
                            : Icons.wifi_off_rounded,
                        color: Colors.white,
                        size: 20.r,
                      ),
                      8.pw,
                      Text(
                        _isConnected
                            ? S.current
                                .connectionRestored // Add this key if it doesn't exist or use generic
                            : S.current.noInternetConnection,
                        // Add this key or use generic
                        style: Styles.textStyle14SemiBold(context).copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
