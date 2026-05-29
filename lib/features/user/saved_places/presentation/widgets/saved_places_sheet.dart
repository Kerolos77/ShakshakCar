import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shakshak/core/extentions/glopal_extentions.dart';
import 'package:shakshak/core/utils/styles.dart';
import 'package:shakshak/features/user/user_home/presentation/view_models/location/location_cubit.dart';
import 'package:shakshak/generated/l10n.dart';
import 'package:shakshak/features/user/saved_places/presentation/cubit/saved_places_cubit.dart';
import 'package:shakshak/features/user/saved_places/domain/entities/saved_place_entity.dart';

class SavedPlacesSheet extends StatefulWidget {
  final Function(SavedPlaceEntity) onPlaceSelected;
  final VoidCallback? onAddCurrentLocation;

  const SavedPlacesSheet({
    super.key,
    required this.onPlaceSelected,
    this.onAddCurrentLocation,
  });

  @override
  State<SavedPlacesSheet> createState() => _SavedPlacesSheetState();
}

class _SavedPlacesSheetState extends State<SavedPlacesSheet> {
  final TextEditingController _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 600.h,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                S.of(context).savedPlaces,
                style: Styles.textStyle20Bold(context),
              ),
              IconButton(
                onPressed: () => _showAddPlaceDialog(context),
                icon: const Icon(Icons.add_circle_outline, color: Colors.blue),
                tooltip: S.of(context).addNewPlace,
              ),
            ],
          ),
          const Divider(),
          Expanded(
            child: BlocBuilder<SavedPlacesCubit, SavedPlacesState>(
              builder: (context, state) {
                if (state is SavedPlacesLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is SavedPlacesSuccess) {
                  if (state.places.isEmpty) {
                    return Center(child: Text(S.of(context).noData));
                  }
                  return ListView.builder(
                    itemCount: state.places.length,
                    itemBuilder: (context, index) {
                      final place = state.places[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor:
                              Theme.of(context).primaryColor.withOpacity(0.1),
                          child: Icon(
                            place.name.toLowerCase().contains('home') ||
                                    place.name.contains('Ù…Ù†Ø²Ù„')
                                ? Icons.home
                                : place.name.toLowerCase().contains('work') ||
                                        place.name.contains('Ø¹Ù…Ù„')
                                    ? Icons.work
                                    : Icons.star,
                            color: Theme.of(context).primaryColor,
                            size: 20.sp,
                          ),
                        ),
                        title: Text(place.name,
                            style: Styles.textStyle16Bold(context)),
                        subtitle: Text(place.address,
                            maxLines: 1, overflow: TextOverflow.ellipsis),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit_outlined,
                                  color: Colors.blue),
                              onPressed: () {
                                _showEditPlaceDialog(context, place);
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline,
                                  color: Colors.red),
                              onPressed: () {
                                context
                                    .read<SavedPlacesCubit>()
                                    .removeSavedPlace(place.id);
                              },
                            ),
                          ],
                        ),
                        onTap: () {
                          widget.onPlaceSelected(place);
                          Navigator.pop(context);
                        },
                      );
                    },
                  );
                } else if (state is SavedPlacesFailure) {
                  return Center(child: Text(state.errorMessage));
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showAddPlaceDialog(BuildContext context) {
    showDialog<String>(
      context: context,
      builder: (diagContext) => const _AddPlaceDialog(),
    ).then((resultName) {
      if (resultName != null && resultName.isNotEmpty) {
        final locationCubit = context.read<LocationCubit>();
        final activePlace = locationCubit.isSourceSelected
            ? locationCubit.sourcePlace
            : locationCubit.destinationPlace;

        if (activePlace != null &&
            activePlace.lat != null &&
            activePlace.lng != null) {
          final place = SavedPlaceEntity(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            name: resultName,
            address: activePlace.description,
            lat: activePlace.lat!,
            lng: activePlace.lng!,
          );
          context.read<SavedPlacesCubit>().addSavedPlace(place);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(S.of(context).selectLocationFirst)),
          );
        }
      }
    });
  }

  void _showEditPlaceDialog(BuildContext context, SavedPlaceEntity place) {
    showDialog<String>(
      context: context,
      builder: (diagContext) => _EditPlaceDialog(initialName: place.name),
    ).then((resultName) {
      if (resultName != null && resultName.isNotEmpty && resultName != place.name) {
        final updatedPlace = SavedPlaceEntity(
          id: place.id,
          name: resultName,
          address: place.address,
          lat: place.lat,
          lng: place.lng,
        );
        context.read<SavedPlacesCubit>().updateSavedPlace(updatedPlace);
      }
    });
  }
}

class _AddPlaceDialog extends StatefulWidget {
  const _AddPlaceDialog();

  @override
  State<_AddPlaceDialog> createState() => _AddPlaceDialogState();
}

class _AddPlaceDialogState extends State<_AddPlaceDialog> {
  final TextEditingController _nameController = TextEditingController();
  String _name = "";

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final quickNames = [
      {'label': S.of(context).home, 'icon': Icons.home},
      {'label': S.of(context).work, 'icon': Icons.work},
      {'label': S.of(context).school, 'icon': Icons.school},
      {'label': S.of(context).other, 'icon': Icons.more_horiz},
    ];

    return AlertDialog(
      title: Text(S.of(context).addNewPlace),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _nameController,
            autofocus: true,
            onChanged: (value) => _name = value.trim(),
            decoration: InputDecoration(
              hintText: S.of(context).egHomeWork,
              labelText: S.of(context).placeName,
            ),
          ),
          15.ph,
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: quickNames.map((item) {
              final label = item['label'] as String;
              final icon = item['icon'] as IconData;
              return ActionChip(
                avatar: Icon(icon, size: 16.sp),
                label: Text(label, style: TextStyle(fontSize: 12.sp)),
                onPressed: () {
                  setState(() {
                    _name = label;
                    _nameController.text = label;
                    _nameController.selection = TextSelection.fromPosition(
                      TextPosition(offset: label.length),
                    );
                  });
                },
              );
            }).toList(),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(S.of(context).cancel),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, _name),
          child: Text(S.of(context).save),
        ),
      ],
    );
  }
}

class _EditPlaceDialog extends StatefulWidget {
  final String initialName;

  const _EditPlaceDialog({required this.initialName});

  @override
  State<_EditPlaceDialog> createState() => _EditPlaceDialogState();
}

class _EditPlaceDialogState extends State<_EditPlaceDialog> {
  late final TextEditingController _nameController;
  late String _name;

  @override
  void initState() {
    super.initState();
    _name = widget.initialName;
    _nameController = TextEditingController(text: _name);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _nameController,
            autofocus: true,
            onChanged: (value) => _name = value.trim(),
            decoration: InputDecoration(
              hintText: S.of(context).egHomeWork,
              labelText: S.of(context).placeName,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(S.of(context).cancel),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, _name),
          child: Text(S.of(context).save),
        ),
      ],
    );
  }
}
