import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shakshak/core/extentions/glopal_extentions.dart';
import 'package:shakshak/core/extentions/padding_extention.dart';
import 'package:shakshak/core/resources/app_colors.dart';
import 'package:shakshak/core/utils/shared_widgets/custom_text_field.dart';
import 'package:shakshak/core/utils/shared_widgets/show_snack_bar.dart';
import 'package:shakshak/core/utils/styles.dart';
import 'package:shakshak/features/shared/base_layout/presentation/views/base_layout_view.dart';
import 'package:shakshak/features/shared/chat/presentation/view_models/chat_cubit.dart';
import 'package:shakshak/generated/assets.dart';

import 'package:shakshak/generated/l10n.dart';
import 'package:shakshak/features/shared/chat/presentation/widgets/chat_list_item.dart';

import 'dart:convert';
import 'package:shakshak/core/services/real_time/realtime_manager.dart';
import 'package:shakshak/core/services/service_locator.dart';
import 'package:shakshak/core/constants/app_const.dart';
import 'package:shakshak/core/network/local/cache_helper.dart';

class ChatView extends StatefulWidget {
  final int tripId;
  final String? driverName;

  const ChatView({
    super.key,
    required this.tripId,
    this.driverName,
  });

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final TextEditingController _messageController = TextEditingController();
  String? _chatListenerToken;

  @override
  void initState() {
    super.initState();
    _subscribeToRealtimeChat();
  }

  void _subscribeToRealtimeChat() {
    final String channelName = "trip-${widget.tripId}";
    debugPrint("📡 ChatView: Subscribing to real-time chat on $channelName...");
    _chatListenerToken = sl<RealtimeManager>().addListener(
      channel: channelName,
      event: ".chat",
      callback: (data) {
        try {
          debugPrint("📥 Realtime Chat Message: $data");
          Map<String, dynamic> payload;
          if (data is String) {
            payload = jsonDecode(data) as Map<String, dynamic>;
          } else if (data is Map<String, dynamic>) {
            payload = data;
          } else if (data is Map) {
            payload = Map<String, dynamic>.from(data);
          } else {
            return;
          }

          final String text = payload['message'] ?? payload['text'] ?? payload['description'] ?? '';
          if (text.isEmpty) return;

          // Prevent duplicate messages
          final bool alreadyExists = messages.any((m) => m['text'] == text);
          if (alreadyExists) return;

          final isDriver = CacheHelper.getData(key: AppConstant.kIsDriver) == 1;
          final senderType = payload['sender_type']?.toString().toLowerCase();
          final bool isSentByMe = (isDriver && senderType == 'driver') || (!isDriver && senderType == 'user');

          if (mounted) {
            setState(() {
              messages.add({
                "text": text,
                "isSent": isSentByMe,
                "time": "10 AM",
                "avatar": isSentByMe ? "assets/images/user1.png" : "assets/images/user2.png",
              });
            });
          }
        } catch (e) {
          debugPrint("⚠️ Error processing realtime chat message: $e");
        }
      },
    );
  }

  final List<Map<String, dynamic>> messages = [
    {
      "text":
          "Lorem Ipsum Dolor Sit Amet, Consectetur Adipiscing Elit, Sed Do Eiusmod Tempor Incididunt Ut Labore Et Dolore.",
      "isSent": true,
      "time": "10 AM",
      "avatar": "assets/images/user1.png"
    },
    {
      "text":
          "Sed Do Eiusmod Tempor Incididunt Ut Labore Et Magna Aliqua. Ut Enim Ad Minim Veniam, Quis Nostrud Exercitation Ullamco Laboris Nisi Ut Aliqui.",
      "isSent": false,
      "time": "10 AM",
      "avatar": "assets/images/user2.png"
    },
    {
      "text": "Lorem Ipsum Dolor Sit",
      "isSent": true,
      "time": "10 AM",
      "avatar": "assets/images/user1.png"
    },
    {
      "text":
          "Sed Do Eiusmod Tempor Incididunt Ut Labore Et Magna Aliqua. Ut Enim Ad Minim Veniam,.",
      "isSent": false,
      "time": "10 AM",
      "avatar": "assets/images/user2.png"
    },
    {
      "text": "Lorem Ipsum Dolor Sit Amet, Consectetur Adipiscing",
      "isSent": true,
      "time": "10 AM",
      "avatar": "assets/images/user1.png"
    },
    {
      "text": "Sed Do Eiusmod Tempor Incididunt Ut Labore Et",
      "isSent": false,
      "time": "10 AM",
      "avatar": "assets/images/user2.png"
    },
    {
      "text": "Ok",
      "isSent": true,
      "time": "10 AM",
      "avatar": "assets/images/user1.png"
    },
  ];

  void sendMessage() {
    if (_messageController.text.isNotEmpty) {
      final messageText = _messageController.text;

      context.read<ChatCubit>().sendMessage(
            tripId: widget.tripId,
            message: messageText,
          );

      _messageController.clear();
    }
  }

  @override
  void dispose() {
    if (_chatListenerToken != null) {
      sl<RealtimeManager>().removeListener(_chatListenerToken!);
      sl<RealtimeManager>().unsubscribe("trip-${widget.tripId}");
    }
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseLayoutView(
      header: buildChatAppBar(context),
      body: BlocListener<ChatCubit, ChatState>(
        listener: (context, state) {
          if (state is SendMessageSuccess) {
            setState(() {
              messages.add({
                "text": state.sendMessageEntity.message ?? '',
                "isSent": true,
                "time": "10 AM",
                "avatar": "assets/images/user1.png",
              });
            });

            showSnackBar(
                context,
                S.of(context).messageSentSuccessfully,
                S.of(context).doneSuccessfully,
                AppColors.primaryColor,
                ContentType.success);
          } else if (state is SendMessageFailure) {
            showSnackBar(
                context,
                state.errorMessage,
                S.of(context).errorOccurred,
                AppColors.primaryColor,
                ContentType.failure);
          }
        },
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                reverse: false,
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final message = messages[index];
                  final isSent = message["isSent"];

                  return ChatListItem(isSent: isSent, message: message);
                },
              ),
            ),
            BlocBuilder<ChatCubit, ChatState>(
              builder: (context, state) {
                final isLoading = state is SendMessageLoading;

                return Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        controller: _messageController,
                        hint: S.of(context).typeMessageHere,
                        isReadOnly: isLoading,
                      ),
                    ),
                    12.pw,
                    GestureDetector(
                      onTap: isLoading ? null : sendMessage,
                      child: Container(
                        width: 46.r,
                        height: 46.r,
                        padding: EdgeInsets.all(12.r),
                        decoration: BoxDecoration(
                          color: isLoading
                              ? AppColors.primaryColor.withOpacity(0.5)
                              : AppColors.primaryColor,
                          shape: BoxShape.circle,
                        ),
                        child: isLoading
                            ? CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.r,
                              )
                            : SvgPicture.asset(
                                Assets.svgSend,
                                height: 26.r,
                                width: 26.r,
                              ),
                      ),
                    )
                  ],
                ).paddingSymmetric(
                  horizontal: 16.w,
                  vertical: 16.h,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildChatAppBar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      child: Column(
        children: [
          Text(
            widget.driverName ?? S.of(context).driver,
            textAlign: TextAlign.center,
            style: Styles.textStyle18SemiBold(context)
                .copyWith(color: Colors.white),
          ),
          Text(
            '( ${S.of(context).driver} )',
            style: Styles.textStyle14Medium(context)
                .copyWith(color: AppColors.lightGreyColor),
          ),
        ],
      ),
    );
  }
}
