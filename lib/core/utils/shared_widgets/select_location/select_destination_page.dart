import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shakshak/core/router/router_helper.dart';

import 'package:shakshak/features/user/user_home/presentation/view_models/location/location_cubit.dart';
import 'package:shakshak/features/user/user_home/presentation/widgets/select_destination_widget.dart';
import 'package:shakshak/core/router/routes.dart';

class SelectDestinationPage extends StatefulWidget {
  const SelectDestinationPage({
    super.key,
    required this.cubit,
  });

  final LocationCubit cubit;

  @override
  State<SelectDestinationPage> createState() => _SelectDestinationPageState();
}

class _SelectDestinationPageState extends State<SelectDestinationPage> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: BlocProvider.value(
        value: widget.cubit,
        child: SelectDestinationWidget(
          changeMapTap: () async {
            FocusScope.of(context).unfocus();

            navigateTo(context, Routes.selectDestinationMapScreen,
                extra: {'cubit': widget.cubit});
          },
        ),
      ),
    );
  }
}


