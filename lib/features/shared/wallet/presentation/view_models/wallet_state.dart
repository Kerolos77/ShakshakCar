part of 'wallet_cubit.dart';

@immutable
sealed class WalletState {}

final class WalletInitial extends WalletState {}

final class WalletTransactionsLoading extends WalletState {}

final class WalletTransactionsSuccess extends WalletState {
  final WalletTransactionsResponseEntity walletTransactionsResponseEntity;

  WalletTransactionsSuccess({required this.walletTransactionsResponseEntity});
}

final class WalletTransactionsFailure extends WalletState {
  final String errorMessage;

  WalletTransactionsFailure({required this.errorMessage});
}

final class ChargeWalletLoading extends WalletState {}

final class ChargeWalletSuccess extends WalletState {
  final ChargeWalletEntity chargeWalletEntity;

  ChargeWalletSuccess({required this.chargeWalletEntity});
}

final class ChargeWalletFailure extends WalletState {
  final String errorMessage;

  ChargeWalletFailure({required this.errorMessage});
}

final class WithdrawLoading extends WalletState {}

final class WithdrawSuccess extends WalletState {
  final WalletTransactionsResponseEntity walletTransactionsResponseEntity;

  WithdrawSuccess({required this.walletTransactionsResponseEntity});
}

final class WithdrawFailure extends WalletState {
  final String errorMessage;

  WithdrawFailure({required this.errorMessage});
}
