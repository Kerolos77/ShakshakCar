import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shakshak/core/constants/app_const.dart';
import 'package:shakshak/core/network/local/cache_helper.dart';
import 'package:shakshak/core/resources/app_colors.dart';
import 'package:shakshak/core/router/router_helper.dart';
import 'package:shakshak/core/utils/shared_widgets/custom_button.dart';
import 'package:shakshak/core/utils/shared_widgets/custom_text_field.dart';
import 'package:shakshak/core/utils/styles.dart';
import 'package:shakshak/core/network/dio_helper/dio_helper.dart';
import 'package:shakshak/features/shared/base_layout/presentation/views/base_layout_view.dart';
import 'package:shakshak/features/driver/online_registration/widgets/custom_image_picker_widget.dart';
import 'package:shakshak/core/extentions/glopal_extentions.dart';
import 'package:shakshak/generated/l10n.dart';

class UserIdentityVerificationView extends StatefulWidget {
  const UserIdentityVerificationView({super.key});

  @override
  State<UserIdentityVerificationView> createState() =>
      _UserIdentityVerificationViewState();
}

class _UserIdentityVerificationViewState
    extends State<UserIdentityVerificationView> {
  // Loading status of initial check
  bool _isLoadingStatus = true;

  // Processing status during AI verification
  bool _isProcessingAI = false;

  // Identity Status states: 'unverified', 'pending', 'verified', 'failed'
  String _verificationStatus = 'unverified';
  String _rejectionReason = '';
  String _verifiedName = '';
  String _verifiedIdNumber = '';
  int _faceSimilarityScore = 0;

  // Image picked files
  XFile? _frontImage;
  XFile? _backImage;
  XFile? _selfieImage;

  final TextEditingController _nIDController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _checkCurrentIdentityStatus();
  }

  // Fetch current user identity verification status from the server
  Future<void> _checkCurrentIdentityStatus() async {
    setState(() {
      _isLoadingStatus = true;
    });

    try {
      final token = CacheHelper.getData(key: AppConstant.kToken);
      final response = await DioHelper.getData(
        url: 'user/identity-status',
        token: token,
      );

      if (response.statusCode == 200 && response.data != null) {
        final resData = response.data['data'];
        if (resData != null) {
          setState(() {
            _verificationStatus = resData['verification_status'] ?? 'unverified';
            _rejectionReason = resData['rejection_reason'] ?? '';
            _verifiedIdNumber = resData['id_number'] ?? '';
            _faceSimilarityScore = resData['face_similarity_score'] ?? 0;
            // Name might be inside raw report
            final report = response.data['ai_verification_report'];
            if (report != null) {
              _verifiedName = report['extracted_full_name'] ?? '';
            }
          });
        }
      }
    } catch (e) {
      debugPrint("Error fetching identity status: $e");
    } finally {
      setState(() {
        _isLoadingStatus = false;
      });
    }
  }

  // Submit documents for synchronous AI validation
  Future<void> _submitForVerification() async {
    if (!_formKey.currentState!.validate()) return;

    if (_frontImage == null || _backImage == null || _selfieImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(S.of(context).captureThreeImagesWarning),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _isProcessingAI = true;
    });

    try {
      final token = CacheHelper.getData(key: AppConstant.kToken);

      // Construct multipart form data
      final formData = FormData.fromMap({
        'front_image': await MultipartFile.fromFile(
          _frontImage!.path,
          filename: 'front_id.jpg',
        ),
        'back_image': await MultipartFile.fromFile(
          _backImage!.path,
          filename: 'back_id.jpg',
        ),
        'selfie_image': await MultipartFile.fromFile(
          _selfieImage!.path,
          filename: 'selfie.jpg',
        ),
        'id_number': _nIDController.text.trim(),
      });

      final response = await DioHelper.postData(
        url: 'user/verify-identity',
        token: token,
        data: formData,
      );

      if (response.data != null) {
        final success = response.data['status'] ?? false;
        final resData = response.data['data'];

        if (success && resData != null) {
          // Verification passed successfully
          setState(() {
            _verificationStatus = 'verified';
            _verifiedIdNumber = resData['extracted_id_number'] ?? _nIDController.text;
            _verifiedName = resData['extracted_name'] ?? '';
            _faceSimilarityScore = resData['face_similarity_score'] ?? 0;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(S.of(context).verificationSuccessToast),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          // Verification failed (rejection reason provided)
          setState(() {
            _verificationStatus = 'failed';
            _rejectionReason = (resData != null && resData['rejection_reason'] != null)
                ? resData['rejection_reason']
                : S.of(context).aiScanFailed;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(S.of(context).verificationRejectedToast(_rejectionReason)),
              backgroundColor: AppColors.redColor,
            ),
          );
        }
      }
    } catch (e) {
      debugPrint("Error sending identity verification: $e");
      String errorMsg = S.of(context).serverErrorToast;
      
      if (e is DioException) {
        if (e.response?.data != null && e.response?.data['message'] != null) {
          errorMsg = e.response?.data['message'];
        }
      }
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMsg),
          backgroundColor: AppColors.redColor,
        ),
      );
    } finally {
      setState(() {
        _isProcessingAI = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseLayoutView(
      title: S.of(context).identityVerificationTitle,
      body: _isLoadingStatus
          ? Center(
              child: SpinKitDoubleBounce(
                color: AppColors.primaryColor,
                size: 50.r,
              ),
            )
          : Stack(
              children: [
                SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_verificationStatus == 'verified')
                        _buildVerifiedWidget()
                      else
                        _buildUploadFormWidget(),
                    ],
                  ),
                ),
                if (_isProcessingAI) _buildProcessingOverlay(),
              ],
            ),
    );
  }

  // Widget to display if the user is successfully verified
  Widget _buildVerifiedWidget() {
    return Center(
      child: Column(
        children: [
          50.ph,
          Icon(
            Icons.verified_user_rounded,
            color: Colors.green,
            size: 100.r,
          ),
          20.ph,
          Text(
            S.of(context).verifiedStatusTitle,
            style: Styles.textStyle22Bold(context).copyWith(color: Colors.green),
          ),
          10.ph,
          Text(
            S.of(context).verifiedStatusSubtitle,
            textAlign: TextAlign.center,
            style: Styles.textStyle14(context).copyWith(color: AppColors.greyColor),
          ),
          40.ph,
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20.r),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: Theme.of(context).dividerColor),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoDetail(S.of(context).extractedIdNumber, _verifiedIdNumber),
                if (_verifiedName.isNotEmpty) ...[
                  const Divider(),
                  _buildInfoDetail(S.of(context).extractedFullName, _verifiedName),
                ],
                if (_faceSimilarityScore > 0) ...[
                  const Divider(),
                  _buildInfoDetail(S.of(context).faceSimilarityScore, "$_faceSimilarityScore%"),
                ],
              ],
            ),
          ),
          50.ph,
          CustomButton(
            text: S.of(context).backToHome,
            onTap: () {
              navigatePop(context);
            },
          ),
        ],
      ),
    );
  }

  // Form widget for uploading/capturing images
  Widget _buildUploadFormWidget() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_verificationStatus == 'failed' && _rejectionReason.isNotEmpty)
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16.r),
              margin: EdgeInsets.only(bottom: 20.h),
              decoration: BoxDecoration(
                color: AppColors.redColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: AppColors.redColor.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.error_outline_rounded,
                    color: AppColors.redColor,
                    size: 28.r,
                  ),
                  12.pw,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          S.of(context).previousVerificationRejected,
                          style: Styles.textStyle14Bold(context)
                              .copyWith(color: AppColors.redColor),
                        ),
                        4.ph,
                        Text(
                          _rejectionReason,
                          style: Styles.textStyle14(context)
                              .copyWith(color: AppColors.redColor),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

          Text(
            S.of(context).verificationRequiredTitle,
            style: Styles.textStyle18Bold(context),
          ),
          8.ph,
          Text(
            S.of(context).verificationRequiredInstructions,
            style: Styles.textStyle14(context).copyWith(color: AppColors.greyColor),
          ),
          24.ph,

          CustomTextField(
            hint: S.of(context).nationalIdHint,
            keyType: TextInputType.number,
            controller: _nIDController,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(14),
            ],
            validator: (value) {
              if (value == null || value.isEmpty) {
                return S.of(context).nationalIdRequired;
              }
              if (value.length != 14) {
                return S.of(context).nationalIdMustBe14Digits;
              }
              return null;
            },
          ),
          20.ph,

          // cameraOnly is false during testing to allow gallery/file uploads
          CustomImagePickerWidget(
            title: S.of(context).frontIdCardTitle,
            cameraOnly: false,
            onImagePicked: (file) {
              setState(() {
                _frontImage = file;
              });
            },
            initialImage: _frontImage,
          ),
          20.ph,

          CustomImagePickerWidget(
            title: S.of(context).backIdCardTitle,
            cameraOnly: false,
            onImagePicked: (file) {
              setState(() {
                _backImage = file;
              });
            },
            initialImage: _backImage,
          ),
          20.ph,

          CustomImagePickerWidget(
            title: S.of(context).selfieCaptureTitle,
            cameraOnly: false,
            onImagePicked: (file) {
              setState(() {
                _selfieImage = file;
              });
            },
            initialImage: _selfieImage,
          ),
          30.ph,

          CustomButton(
            text: S.of(context).startVerificationButton,
            onTap: _submitForVerification,
          ),
          20.ph,
        ],
      ),
    );
  }

  // Processing screen overlay shown during AI processing
  Widget _buildProcessingOverlay() {
    return Container(
      color: Colors.black.withOpacity(0.75),
      width: double.infinity,
      height: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SpinKitThreeBounce(
              color: Colors.white,
              size: 45.r,
            ),
            24.ph,
            Text(
              S.of(context).analyzingImagesProgress,
              textAlign: TextAlign.center,
              style: Styles.textStyle16Bold(context).copyWith(color: Colors.white),
            ),
            12.ph,
            Text(
              S.of(context).pleaseWaitWarning,
              textAlign: TextAlign.center,
              style: Styles.textStyle14(context).copyWith(color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoDetail(String title, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: Styles.textStyle14(context).copyWith(color: AppColors.greyColor),
          ),
          Text(
            value,
            style: Styles.textStyle14SemiBold(context),
          ),
        ],
      ),
    );
  }
}
