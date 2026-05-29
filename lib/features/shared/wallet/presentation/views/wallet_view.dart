import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shakshak/core/extentions/glopal_extentions.dart';
import 'package:shakshak/core/resources/app_colors.dart';
import 'package:shakshak/core/router/route_args.dart';
import 'package:shakshak/core/router/router_helper.dart';
import 'package:shakshak/core/router/routes.dart';
import 'package:shakshak/core/services/service_locator.dart';
import 'package:shakshak/core/utils/shared_widgets/custom_button.dart';
import 'package:shakshak/core/utils/shared_widgets/custom_loading_button.dart';
import 'package:shakshak/core/utils/shared_widgets/custom_text_field.dart';
import 'package:shakshak/core/utils/shared_widgets/show_snack_bar.dart';
import 'package:shakshak/core/utils/styles.dart';
import 'package:shakshak/features/shared/authentication/presentation/view_models/auth_cubit/auth_cubit.dart';
import 'package:shakshak/features/shared/base_layout/presentation/views/base_layout_view.dart';
import 'package:shakshak/features/shared/payment/presentation/view_models/payment_cubit.dart';
import 'package:shakshak/features/shared/payment/presentation/view_models/payment_states.dart';
import 'package:shakshak/features/shared/payment/domain/entities/saved_card_entity.dart';
import 'package:shakshak/features/shared/wallet/domain/usecases/charge_wallet_usecase.dart';
import 'package:shakshak/features/shared/wallet/domain/usecases/get_wallet_transactions_usecase.dart';
import 'package:shakshak/features/shared/wallet/domain/usecases/withdraw_request_usecase.dart';
import 'package:shakshak/features/shared/wallet/presentation/view_models/wallet_cubit.dart';
import 'package:shakshak/features/shared/wallet/presentation/widgets/horizontal_payment_methods.dart';
import 'package:shakshak/features/shared/wallet/presentation/widgets/wallet_card.dart';
import 'package:shakshak/features/shared/wallet/presentation/widgets/wallet_transactions_list.dart';
import 'package:shakshak/features/shared/wallet/presentation/widgets/inline_webview.dart';
import 'package:shakshak/generated/l10n.dart';

class WalletView extends StatefulWidget {
  const WalletView({super.key});

  @override
  State<WalletView> createState() => _WalletViewState();
}

class _WalletViewState extends State<WalletView> {
  final TextEditingController _chargeController = TextEditingController();
  final TextEditingController _withdrawController = TextEditingController();
  final TextEditingController _withdrawNotesController =
      TextEditingController();
      
  String? _inlineWebViewUrl;
  WalletCubit? _walletCubit;

  @override
  void initState() {
    super.initState();
    context.read<AuthCubit>().getProfile();
  }

  @override
  void dispose() {
    _chargeController.dispose();
    _withdrawController.dispose();
    _withdrawNotesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) {
                _walletCubit = WalletCubit(
                  sl<GetWalletTransactionsUseCase>(),
                  sl<ChargeWalletUseCase>(),
                  sl<WithdrawRequestUseCase>(),
                );
                return _walletCubit!;
            }),
        BlocProvider(
            create: (context) =>
                PaymentCubit(sl(), sl(), sl(), sl(), sl())..getSavedCards()),
      ],
      child: BaseLayoutView(
        title: S.of(context).myWallet,
        horizontalPadding: 0,
        body: _inlineWebViewUrl != null
          ? InlineWebView(
              url: _inlineWebViewUrl!,
              onFinish: () {
                setState(() {
                  _inlineWebViewUrl = null;
                });
                context.read<AuthCubit>().getProfile();
                if (_walletCubit != null && !_walletCubit!.isClosed) {
                  _walletCubit!.getWalletTransactions();
                }
              },
            )
          : BlocBuilder<AuthCubit, AuthState>(
              builder: (authContext, authState) {
                final authCubit = authContext.read<AuthCubit>();
                final balance =
                    authCubit.profileModel?.data?.walletAmount?.toString() ??
                        '0.00';
                return BlocListener<PaymentCubit, PaymentState>(
                  listener: (paymentContext, paymentState) {
                     if (paymentState is AddCardRequiresWebView) {
                        setState(() { _inlineWebViewUrl = paymentState.checkoutUrl; });
                     } else if (paymentState is AddCardFailure) {
                        showSnackBar(paymentContext, paymentState.errorMessage, "", AppColors.redColor, ContentType.failure);
                     }
                  },
                  child: CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(
                        child: Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                          child: BlocBuilder<PaymentCubit, PaymentState>(
                            builder: (paymentCtx, _) {
                              final paymentCubit = PaymentCubit.get(paymentCtx);
                              return WalletCard(
                                balance: balance,
                                onTopUp: () => _showChargeWalletBottomSheet(paymentCubit),
                              );
                            }
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: BlocBuilder<PaymentCubit, PaymentState>(
                          builder: (paymentContext, paymentState) {
                            final paymentCubit = PaymentCubit.get(paymentContext);
                            return HorizontalPaymentMethods(
                              cards: paymentCubit.savedCards,
                              onAddCard: () {
                                paymentCubit.addCardIntent();
                              },
                              onCardTap: (card) {
                                _showChargeWalletBottomSheet(paymentCubit, preSelectedCard: card);
                              },
                              onDeleteCard: (id) => paymentCubit.deleteCard(id),
                            );
                          },
                        ),
                      ),
                      if (authCubit.profileModel?.data?.isDriver == 1)
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16.w, vertical: 16.h),
                            child: Row(
                              children: [
                                Expanded(
                                  child: CustomButton(
                                    text: S.of(context).withdraw,
                                    buttonColor: AppColors.lightGreyColor,
                                    textColor: AppColors.primaryColor,
                                    onTap: _showWithdrawBottomSheet,
                                  ),
                                ),
                                12.pw,
                                Expanded(
                                  child: CustomButton(
                                    text: S.of(context).withdrawalHistory,
                                    buttonColor: AppColors.secondaryColor,
                                    textColor: Colors.white,
                                    onTap: () {
                                      navigateTo(
                                          authContext, Routes.withdrawHistoryView);
                                    },
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(16.w, 24.h, 16.w, 12.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                S.of(context).transactionHistory,
                                style: Styles.textStyle18Bold(context),
                              ),
                              Builder(
                                builder: (walletCtx) {
                                  return IconButton(
                                    icon: Icon(Icons.refresh,
                                        color: AppColors.primaryColor),
                                    onPressed: () {
                                      walletCtx.read<WalletCubit>().getWalletTransactions();
                                    },
                                  );
                                }
                              ),
                            ],
                          ),
                        ),
                      ),
                      const WalletTransactionsList(),
                    ],
                  ),
                );
              },
            ),
      ),
    );
  }

  void _showChargeWalletBottomSheet(PaymentCubit paymentCubit, {SavedCardEntity? preSelectedCard}) {
    int? selectedCardId = preSelectedCard?.id;
    bool isNewCardSelected = preSelectedCard == null;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      builder: (bottomSheetContext) {
        return StatefulBuilder(
          builder: (context, setStateBottomSheet) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 16.w, right: 16.w, top: 20.h,
              ),
              child: SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(S.of(context).topupWallet, style: Styles.textStyle18Bold(context)),
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: Icon(Icons.close, color: AppColors.greyColor),
                          ),
                        ],
                      ),
                    12.ph,
                    CustomTextField(
                      controller: _chargeController,
                      label: S.of(context).addTopupAmount,
                      hint: S.of(context).enterAmount,
                      keyType: TextInputType.number,
                    ),
                    24.ph,
                    Text(S.of(context).savedCards, style: Styles.textStyle16Bold(context)),
                    12.ph,
                    GestureDetector(
                      onTap: () {
                        setStateBottomSheet(() {
                          isNewCardSelected = true;
                          selectedCardId = null;
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.only(bottom: 12.h),
                        padding: EdgeInsets.all(12.r),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: isNewCardSelected ? AppColors.primaryColor : AppColors.lightGreyColor,
                            width: isNewCardSelected ? 2 : 1,
                          ),
                          borderRadius: BorderRadius.circular(8.r),
                          color: isNewCardSelected ? AppColors.primaryColor.withOpacity(0.05) : Colors.transparent,
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.add_card, color: isNewCardSelected ? AppColors.primaryColor : AppColors.greyColor),
                            12.pw,
                            Text(S.of(context).addNewCard, style: Styles.textStyle14Medium(context)),
                          ],
                        ),
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: paymentCubit.savedCards.length,
                      itemBuilder: (context, index) {
                        final card = paymentCubit.savedCards[index];
                        final isSelected = (selectedCardId == card.id) && !isNewCardSelected;
                        return GestureDetector(
                          onTap: () {
                            setStateBottomSheet(() {
                              selectedCardId = card.id;
                              isNewCardSelected = false;
                            });
                          },
                          child: Container(
                            margin: EdgeInsets.only(bottom: index == paymentCubit.savedCards.length - 1 ? 24.h : 8.h),
                            padding: EdgeInsets.all(12.r),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: isSelected ? AppColors.primaryColor : AppColors.lightGreyColor,
                                width: isSelected ? 2 : 1,
                              ),
                              borderRadius: BorderRadius.circular(8.r),
                              color: isSelected ? AppColors.primaryColor.withOpacity(0.05) : Colors.transparent,
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.credit_card, color: isSelected ? AppColors.primaryColor : AppColors.greyColor),
                                12.pw,
                                Text('**** **** **** ${card.maskedPan.length >= 4 ? card.maskedPan.substring(card.maskedPan.length - 4) : card.maskedPan}', 
                                  style: Styles.textStyle14Medium(context),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    BlocConsumer<PaymentCubit, PaymentState>(
                      bloc: paymentCubit,
                      listener: (context, state) {
                        if (state is PayWithSavedCardWalletSuccess || state is ChargeWalletNewCardSuccess) {
                          Navigator.pop(context);
                          if (state is PayWithSavedCardWalletSuccess) {
                            _chargeController.clear();
                            this.context.read<AuthCubit>().getProfile();
                            if (_walletCubit != null && !_walletCubit!.isClosed) {
                              _walletCubit!.getWalletTransactions();
                            }
                            showSnackBar(this.context, S.of(context).doneSuccessfully, "", AppColors.primaryColor, ContentType.success);
                          } else if (state is ChargeWalletNewCardSuccess) {
                            _chargeController.clear();
                            setState(() {
                              _inlineWebViewUrl = state.checkoutUrl;
                            });
                          }
                        } else if (state is PayWithSavedCardWalletFailure || state is ChargeWalletNewCardFailure) {
                           final error = state is PayWithSavedCardWalletFailure ? state.errorMessage : (state as ChargeWalletNewCardFailure).errorMessage;
                           showSnackBar(this.context, error, "", AppColors.redColor, ContentType.failure);
                        }
                      },
                      builder: (context, state) {
                        if (state is PayWithSavedCardWalletLoading || state is ChargeWalletNewCardLoading) {
                          return const CustomLoadingButton();
                        }
                        return CustomButton(
                          text: S.of(context).pay,
                          onTap: () {
                            if (_chargeController.text.isEmpty) return;
                            final amount = double.tryParse(_chargeController.text) ?? 0;
                            if (amount <= 0) return;
                            
                            if (isNewCardSelected) {
                              paymentCubit.chargeWalletWithNewCard(amount);
                            } else if (selectedCardId != null) {
                              paymentCubit.payWithSavedCardForWallet(selectedCardId!, amount);
                            }
                          },
                        );
                      },
                    ),
                    12.ph,
                  ],
                ),
               ),
              ),
            );
          },
        );
      },
    );
  }

  void _showWithdrawBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      builder: (context) => BlocProvider(
        create: (context) => WalletCubit(
          sl<GetWalletTransactionsUseCase>(),
          sl<ChargeWalletUseCase>(),
          sl<WithdrawRequestUseCase>(),
        ),
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SafeArea(
            child: Stack(
              children: [
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 20.h),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(S.of(context).withdraw,
                          style: Styles.textStyle18Bold(context)),
                      12.ph,
                      CustomTextField(
                        controller: _withdrawController,
                        label: S.of(context).addWithdrawAmount,
                        hint: S.of(context).enterAmount,
                        keyType: TextInputType.number,
                      ),
                      12.ph,
                      CustomTextField(
                        controller: _withdrawNotesController,
                        hint: S.of(context).notes,
                        maxLiens: 3,
                      ),
                      24.ph,
                      BlocConsumer<WalletCubit, WalletState>(
                        listener: (context, state) {
                          if (state is WithdrawSuccess) {
                            showSnackBar(
                              context,
                              S.of(context).doneSuccessfully,
                              S.of(context).doneSuccessfully,
                              AppColors.primaryColor,
                              ContentType.success,
                            );
                            navigatePop(context);
                          } else if (state is WithdrawFailure) {
                            showSnackBar(
                              context,
                              state.errorMessage,
                              S.of(context).errorOccurred,
                              AppColors.redColor,
                              ContentType.failure,
                            );
                          }
                        },
                        builder: (context, state) {
                          if (state is WithdrawLoading) {
                            return const CustomLoadingButton();
                          }
                          return CustomButton(
                            text: S.of(context).withdrawal,
                            onTap: () {
                              if (_withdrawController.text.isNotEmpty) {
                                context.read<WalletCubit>().withdrawRequest(
                                      amount: double.parse(
                                          _withdrawController.text),
                                      note: _withdrawNotesController.text,
                                    );
                              }
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
                Positioned(
                  right: 10.w,
                  top: 10.h,
                  child: IconButton(
                    onPressed: () => navigatePop(context),
                    icon: Icon(
                      Icons.highlight_remove_sharp,
                      color: AppColors.greyColor,
                      size: 32.r,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
