import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:local_auth_darwin/local_auth_darwin.dart';

class LocalAuthHelper {
  static final LocalAuthentication _auth = LocalAuthentication();

  /// Authenticates the user using biometric or device PIN/pattern
  static Future<bool> authenticate({
    required String reason,
    required String title,
    required String cancel,
  }) async {
    try {
      final bool canAuthenticateWithBiometrics = await _auth.canCheckBiometrics;
      final bool canAuthenticate =
          canAuthenticateWithBiometrics || await _auth.isDeviceSupported();

      if (!canAuthenticate) {
        // If device does not support any authentication, allow them to proceed or handle differently
        return true;
      }

      final bool didAuthenticate = await _auth.authenticate(
        localizedReason: reason,
        biometricOnly: false,
        authMessages: <AuthMessages>[
          AndroidAuthMessages(
            signInTitle: title,
            cancelButton: cancel,
          ),
          IOSAuthMessages(
            cancelButton: cancel,
          ),
        ],
      );

      return didAuthenticate;
    } on PlatformException catch (_) {
      // Ignored intentionally for production, you can log if needed
      return false;
    }
  }
}

