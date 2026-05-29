import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shakshak/core/extentions/glopal_extentions.dart';
import 'package:shakshak/core/utils/shared_widgets/custom_button.dart';
import 'package:shakshak/core/utils/shared_widgets/custom_drop_down.dart';
import 'package:shakshak/core/utils/shared_widgets/custom_text_field.dart';
import 'package:shakshak/features/shared/base_layout/presentation/views/base_layout_view.dart';
import 'package:shakshak/features/driver/online_registration/data/models/car_brand_model.dart';
import 'package:shakshak/generated/l10n.dart';

import 'package:shakshak/core/router/router_helper.dart';
import 'package:shakshak/features/driver/vehicle_information/presentation/widgets/car_model_drop_down.dart';
import 'package:shakshak/features/driver/online_registration/presentation/view_models/driver_registration_cubit.dart';
import 'package:shakshak/features/driver/online_registration/widgets/custom_image_picker_widget.dart';

class CarView extends StatefulWidget {
  const CarView({super.key});

  @override
  State<CarView> createState() => _CarViewState();
}

class _CarViewState extends State<CarView> {
  final TextEditingController _carNumberController = TextEditingController();
  final TextEditingController _carColorController = TextEditingController();
  String? selectedBrand;
  int? selectedBrandId;
  String? selectedYear;
  String? selectedModel;
  XFile? carImage;

  @override
  void initState() {
    super.initState();
    // Initialize with stored data if available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cubit = context.read<DriverRegistrationCubit>();

      // Fetch brands initially
      cubit.getCarBrands();

      if (cubit.storedCarNumber != null) {
        setState(() {
          _carNumberController.text = cubit.storedCarNumber!;
        });
      }
      if (cubit.storedCarColor != null) {
        setState(() {
          _carColorController.text = cubit.storedCarColor!;
        });
      }
      setState(() {
        selectedBrand = cubit.storedCarBrand;
        selectedBrandId = cubit.carBrandId;
        selectedYear = cubit.storedCarYear;
        selectedModel = cubit.storedCarModel;

        // Restore models list if brand is selected
        if (selectedBrandId != null) {
          cubit.getCarModels(selectedBrandId!);
        }

        if (cubit.storedCarImage != null) {
          carImage = XFile(cubit.storedCarImage!.path);
        }
      });
    });
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DriverRegistrationCubit, DriverRegistrationState>(
      listener: (context, state) {
        if (state is CarImageStoredState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(S.of(context).carInfoStored),
              backgroundColor: Colors.green,
            ),
          );
          navigatePop(context);
        }
      },
      builder: (context, state) {
        return BaseLayoutView(
          title: S.of(context).car,
          body: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  // SelectVehicleSection(),
                  12.ph,
                  CustomImagePickerWidget(
                    title:
                        "${S.of(context).car} ${S.of(context).image.replaceAll(':', '')}",
                    onImagePicked: (file) => carImage = file,
                    initialImage: carImage,
                  ),
                  12.ph,
                  CustomTextField(
                    controller: _carNumberController,
                    label: S.of(context).carNumber,
                    hint: S.of(context).carNumber,
                    keyType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return S
                            .of(context)
                            .carNumber; // Using as error message
                      }
                      return null;
                    },
                    onchange: (value) {
                      context
                          .read<DriverRegistrationCubit>()
                          .storeCarNumber(value ?? '');
                    },
                  ),
                  12.ph,
                  CustomDropDown(
                    label: S.of(context).carBrand,
                    hint: state is GetCarBrandsLoading
                        ? S.of(context).loadingBrands
                        : S.of(context).carBrand,
                    items: context
                        .read<DriverRegistrationCubit>()
                        .brands
                        .map((e) => e.name ?? '')
                        .toSet()
                        .toList(),
                    value: selectedBrand,
                    onChange: (value) {
                      final cubit = context.read<DriverRegistrationCubit>();
                      final brand = cubit.brands.firstWhere(
                          (e) => e.name == value,
                          orElse: () => CarBrandData());

                      setState(() {
                        selectedBrand = value;
                        selectedBrandId = brand.id;
                        selectedModel = null; // Reset model when brand changes
                      });

                      cubit.storeCarBrand(value ?? '');
                      if (brand.id != null) {
                        cubit.getCarModels(brand.id!);
                      }
                    },
                  ),
                  12.ph,
                  YearsDropDown(
                    selectedValue: selectedYear,
                    onYearChanged: (value) {
                      setState(() {
                        selectedYear = value;
                      });
                      context
                          .read<DriverRegistrationCubit>()
                          .storeCarYear(value ?? '');
                    },
                  ),
                  12.ph,
                  CustomDropDown(
                    label: S.of(context).carModel,
                    hint: state is GetCarModelsLoading
                        ? S.of(context).loadingModels
                        : (selectedBrand == null
                            ? S.of(context).selectBrandFirst
                            : S.of(context).carModel),
                    items: context
                        .read<DriverRegistrationCubit>()
                        .models
                        .map((e) => e.name ?? '')
                        .toSet()
                        .toList(),
                    value: selectedModel,
                    onChange: (value) {
                      setState(() {
                        selectedModel = value;
                      });
                      context
                          .read<DriverRegistrationCubit>()
                          .storeCarModel(value ?? '');
                    },
                  ),
                  12.ph,
                  CustomTextField(
                    controller: _carColorController,
                    label: S.of(context).carColor,
                    hint: S.of(context).carColor,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return S.of(context).carColor; // Using as error message
                      }
                      return null;
                    },
                    onchange: (value) {
                      context
                          .read<DriverRegistrationCubit>()
                          .storeCarColor(value ?? '');
                    },
                  ),
                  24.ph,
                  CustomButton(
                    text: S.of(context).done,
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        // Check dropdowns manually if needed, or if they are required
                        if (selectedBrand == null ||
                            selectedYear == null ||
                            selectedModel == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Please select all car details'),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }

                        // Store car data and navigate back
                        if (carImage != null) {
                          context
                              .read<DriverRegistrationCubit>()
                              .storeCarImage(File(carImage!.path));
                          navigatePop(context);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(S.of(context).pleaseSelectImage),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      }
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
  }
}
