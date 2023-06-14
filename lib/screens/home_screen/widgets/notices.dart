import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mbl_am/models/news.dart';
import 'package:cached_network_image/cached_network_image.dart';

class NoticesTile extends StatefulWidget {
  const NoticesTile({super.key});

  @override
  State<NoticesTile> createState() => _NoticesTileState();
}

class _NoticesTileState extends State<NoticesTile> {
  List<News>? news;

  getNews() async {
    try{
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('news').orderBy('date', descending: true).limit(6).get();
      setState(() {
        news = querySnapshot.docs.map<News>((e) => News.fromDocumentSnapshot(e)).toList();
      });
    } catch(e){
      debugPrint('Sem notícias');
    }
  }

  @override
  void initState() {
    super.initState();
    getNews();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return news == null ? const Center(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Text('No momento não há notícias', style: TextStyle(color: Colors.white, fontSize: 20),),
      ),
    ):
    Center(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: screenWidth < 1200 ? 20 : 0),
        width: screenWidth < 1200 ? screenWidth : 1200,
        child: GridView.builder(
          itemCount: news!.length,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: screenWidth < 700 ? 1 : screenWidth < 900 ? 2 : screenWidth < 1200 ? 3 : 4,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 1.6,
          ),
          itemBuilder: (context, index){
            News notice = news![index];
            return noticiaBuild(notice, context);
          }
        ),
      ),
    );
  }
}

Widget noticiaBuild(News notice, BuildContext context){
  String dateFormat(String dateFormat, String time){
    return DateFormat(dateFormat, 'pt_BR').format(DateTime.parse(time));
  }

  return InkWell(
    onTap: (){
      /*FirebaseFirestore db =FirebaseFirestore.instance;
      News news = notice;
      news.date = Timestamp.now().toDate().toString();
      news.id = db.collection('news').doc().id;
      db.collection('news').doc(news.id).set(news.toMap()).then((value){
        debugPrint("Noticia re-upada");
      });*/
      context.go('/noticias/${notice.id}');
    },
    child: Container(
      decoration: BoxDecoration(
        image: DecorationImage(image: CachedNetworkImageProvider(notice.image, maxHeight: 500), fit: BoxFit.cover),
        borderRadius: BorderRadius.circular(10)
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Colors.black
              //Color.fromARGB(255, 33, 62, 165)
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(notice.category, style: const TextStyle(color: Colors.amberAccent, fontSize: 14, fontFamily: 'GothamBold', fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis,),
            Text(notice.title, style: const TextStyle(color: Colors.white, fontSize: 22, fontFamily: 'GothamBold', fontWeight: FontWeight.bold), maxLines: 2, overflow: TextOverflow.ellipsis,),
            Text("${dateFormat(DateFormat.YEAR_MONTH_DAY, notice.date)} às ${dateFormat(DateFormat.HOUR24_MINUTE, notice.date)}", style: const TextStyle(color: Colors.white, fontSize: 12, fontFamily: 'GothamBook',),),
          ],
        ),
      ),
    ),
  );
}