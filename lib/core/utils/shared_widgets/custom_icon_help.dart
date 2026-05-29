import 'package:flutter/material.dart';

import 'package:shakshak/core/resources/app_colors.dart';

class CustomIconHelp extends StatefulWidget {
  final String? title;
  final String? content;

  CustomIconHelp({Key? key, required this.title, required this.content})
      : super(key: key);

  @override
  State<CustomIconHelp> createState() => _CustomIconHelpState();
}

class _CustomIconHelpState extends State<CustomIconHelp> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () {},
          child: Tooltip(
            message: 'Click for details',
            child: Container(
              width: 5,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ),
        CircleAvatar(
          backgroundColor: AppColors.primaryColor,
          radius: 17, // نصف قطر الدائرة
          child: IconButton(
            onPressed: () {
              // عند النقر على الأيقونة، قم بعرض النص
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    title: Text(widget.title!),
                    content: IntrinsicWidth(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Text(widget.content!),
                          ],
                        ),
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text("Close"),
                      ),
                    ],
                  );
                },
              );
            },
            icon: Icon(
              Icons.question_mark,
              size: 17,
            ),
          ),
        ),
      ],
    );
  }
}
