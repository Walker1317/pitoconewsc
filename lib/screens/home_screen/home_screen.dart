import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mbl_am/screens/home_screen/widgets/about_session.dart';
import 'package:mbl_am/screens/home_screen/widgets/doacao_session.dart';
import 'package:mbl_am/screens/home_screen/widgets/notices.dart';
import 'package:mbl_am/screens/home_screen/widgets/youtube_session.dart';
import 'package:mbl_am/widgets/app_bar.dart';
import 'package:mbl_am/widgets/rodape.dart';
import 'package:mbl_am/widgets/widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ScrollController scrollController = ScrollController();
  final _aboutKey = GlobalKey();
  final _noticesKey = GlobalKey();
  final _apoieKey = GlobalKey();
  final _cadastreKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawerDragStartBehavior: DragStartBehavior.down,
      appBar: mblAppBar(context, onChanged: (value){
        debugPrint(value.toString());
        if(value == 0){
          Scrollable.ensureVisible(_aboutKey.currentContext!);
        } else if(value == 1){
          Scrollable.ensureVisible(_noticesKey.currentContext!);
        } else if(value == 2){
          Scrollable.ensureVisible(_apoieKey.currentContext!);
        } else if(value == 3){
          Scrollable.ensureVisible(_cadastreKey.currentContext!);
        }
      }, enabledMobile: true),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            /*Container(
              height: 600,
              color: Colors.black,
            ),*/
            AboutSession(key: _aboutKey,),
            const SizedBox(height: 60,),
            SessionDivider(key: _noticesKey, title: 'ÚTLIMAS NOTÍCIAS', subTitle: 'Fique por dentro das últimas notícias!'),
            const SizedBox(height: 40,),
            const NoticesTile(),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: InkWell(
                  onTap: (){
                    context.go('/noticias');
                  },
                  child: const Text('Ver todas')
                ),
              ),
            ),
            const SizedBox(height: 120,),
            DoacaoSession(key: _apoieKey,),
            const SessionDivider(title: 'ACOMPANHE MEU CONTEÚDO', subTitle: 'Ultímos vídeos postados, inscreva-e para não perder mais nenhuma informação.'),
            const YoutubeSession(),
            const SizedBox(height: 100,),
            Rodape(key: _cadastreKey,)
          ],
        ),
      ),
    );
  }
}