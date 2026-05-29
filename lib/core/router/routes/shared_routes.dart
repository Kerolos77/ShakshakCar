import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shakshak/core/router/route_args.dart';
import 'package:shakshak/core/router/routes.dart';
import 'package:shakshak/core/services/service_locator.dart';
import 'package:shakshak/features/shared/chat/domain/usecases/send_message_usecase.dart';
import 'package:shakshak/features/shared/chat/presentation/view_models/chat_cubit.dart';
import 'package:shakshak/features/shared/chat/presentation/views/chat_view.dart';
import 'package:shakshak/features/shared/contact_us/domain/usecases/get_contact_us_usecase.dart';
import 'package:shakshak/features/shared/contact_us/domain/usecases/write_us_usecase.dart';
import 'package:shakshak/features/shared/contact_us/presentation/view_models/contact_us_cubit.dart';
import 'package:shakshak/features/shared/contact_us/presentation/views/contact_us_view.dart';
import 'package:shakshak/features/shared/faq/domain/usecases/get_faqs_usecase.dart';
import 'package:shakshak/features/shared/faq/presentation/view_models/faqs_cubit.dart';
import 'package:shakshak/features/shared/faq/presentation/views/faq_view.dart';
import 'package:shakshak/features/shared/help_center/presentation/views/help_center_view.dart';
import 'package:shakshak/features/shared/help_center/presentation/views/trip_issue_view.dart';
import 'package:shakshak/features/shared/notifications/presentation/pages/notification_screen.dart';
import 'package:shakshak/features/shared/notifications/presentation/views/notification_details_view.dart';
import 'package:shakshak/features/shared/sos/presentation/views/sos_view.dart';
import 'package:shakshak/features/shared/review/presentation/views/review_view.dart';
import 'package:shakshak/features/shared/on_boarding/presentation/views/on_boarding_view.dart';
import 'package:shakshak/features/shared/payment/presentation/view_models/payment_cubit.dart';
import 'package:shakshak/features/shared/payment/presentation/views/add_card_view.dart';
import 'package:shakshak/features/shared/payment/presentation/views/payment_view.dart'
    as card_payment;
import 'package:shakshak/features/shared/rides/domain/usecases/get_rides_usecase.dart';
import 'package:shakshak/features/shared/rides/presentation/view_models/rides_cubit.dart';
import 'package:shakshak/features/shared/rides/presentation/views/trip_summary_view.dart';
import 'package:shakshak/features/shared/rides/presentation/views/unified_rides_history_view.dart';
import 'package:shakshak/features/shared/settings/presentation/views/account_deletion_view.dart';
import 'package:shakshak/features/shared/settings/presentation/views/settings_view.dart';
import 'package:shakshak/features/shared/static_pages/presentation/view_models/static_pages_cubit.dart';
import 'package:shakshak/features/shared/static_pages/presentation/views/privacy_policy_view.dart';
import 'package:shakshak/features/shared/static_pages/presentation/views/terms_and_conditions_view.dart';
import 'package:shakshak/features/shared/wallet/domain/usecases/charge_wallet_usecase.dart';
import 'package:shakshak/features/shared/wallet/domain/usecases/get_wallet_transactions_usecase.dart';
import 'package:shakshak/features/shared/wallet/domain/usecases/withdraw_request_usecase.dart';
import 'package:shakshak/features/shared/wallet/presentation/view_models/wallet_cubit.dart';
import 'package:shakshak/features/shared/wallet/presentation/views/payment_view.dart'
    as wallet;
import 'package:shakshak/features/shared/wallet/presentation/views/wallet_view.dart';
import 'package:shakshak/features/shared/wallet/presentation/views/withdraw_history_view.dart';
import 'package:shakshak/features/user/user_home/data/models/new-ride/new_ride_data.dart';
import 'package:shakshak/features/shared/loyalty/presentation/views/points_view.dart';
import 'package:shakshak/features/shared/loyalty/presentation/view_models/loyalty_cubit.dart';

class SharedRoutes {
  static final List<RouteBase> routes = [
    GoRoute(
      path: Routes.pointsView,
      builder: (context, state) {
        return BlocProvider.value(
          value: context.read<LoyaltyCubit>()..getPointsHistory(),
          child: const PointsView(),
        );
      },
    ),
    GoRoute(
      path: Routes.onBoardingView,
      builder: (context, state) => const OnBoardingView(),
    ),
    GoRoute(
      path: Routes.termsAndConditionsView,
      builder: (context, state) => BlocProvider(
        create: (context) => StaticPagesCubit(sl()),
        child: const TermsAndConditionsView(),
      ),
    ),
    GoRoute(
      path: Routes.privacyPolicyView,
      builder: (context, state) => BlocProvider(
        create: (context) => StaticPagesCubit(sl()),
        child: const PrivacyPolicyView(),
      ),
    ),
    GoRoute(
      path: Routes.settingsView,
      builder: (context, state) => const SettingsView(),
    ),
    GoRoute(
      path: Routes.ridesView,
      builder: (context, state) {
        final args = state.extra as RidesViewArgs?;
        final isSelectionMode = args?.isSelectionMode ?? false;
        return BlocProvider(
          create: (context) => RidesCubit(sl<GetSharedRidesUseCase>()),
          child: UnifiedRidesHistoryView(isSelectionMode: isSelectionMode),
        );
      },
    ),
    GoRoute(
      path: Routes.outstationRidesView,
      builder: (context, state) => BlocProvider(
        create: (context) => RidesCubit(sl<GetSharedRidesUseCase>()),
        child: const UnifiedRidesHistoryView(),
      ),
    ),
    GoRoute(
      path: Routes.walletView,
      builder: (context, state) => BlocProvider(
        create: (context) => WalletCubit(
          sl<GetWalletTransactionsUseCase>(),
          sl<ChargeWalletUseCase>(),
          sl<WithdrawRequestUseCase>(),
        ),
        child: const WalletView(),
      ),
    ),
    GoRoute(
      path: Routes.withdrawHistoryView,
      builder: (context, state) => const WithdrawHistoryView(),
    ),
    GoRoute(
      path: Routes.contactUsView,
      builder: (context, state) => BlocProvider(
        create: (context) =>
            ContactUsCubit(sl<GetContactUsUseCase>(), sl<WriteUsUseCase>()),
        child: const ContactUsView(),
      ),
    ),
    GoRoute(
      path: Routes.faqView,
      builder: (context, state) => BlocProvider(
        create: (context) => FaqsCubit(sl<GetFaqsUseCase>()),
        child: const FaqView(),
      ),
    ),
    GoRoute(
      path: Routes.helpCenterView,
      builder: (context, state) => const HelpCenterView(),
    ),
    GoRoute(
      path: Routes.tripIssueView,
      builder: (context, state) {
        final ride = state.extra as NewRideData;
        return TripIssueView(ride: ride);
      },
    ),
    GoRoute(
      path: Routes.reviewView,
      builder: (context, state) {
        final args = state.extra as ReviewViewArgs;
        return ReviewView(
          orderId: args.orderId,
          isDriver: args.isDriver,
          initialRating: args.initialRating,
        );
      },
    ),
    GoRoute(
      path: Routes.paymentView,
      builder: (context, state) {
        final args = state.extra as PaymentViewArgs;
        return wallet.PaymentView(paymentUrl: args.paymentUrl);
      },
    ),
    GoRoute(
      path: Routes.cardManagementView,
      builder: (context, state) => const card_payment.PaymentView(),
    ),
    GoRoute(
      path: Routes.addCardView,
      builder: (context, state) {
        final cubit = state.extra as PaymentCubit?;
        return cubit != null
            ? BlocProvider.value(
                value: cubit,
                child: const AddCardView(),
              )
            : BlocProvider(
                create: (context) => PaymentCubit(sl(), sl(), sl(), sl(), sl())..getSavedCards(),
                child: const AddCardView(),
              );
      },
    ),
    GoRoute(
      path: Routes.chatView,
      builder: (context, state) {
        final args = state.extra as ChatViewArgs;
        return BlocProvider(
          create: (context) => ChatCubit(sl<SendMessageUseCase>()),
          child: ChatView(
            tripId: args.rideId,
            driverName: args.driverName,
          ),
        );
      },
    ),
    GoRoute(
      path: Routes.tripSummaryView,
      builder: (context, state) {
        final ride = state.extra as NewRideData;
        return TripSummaryView(ride: ride);
      },
    ),
    GoRoute(
      path: Routes.notificationView,
      builder: (context, state) => const NotificationScreen(),
    ),
    GoRoute(
      path: Routes.deleteAccountView,
      builder: (context, state) => const AccountDeletionView(),
    ),
    GoRoute(
      path: Routes.notificationDetailsView,
      builder: (context, state) {
        final args = state.extra as Map<String, dynamic>?;
        return NotificationDetailsView(
          title: args?['title'] ?? 'إشعار',
          body: args?['body'] ?? '',
        );
      },
    ),
    GoRoute(
      path: Routes.sosView,
      builder: (context, state) => const SOSView(),
    ),
  ];
}
