import 'dart:io';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shakshak/core/extentions/glopal_extentions.dart';
import 'package:shakshak/core/resources/app_colors.dart';
import 'package:shakshak/core/services/service_locator.dart';
import 'package:shakshak/core/utils/shared_widgets/custom_button.dart';
import 'package:shakshak/core/utils/shared_widgets/custom_cached_network_image.dart';
import 'package:shakshak/core/utils/shared_widgets/custom_loading_button.dart';
import 'package:shakshak/core/utils/shared_widgets/custom_text_field.dart';
import 'package:shakshak/core/utils/shared_widgets/show_snack_bar.dart';
import 'package:shakshak/core/utils/styles.dart';
import 'package:shakshak/features/shared/authentication/presentation/view_models/auth_cubit/auth_cubit.dart';
import 'package:shakshak/features/shared/authentication/presentation/view_models/country_city_cubit/countries_cities_cubit.dart';
import 'package:shakshak/features/shared/authentication/presentation/widgets/cities_drop_down.dart';
import 'package:shakshak/generated/l10n.dart';

class EditProfileView extends StatefulWidget {
  const EditProfileView({super.key});

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  int? _selectedCountryId;
  int? _selectedCityId;
  String profilePhotoUrl = '';

  ImagePicker imagePicker = ImagePicker();
  File? image;

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthCubit>().profileModel?.data;
    if (user != null) {
      _userNameController.text = user.name ?? '';
      _emailController.text = user.email ?? '';
      profilePhotoUrl = user.image ?? '';
      _selectedCountryId = user.countryId;
      _selectedCityId = user.city;
    } else {
      // If profileModel is null, fetch it
      context.read<AuthCubit>().getProfile();
    }
  }

  @override
  void dispose() {
    _userNameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _updateProfile() {
    if (_selectedCityId == null) {
      showSnackBar(context, "يرجى اختيار المدينة", "تنبيه", Colors.orange, ContentType.warning);
      return;
    }
    context.read<AuthCubit>().updateProfile(
          name: _userNameController.text,
          email: _emailController.text,
          countryId: _selectedCountryId ?? 1,
          cityId: _selectedCityId!,
          photo: image,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).editProfile),
        centerTitle: true,
      ),
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is GetProfileSuccessState) {
            final user = state.userModel.data;
            if (user != null) {
              setState(() {
                _userNameController.text = user.name ?? '';
                _emailController.text = user.email ?? '';
                profilePhotoUrl = user.image ?? '';
                _selectedCountryId = user.countryId;
                _selectedCityId = user.city;
              });
            }
          } else if (state is UpdateProfileSuccessState) {
            showSnackBar(
              context,
              S.of(context).profileUpdatedSuccessfully,
              S.of(context).doneSuccessfully,
              AppColors.primaryColor,
              ContentType.success,
            );
            Navigator.pop(context);
          } else if (state is UpdateProfileFailureState) {
            showSnackBar(
                context,
                state.errMessage,
                S.of(context).errorOccurred,
                AppColors.redColor,
                ContentType.failure);
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: EdgeInsets.all(20.r),
            child: Column(
              children: [
                Center(
                  child: Stack(
                    children: [
                      Container(
                        width: 120.r,
                        height: 120.r,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.primaryColor, width: 2),
                        ),
                        child: ClipOval(
                          child: image != null
                              ? Image.file(image!, fit: BoxFit.cover)
                              : (profilePhotoUrl.isNotEmpty
                                  ? CustomCachedNetworkImage(
                                      imgUrl: profilePhotoUrl,
                                      width: 120.r,
                                      height: 120.r,
                                      errorIconSize: 40,
                                    )
                                  : Icon(Icons.person, size: 80.r, color: Colors.grey)),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: () async {
                            final XFile? pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
                            if (pickedFile != null) {
                              setState(() {
                                image = File(pickedFile.path);
                              });
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.all(8.r),
                            decoration: const BoxDecoration(
                              color: AppColors.primaryColor,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.camera_alt, color: Colors.white, size: 20.r),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                30.ph,
                _buildField(
                  controller: _userNameController,
                  label: S.of(context).userName,
                  icon: Icons.person_outline,
                ),
                20.ph,
                _buildField(
                  controller: _emailController,
                  label: S.of(context).email,
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                ),
                20.ph,
                BlocProvider(
                  create: (context) => CountriesCitiesCubit(getCountriesUseCase: sl(), getCitiesUseCase: sl()),
                  child: CitiesDropDown(
                    enabled: true,
                    initialCountryId: _selectedCountryId,
                    initialCityId: _selectedCityId,
                    onCountrySelected: (id) => setState(() => _selectedCountryId = id),
                    onCitySelected: (id) => setState(() => _selectedCityId = id),
                  ),
                ),
                40.ph,
                state is UpdateProfileLoadingState
                    ? const CustomLoadingButton()
                    : CustomButton(
                        text: S.of(context).save,
                        onTap: _updateProfile,
                        height: 55,
                        borderRadius: 15,
                      ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
  }) {
    return CustomTextField(
      controller: controller,
      hint: label,
      keyType: keyboardType,
      prefix: Icon(icon, color: AppColors.primaryColor),
    );
  }
}
