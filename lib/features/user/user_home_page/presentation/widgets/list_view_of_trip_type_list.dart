import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:shakshak/features/user/user_home_page/data/models/calc_price_time_distance_request_body.dart';
import 'package:shakshak/features/user/user_home_page/data/models/trip_type_model.dart';
import 'package:shakshak/features/user/user_home_page/logic/home_cubit.dart';
import 'trip_type_widget.dart';

class ListViewOfTripTypeList extends StatefulWidget {
  const ListViewOfTripTypeList({
    Key? key,
    required this.tripTypeList,
    required this.onTripTypeSelected,
    required this.homeCubit, // Add the callback
  }) : super(key: key);

  final List<TripTypeModel> tripTypeList;
  final Function(TripTypeModel) onTripTypeSelected; // Add this line
  final HomeCubit homeCubit;

  @override
  State<ListViewOfTripTypeList> createState() => _ListViewOfTripTypeListState();
}

class _ListViewOfTripTypeListState extends State<ListViewOfTripTypeList> {
  int selectedTripIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    widget.homeCubit.selectedCategoryName =
        widget.tripTypeList[selectedTripIndex].type;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70.w,
      child: ListView.separated(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        separatorBuilder: (context, index) {
          return SizedBox(
            width: 10.w,
          );
        },
        itemBuilder: (BuildContext context, int index) {
          return TripTypeWidget(
            tripTypeModel: widget.tripTypeList[index],
            isSelected: selectedTripIndex == index,
            onTap: () {
              setState(() {
                selectedTripIndex = index; // Update the selected trip type
              });
              widget.homeCubit.destinationAddress != "No Address Found"
                  ? widget.homeCubit.calcPriceAndTimeDistance(
                      calcPriceTimeDistanceRequestBody:
                          CalcPriceTimeDistanceRequestBody(
                        category: widget.tripTypeList[index].type,
                        droppOffLat: widget
                            .homeCubit.destinationLocation.latitude
                            .toString(),
                        droppOffLon: widget
                            .homeCubit.destinationLocation.longitude
                            .toString(),
                        pickUpLat:
                            widget.homeCubit.mapLocation.latitude.toString(),
                        pickUpLon:
                            widget.homeCubit.mapLocation.longitude.toString(),
                      ),
                    )
                  : null;
              // Call the callback with the selected trip type
              widget.onTripTypeSelected(widget.tripTypeList[index]);
            },
          );
        },
        itemCount: widget.tripTypeList.length,
      ),
    );
  }
}
