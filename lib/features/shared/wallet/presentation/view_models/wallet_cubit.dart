import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:shakshak/core/usecases/base_usecase.dart';
import 'package:shakshak/features/shared/wallet/domain/usecases/get_wallet_transactions_usecase.dart';
import 'package:shakshak/features/shared/wallet/domain/usecases/charge_wallet_usecase.dart';
import 'package:shakshak/features/shared/wallet/domain/usecases/withdraw_request_usecase.dart';
import 'package:shakshak/features/shared/wallet/domain/entities/wallet_transactions_response_entity.dart';
import 'package:shakshak/features/shared/wallet/domain/entities/charge_wallet_entity.dart';

part 'wallet_state.dart';

class WalletCubit extends Cubit<WalletState> {
  WalletCubit(
    this.getWalletTransactionsUseCase,
    this.chargeWalletUseCase,
    this.withdrawRequestUseCase,
  ) : super(WalletInitial());

  final GetWalletTransactionsUseCase getWalletTransactionsUseCase;
  final ChargeWalletUseCase chargeWalletUseCase;
  final WithdrawRequestUseCase withdrawRequestUseCase;

  Future<void> getWalletTransactions() async {
    emit(WalletTransactionsLoading());
    var result = await getWalletTransactionsUseCase(const NoParameters());
    result.fold((error) {
      debugPrint("error while get wallet transactions data ${error.message}");
      return emit(WalletTransactionsFailure(errorMessage: error.message));
    }, (success) {
      return emit(
          WalletTransactionsSuccess(walletTransactionsResponseEntity: success));
    });
  }

  Future<void> chargeWallet({required double value}) async {
    emit(ChargeWalletLoading());
    var result = await chargeWalletUseCase(ChargeWalletParams(value: value));
    result.fold((error) {
      debugPrint("error while charge wallet ${error.message}");
      return emit(ChargeWalletFailure(errorMessage: error.message));
    }, (success) {
      return emit(ChargeWalletSuccess(chargeWalletEntity: success));
    });
  }

  Future<void> withdrawRequest({required double amount, String? note}) async {
    emit(WithdrawLoading());
    var result = await withdrawRequestUseCase(
        WithdrawRequestParams(amount: amount, note: note));
    result.fold((error) {
      debugPrint("error while withdraw request ${error.message}");
      return emit(WithdrawFailure(errorMessage: error.message));
    }, (success) {
      return emit(WithdrawSuccess(walletTransactionsResponseEntity: success));
    });
  }
}
