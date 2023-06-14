// ignore_for_file: duplicate_import, depend_on_referenced_packages

import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:flutter/foundation.dart';
//import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
//import 'package:fwfh_webview/fwfh_webview.dart';
//import 'package:pointer_interceptor/pointer_interceptor.dart';
//import 'package:youtube_api/youtube_api.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
//import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
//import 'package:fwfh_webview/fwfh_webview.dart';

class YoutubeSession extends StatefulWidget {
  const YoutubeSession({super.key});

  @override
  State<YoutubeSession> createState() => _YoutubeSessionState();
}

class _YoutubeSessionState extends State<YoutubeSession> {
  List<dynamic> videoUrls = [];
  /*static String key = 'AIzaSyCmbeWIeIxbm61Y0GqM-ob5Pegn1kwikgs';
  YoutubeAPI ytApi = YoutubeAPI(key);
  List<YouTubeVideo> videoResult = [];*/

  /*getVideos() async {
    //String query = "dragonforce";
    videoResult = await ytApi.channel('UCIUA7-MNA9NyrpimQo7Dw8g');// search(query,);
    setState(() {
      videoResult;
    });
  }*/

  getVideos() async {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection('config').doc('youtube').get();
    setState(() {
      videoUrls = documentSnapshot['videos'].reversed.toList();
      if(videoUrls.length > 10){
        videoUrls = videoUrls.sublist(0, 10);
      }
    });
  }
  
  @override
  void initState() {
    super.initState();
    getVideos();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Center(
      child: Container(
        margin: const EdgeInsets.only(top: 60),
        padding: EdgeInsets.symmetric(horizontal: screenWidth < 900 ? 30 :0),
        width: screenWidth < 1200 ? screenWidth : 1200,
        child: GridView.builder(
          itemCount: videoUrls.length,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          padding: const EdgeInsets.only(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: screenWidth < 900 ? 1 : 2,
            childAspectRatio: 1.8,
            mainAxisSpacing: 20,
            crossAxisSpacing: 20
          ),
          /*children: [
            SimpleHtmlYoutubeIframe(youtubeCode: YoutubePlayerController.convertUrlToId('https://www.youtube.com/watch?v=qyc07COpZDQ&list=RD_wSt2C0CieE&index=2&ab_channel=LITkillah')!,),
            SimpleHtmlYoutubeIframe(youtubeCode: YoutubePlayerController.convertUrlToId('https://www.youtube.com/watch?v=9l8AfJ7EVTs')!,),
            SimpleHtmlYoutubeIframe(youtubeCode: YoutubePlayerController.convertUrlToId('https://www.youtube.com/watch?v=rnwMoDQ5_dE')!,),
            SimpleHtmlYoutubeIframe(youtubeCode: YoutubePlayerController.convertUrlToId('https://www.youtube.com/watch?v=QWKpeRsVpIg')!,),
            SimpleHtmlYoutubeIframe(youtubeCode: YoutubePlayerController.convertUrlToId('https://www.youtube.com/watch?v=5d2TUXgs1vs')!,),
            SimpleHtmlYoutubeIframe(youtubeCode: YoutubePlayerController.convertUrlToId('https://www.youtube.com/watch?v=pzOpP6FqYuA')!,),
            SimpleHtmlYoutubeIframe(youtubeCode: YoutubePlayerController.convertUrlToId('https://www.youtube.com/watch?v=82psX8vESbo')!,),
            /*VideoObject(youtubeUrl: 'https://www.youtube.com/watch?v=1bYkaZJRrwo&ab_channel=DanielPenin'),
            VideoObject(youtubeUrl: 'https://www.youtube.com/watch?v=9l8AfJ7EVTs'),
            VideoObject(youtubeUrl: 'https://www.youtube.com/watch?v=rnwMoDQ5_dE'),
            VideoObject(youtubeUrl: 'https://www.youtube.com/watch?v=QWKpeRsVpIg'),
            VideoObject(youtubeUrl: 'https://www.youtube.com/watch?v=5d2TUXgs1vs'),
            VideoObject(youtubeUrl: 'https://www.youtube.com/watch?v=pzOpP6FqYuA'),
            VideoObject(youtubeUrl: 'https://www.youtube.com/watch?v=82psX8vESbo'),*/
          ],*/
          itemBuilder: (context, index){
            return /*VideoObject(youtubeUrl: video.url);*/
            //SimpleHtmlYoutubeIframe(youtubeCode: YoutubePlayerController.convertUrlToId(videoUrls[index])!);
            HtmlWidget('''
              <div style="pointer-events: none;">
                <iframe src="https://www.youtube.com/embed/${YoutubePlayerController.convertUrlToId(videoUrls[index])!}"></iframe>
              </div>
            ''');
          },
        ),
      ),
    );
  }
}

/*class SimpleHtmlYoutubeIframe extends StatelessWidget { 
  final String youtubeCode;

  const SimpleHtmlYoutubeIframe( {
    super.key,
    required this.youtubeCode,
    //required super.key,
  });

  @override
  Widget build(BuildContext context) { 
    String content =
        '<iframe src="https://www.youtube.com/embed/$youtubeCode"></iframe>';

    return Stack(
      children: [
        SizedBox(
          //height: webViewModel.webViewHeight ?? 300,
          // width: width,
          child: HtmlWidget(
            content,
            factoryBuilder: () => _YoutubeIframeWidgetFactory(),
          ),
        ),
        PointerInterceptor(
          child: SizedBox(
            //height: webViewModel.webViewHeight ?? 300,
            width: MediaQuery.of(context).size.width,
          )
        )
      ],
    );
  }
}*/
 
/*class _YoutubeIframeWidgetFactory extends WidgetFactory with WebViewFactory {
  @override
  bool get webViewMediaPlaybackAlwaysAllow => true;
  @override
  String? get webViewUserAgent => 'Lang Learning';
}

class VideoObject extends StatefulWidget {
  const VideoObject({super.key, required this.youtubeUrl});
  final String youtubeUrl;

  @override
  State<VideoObject> createState() => _VideoObjectState();
}

class _VideoObjectState extends State<VideoObject> {

  YoutubePlayerController? controller;
  PlayerState? playerState;

  @override
  void initState() {
    super.initState();
    controller = YoutubePlayerController.fromVideoId(
      videoId: YoutubePlayerController.convertUrlToId(widget.youtubeUrl)!,
      autoPlay: false,
      params: const YoutubePlayerParams(
        showFullscreenButton: false,
        mute: false,
        showControls: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 720,
      width: 1280,
      child: YoutubePlayer(
        gestureRecognizers: const <Factory<OneSequenceGestureRecognizer>>{},
        controller: controller!,
        aspectRatio: 16 / 9,
        enableFullScreenOnVerticalDrag: false,
      ),
    );
  }
}*/