import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mbl_am/models/news.dart';
import 'package:mbl_am/widgets/app_bar.dart';
import 'package:mbl_am/widgets/rodape.dart';
import 'package:seo_renderer/seo_renderer.dart';

class NewsDetails extends StatefulWidget {
  const NewsDetails({super.key, required this.newsData});
  final String newsData;

  @override
  State<NewsDetails> createState() => _NewsDetailsState();
}

class _NewsDetailsState extends State<NewsDetails> {
  News? news;
  bool error = false;
  final _key = GlobalKey();

  _getNews() async {
    try{
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection('news').doc(widget.newsData).get();
      setState(() {
        news = News.fromDocumentSnapshot(documentSnapshot);
      });
    } catch (e){
      setState(() {
        error = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getNews();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    String dateFormat(String dateFormat, String time){
      return DateFormat(dateFormat, 'pt_BR').format(DateTime.parse(time));
    }
    return Scaffold(
      appBar: mblAppBar(context),
      body: SingleChildScrollView(
        child: error ?
        Center(child: Text('Não encontramos a notícia', style: TextStyle(color: Colors.redAccent[700]),),):
        news == null ? const Center(child: CircularProgressIndicator(),):
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: screenWidth,
              decoration: BoxDecoration(
                image: DecorationImage(image: CachedNetworkImageProvider(news!.image, maxHeight: 500), fit: BoxFit.cover),
              ),
              height: 400,
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black87
                      //Color.fromARGB(255, 33, 62, 165)
                    ],
                  ),
                ),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    width: screenWidth < 1000 ? screenWidth : 1000,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextRenderer(text: news!.category, child: SelectableText(news!.category, style: const TextStyle(color: Colors.amberAccent, fontSize: 26, fontFamily: 'GothamBold', fontWeight: FontWeight.bold), maxLines: 1,)),
                        TextRenderer(text: news!.title, child: SelectableText(news!.title, style: const TextStyle(color: Colors.white, fontSize: 48, fontFamily: 'GothamBold', fontWeight: FontWeight.bold), maxLines: 1,)),
                        SelectableText("${dateFormat(DateFormat.YEAR_MONTH_DAY, news!.date)} às ${dateFormat(DateFormat.HOUR24_MINUTE, news!.date)}", style: const TextStyle(color: Colors.white, fontFamily: 'GothamBook',),),
                        const SizedBox(height: 20,)
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Center(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: screenWidth < 1500 ? 20 : 0),
                width: screenWidth < 1000 ? screenWidth : 1000,
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: news!.elements.length,
                  itemBuilder: (context, index) {
                    dynamic element = news!.elements[index];
                    switch (element['type']) {
                      case 'title':
                        return titleSession(element['content']);
                      case 'paragraph':
                        return paragrahSession(element['content']);
                      case 'file':
                        return imageSession(element['content']);
                      default:
                    }
                    return Container();
                  }
                ),
              ),
            ),
            const SizedBox(height: 100,),
            Divider(color: Colors.grey[800],),
            Rodape(key: _key,)
          ],
        ),
      ),
    );
  }

  Widget titleSession(String title){
    return Padding(
      padding: const EdgeInsets.only(top: 40, bottom: 30),
      child: TextRenderer(text: title, child: SelectableText(title, style: const TextStyle(fontSize: 42),)),
    );
  }

  Widget paragrahSession(String paragraph){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: TextRenderer(
        text: paragraph,
        child: SelectableText(paragraph, style: const TextStyle(fontFamily: 'GothamBook'),)
      ),
    );
  }

  Widget imageSession(String url){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: CachedNetworkImage(
        imageUrl: url,
      ),
    );
  }

}