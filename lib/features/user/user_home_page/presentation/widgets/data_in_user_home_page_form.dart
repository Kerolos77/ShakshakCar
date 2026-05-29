// import 'package:shakshak/core/utils/constants/app_imports.dart';
// import 'info_and_cancel_widget.dart';
// import 'use_map_button_widget.dart';
//
// class MyMapWidget extends StatefulWidget {
//   const MyMapWidget({super.key});
//
//   @override
//   State<MyMapWidget> createState() => _MyMapWidgetState();
// }
//
// class _MyMapWidgetState extends State<MyMapWidget> {
//   @override
//   Widget build(BuildContext context) {
//     return UseMapButtonWidget(
//         onPressed: () {
//           showModalBottomSheet(
//             shape: RoundedRectangleBorder(
//               side: const BorderSide(),
//               borderRadius: BorderRadius.only(
//                 topRight: Radius.circular(27.r),
//                 topLeft: Radius.circular(27.r),
//               ),
//             ),
//             context: context,
//             builder: (BuildContext context) {
//               return Padding(
//                 padding: const EdgeInsets.all(20.0),
//                 child: SizedBox(
//                   height: 300,
//                   child: Column(
//                     children: [
//                       /// info widget and cancel
//                       InfoAndCancelWidget(),
//                       SizedBox(
//                         height: 15.h,
//                       ),
//
//                       /// start point text form widget
//                       TextField(
//                         style: TextStyle(
//                             fontSize: 15.sp,
//                             fontWeight: FontWeight.bold),
//                         readOnly: true,
//                         // ØªØ­Ø¯ÙŠØ¯ Ø­Ø¬Ù… Ø§Ù„Ø®Ø·
//                         focusNode: _startPointFocusNode,
//                         keyboardType: TextInputType.streetAddress,
//                         controller: _startAddressController,
//                         onTap: () {
//                           showModalBottomSheet(
//                             shape: RoundedRectangleBorder(
//                               side: const BorderSide(),
//                               borderRadius: BorderRadius.only(
//                                 topRight: Radius.circular(27.r),
//                                 topLeft: Radius.circular(27.r),
//                               ),
//                             ),
//                             constraints: BoxConstraints(
//                                 maxHeight: 690.h,
//                                 minHeight: 500.w),
//                             useSafeArea: true,
//                             isScrollControlled: true,
//                             context: context,
//                             builder: (context) {
//                               double screenHeight = 900.h;
//                               double containerHeight =
//                                   screenHeight * 0.93;
//                               return SingleChildScrollView(
//                                 // physics: AlwaysScrollableScrollPhysics(),
//                                 child: Container(
//                                     width: double.infinity,
//                                     height: containerHeight,
//                                     decoration: BoxDecoration(
//                                       borderRadius:
//                                       BorderRadius.only(
//                                         topLeft:
//                                         Radius.circular(27.r),
//                                         topRight:
//                                         Radius.circular(27.r),
//                                       ),
//                                       // color: AppColors.whitColor(context),
//                                     ),
//                                     child: Padding(
//                                       padding:
//                                       const EdgeInsets.all(
//                                           22.0),
//                                       child: Column(
//                                         children: [
//                                           //                                         ElevatedButton(
//                                           //   onPressed: () {
//                                           //     Navigator.of(context).pop();
//                                           //   },
//                                           //   child: Text('Ø¥ØºÙ„Ø§Ù‚'),
//                                           // ),
//
//                                           SizedBox(
//                                             height: 45.h,
//                                             child: TextField(
//                                               style: TextStyle(
//                                                 fontSize: 14.sp,
//                                               ),
//                                               // ØªØ­Ø¯ÙŠØ¯ Ø­Ø¬Ù… Ø§Ù„Ø®Ø·
//                                               // focusNode: startPointFocusNode,
//                                               keyboardType:
//                                               TextInputType
//                                                   .streetAddress,
//                                               controller:
//                                               _startAddressController,
//                                               onTap: () {
//                                                 setState(() {
//                                                   markers.clear();
//                                                   polylines
//                                                       .clear();
//                                                   distance = "";
//                                                 });
//                                               },
//                                               onChanged:
//                                                   (value) async {},
//                                               decoration:
//                                               InputDecoration(
//                                                 // labelStyle: TextStyle(
//                                                 //     color: AppColors.blackColors),
//                                                 contentPadding:
//                                                 const EdgeInsets
//                                                     .symmetric(
//                                                     vertical:
//                                                     15.0,
//                                                     horizontal:
//                                                     10.0),
//
//                                                 border:
//                                                 OutlineInputBorder(
//                                                   borderRadius:
//                                                   BorderRadius
//                                                       .all(
//                                                     Radius
//                                                         .circular(
//                                                         18.r),
//                                                   ),
//                                                 ),
//                                                 enabledBorder:
//                                                 OutlineInputBorder(
//                                                   borderSide: const BorderSide(
//                                                       color: AppColors
//                                                           .blackColors),
//                                                   borderRadius:
//                                                   BorderRadius
//                                                       .all(
//                                                     Radius
//                                                         .circular(
//                                                         18.r),
//                                                   ),
//                                                 ),
//                                                 labelText:
//                                                 'Start Point',
//                                                 suffixIcon:
//                                                 const Icon(
//                                                   Icons
//                                                       .circle_outlined,
//                                                   color: Colors
//                                                       .green,
//                                                 ),
//                                                 prefixIcon:
//                                                 IconButton(
//                                                   icon:
//                                                   const Icon(
//                                                     Icons.clear,
//                                                     // color: AppColors.textColor,
//                                                   ),
//                                                   onPressed: () {
//                                                     setState(() {
//                                                       startPoint =
//                                                           LatLng(
//                                                               0.0,
//                                                               0.0);
//                                                       _startAddressController
//                                                           .clear();
//                                                       markers
//                                                           .clear();
//                                                       polylines
//                                                           .clear();
//                                                     });
//                                                   },
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                           SizedBox(
//                                             height: 30.h,
//                                           ),
//                                           TextButton(
//                                             onPressed: () {},
//                                             child: Text(
//                                               "Ø¹Ø±Ø¶ Ø¹Ù„ÙŠ Ø§Ù„Ø®Ø±ÙŠØ·Ø©",
//                                             ),
//                                           ),
//
//                                           ButtonWidget(
//                                             color: AppColors
//                                                 .primaryColor(
//                                                 context),
//                                             height: 45.h,
//                                             margin: EdgeInsets
//                                                 .symmetric(
//                                                 horizontal:
//                                                 20.w),
//                                             borderRadius: 18.r,
//                                             onPressed: () {
//                                               // _commentFocusNode
//                                               //     .unfocus();
//                                               Navigator.pop(
//                                                   context);
//                                               // if (loginKey.currentState!.validate()) {
//                                               //   use the information provided
//                                               // }
//                                             },
//                                             child: Center(
//                                               child: Text(
//                                                 'Done',
//                                                 style: TextStyle(
//                                                   fontWeight:
//                                                   FontWeight
//                                                       .w600,
//                                                   fontSize: 18.sp,
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     )),
//                               );
//                             },
//                           );
//                           setState(() {
//                             markers.clear();
//                             polylines.clear();
//                             distance = "";
//                           });
//                         },
//                         onChanged: (value) async {},
//                         decoration: InputDecoration(
//                           floatingLabelAlignment:
//                           FloatingLabelAlignment.center,
//
//                           // labelStyle:
//                           //     TextStyle(color: AppColors.blackColors),
//                           contentPadding:
//                           const EdgeInsets.symmetric(
//                               vertical: 15.0,
//                               horizontal: 10.0),
//                           // ÙŠÙ…ÙƒÙ†Ùƒ Ø£ÙŠØ¶Ø§Ù‹ ØªØ­Ø¯ÙŠØ¯ Ø§Ù„Ø¹Ø¯ÙŠØ¯ Ù…Ù† Ø§Ù„Ø®ØµØ§Ø¦Øµ Ø§Ù„Ø£Ø®Ø±Ù‰ Ù„ØªØ®ØµÙŠØµ Ø§Ù„Ù…Ø¸Ù‡Ø±
//
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.all(
//                               Radius.circular(18.r),
//                             ),
//                           ),
//                           enabledBorder: OutlineInputBorder(
//                             borderSide: const BorderSide(
//                               // color: AppColors.blackColors
//                             ),
//                             borderRadius: BorderRadius.all(
//                               Radius.circular(18.r),
//                             ),
//                           ),
//                           labelText: 'Start Point',
//                           prefixIcon: IconButton(
//                             icon: const Icon(
//                               Icons.clear,
//                               // color: AppColors.textColor,
//                             ),
//                             onPressed: () {
//                               setState(() {
//                                 startPoint =
//                                 const LatLng(0.0, 0.0);
//                                 _startAddressController.clear();
//                                 markers.clear();
//                                 polylines.clear();
//                               });
//                             },
//                           ),
//                           suffixIcon: Container(
//                             width: 70.w,
//                             height: 50.h,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.all(
//                                   Radius.circular(18.r)),
//
//                               shape: BoxShape.rectangle,
//                               color: Colors.green, // Ù„ÙˆÙ† Ø§Ù„Ø®Ù„ÙÙŠØ©
//                             ),
//                             child: TextButton(
//                               onPressed: () {},
//                               child: Center(
//                                 child: Text(
//                                   'start',
//                                   style: TextStyle(
//                                     fontWeight: FontWeight.w600,
//                                     color: AppColors.blackColors,
//                                     fontSize: 14.sp,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                       SizedBox(
//                         height: 15.h,
//                       ),
//
//                       /// end point text form field widget
//                       TextField(
//                         style: TextStyle(
//                             fontSize: 15.sp,
//                             fontWeight: FontWeight.bold),
//                         // ØªØ­Ø¯ÙŠØ¯ Ø­Ø¬Ù… Ø§Ù„Ø®Ø·
//                         focusNode: _endPointFocusNode,
//                         keyboardType: TextInputType.streetAddress,
//                         controller: _endAddressController,
//                         readOnly: true,
//                         onTap: () {
//                           showModalBottomSheet(
//                             shape: RoundedRectangleBorder(
//                               side: const BorderSide(),
//                               borderRadius: BorderRadius.only(
//                                 topRight: Radius.circular(27.r),
//                                 topLeft: Radius.circular(27.r),
//                               ),
//                             ),
//                             constraints: const BoxConstraints(
//                                 maxHeight: 690, minHeight: 500),
//                             useSafeArea: true,
//                             isScrollControlled: true,
//                             context: context,
//                             builder: (context) {
//                               double screenHeight = 900.h;
//                               double containerHeight =
//                                   screenHeight * 0.93;
//
//                               return SingleChildScrollView(
//                                 // physics: AlwaysScrollableScrollPhysics(),
//                                 child: Container(
//                                     width: double.infinity,
//                                     height: containerHeight,
//                                     decoration: BoxDecoration(
//                                       borderRadius:
//                                       BorderRadius.only(
//                                         topLeft:
//                                         Radius.circular(27.r),
//                                         topRight:
//                                         Radius.circular(27.r),
//                                       ),
//                                       // color: AppColors.whitColor(context),
//                                     ),
//                                     child: Padding(
//                                       padding:
//                                       const EdgeInsets.all(
//                                           22.0),
//                                       child: Column(
//                                         children: [
//                                           //                                         ElevatedButton(
//                                           //   onPressed: () {
//                                           //     Navigator.of(context).pop();
//                                           //   },
//                                           //   child: Text('Ø¥ØºÙ„Ø§Ù‚'),
//                                           // ),
//
//                                           SizedBox(
//                                             height: 60,
//                                             child: TextField(
//                                               style: TextStyle(
//                                                   fontSize: 14.sp,
//                                                   fontWeight:
//                                                   FontWeight
//                                                       .bold),
//                                               // ØªØ­Ø¯ÙŠØ¯ Ø­Ø¬Ù… Ø§Ù„Ø®Ø·
//                                               // focusNode:
//                                               //     _endPointFocusNode,
//
//                                               keyboardType:
//                                               TextInputType
//                                                   .streetAddress,
//                                               controller:
//                                               _endAddressController,
//                                               readOnly: false,
//                                               onTap: () {
//                                                 setState(() {
//                                                   markers.clear();
//                                                   polylines
//                                                       .clear();
//                                                 });
//                                               },
//                                               onChanged:
//                                                   (value) async {},
//                                               decoration:
//                                               InputDecoration(
//                                                 // labelStyle:
//                                                 //     TextStyle(color: AppColors.blackColors),
//                                                   contentPadding: const EdgeInsets
//                                                       .symmetric(
//                                                       vertical:
//                                                       15.0,
//                                                       horizontal:
//                                                       10.0),
//                                                   border:
//                                                   OutlineInputBorder(
//                                                     borderRadius:
//                                                     BorderRadius
//                                                         .all(
//                                                       Radius.circular(
//                                                           18.r),
//                                                     ),
//                                                   ),
//                                                   enabledBorder:
//                                                   OutlineInputBorder(
//                                                     borderSide:
//                                                     const BorderSide(),
//                                                     borderRadius:
//                                                     BorderRadius
//                                                         .all(
//                                                       Radius.circular(
//                                                           18.r),
//                                                     ),
//                                                   ),
//                                                   labelText:
//                                                   'End Point',
//                                                   prefixIcon:
//                                                   IconButton(
//                                                     icon:
//                                                     const Icon(
//                                                       Icons
//                                                           .clear,
//                                                       // color: AppColors.textColor,
//                                                     ),
//                                                     onPressed:
//                                                         () {
//                                                       setState(
//                                                               () {
//                                                             endPoint = LatLng(
//                                                                 0.0,
//                                                                 0.0);
//                                                             _endAddressController
//                                                                 .clear();
//                                                             markers
//                                                                 .clear();
//                                                             polylines
//                                                                 .clear();
//                                                           });
//                                                     },
//                                                   ),
//                                                   suffixIcon:
//                                                   const Icon(
//                                                     Icons
//                                                         .circle_outlined,
//                                                     color: AppColors
//                                                         .redColor,
//                                                   )),
//                                             ),
//                                           ),
//                                           SizedBox(
//                                             height: 50.h,
//                                           ),
//                                           ButtonWidget(
//                                             color: AppColors
//                                                 .primaryColor(
//                                                 context),
//                                             height: 45.h,
//                                             margin: EdgeInsets
//                                                 .symmetric(
//                                                 horizontal:
//                                                 20.w),
//                                             borderRadius: 18.r,
//                                             onPressed: () {
//                                               Navigator.pop(
//                                                   context);
//                                               // if (loginKey.currentState!.validate()) {
//                                               //   use the information provided
//                                               // }
//                                             },
//                                             child: Center(
//                                               child: Text(
//                                                 'Done',
//                                                 style: TextStyle(
//                                                   fontWeight:
//                                                   FontWeight
//                                                       .w600,
//                                                   fontSize: 18.sp,
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     )),
//                               );
//                             },
//                           );
//
//                           setState(() {
//                             markers.clear();
//                             polylines.clear();
//                           });
//                         },
//                         onChanged: (value) async {},
//                         decoration: InputDecoration(
//                           // labelStyle:
//                           //     TextStyle(color: AppColors.blackColors),
//                           contentPadding:
//                           const EdgeInsets.symmetric(
//                               vertical: 10.0,
//                               horizontal: 10.0),
//
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.all(
//                               Radius.circular(18.r),
//                             ),
//                           ),
//                           enabledBorder: OutlineInputBorder(
//                             borderSide: const BorderSide(),
//                             borderRadius: BorderRadius.all(
//                               Radius.circular(18.r),
//                             ),
//                           ),
//                           labelText: 'End Point',
//                           prefixIcon: IconButton(
//                             icon: const Icon(
//                               Icons.clear,
//                               // color: AppColors.textColor,
//                             ),
//                             onPressed: () {
//                               setState(() {
//                                 endPoint = LatLng(0.0, 0.0);
//                                 _endAddressController.clear();
//                                 markers.clear();
//                                 polylines.clear();
//                               });
//                             },
//                           ),
//                           suffixIcon: Container(
//                             width: 70.w,
//                             height: 50.h,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.all(
//                                   Radius.circular(18.r)),
//
//                               shape: BoxShape.rectangle,
//                               color: Colors.red, // Ù„ÙˆÙ† Ø§Ù„Ø®Ù„ÙÙŠØ©
//                             ),
//                             child: TextButton(
//                               onPressed: () {},
//                               child: Center(
//                                 child: Text(
//                                   'End',
//                                   style: TextStyle(
//                                     fontWeight: FontWeight.w600,
//                                     color: AppColors.blackColors,
//                                     fontSize: 11.sp,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                       SizedBox(
//                         height: 30.h,
//                       ),
//
//                       /// save button
//                       SaveButtonWidget(
//                         onPressed: () {
//                           showModalBottomSheet(
//                             shape: RoundedRectangleBorder(
//                               side: const BorderSide(),
//                               borderRadius: BorderRadius.only(
//                                 topRight: Radius.circular(27.r),
//                                 topLeft: Radius.circular(27.r),
//                               ),
//                             ),
//                             constraints: const BoxConstraints(
//                                 maxHeight: 800, minHeight: 300),
//                             useSafeArea: true,
//                             isScrollControlled: true,
//                             context: context,
//                             builder: (context) {
//                               double screenHeight = 800.h;
//                               double containerHeight =
//                                   screenHeight * 0.90;
//
//                               return SingleChildScrollView(
//                                 // physics: AlwaysScrollableScrollPhysics(),
//                                 child: Container(
//                                   width: double.infinity,
//                                   height: containerHeight,
//                                   decoration: BoxDecoration(
//                                     borderRadius:
//                                     BorderRadius.only(
//                                       topLeft:
//                                       Radius.circular(27.r),
//                                       topRight:
//                                       Radius.circular(27.r),
//                                     ),
//                                     // color: AppColors.whitColor(context),
//                                   ),
//                                   child: Column(children: [
//                                     /// back button
//                                     Row(
//                                       children: [
//                                         IconButton(
//                                             onPressed: () {
//                                               Navigator
//                                                   .pushReplacement(
//                                                 context,
//                                                 MaterialPageRoute(
//                                                   builder:
//                                                       (context) =>
//                                                   const UserHomePage(),
//                                                   settings:
//                                                   const RouteSettings(),
//                                                 ),
//                                               );
//                                             },
//                                             icon: const Icon(
//                                               Icons
//                                                   .arrow_back_ios,
//                                               size: 33,
//                                             )),
//                                       ],
//                                     ),
//
//                                     //                                         ElevatedButton(
//                                     //   onPressed: () {
//                                     //     Navigator.of(context).pop();
//                                     //   },
//                                     //   child: Text('Ø¥ØºÙ„Ø§Ù‚'),
//                                     // ),
//                                     SizedBox(
//                                       height: 15.h,
//                                     ),
//
//                                     /// start point widget
//                                     Padding(
//                                       padding:
//                                       const EdgeInsets.only(
//                                           right: 20,
//                                           left: 20),
//                                       child: SizedBox(
//                                         height: 55,
//                                         child: TextField(
//                                           style: TextStyle(
//                                             fontSize: 14.sp,
//                                           ),
//                                           // ØªØ­Ø¯ÙŠØ¯ Ø­Ø¬Ù… Ø§Ù„Ø®Ø·
//                                           // focusNode: startPointFocusNode,
//                                           keyboardType:
//                                           TextInputType
//                                               .streetAddress,
//                                           controller:
//                                           _startAddressController,
//                                           readOnly: true,
//                                           onTap: () {
//                                             setState(() {
//                                               markers.clear();
//                                               polylines.clear();
//                                               distance = "";
//                                             });
//                                           },
//                                           onChanged:
//                                               (value) async {},
//                                           decoration:
//                                           InputDecoration(
//                                             // labelStyle: TextStyle(
//                                             //     color: AppColors.blackColors),
//                                               contentPadding:
//                                               const EdgeInsets
//                                                   .symmetric(
//                                                   vertical:
//                                                   10.0,
//                                                   horizontal:
//                                                   10.0),
//                                               border:
//                                               OutlineInputBorder(
//                                                 borderRadius:
//                                                 BorderRadius
//                                                     .all(
//                                                   Radius.circular(
//                                                       18.r),
//                                                 ),
//                                               ),
//                                               enabledBorder:
//                                               OutlineInputBorder(
//                                                 borderSide:
//                                                 const BorderSide(
//                                                     color:
//                                                     AppColors.blackColors),
//                                                 borderRadius:
//                                                 BorderRadius
//                                                     .all(
//                                                   Radius.circular(
//                                                       18.r),
//                                                 ),
//                                               ),
//                                               labelText:
//                                               'Start Point',
//                                               prefixIcon:
//                                               const Icon(
//                                                 Icons
//                                                     .circle_outlined,
//                                                 color: Colors
//                                                     .green,
//                                               )),
//                                         ),
//                                       ),
//                                     ),
//                                     SizedBox(
//                                       height: 10.h,
//                                     ),
//
//                                     /// end point widget
//                                     Padding(
//                                       padding:
//                                       const EdgeInsets.only(
//                                           right: 20,
//                                           left: 20),
//                                       child: SizedBox(
//                                         height: 50.h,
//                                         child: TextField(
//                                           style: TextStyle(
//                                             fontSize: 14.sp,
//                                           ),
//                                           // ØªØ­Ø¯ÙŠØ¯ Ø­Ø¬Ù… Ø§Ù„Ø®Ø·
//
//                                           // focusNode: endPointFocusNode,
//                                           keyboardType:
//                                           TextInputType
//                                               .streetAddress,
//                                           controller:
//                                           _endAddressController,
//                                           readOnly: true,
//                                           onTap: () {
//                                             setState(() {
//                                               markers.clear();
//                                               polylines.clear();
//                                             });
//                                           },
//                                           onChanged:
//                                               (value) async {},
//                                           decoration: InputDecoration(
//                                               labelStyle: const TextStyle(),
//                                               border: OutlineInputBorder(
//                                                 borderRadius:
//                                                 BorderRadius
//                                                     .all(
//                                                   Radius.circular(
//                                                       18.r),
//                                                 ),
//                                               ),
//                                               enabledBorder: OutlineInputBorder(
//                                                 borderSide:
//                                                 const BorderSide(),
//                                                 borderRadius:
//                                                 BorderRadius
//                                                     .all(
//                                                   Radius.circular(
//                                                       18.r),
//                                                 ),
//                                               ),
//                                               labelText: 'End Point',
//                                               prefixIcon: const Icon(
//                                                 Icons
//                                                     .circle_outlined,
//                                                 color: AppColors
//                                                     .redColor,
//                                               )
//                                             // suffixIcon: IconButton(
//                                             //   icon: const Icon(Icons.clear),
//                                             //   onPressed: () {
//                                             //     setState(() {
//                                             //       endPoint = null;
//                                             //       endAddressController.clear();
//                                             //       markers.clear();
//                                             //       polylines.clear();
//                                             //     });
//                                             //   },
//                                             // ),
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                     SizedBox(
//                                       height: 20.h,
//                                     ),
//
//                                     TimeAndDistanceInfoWidget(
//                                       time: time,
//                                       distance: distance,
//                                     ),
//                                     //                         Text(
//                                     // distance != null
//                                     //     ? 'Distance: $distance km\nTime: $time'
//                                     //     : '',
//                                     // style: TextStyle(
//                                     //   fontSize: 14.sp,
//                                     //   color: AppColors.blackColors,
//                                     // ),
//                                     //                         ),
//                                     SizedBox(
//                                       height: 10.h,
//                                     ),
//
//                                     /// write comment widget
//                                     WriteCommentWidget(
//                                       commentController:
//                                       _commentController,
//                                       onTap: () {
//                                         // Ø¹Ù†Ø¯Ù…Ø§ ÙŠØªÙ… Ø§Ù„Ù†Ù‚Ø± Ø¹Ù„Ù‰ Ø§Ù„Ø­Ù‚Ù„ TextField
//                                         showModalBottomSheet(
//                                           shape:
//                                           RoundedRectangleBorder(
//                                             borderRadius:
//                                             BorderRadius.only(
//                                               topRight:
//                                               Radius.circular(
//                                                   27.r),
//                                               topLeft:
//                                               Radius.circular(
//                                                   27.r),
//                                             ),
//                                           ),
//                                           constraints:
//                                           const BoxConstraints(
//                                               maxHeight: 550,
//                                               minHeight: 400),
//                                           useSafeArea: true,
//                                           isScrollControlled:
//                                           true,
//                                           context: context,
//                                           builder: (context) {
//                                             return BottomSheetModalForWriteCommentWidget(
//                                               commentFocusNode:
//                                               _commentFocusNode,
//                                               commentController:
//                                               _commentController,
//                                               onPressedClearButton:
//                                                   () {
//                                                 setState(() {
//                                                   _commentController
//                                                       .clear();
//                                                 });
//                                               },
//                                               onPressedDoneButton:
//                                                   () {
//                                                 _commentFocusNode
//                                                     .unfocus();
//                                                 Navigator.pop(
//                                                     context);
//                                                 // if (loginKey.currentState!.validate()) {
//                                                 //   use the information provided
//                                                 // }
//                                               },
//                                             );
//                                           },
//                                         );
//                                       },
//                                     ),
//
//                                     Padding(
//                                       padding:
//                                       const EdgeInsets.only(
//                                           right: 20,
//                                           left: 20),
//                                       child: Column(
//                                         children: [
//                                           SizedBox(height: 10.h),
//                                           ChooseVehicleAndInfoWidget(),
//                                           SizedBox(height: 10.h),
//                                           ChooseVehicleListViewWidget(
//                                             callBackFunction:
//                                             callBack,
//                                             pricebike: pricebike,
//                                             priceeconomy:
//                                             priceeconomy,
//                                             pricetrip: pricetrip,
//                                             PriceProoPlus:
//                                             PriceProoPlus,
//                                             pricevip:
//                                             priceeconomy,
//                                           ),
//                                           SizedBox(
//                                             height: 10.h,
//                                           ),
//                                           ConfirmTripButtonWidget(
//                                             onPressed: () {},
//                                           ),
//                                         ],
//                                         // drawer: NavBar(),
//                                         //
//
//                                         // ... Ø§Ù„Ù…Ø­ØªÙˆÙ‰ Ø§Ù„Ø¥Ø¶Ø§ÙÙŠ Ù‡Ù†Ø§
//                                       ),
//                                     ),
//                                   ]),
//                                 ),
//                               );
//                             },
//
//                             // if (registerdriverKey.currentState!.validate()) {
//                           ); // use the information provided
//
//                           // }
//                         },
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       );
//   }
// }









/// ÙƒØ§Ù†ÙˆØ§ Ù„ÙˆØ­Ø¯Ù‡Ù… ØªØ­Øª Ø®Ø§Ù„Øµ

// // class TripPriceBike {
// //   static int calculatePriceBike(double distanceInKm) {
// //     double pricePerKilometer = 2.90;
// //     int basePrice = 8;
// //     int additionalFee = 12;
// //
// //     // Ø­Ø³Ø§Ø¨ Ø§Ù„Ø³Ø¹Ø± Ø¨Ù†Ø§Ø¡Ù‹ Ø¹Ù„Ù‰ Ø§Ù„ÙƒÙŠÙ„ÙˆÙ…ØªØ±Ø§Øª
// //     double pricebike = distanceInKm * pricePerKilometer;
// //
// //     // Ø¥Ø¶Ø§ÙØ© Ø±Ø³ÙˆÙ… Ø¥Ø¶Ø§ÙÙŠØ© Ø¥Ø°Ø§ ÙƒØ§Ù†Øª Ø§Ù„Ù…Ø³Ø§ÙØ© Ø£Ù‚Ù„ Ù…Ù† 3 ÙƒÙŠÙ„ÙˆÙ…ØªØ±
// //     if (distanceInKm < 3) {
// //       return additionalFee; // Ù„Ø§ ÙŠØªÙ… Ø­Ø³Ø§Ø¨ Ø£ÙŠ Ø±Ø³ÙˆÙ…
// //     }
// //
// //     // Ø¥Ø¶Ø§ÙØ© Ø§Ù„Ø±Ø³ÙˆÙ… Ø§Ù„Ø£Ø³Ø§Ø³ÙŠØ©
// //     pricebike += basePrice;
// //
// //     // ØªØ­Ø¯ÙŠØ« Ø³Ø¹Ø± Ø§Ù„ÙƒÙŠÙ„ÙˆÙ…ØªØ± Ø¥Ø°Ø§ Ø²Ø§Ø¯Øª Ø§Ù„Ù…Ø³Ø§ÙØ© Ø¹Ù† 12 ÙƒÙŠÙ„ÙˆÙ…ØªØ±
// //     if (distanceInKm > 12 && distanceInKm <= 30) {
// //       pricePerKilometer = 2.50; // Ù‚ÙŠÙ…Ø© Ø£Ù‚Ù„ Ù„Ø³Ø¹Ø± Ø§Ù„ÙƒÙŠÙ„ÙˆÙ…ØªØ±
// //       pricebike =
// //           (distanceInKm * pricePerKilometer).clamp(0.0, double.infinity);
// //       pricebike += basePrice;
// //     }
// //
// //     // ØªØ­Ø¯ÙŠØ« Ø³Ø¹Ø± Ø§Ù„ÙƒÙŠÙ„ÙˆÙ…ØªØ± Ø¥Ø°Ø§ Ø²Ø§Ø¯Øª Ø§Ù„Ù…Ø³Ø§ÙØ© Ø¹Ù† 30 ÙƒÙŠÙ„ÙˆÙ…ØªØ±
// //     if (distanceInKm > 30 && distanceInKm <= 50) {
// //       pricePerKilometer = 2.00; // Ù‚ÙŠÙ…Ø© Ø£Ù‚Ù„ Ù„Ø³Ø¹Ø± Ø§Ù„ÙƒÙŠÙ„ÙˆÙ…ØªØ±
// //       pricebike =
// //           (distanceInKm * pricePerKilometer).clamp(0.0, double.infinity);
// //       pricebike += basePrice;
// //     }
// //
// //     // ÙˆÙ‡ÙƒØ°Ø§ ØªÙƒØ±Ø± Ø§Ù„Ø¹Ù…Ù„ÙŠØ© Ø­Ø³Ø¨ Ø§Ù„Ø´Ø±ÙˆØ· Ø§Ù„Ø¥Ø¶Ø§ÙÙŠØ© Ø§Ù„ØªÙŠ ØªØ­ØªØ§Ø¬Ù‡Ø§
// //
// //     // ØªØ­ÙˆÙŠÙ„ Ø§Ù„Ø³Ø¹Ø± Ø¥Ù„Ù‰ int
// //     return pricebike.isFinite ? pricebike.toInt() : 0;
// //   }
// // }
// //
// // class TripPriceEconomy {
// //   static int calculatePriceEconomy(double distanceInKm) {
// //     double pricePerKilometer = 4.00;
// //     int basePrice = 8;
// //     int additionalFee = 15;
// //
// //     // Ø­Ø³Ø§Ø¨ Ø§Ù„Ø³Ø¹Ø± Ø¨Ù†Ø§Ø¡Ù‹ Ø¹Ù„Ù‰ Ø§Ù„ÙƒÙŠÙ„ÙˆÙ…ØªØ±Ø§Øª
// //     double priceeconomy = distanceInKm * pricePerKilometer;
// //
// //     // Ø¥Ø¶Ø§ÙØ© Ø±Ø³ÙˆÙ… Ø¥Ø¶Ø§ÙÙŠØ© Ø¥Ø°Ø§ ÙƒØ§Ù†Øª Ø§Ù„Ù…Ø³Ø§ÙØ© Ø£Ù‚Ù„ Ù…Ù† 3 ÙƒÙŠÙ„ÙˆÙ…ØªØ±
// //     if (distanceInKm < 3) {
// //       return additionalFee; // Ù„Ø§ ÙŠØªÙ… Ø­Ø³Ø§Ø¨ Ø£ÙŠ Ø±Ø³ÙˆÙ…
// //     }
// //
// //     // Ø¥Ø¶Ø§ÙØ© Ø§Ù„Ø±Ø³ÙˆÙ… Ø§Ù„Ø£Ø³Ø§Ø³ÙŠØ©
// //     priceeconomy += basePrice;
// //
// //     // ØªØ­Ø¯ÙŠØ« Ø³Ø¹Ø± Ø§Ù„ÙƒÙŠÙ„ÙˆÙ…ØªØ± Ø¥Ø°Ø§ Ø²Ø§Ø¯Øª Ø§Ù„Ù…Ø³Ø§ÙØ© Ø¹Ù† 12 ÙƒÙŠÙ„ÙˆÙ…ØªØ±
// //     if (distanceInKm > 12 && distanceInKm <= 30) {
// //       pricePerKilometer = 3.80; // Ù‚ÙŠÙ…Ø© Ø£Ù‚Ù„ Ù„Ø³Ø¹Ø± Ø§Ù„ÙƒÙŠÙ„ÙˆÙ…ØªØ±
// //       priceeconomy =
// //           (distanceInKm * pricePerKilometer).clamp(0.0, double.infinity);
// //       priceeconomy += basePrice;
// //     }
// //
// //     // ØªØ­Ø¯ÙŠØ« Ø³Ø¹Ø± Ø§Ù„ÙƒÙŠÙ„ÙˆÙ…ØªØ± Ø¥Ø°Ø§ Ø²Ø§Ø¯Øª Ø§Ù„Ù…Ø³Ø§ÙØ© Ø¹Ù† 30 ÙƒÙŠÙ„ÙˆÙ…ØªØ±
// //     if (distanceInKm > 30 && distanceInKm <= 50) {
// //       pricePerKilometer = 3.60; // Ù‚ÙŠÙ…Ø© Ø£Ù‚Ù„ Ù„Ø³Ø¹Ø± Ø§Ù„ÙƒÙŠÙ„ÙˆÙ…ØªØ±
// //       priceeconomy =
// //           (distanceInKm * pricePerKilometer).clamp(0.0, double.infinity);
// //       priceeconomy += basePrice;
// //     }
// //
// //     // ÙˆÙ‡ÙƒØ°Ø§ ØªÙƒØ±Ø± Ø§Ù„Ø¹Ù…Ù„ÙŠØ© Ø­Ø³Ø¨ Ø§Ù„Ø´Ø±ÙˆØ· Ø§Ù„Ø¥Ø¶Ø§ÙÙŠØ© Ø§Ù„ØªÙŠ ØªØ­ØªØ§Ø¬Ù‡Ø§
// //
// //     // ØªØ­ÙˆÙŠÙ„ Ø§Ù„Ø³Ø¹Ø± Ø¥Ù„Ù‰ int
// //     return priceeconomy.isFinite ? priceeconomy.toInt() : 0;
// //   }
// // }
// //
// // class TripPriceTrip {
// //   static int calculatePriceTrip(double distanceInKm) {
// //     double pricePerKilometer = 4.50;
// //     int basePrice = 8;
// //     int additionalFee = 15;
// //
// //     // Ø­Ø³Ø§Ø¨ Ø§Ù„Ø³Ø¹Ø± Ø¨Ù†Ø§Ø¡Ù‹ Ø¹Ù„Ù‰ Ø§Ù„ÙƒÙŠÙ„ÙˆÙ…ØªØ±Ø§Øª
// //     double pricetrip = distanceInKm * pricePerKilometer;
// //
// //     // Ø¥Ø¶Ø§ÙØ© Ø±Ø³ÙˆÙ… Ø¥Ø¶Ø§ÙÙŠØ© Ø¥Ø°Ø§ ÙƒØ§Ù†Øª Ø§Ù„Ù…Ø³Ø§ÙØ© Ø£Ù‚Ù„ Ù…Ù† 3 ÙƒÙŠÙ„ÙˆÙ…ØªØ±
// //     if (distanceInKm < 3) {
// //       return additionalFee; // Ù„Ø§ ÙŠØªÙ… Ø­Ø³Ø§Ø¨ Ø£ÙŠ Ø±Ø³ÙˆÙ…
// //     }
// //
// //     // Ø¥Ø¶Ø§ÙØ© Ø§Ù„Ø±Ø³ÙˆÙ… Ø§Ù„Ø£Ø³Ø§Ø³ÙŠØ©
// //     pricetrip += basePrice;
// //
// //     // ØªØ­Ø¯ÙŠØ« Ø³Ø¹Ø± Ø§Ù„ÙƒÙŠÙ„ÙˆÙ…ØªØ± Ø¥Ø°Ø§ Ø²Ø§Ø¯Øª Ø§Ù„Ù…Ø³Ø§ÙØ© Ø¹Ù† 12 ÙƒÙŠÙ„ÙˆÙ…ØªØ±
// //     if (distanceInKm > 12 && distanceInKm <= 30) {
// //       pricePerKilometer = 4.20; // Ù‚ÙŠÙ…Ø© Ø£Ù‚Ù„ Ù„Ø³Ø¹Ø± Ø§Ù„ÙƒÙŠÙ„ÙˆÙ…ØªØ±
// //       pricetrip =
// //           (distanceInKm * pricePerKilometer).clamp(0.0, double.infinity);
// //       pricetrip += basePrice;
// //     }
// //
// //     // ØªØ­Ø¯ÙŠØ« Ø³Ø¹Ø± Ø§Ù„ÙƒÙŠÙ„ÙˆÙ…ØªØ± Ø¥Ø°Ø§ Ø²Ø§Ø¯Øª Ø§Ù„Ù…Ø³Ø§ÙØ© Ø¹Ù† 30 ÙƒÙŠÙ„ÙˆÙ…ØªØ±
// //     if (distanceInKm > 30 && distanceInKm <= 50) {
// //       pricePerKilometer = 3.80; // Ù‚ÙŠÙ…Ø© Ø£Ù‚Ù„ Ù„Ø³Ø¹Ø± Ø§Ù„ÙƒÙŠÙ„ÙˆÙ…ØªØ±
// //       pricetrip =
// //           (distanceInKm * pricePerKilometer).clamp(0.0, double.infinity);
// //       pricetrip += basePrice;
// //     }
// //
// //     // ÙˆÙ‡ÙƒØ°Ø§ ØªÙƒØ±Ø± Ø§Ù„Ø¹Ù…Ù„ÙŠØ© Ø­Ø³Ø¨ Ø§Ù„Ø´Ø±ÙˆØ· Ø§Ù„Ø¥Ø¶Ø§ÙÙŠØ© Ø§Ù„ØªÙŠ ØªØ­ØªØ§Ø¬Ù‡Ø§
// //
// //     // ØªØ­ÙˆÙŠÙ„ Ø§Ù„Ø³Ø¹Ø± Ø¥Ù„Ù‰ int
// //     return pricetrip.isFinite ? pricetrip.toInt() : 0;
// //   }
// // }
// //
// // class TripPriceProoPlus {
// //   static int calculatePriceProoPlus(double distanceInKm) {
// //     double pricePerKilometer = 5.20;
// //     int basePrice = 8;
// //     int additionalFee = 15;
// //
// //     // Ø­Ø³Ø§Ø¨ Ø§Ù„Ø³Ø¹Ø± Ø¨Ù†Ø§Ø¡Ù‹ Ø¹Ù„Ù‰ Ø§Ù„ÙƒÙŠÙ„ÙˆÙ…ØªØ±Ø§Øª
// //     double PriceProoPlus = distanceInKm * pricePerKilometer;
// //
// //     // Ø¥Ø¶Ø§ÙØ© Ø±Ø³ÙˆÙ… Ø¥Ø¶Ø§ÙÙŠØ© Ø¥Ø°Ø§ ÙƒØ§Ù†Øª Ø§Ù„Ù…Ø³Ø§ÙØ© Ø£Ù‚Ù„ Ù…Ù† 3 ÙƒÙŠÙ„ÙˆÙ…ØªØ±
// //     if (distanceInKm < 3) {
// //       return additionalFee; // Ù„Ø§ ÙŠØªÙ… Ø­Ø³Ø§Ø¨ Ø£ÙŠ Ø±Ø³ÙˆÙ…
// //     }
// //
// //     // Ø¥Ø¶Ø§ÙØ© Ø§Ù„Ø±Ø³ÙˆÙ… Ø§Ù„Ø£Ø³Ø§Ø³ÙŠØ©
// //     PriceProoPlus += basePrice;
// //
// //     // ØªØ­Ø¯ÙŠØ« Ø³Ø¹Ø± Ø§Ù„ÙƒÙŠÙ„ÙˆÙ…ØªØ± Ø¥Ø°Ø§ Ø²Ø§Ø¯Øª Ø§Ù„Ù…Ø³Ø§ÙØ© Ø¹Ù† 12 ÙƒÙŠÙ„ÙˆÙ…ØªØ±
// //     if (distanceInKm > 12 && distanceInKm <= 30) {
// //       pricePerKilometer = 4.60; // Ù‚ÙŠÙ…Ø© Ø£Ù‚Ù„ Ù„Ø³Ø¹Ø± Ø§Ù„ÙƒÙŠÙ„ÙˆÙ…ØªØ±
// //       PriceProoPlus =
// //           (distanceInKm * pricePerKilometer).clamp(0.0, double.infinity);
// //       PriceProoPlus += basePrice;
// //     }
// //
// //     // ØªØ­Ø¯ÙŠØ« Ø³Ø¹Ø± Ø§Ù„ÙƒÙŠÙ„ÙˆÙ…ØªØ± Ø¥Ø°Ø§ Ø²Ø§Ø¯Øª Ø§Ù„Ù…Ø³Ø§ÙØ© Ø¹Ù† 30 ÙƒÙŠÙ„ÙˆÙ…ØªØ±
// //     if (distanceInKm > 30 && distanceInKm <= 50) {
// //       pricePerKilometer = 4.30; // Ù‚ÙŠÙ…Ø© Ø£Ù‚Ù„ Ù„Ø³Ø¹Ø± Ø§Ù„ÙƒÙŠÙ„ÙˆÙ…ØªØ±
// //       PriceProoPlus =
// //           (distanceInKm * pricePerKilometer).clamp(0.0, double.infinity);
// //       PriceProoPlus += basePrice;
// //     }
// //
// //     // ÙˆÙ‡ÙƒØ°Ø§ ØªÙƒØ±Ø± Ø§Ù„Ø¹Ù…Ù„ÙŠØ© Ø­Ø³Ø¨ Ø§Ù„Ø´Ø±ÙˆØ· Ø§Ù„Ø¥Ø¶Ø§ÙÙŠØ© Ø§Ù„ØªÙŠ ØªØ­ØªØ§Ø¬Ù‡Ø§
// //
// //     // ØªØ­ÙˆÙŠÙ„ Ø§Ù„Ø³Ø¹Ø± Ø¥Ù„Ù‰ int
// //     return PriceProoPlus.isFinite ? PriceProoPlus.toInt() : 0;
// //   }
// // }



/// Ø¨Ø¯Ø§Ø®Ù„ Ø§Ù„ build method
//
//
// double calculateDiscountedPrice() {
//   double originalPrice = 100.0; // Ø§ÙØªØ±Ø§Ø¶ÙŠ Ù‚ÙŠÙ…Ø© Ø§Ù„Ø³Ø¹Ø± Ø§Ù„Ø£ØµÙ„ÙŠ
//   double enteredPrice = double.tryParse(_priceController.text) ?? 0.0;
//   double discountedPrice = enteredPrice - (enteredPrice * 0.10);
//
//   // Ø§Ù„ØªØ­Ù‚Ù‚ Ù…Ù† Ø£Ù† Ø§Ù„Ø³Ø¹Ø± Ø¨Ø¹Ø¯ Ø§Ù„ØªØ®ÙÙŠØ¶ Ù„Ø§ ÙŠÙ‚Ù„ Ø¹Ù† 90% Ù…Ù† Ø§Ù„Ø³Ø¹Ø± Ø§Ù„Ø£ØµÙ„ÙŠ
//   return discountedPrice >= 0.9 * originalPrice ? discountedPrice : 0.0;
// }
//
// void _onMapCreated(GoogleMapController controller) {
//   mapController = controller;
// }
//
// LatLngBounds _calculateLatLngBounds(List<LatLng> polylineCoordinates) {
//   double minLat = double.infinity;
//   double minLng = double.infinity;
//   double maxLat = double.negativeInfinity;
//   double maxLng = double.negativeInfinity;
//
//   for (LatLng point in polylineCoordinates) {
//     minLat = min(minLat, point.latitude);
//     minLng = min(minLng, point.longitude);
//     maxLat = max(maxLat, point.latitude);
//     maxLng = max(maxLng, point.longitude);
//   }
//
//   LatLng southwest = LatLng(minLat, minLng);
//   LatLng northeast = LatLng(maxLat, maxLng);
//
//   return LatLngBounds(southwest: southwest, northeast: northeast);
// }
//
// void _getPolylines() async {
//   if (startPoint != null && endPoint != null) {
//     PolylineResult result = await PolylinePoints().getRouteBetweenCoordinates(
//       'YOUR_API_KEY_HERE', // Replace with your Google Maps API key
//       PointLatLng(startPoint.latitude, startPoint.longitude),
//       PointLatLng(endPoint.latitude, endPoint.longitude),
//     );
//
//     if (result.points.isNotEmpty) {
//       List<LatLng> polylineCoordinates = [];
//
//       for (var point in result.points) {
//         polylineCoordinates.add(LatLng(point.latitude, point.longitude));
//       }
//
//       const polylineId = PolylineId('polyline');
//       final polyline = Polyline(
//         polylineId: polylineId,
//         color: Colors.red,
//         width: 3,
//         points: polylineCoordinates,
//       );
//       setState(() {
//         polylines.clear(); // Clear existing polylines
//         polylines[polylineId] = polyline; // Add new polyline
//       });
//
//       LatLngBounds bounds = _calculateLatLngBounds(polylineCoordinates);
//
//       mapController?.animateCamera(
//         CameraUpdate.newLatLngBounds(bounds, 50.0),
//       );
//     }
//   }
// }



