// ignore_for_file: avoid_web_libraries_in_flutter

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'dart:js' as js;

PreferredSizeWidget mblAppBar(BuildContext context, {ValueChanged<int>? onChanged, bool enabledMobile = false,}){
  double screenWidth = MediaQuery.of(context).size.width;
  debugPrint(screenWidth.toString());
  return AppBar(
    title: SizedBox(
      width: screenWidth / 1.28,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: (){
              context.go('/');
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset('images/pitoco.png', height: 40,),
                const SizedBox(width: 20,),
                const Text('Pitoco News', style: TextStyle(fontSize: 30),)
              ],
            )
          ),
          SizedBox(width: screenWidth < 1100 ? 10 : screenWidth / 10),
          screenWidth < 720 ? const SizedBox():
          SizedBox(
            width: screenWidth < 1100 ? screenWidth / 2 : screenWidth / 3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  child: const Text('Quem somos'),
                  onTap: (){
                    onChanged!.call(0);
                  },
                ),
                InkWell(
                  child: const Text('Notícias'),
                  onTap: (){
                    onChanged!.call(1);
                  },
                ),
                InkWell(
                  child: const Text('Apoie'),
                  onTap: (){
                    onChanged!.call(2);
                  },
                ),
                InkWell(
                  child: const Text('Cadastre-se'),
                  onTap: (){
                    onChanged!.call(3);
                  },
                ),
              ],
            ),
          ),
          const SizedBox(width: 10,),
          screenWidth < 830 ?
          enabledMobile ?
          PopupMenuButton<int>(
            initialValue: 0,
            onSelected: (int item) {
              onChanged!.call(item);
            },
            color: Colors.grey[900],
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
              PopupMenuItem<int>(
                value: 0,
                onTap: (){},
                child: const Text('Quem somos', style: TextStyle(color: Colors.white),),
              ),
              PopupMenuItem<int>(
                value: 1,
                onTap: (){},
                child: const Text('Notícias', style: TextStyle(color: Colors.white),),
              ),
              PopupMenuItem<int>(
                value: 2,
                onTap: (){},
                child: const Text('Apoie', style: TextStyle(color: Colors.white),),
              ),
              PopupMenuItem<int>(
                value: 3,
                onTap: (){},
                child: const Text('Cadastre-se', style: TextStyle(color: Colors.white),),
              ),
            ],
            child: const Icon(Icons.menu),
          ): Container() :
          Row(
            children: [
              InkWell(
                onTap: (){
                  js.context.callMethod('open', ['https://www.youtube.com/@gabrielpitoco560']);
                },
                child: const Icon(Ionicons.logo_youtube),
              ),
              const SizedBox(width: 20,),
              InkWell(
                onTap: (){
                  js.context.callMethod('open', ['https://www.facebook.com/profile.php?id=100093174368044']);
                },
                child: const Icon(Ionicons.logo_facebook),
              ),
              const SizedBox(width: 20,),
              InkWell(
                onTap: (){
                  js.context.callMethod('open', ['https://discord.com/invite/yyM3eRmpnQ']);
                },
                child: const Icon(Ionicons.logo_discord),
              ),
            ],
          ),
        ],
      ),
    ),
    centerTitle: true,
    bottom: PreferredSize(
      preferredSize: Size(screenWidth, 2),
      child: Container(width: screenWidth, height: 2, color: Colors.grey[800],),
    ),
  );
}