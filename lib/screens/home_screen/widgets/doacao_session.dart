// ignore_for_file: avoid_web_libraries_in_flutter

import 'package:flutter/material.dart';
import 'dart:js' as js;

class DoacaoSession extends StatelessWidget {
  const DoacaoSession({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    Widget text(){
      return const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('APOIE O MOVIMENTO!', style: TextStyle(fontSize: 40),),
          SizedBox(height: 30,),
          Text(
            'Com o objetivo de auxiliar projetos sociais em Manaus, optamos por ampliar e acolher a generosa contribuição de todos que desejam participar na concretização de ideias e ações, fortalecendo o apoio em defesa dos trabalhadores e dos mais necessitados. Acreditamos firmemente que podemos melhorar a realidade dessas pessoas. Junte-se a nós e faça sua doação!',
            style: TextStyle(fontFamily: 'GothamBook'),
          ),
        ],
      );
    }

    Widget button(){
      return SizedBox(
        height: 60,
        width: 200,
        child: ElevatedButton(
          onPressed: (){
            js.context.callMethod('open', ['https://nubank.com.br/pagar/v591i/i6X4CfA3LV']);
          },
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.pix),
              SizedBox(width: 10,),
              Text('FAZER DOAÇÃO PIX'),
            ],
          )
        ),
      );
    }
    return Center(
      child: Column(
        children: [
          SizedBox(height: screenWidth < 1200 ? 40 : 40),
          Container(
            padding: EdgeInsets.symmetric(horizontal: screenWidth < 1200 ? 20 : 0),
            width: screenWidth < 1200 ? screenWidth : 1200,
            child: screenWidth < 1200 ?
            SizedBox(
              height: 500,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  text(),
                  const SizedBox(height: 30,),
                  button(),
                ],
              ),
            ):
            Row(
              children: [
                Expanded(child: text()),
                const SizedBox(width: 40,),
                Expanded(child: button()),
              ],
            ),
          ),
          SizedBox(height: screenWidth < 1200 ? 40 : 120),
        ],
      ),
    );
  }
}