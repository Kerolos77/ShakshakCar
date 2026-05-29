import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:shakshak/generated/l10n.dart';
import 'package:shakshak/core/network/local/cache_helper.dart';
import 'package:shakshak/core/resources/app_colors.dart';
import 'package:shakshak/features/user/user_home_page/data/models/cancel_ride_request_body.dart';
import 'package:shakshak/features/user/user_home_page/logic/home_cubit.dart';
import 'package:shakshak/features/user/user_home_page/logic/home_states.dart';
import 'find_driver_button.dart';

class WaitingForRepliesAndChangeOfferWidget extends StatefulWidget {
  WaitingForRepliesAndChangeOfferWidget(
      {super.key,
      required this.currentOfferValue,
      required this.offerController,
      required this.cubit});

  final HomeCubit cubit;

  int currentOfferValue = 0;
  TextEditingController offerController;

  @override
  State<WaitingForRepliesAndChangeOfferWidget> createState() =>
      _WaitingForRepliesAndChangeOfferWidgetState();
}

class _WaitingForRepliesAndChangeOfferWidgetState
    extends State<WaitingForRepliesAndChangeOfferWidget> {
  // late HubConnection connection;
  //
  // @override
  // void initState() {
  //   super.initState();
  //   setupSignalRConnection();
  // }
  //
  // void setupSignalRConnection() {
  //   connection = HubConnectionBuilder()
  //       .withUrl(
  //     'http://209.38.202.150/locationhub', // Use HTTPS if server supports it
  //     HttpConnectionOptions(
  //       logging: (level, message) => print("SignalR Log [$level]: $message"),
  //       // transport: HttpTransportType.webSockets,
  //       accessTokenFactory: () async => 'Bearer ${CacheHelper.getdata(key: "token") }', // Optional: Add if required
  //     ),
  //   )
  //       // .withHubProtocol(JsonHubProtocol()) // Explicitly set JSON protocol
  //       // .withAutomaticReconnect() // Optionally handle reconnection attempts
  //       .build();
  //
  //   connection.onclose((error) {
  //     print("SignalR connection closed: $error");
  //     if (error != null) {
  //       Future.delayed(Duration(seconds: 10), openSignalRConnection); // Retry logic if needed
  //     }
  //   });
  //
  //   connection.on('ReceiveNearbyDrivers', (drivers) {
  //     // Handle incoming data
  //   });
  //
  //   openSignalRConnection();
  // }
  //
  // Future<void> openSignalRConnection() async {
  //   try {
  //     await connection.start();
  //     print("SignalR connection started successfully");
  //   } catch (error) {
  //     print("SignalR connection error: $error");
  //     Future.delayed(Duration(seconds: 5), openSignalRConnection); // Retry if necessary
  //   }
  // }
  //
  // void closeSignalRConnection() {
  //   if (connection.state == HubConnectionState.connected || connection.state == HubConnectionState.connecting) {
  //     connection.stop();
  //   }
  // }
  //
  // @override
  // void dispose() {
  //   closeSignalRConnection();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setState) {
        return Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.46,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(27.r),
              topRight: Radius.circular(27.r),
            ),
            color: Theme.of(context).colorScheme.surface,
          ),
          child: ListView(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                child: Column(
                  children: [
                    Text(
                      S.of(context).waitingForReplies,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    LinearProgressIndicator(
                      value: 0.8,
                      valueColor: AlwaysStoppedAnimation(
                        AppColors.primaryColor,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      S.of(context).yourOffer,
                      style: TextStyle(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.7),
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              widget.currentOfferValue =
                                  widget.currentOfferValue - 3;
                            });
                          },
                          child: Text(
                            "-3",
                            style: TextStyle(
                              color: Theme.of(context).hintColor,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context)
                                  .colorScheme
                                  .surfaceContainerHighest,
                              padding: EdgeInsets.symmetric(
                                horizontal: 25.w,
                                vertical: 10.h,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.r),
                              )),
                        ),
                        Spacer(),
                        Text(
                          "EGP ${widget.currentOfferValue.toString()}",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Spacer(),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              widget.currentOfferValue =
                                  widget.currentOfferValue + 3;
                            });
                          },
                          child: Text(
                            "+3",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSecondary,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.secondary,
                            padding: EdgeInsets.symmetric(
                              horizontal: 25.w,
                              vertical: 10.h,
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.r)),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * .8,
                      child: DriverButton(
                        buttonText: S.of(context).raiseFare,
                        onPressed: widget.currentOfferValue ==
                                int.parse(widget.offerController.text)
                            ? null
                            : () async {},
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * .8,
                      child: DriverButton(
                        buttonText: S.of(context).cancel,
                        onPressed: () async {
                          widget.cubit.cancelRideRequestByPassenger(
                            cancelRideRequestBody: CancelRideRequestBody(
                              rideRequestsId:
                                  CacheHelper.getData(key: "rideRequestId"),
                            ),
                          );
                        },
                        buttonColor: Colors.red,
                      ),
                    ),
                    BlocConsumer<HomeCubit, HomeState>(
                      builder: (context, state) {
                        return SizedBox.shrink();
                      },
                      listener: (context, state) {
                        if (state is CancelRideRequestPassengerSuccessState) {
                          Navigator.pop(context);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
