// ignore_for_file: avoid_web_libraries_in_flutter

import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:mbl_am/widgets/cadastro.dart';
import 'package:mbl_am/widgets/criar_denuncia.dart';
import 'dart:js' as js;

class Rodape extends StatelessWidget {
  const Rodape({this.key});
  final GlobalKey? key;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Column(
        children: [
          const FazerDenuncia(),
          const SizedBox(height: 40,),
          const Text('PARTICIPE DO PITOCO NEWS NO WHATSAPP', style: TextStyle(fontSize: 20), textAlign: TextAlign.center,),
          const SizedBox(height: 40,),
          SizedBox(
            height: 60,
            width: 300,
            child: ElevatedButton(
              onPressed: (){
                js.context.callMethod('open', ['https://chat.whatsapp.com/Ll3JwLJpqGzAKKmsmRtxe1']);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.greenAccent[700],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(200)
                )
              ),
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Icon(Ionicons.logo_whatsapp, color: Colors.white, size: 40,),
                  SizedBox(width: 20,),
                  Center(child: Text("Entrar para Grupo", style: TextStyle(color: Colors.white, fontSize: 20), textAlign: TextAlign.center,))
                ],
              )
            ),
          ),
          const SizedBox(height: 60,),
          CadastroSession(key: key!,),
          Image.asset('images/pitoco.png', height: 200,),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
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
          ),
        ],
      ),
    );
  }
}