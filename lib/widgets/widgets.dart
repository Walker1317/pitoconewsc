
import 'package:flutter/material.dart';

class SessionDivider extends StatelessWidget {
  const SessionDivider({super.key, required this.title, required this.subTitle});
  final String title;
  final String? subTitle;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 40, horizontal: screenWidth < 1200 ? 20 : 0),
        width: screenWidth < 1200 ? screenWidth : 1200,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 32),),
            subTitle == null ? Container():
            Text(subTitle!, style: const TextStyle(fontFamily: 'GothamBook'),),
          ],
        ),
      ),
    );
  }
}