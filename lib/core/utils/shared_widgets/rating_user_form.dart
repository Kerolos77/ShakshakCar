import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shakshak/core/utils/shared_widgets/custom_button.dart';

import 'package:shakshak/core/resources/app_colors.dart';

// class RatingDialog extends StatefulWidget {
//   const RatingDialog({Key? key}) : super(key: key);
//
//   @override
//   _RatingDialogState createState() => _RatingDialogState();
// }
//
// TextEditingController ratecommentController = TextEditingController();
//
// class _RatingDialogState extends State<RatingDialog> {
//   int _stars = 0;
//   String selectedEmotion = '';
//   bool checkone = true;
//   List<String> emotions = [
//     '😍',
//     '😊',
//     '😎',
//     '😢',
//     '😡',
//   ]; // يمكنك إضافة المزيد من الرموز التعبيرية
//
//   Widget _buildStar(int starCount) {
//     return InkWell(
//       child: Column(
//         children: [
//           Text(
//             '$starCount',
//             style: TextStyle(fontSize: 12.0),
//           ),
//           Icon(
//             Icons.star,
//             size: 40.0,
//             color: _stars >= starCount ? Colors.orange : Colors.grey,
//           ),
//         ],
//       ),
//       onTap: () {
//         setState(() {
//           _stars = starCount;
//         });
//       },
//     );
//   }
//
//   int selectedEmotionIndex = 0; // تمثل الفهرس المحدد للايموجي
//   double zoomFactor = 2.5;
//
//   @override
//   Widget build(BuildContext context) {
//     double zoomFactor = 2.5;
//
//     return
//       AlertDialog(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(20.0),
//       ),
//       content: IntrinsicWidth(
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   for (int i = 1; i <= 5; i++) _buildStar(i),
//                 ],
//               ),
//               TextField(
//                 controller: ratecommentController,
//                 decoration: InputDecoration(labelText: 'Add a comment'),
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   IconButton(
//                     onPressed: () {
//                       showModalBottomSheet(
//                         shape: RoundedRectangleBorder(
//                           side: const BorderSide(),
//                           borderRadius: BorderRadius.only(
//                             topRight: Radius.circular(27.r),
//                             topLeft: Radius.circular(27.r),
//                           ),
//                         ),
//                         constraints:
//                             BoxConstraints(maxHeight: 400, minHeight: 300),
//                         useSafeArea: true,
//                         isScrollControlled: true,
//                         context: context,
//                         builder: (context) {
//                           double screenHeight =
//                               MediaQuery.of(context).size.height;
//                           double containerHeight = screenHeight * 0.65;
//
//                           return StatefulBuilder(
//                             builder: (context, setState) {
//                               return SingleChildScrollView(
//                                 child: Container(
//                                   width: double.infinity,
//                                   height: containerHeight,
//                                   decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.only(
//                                       topLeft: Radius.circular(27.r),
//                                       topRight: Radius.circular(27.r),
//                                     ),
//                                   ),
//                                   child: Column(
//                                     children: [
//                                       Padding(
//                                         padding: const EdgeInsets.all(20.0),
//                                         child: GridView.builder(
//                                           shrinkWrap: true,
//                                           gridDelegate:
//                                           SliverGridDelegateWithFixedCrossAxisCount(
//                                             crossAxisCount: 5,
//                                             crossAxisSpacing: 8.0,
//                                             mainAxisSpacing: 8.0,
//                                           ),
//                                           itemCount: emotions.length,
//                                           itemBuilder: (context, index) {
//                                             return InkWell(
//                                               onTap: () {
//                                                 setState(() {
//                                                   selectedEmotionIndex = index;
//                                                   zoomFactor =
//                                                   index == selectedEmotionIndex
//                                                       ? 1.5
//                                                       : 1.0;
//                                                 });
//
//                                               },
//                                               child: Container(
//                                                 alignment: Alignment.center,
//                                                 padding: EdgeInsets.all(8.0),
//                                                 decoration: BoxDecoration(
//                                                   color: Colors.grey[300],
//                                                   borderRadius:
//                                                   BorderRadius.circular(8.0),
//                                                 ),
//                                                 child: Text(
//                                                   emotions[index],
//                                                   style: TextStyle(fontSize: 20.0),
//                                                 ),
//                                               ),
//                                             );
//                                           },
//                                         ),
//                                       ),
//                                       Container(
//                                         width: 70,
//                                         height: 70.0,
//                                         color: Colors.grey[300],
//                                         child: Center(
//                                           child: Transform.scale(
//                                             // تحديث حجم الايموجي بناءً على ال zoomFactor
//                                             scale: zoomFactor,
//                                             child: Text(
//                                                 emotions[selectedEmotionIndex]),
//                                           ),
//                                         ),
//                                       ),
//                                       Text(
//                                         "I agree to all terms and  \n conditions and laws of work",
//                                         style: TextStyle(
//                                           fontSize: 18.sp,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                       ),
//                                       Checkbox(
//                                           value: checkone,
//                                           onChanged: (val) {
//                                             setState(() {
//                                               checkone = val!;
//                                             });
//                                           }),
//                                       Padding(
//                                         padding: const EdgeInsets.all(20.0),
//                                         child: Column(
//                                           children: [
//                                             SizedBox(height: 200.h),
//                                             ButtonWidget(
//                                               color:
//                                               AppColors.primaryColor(context),
//                                               height: 45.h,
//                                               margin: EdgeInsets.symmetric(
//                                                   horizontal: 20.w),
//                                               borderRadius: 18.r,
//                                               onPressed: () {
//                                                 Navigator.pop(context);
//                                               },
//                                               child: Center(
//                                                 child: Text(
//                                                   'Done',
//                                                   style: TextStyle(
//                                                     fontWeight: FontWeight.w600,
//                                                     fontSize: 18.sp,
//                                                   ),
//                                                 ),
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               );
//                             },
//                           );
//                         },
//                       );
//                     },
//                     icon: Icon(Icons.thumb_up),
//                   ),
//                   IconButton(
//                     onPressed: () {
//                       showModalBottomSheet(
//                         shape: RoundedRectangleBorder(
//                           side: const BorderSide(),
//                           borderRadius: BorderRadius.only(
//                             topRight: Radius.circular(27.r),
//                             topLeft: Radius.circular(27.r),
//                           ),
//                         ),
//                         constraints: const BoxConstraints(
//                             maxHeight: 400, minHeight: 300),
//                         useSafeArea: true,
//                         isScrollControlled: true,
//                         context: context,
//                         builder: (context) {
//                           double screenHeight =
//                               MediaQuery.of(context).size.height;
//                           double containerHeight = screenHeight * 0.80;
//
//                           return SingleChildScrollView(
//                             child: Container(
//                               width: double.infinity,
//                               height: containerHeight,
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.only(
//                                   topLeft: Radius.circular(27.r),
//                                   topRight: Radius.circular(27.r),
//                                 ),
//                               ),
//                               child: Column(
//                                 children: [
//                                   SizedBox(
//                                     height: 30.h,
//                                   ),
//                                   Text(
//                                     'Emotion: $emotions',
//                                     style: TextStyle(fontSize: 15.sp),
//                                   ),
//                                   Padding(
//                                     padding: const EdgeInsets.all(20.0),
//                                     child: Column(
//                                       children: [
//                                         SizedBox(height: 300.h),
//                                         ButtonWidget(
//                                           color:
//                                               AppColors.primaryColor(context),
//                                           height: 45.h,
//                                           margin: EdgeInsets.symmetric(
//                                               horizontal: 20.w),
//                                           borderRadius: 18.r,
//                                           onPressed: () {
//                                             Navigator.pop(context);
//                                           },
//                                           child: Center(
//                                             child: Text(
//                                               'Done',
//                                               style: TextStyle(
//                                                 fontWeight: FontWeight.w600,
//                                                 fontSize: 18.sp,
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           );
//                         },
//                       );
//                     },
//                     icon: Icon(Icons.thumb_down),
//                   ),
//                 ],
//               ),
//               // GridView.builder(
//               //   shrinkWrap: true,
//               //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//               //     crossAxisCount: 5,
//               //     crossAxisSpacing: 8.0,
//               //     mainAxisSpacing: 8.0,
//               //   ),
//               //   itemCount: emotions.length,
//               //   itemBuilder: (context, index) {
//               //     return InkWell(
//               //       onTap: () {
//               //         // إجراء عند النقر على العنصر في GridView
//               //       },
//               //       child: Container(
//               //         alignment: Alignment.center,
//               //         padding: EdgeInsets.all(8.0),
//               //         decoration: BoxDecoration(
//               //           color: Colors.grey[300],
//               //           borderRadius: BorderRadius.circular(8.0),
//               //         ),
//               //         child: Text(
//               //           emotions[index],
//               //           style: TextStyle(fontSize: 20.0),
//               //         ),
//               //       ),
//               //     );
//               //   },
//               // ),
//             ],
//           ),
//         ),
//       ),
//       title: Center(child: Text('Rate The Trip')),
//       actions: <Widget>[
//         // TextButton(
//         //   child: Text('CANCEL'),
//         //   onPressed: Navigator.of(context).pop,
//         // ),
//         ButtonWidget(
//           color: AppColors.primaryColor,
//           height: 45.h,
//           margin: EdgeInsets.symmetric(horizontal: 40.w),
//           borderRadius: 18.r,
//           onPressed: () {
//             // _commentFocusNode
//             //     .unfocus();
//             Navigator.pop(context);
//             // if (loginKey.currentState!.validate()) {
//             //   use the information provided
//             // }
//           },
//           child: Center(
//             child: Text(
//               'Send',
//               style: TextStyle(
//                 fontWeight: FontWeight.w600,
//                 fontSize: 18.sp,
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

// showModalBottomSheet(
//   shape: RoundedRectangleBorder(
//     side: const BorderSide(),
//     borderRadius: BorderRadius.only(
//       topRight: Radius.circular(27.r),
//       topLeft: Radius.circular(27.r),
//     ),
//   ),
//   constraints: const BoxConstraints(maxHeight: 400, minHeight: 300),
//   useSafeArea: true,
//   isScrollControlled: true,
//   context: context,
//   builder: (context) {
//     double screenHeight = MediaQuery.of(context).size.height;
//     double containerHeight = screenHeight * 0.80;

//     return SingleChildScrollView(
//       child: Container(
//         width: double.infinity,
//         height: containerHeight,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.only(
//             topLeft: Radius.circular(27.r),
//             topRight: Radius.circular(27.r),
//           ),
//         ),
//         child: Column(
//           children: [
//             SizedBox(
//               height: 30.h,
//             ),
//             Text(
//               'Emotion: $emotion',
//               style: TextStyle(fontSize: 15.sp),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(20.0),
//               child: Column(
//                 children: [
//                   SizedBox(height: 300.h),
//                   ButtonWidget(
//                     color: AppColors.primaryColor(context),
//                     height: 45.h,
//                     margin: EdgeInsets.symmetric(horizontal: 20.w),
//                     borderRadius: 18.r,
//                     onPressed: () {
//                       Navigator.pop(context);
//                     },
//                     child: Center(
//                       child: Text(
//                         'Done',
//                         style: TextStyle(
//                           fontWeight: FontWeight.w600,
//                           fontSize: 18.sp,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   },
// );
//
// class SummaryRating extends StatelessWidget {
//   final int counter;
//   final double average;
//   final int counterFiveStars;
//   final int counterFourStars;
//   final int counterThreeStars;
//   final int counterTwoStars;
//   final int counterOneStars;
//
//   const SummaryRating({
//     Key? key,
//     required this.counter,
//     required this.average,
//     required this.counterFiveStars,
//     required this.counterFourStars,
//     required this.counterThreeStars,
//     required this.counterTwoStars,
//     required this.counterOneStars,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         drawer: CustomDrawer(),
//         extendBodyBehindAppBar: true,
//         appBar: AppBar(
//           backgroundColor: AppColors.primaryColor,
//           elevation: 0.0,
//           toolbarHeight: 55,
//           title: Text(
//             'The Rating',
//             style: TextStyle(
//               fontSize: 22.sp,
//             ),
//           ),
//           centerTitle: true,
//           flexibleSpace: Container(
//             decoration: BoxDecoration(
//               color: AppColors.primaryColor,
//               borderRadius: const BorderRadius.only(
//                   bottomLeft: Radius.circular(17),
//                   bottomRight: Radius.circular(17)),
//             ),
//           ),
//           systemOverlayStyle: SystemUiOverlayStyle.light,
//         ),
//         body: Column(
//           children: [
//             Text('Total Ratings: $counter'),
//             Text('Average Rating: ${average.toStringAsFixed(2)}'),
//             Text('5 Stars: $counterFiveStars'),
//             Text('4 Stars: $counterFourStars'),
//             Text('3 Stars: $counterThreeStars'),
//             Text('2 Stars: $counterTwoStars'),
//             Text('1 Star: $counterOneStars'),
//             Padding(
//               padding: const EdgeInsets.all(20.0),
//               child: RatingSummary(
//                 showAverage: true,
//                 counter: counter,
//                 average: average,
//                 counterFiveStars: counterFiveStars,
//                 counterFourStars: counterFourStars,
//                 counterThreeStars: counterThreeStars,
//                 counterTwoStars: counterTwoStars,
//                 counterOneStars: counterOneStars,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   int totalRatings() {
//     return counterFiveStars +
//         counterFourStars +
//         counterThreeStars +
//         counterTwoStars +
//         counterOneStars;
//   }
// }

// class RatingSummary extends StatelessWidget {
//   final int counter;
//   final double average;
//   final int counterFiveStars;
//   final int counterFourStars;
//   final int counterThreeStars;
//   final int counterTwoStars;
//   final int counterOneStars;

//   const RatingSummary({
//     Key? key,
//     required this.counter,
//     required this.average,
//     required this.counterFiveStars,
//     required this.counterFourStars,
//     required this.counterThreeStars,
//     required this.counterTwoStars,
//     required this.counterOneStars,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         body: Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text('Total Ratings: $counter'),
//               Text('Average Rating: ${average.toStringAsFixed(2)}'),
//               Text('5 Stars: $counterFiveStars'),
//               Text('4 Stars: $counterFourStars'),
//               Text('3 Stars: $counterThreeStars'),
//               Text('2 Stars: $counterTwoStars'),
//               Text('1 Star: $counterOneStars'),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// SummaryRating(
//   counter: 13,
//   average: 3.846,
//   counterFiveStars: 5,
//   counterFourStars: 4,
//   counterThreeStars: 2,
//   counterTwoStars: 1,
//   counterOneStars: 1,
// ),
// class ReviewChart extends StatelessWidget {
//   const ReviewChart({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           SizedBox(height: 8),
//           chartRow(context, '5', 89),
//           chartRow(context, '4', 8),
//           chartRow(context, '3', 2),
//           chartRow(context, '4', 1),
//           chartRow(context, '1', 0),
//           SizedBox(height: 8),
//         ],
//       ),
//     );
//   }

//   Widget chartRow(BuildContext context, String label, int pct) {
//     return Row(
//       children: [
//         Text(label),
//         SizedBox(width: 8),
//         Icon(Icons.star, color: AppColors.greyColors),
//         Padding(
//           padding: EdgeInsetsDirectional.fromSTEB(8, 0, 8, 0),
//           child:
//           Stack(
//             children: [
//               Container(
//                 width: MediaQuery.of(context).size.width * 0.7,
//                 decoration: BoxDecoration(
//                     color: Colors.amber,
//                     borderRadius: BorderRadius.circular(20)
//                 ),
//                 child: Text(''),
//               ),
//               Container(
//                 width: MediaQuery.of(context).size.width * (pct/100) * 0.7,
//                 decoration: BoxDecoration(
//                     color: Colors.cyan,
//                     borderRadius: BorderRadius.circular(20)
//                 ),
//                 child: Text(''),
//               ),
//             ]

//           ),
//         ),
//         Text('$pct%'),
//       ],
//     );
//   }
// }

// class ScrollAndList extends StatefulWidget {
//   @override
//   _ScrollAndListState createState() => _ScrollAndListState();
// }

// class _ScrollAndListState extends State<ScrollAndList> {
//   List<String> items =
//   ['bike', 'car1', 'car2', 'car3', 'car4'];
//   int selectedIndex = -1; // تعريف متغير لتخزين العنصر المحدد

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         body: Column(
//           children: [
//             // قسم عمودي يحتوي على ListView لعرض النصوص
//             Container(
//               height: 50,
//               child: ListView(
//                 scrollDirection: Axis.horizontal,
//                 children: List.generate(items.length, (index) {
//                   return GestureDetector(
//                     onTap: () {

//                       // عند النقر على أحد النصوص
//                       // قم بتحديث الواجهة الأفقية بناءً على النص المحدد
//   setState(() {
//     selectedIndex = index;
//   });
//   print('Selected (Top): ${items[index]}');

//   // قم بإلغاء تحديد العنصر المحدد في القائمة السفلية
//                     },
//                     child: Container(
//                       padding: EdgeInsets.all(8),
//                       margin: EdgeInsets.all(4),
//                       decoration: BoxDecoration(
//                         border: Border.all(
//                           color: selectedIndex == index
//                               ? Colors.blue // لون مختلف للعنصر المحدد
//                               : Colors.red,
//                         ),
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: Text(items[index]),
//                     ),
//                   );
//                 }),
//               ),
//             ),
//             // قسم أفقي يحتوي على ListView.builder لعرض القائمة الأفقية
// Expanded(

//   child: ListView.builder(
//     itemCount: items.length, // زيادة عدد العناصر بمقدار 1
//     scrollDirection: Axis.horizontal,
//     itemBuilder: (context, index) {
//       if (index == items.length) {
//         // عندما يتم زيادة عدد العناصر بمقدار 1
//         // يتم عرض اسم العنصر في العنصر الأخير من القائمة
//         return Container(
//           width: 150,
//           height: 150,
//           margin: EdgeInsets.all(8),
//           child: Center(
//             child: Text(
//               'Select Item',
//               style: TextStyle(fontSize: 18),
//             ),
//           ),
//         );
//       } else {
//         return GestureDetector(
//           onTap: () {
//             // عند النقر على أحد النصوص
//             // قم بتحديث الواجهة الأفقية بناءً على النص المحدد
//             setState(() {
//               selectedIndex = index;
//             });
//             print('Selected (Top): ${items[index]}');

//             // قم بإلغاء تحديد العنصر المحدد في القائمة السفلية
//           },
//           child: Container(
//             width: 150,
//             margin: EdgeInsets.all(8),
//             decoration: BoxDecoration(
//               border: Border.all(
//                 color: selectedIndex == index
//                    ? Colors.green // لون مختلف للعنصر المحدد
//                     : Colors.blueAccent,
//               ),
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: Center(
//               child: Text(
//                 items[index],
//                 style: TextStyle(fontSize: 18),
//               ),
//             ),
//           ),
//         );
//       }
//     },
//   ),

// ),
//         ],
//         ),
//       ),
//     );
//   }
// }

class ListVichclesPrice extends StatefulWidget {
  const ListVichclesPrice({super.key});

  @override
  _ListVichclesPriceState createState() => _ListVichclesPriceState();
}

class _ListVichclesPriceState extends State<ListVichclesPrice> {
  List<String> items = ['bike', 'car1', 'car2', 'car3', 'car4'];
  int selectedIndex = -1; // تعريف متغير لتخزين العنصر المحدد

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Expanded(
        child: ListView.builder(
          itemCount: 5, // زيادة عدد العناصر بمقدار 1

          itemBuilder: (context, index) {
            // عندما يتم زيادة عدد العناصر بمقدار 1

            // يتم عرض اسم العنصر في العنصر الأخير من القائمة

            return Column(
              children: [
                ListTile(
                  title: Text("hello"),
                  leading: Icon(Icons.abc),
                  trailing: Icon(Icons.abc),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

// class ScrollableList extends StatefulWidget {
//   @override
//   _ScrollableListState createState() => _ScrollableListState();
// }

// class _ScrollableListState extends State<ScrollableList> {
//   List<double> itemHeights = List.generate(5, (index) => 100.0);
//   int selectedIndex = -1;

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text('Scrollable List'),
//         ),
//         body: ListView.builder(
//           itemCount: itemHeights.length,
//           itemBuilder: (context, index) {
//             return GestureDetector(
//               onTap: () {
//                 setState(() {
//                   selectedIndex = index;
//                   // Move the selected item to the top
//                   itemHeights = List.generate(5, (i) => i == index ? 150.0 : 100.0);
//                 });
//               },
//               child: AnimatedContainer(
//                 duration: Duration(milliseconds: 300),
//                 height: itemHeights[index],
//                 color: selectedIndex == index ? Colors.blue : Colors.transparent,
//                 child: Column(
//                   children: [
//                     ListTile(
//                       title: Text('Item 1'[0]),
//                     ),
//                                       ListTile(
//                       title: Text('Item 2'[1]),
//                     ),
//                     ListTile(
//                       title: Text('Item 3'[2]),
//                     ),
//                     ListTile(
//                       title: Text('Item 4'[3]),
//                     ),
//                     ListTile(
//                       title: Text('Item 1'[4]),
//                     ),

//                   ],
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

// class HomePage extends StatefulWidget {
//   @override
//   _HomePageState createState() => _HomePageState();
// }
// int phoneNumber = 0;
// class _HomePageState extends State<HomePage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Phone Auth Demo"),
//         backgroundColor: Colors.cyan,
//       ),
//       body: FutureBuilder(
//         builder: (context, snapshot) {
//            snapshot.data;
//           return snapshot.hasData
//               ? Center(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       Text(
//                         "SignIn Success 😊",
//                         style: TextStyle(
//                           color: Colors.green,
//                           fontWeight: FontWeight.bold,
//                           fontSize: 30,
//                         ),
//                       ),
//                       SizedBox(
//                         height: 20,
//                       ),
//                       Text("UserId:"),
//                       SizedBox(
//                         height: 20,
//                       ),
//                       Text(
//                           "Registered Phone Number: ${phoneNumber}"),
//                       SizedBox(
//                         height: 20,
//                       ),
//                       ElevatedButton(
//                         onPressed:() {

//                         },
//                         child: Text(
//                           "LogOut",
//                           style: TextStyle(color: Colors.white),
//                         ),
//                       )
//                     ],
//                   ),
//                 )
//               : CircularProgressIndicator();
//         },
//       ),
//     );
//   }
// }

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool showOtpFields = false;
  String otp = "";
  int countdown = 300;
  int phoneNumber = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.2,
              ),
              if (!showOtpFields)
                Text(
                  "Phone Number📱",
                  style: TextStyle(
                    color: Colors.cyan,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              if (!showOtpFields)
                Image.asset(
                  "assets/images/phoneAuth.png",
                  height: 150,
                ),
              if (showOtpFields) ...[
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        "Enter the OTP",
                        style: TextStyle(
                          color: Colors.cyan,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          buildOtpTextField(otp.length > 0 ? otp[0] : ""),
                          buildOtpTextField(otp.length > 1 ? otp[1] : ""),
                          buildOtpTextField(otp.length > 2 ? otp[2] : ""),
                          buildOtpTextField(otp.length > 3 ? otp[3] : ""),
                        ],
                      ),
                    ],
                  ),
                ),
                if (countdown > 0)
                  Text(
                    "Resend in ${countdown} seconds",
                    style: TextStyle(color: Colors.red),
                  ),
              ],
              if (!showOtpFields) ...[
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    keyboardType: TextInputType.phone,
                    decoration: new InputDecoration(
                      border: new OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          const Radius.circular(30),
                        ),
                      ),
                      filled: true,
                      prefixIcon: Image.asset(
                        "assets/images/flagegypt.png",
                        scale: 7,
                      ),
                      suffixIcon: Icon(
                        Icons.phone_iphone,
                        color: Colors.cyan,
                      ),
                      hintStyle: new TextStyle(color: Colors.grey[800]),
                      hintText: "Enter Your Phone Number...",
                      fillColor: Colors.white70,
                    ),
                    onChanged: (value) {
                      phoneNumber = value as int;
                    },
                  ),
                ),
              ],
              SizedBox(
                height: 10.0,
              ),
              ElevatedButton(
                onPressed: () {
                  if (!showOtpFields) {
                    // Generate OTP logic goes here
                    // Assuming generateOtp() is a function that returns OTP as String
                    // otp = generateOtp();
                    setState(() {
                      showOtpFields = true;
                      startCountdown();
                    });
                  } else {
                    // Verify OTP logic goes here
                    // Assuming verifyOtp() is a function that returns true if OTP is correct
                    bool isOtpCorrect = true;
                    if (isOtpCorrect) {
                      // Navigate to the next page
                    } else {
                      // Show error message
                    }
                  }
                },
                child: Text(
                  showOtpFields ? "Verify OTP" : "Generate OTP",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text("Need Help?"),
              SizedBox(
                height: 20,
              ),
              Text(
                "Please enter the phone number followed by country code",
                style: TextStyle(color: Colors.green),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildOtpTextField(String digit) {
    return Container(
      width: 50,
      height: 50,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.cyan),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        digit,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }

  void startCountdown() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (countdown > 0) {
          countdown--;
        } else {
          timer.cancel();
        }
      });
    });
  }
}
// class ScrollableList extends StatefulWidget {
//   @override
//   _ScrollableListState createState() => _ScrollableListState();
// }

// class _ScrollableListState extends State<ScrollableList> {
//   List<double> itemHeights = List.generate(5, (index) => 100.0);
//   int selectedIndex = -1;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Scrollable List'),
//       ),
//       body: Stack(
//         children: [
//           ListView.builder(
//             itemCount: itemHeights.length,
//             itemBuilder: (context, index) {
//               return GestureDetector(
//                 onTap: () {
//                   setState(() {
//                     selectedIndex = index;
//                     // Move the selected item to the top
//                     itemHeights =
//                         List.generate(5, (i) => i == index ? 150.0 : 100.0);
//                   });
//                 },
//                 child: AnimatedContainer(
//                   duration: Duration(milliseconds: 300),
//                   height: itemHeights[index],
//                   color: selectedIndex == index ? Colors.blue : Colors.transparent,
//                   child: ListTile(
//                     title: Text('Item ${index + 1}'),
//                   ),
//                 ),
//               );
//             },
//           ),
//           if (selectedIndex != -1)
//             Positioned(
//               bottom: 0,
//               left: 0,
//               right: 0,
//               child: Container(
//                 height: 200,
//                 color: Colors.grey,
//                 child: Center(
//                   child: Text(
//                     'Details for Item ${selectedIndex + 1}',
//                     style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                   ),
//                 ),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }

class ListtileForm extends StatefulWidget {
  ListtileForm({
    super.key,
    required this.title1,
    required this.title2,
    required this.title3,
    required this.title4,
    required this.title5,
    required this.title6,
    required this.trailing1,
    required this.trailing2,
    required this.trailing3,
    required this.trailing4,
    required this.trailing5,
    required this.trailing6,
  });

  String? title1;
  String? title2;
  String? title3;
  String? title4;
  String? title5;
  String? title6;

  IconButton? trailing1;
  IconButton? trailing2;
  IconButton? trailing3;
  IconButton? trailing4;
  IconButton? trailing5;
  IconButton? trailing6;

  @override
  _ListtileFormState createState() => _ListtileFormState();
}

class _ListtileFormState extends State<ListtileForm> {
  int selectedIndex = -1;
  List<double> itemHeights = List.generate(4, (index) => 50.0);
  String? _selectedItem;

  @override
  Widget build(BuildContext context) {
    print("Title 1: ${widget.title1}");
    print("Title 2: ${widget.title2}");
    print("Title 3: ${widget.title3}");
    print("Title 4: ${widget.title4}");

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      physics: AlwaysScrollableScrollPhysics(),
      child: SizedBox(
        height: 250.h,
        child: Row(
          children: [
            Icon(Icons.keyboard_arrow_up, size: 20),

            Expanded(
              child: ListView.separated(
                itemCount: 1,
                separatorBuilder: (context, index) {
                  return Divider(
                    thickness: 5,
                  );
                },
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            selectedIndex = 0;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: selectedIndex == 0
                                ? Color.fromRGBO(0, 0, 255, 0.2)
                                : null,
                            // استخدام null للعودة إلى اللون الافتراضي
                            border: Border.all(
                              color: AppColors.blackColor,
                              // يمكنك استبداله بلون آخر إذا كنت ترغب
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(
                              selectedIndex == 0 ? 35.0 : 20.0,
                            ),
                          ),
                          child: ListTile(
                            // contentPadding: EdgeInsets.symmetric(vertical: 5), // زيادة ارتفاع الحشو العمودي

                            title: Text(
                              widget.title1 ?? "",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              "From 2010",
                              style: TextStyle(fontSize: 11),
                            ),
                            leading: CircleAvatar(
                              radius: 30.0,
                              backgroundColor: Colors.transparent,
                              child: Image.asset(
                                "assets/images/bike.png",
                                scale: 6,
                              ),
                            ),
                            trailing: widget.trailing1 ?? Icon(Icons.abc),
                          ),
                        ),
                      ),
                      Divider(
                        thickness: 5,
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            selectedIndex = 1;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: selectedIndex == 1
                                ? Color.fromRGBO(0, 0, 255, 0.2)
                                : null,
                            // استخدام null للعودة إلى اللون الافتراضي
                            border: Border.all(
                              color: AppColors.blackColor,
                              // يمكنك استبداله بلون آخر إذا كنت ترغب
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(
                              selectedIndex == 1 ? 35.0 : 20.0,
                            ),
                          ),
                          child: ListTile(
                            title: Text(
                              widget.title2 ?? "",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              "From 2010",
                              style: TextStyle(fontSize: 11),
                            ),
                            leading: CircleAvatar(
                              radius: 30.0,
                              backgroundColor: Colors.transparent,
                              child: Image.asset(
                                "assets/images/car1.png",
                                scale: 3,
                              ),
                            ),
                            trailing: widget.trailing2 ?? Icon(Icons.abc),
                          ),
                        ),
                      ),
                      Divider(
                        thickness: 5,
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            selectedIndex = 2;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: selectedIndex == 2
                                ? Color.fromRGBO(0, 0, 255, 0.2)
                                : null,
                            // استخدام null للعودة إلى اللون الافتراضي
                            border: Border.all(
                              color: AppColors.blackColor,
                              // يمكنك استبداله بلون آخر إذا كنت ترغب
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(
                              selectedIndex == 2 ? 35.0 : 20.0,
                            ),
                          ),
                          child: ListTile(
                            title: Text(
                              widget.title3 ?? "",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              "Until 2010",
                              style: TextStyle(fontSize: 11),
                            ),
                            leading: CircleAvatar(
                              radius: 30.0,
                              backgroundColor: Colors.transparent,
                              child: Image.asset(
                                "assets/images/car1.png",
                                scale: 3,
                              ),
                            ),
                            trailing: widget.trailing3 ?? Icon(Icons.abc),
                          ),
                        ),
                      ),
                      Divider(
                        thickness: 5,
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            selectedIndex = 3;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: selectedIndex == 3
                                ? Color.fromRGBO(0, 0, 255, 0.2)
                                : null,
                            // استخدام null للعودة إلى اللون الافتراضي
                            border: Border.all(
                              color: AppColors.blackColor,
                              // يمكنك استبداله بلون آخر إذا كنت ترغب
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(
                              selectedIndex == 3 ? 35.0 : 20.0,
                            ),
                          ),
                          child: ListTile(
                            title: Text(
                              widget.title4 ?? "",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              "From 2010",
                              style: TextStyle(fontSize: 11),
                            ),
                            leading: CircleAvatar(
                              radius: 30.0,
                              backgroundColor: Colors.transparent,
                              child: Image.asset(
                                "assets/images/car1.png",
                                scale: 3,
                              ),
                            ),
                            trailing: widget.trailing3 ?? Icon(Icons.abc),
                          ),
                        ),
                      ),
                      Divider(
                        thickness: 5,
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            selectedIndex = 4;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: selectedIndex == 4
                                ? Color.fromRGBO(0, 0, 255, 0.2)
                                : null,
                            // استخدام null للعودة إلى اللون الافتراضي
                            border: Border.all(
                              color: AppColors.blackColor,
                              // يمكنك استبداله بلون آخر إذا كنت ترغب
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(
                              selectedIndex == 4 ? 35.0 : 20.0,
                            ),
                          ),
                          child: ListTile(
                            title: Text(
                              widget.title5 ?? "",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              "From 2015",
                              style: TextStyle(fontSize: 11),
                            ),
                            leading: CircleAvatar(
                              radius: 30.0,
                              backgroundColor: Colors.transparent,
                              child: Image.asset(
                                "assets/images/car1.png",
                                scale: 3,
                              ),
                            ),
                            trailing: widget.trailing3 ?? Icon(Icons.abc),
                          ),
                        ),
                      ),
                      Divider(
                        thickness: 5,
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            selectedIndex = 5;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: selectedIndex == 5
                                ? Color.fromRGBO(0, 0, 255, 0.2)
                                : null,
                            // استخدام null للعودة إلى اللون الافتراضي
                            border: Border.all(
                              color: AppColors.blackColor,
                              // يمكنك استبداله بلون آخر إذا كنت ترغب
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(
                              selectedIndex == 5 ? 35.0 : 20.0,
                            ),
                          ),
                          child: ListTile(
                            title: Text(
                              widget.title6 ?? "",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              "7 passengers",
                              style: TextStyle(fontSize: 11),
                            ),
                            leading: CircleAvatar(
                              radius: 30.0,
                              backgroundColor: Colors.transparent,
                              child: Image.asset(
                                "assets/images/car1.png",
                                scale: 3,
                              ),
                            ),
                            trailing: widget.trailing6 ?? Icon(Icons.abc),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            //                  Column(
            //                    children: [
            //                      Icon(Icons.keyboard_arrow_up, size: 25),
            //  Icon(Icons.keyboard_arrow_down, size: 25),
            //                    ],
            Icon(Icons.keyboard_arrow_down, size: 20),

            //                  ),
          ],
        ),
      ),
    );
  }
}

class PriceSelectionBottomSheet extends StatefulWidget {
  final int initialPrice;

  const PriceSelectionBottomSheet({super.key, required this.initialPrice});

  @override
  _PriceSelectionBottomSheetState createState() =>
      _PriceSelectionBottomSheetState();
}

class _PriceSelectionBottomSheetState extends State<PriceSelectionBottomSheet> {
  late int _currentPrice;
  int _discountCount = 0;
  bool _reachedDouble = false;

  @override
  void initState() {
    super.initState();
    _currentPrice = widget.initialPrice;
  }

  void _adjustPrice(bool increase) {
    setState(() {
      if (increase) {
        // زيادة السعر بنسبة 10% حتى يصل ضعف المبلغ الأصلي
        if (!_reachedDouble) {
          _currentPrice = (_currentPrice * 1.1).round();
          if (_currentPrice >= widget.initialPrice * 2) {
            _reachedDouble = true;
          }
        }
      } else {
        // تخفيض السعر بنسبة 10% مرة واحدة فقط
        if (_discountCount < 1) {
          _currentPrice = (_currentPrice * 0.9).round();
          _discountCount++;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        constraints: BoxConstraints(
          maxHeight: 300,
          minHeight: 200,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(27),
            topLeft: Radius.circular(27),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    _adjustPrice(false); // تقليل السعر
                  },
                  child: Text(
                    ' -',
                    style: TextStyle(fontSize: 35),
                  ),
                ),
                Text(
                  ' $_currentPrice EGP',
                  style: TextStyle(fontSize: 35),
                ),
                IconButton(
                  onPressed: () => _adjustPrice(true), // زيادة السعر
                  icon: Icon(Icons.add),
                ),
              ],
            ),
            Divider(
              height: 40,
              color: Colors.black,
              thickness: 1.0,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  if (_reachedDouble)
                    Text(
                      'You reached double the original amount',
                      style: TextStyle(fontSize: 15),
                    )
                  else if (_discountCount > 0)
                    Text(
                      'Discount available for you!',
                      style: TextStyle(fontSize: 15),
                    ),
                  SizedBox(
                    height: 30.h,
                  ),
                  CustomButton(
                    buttonColor: AppColors.primaryColor,
                    height: 50,
                    borderRadius: 18,
                    onTap: () {
                      // قم بتنفيذ الإجراء الذي يحتاج إلى القيام به عند الضغط على Done
                      // _commentFocusNode.unfocus();
                      Navigator.pop(context, _currentPrice);
                    },
                    text: 'Done',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// SizedBox(
//   height: 50.h,
//   child: Padding(
//     padding: EdgeInsets.symmetric(
//       horizontal: 2.w,
//     ),
//     child: MainTextFormField(
//       borderRadius: 18.r,
//       keyboardType: TextInputType.none,
//       onTap: () {
//         // DateButtomSheet(
//         //   minimumDate: DateTime(1965),
//         //   maximumDate: DateTime(2006),
//         // );
//       },
//       prefixIcon: DateButtomSheetNow(
//         minimumDate: DateTime.now(),
//         maximumDate: DateTime(2025),
//       ),
//       suffixIcon: Icon(
//         Icons.calendar_month_outlined,
//       ),
//       borderColor:
//           AppColors.primaryColor(context),
//       hintText: 'Travel Date',
//       fillColor:
//           AppColors.bgOfTextFieldColor(context),
//       controller: traveldate,
//       validator: (value) {
//         if (value!.isEmpty) {
//           return 'This field required';
//         } else if (value.isEmpty) {
//           return "This field is required";
//         }
//       },
//     ),
//   ),
// ),
// SizedBox(
//   height: 10.h,
// ),
// SizedBox(
//   height: 50.h,
//   child: Padding(
//     padding: EdgeInsets.symmetric(
//       horizontal: 2.w,
//     ),
//     child: MainTextFormField(
//       borderRadius: 18.r,
//       keyboardType: TextInputType.none,
//       onTap: () {
//         // DateButtomSheet(
//         //   minimumDate: DateTime(1965),
//         //   maximumDate: DateTime(2006),
//         // );
//       },
//       prefixIcon: TimePicker(),
//       suffixIcon: const Icon(
//         Icons.punch_clock_outlined,

//       ),
//       borderColor:
//           AppColors.primaryColor(context),
//       hintText: 'Travel Time',
//       fillColor:
//           AppColors.bgOfTextFieldColor(context),
//       controller: travelTime,
//       validator: (value) {
//         if (value!.isEmpty) {
//           return 'This field required';
//         } else if (value.isEmpty) {
//           return "This field is required";
//         }
//       },
//     ),
//   ),
// ),
