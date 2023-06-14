import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore_ui/firestore_ui.dart';
import 'package:flutter/material.dart';
import 'package:mbl_am/models/news.dart';
import 'package:mbl_am/screens/home_screen/widgets/notices.dart';
import 'package:mbl_am/widgets/app_bar.dart';

class NoticiasScreen extends StatelessWidget {
  const NoticiasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: mblAppBar(context, onChanged: (value){}),
      body: Container(
        width: screenWidth,
        alignment: Alignment.topCenter,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: screenWidth < 1200 ? 20 : 0),
          width: screenWidth < 1200 ? screenWidth : 1200,
          child: FirestoreAnimatedGrid(
            query: FirebaseFirestore.instance.collection('news').orderBy('date', descending: true)
            .withConverter<News>(
            fromFirestore: (snapshot, _)=> News.fromDocumentSnapshot(snapshot),
            toFirestore: (value, options) => {},),
            crossAxisCount: screenWidth < 700 ? 1 : screenWidth < 900 ? 2 : screenWidth < 1200 ? 3 : 4,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 1.6,
            itemBuilder: (context, snapshot, animation, index) {
              dynamic news = snapshot!.data();
              return noticiaBuild(news, context);
            },
          ),
        ),
      ),
    );
  }
}