import 'package:flutter/material.dart';

class AboutSession extends StatelessWidget {
  const AboutSession({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return SizedBox(
      height: screenWidth < 800 ? 1800 : 750,
      child: screenWidth < 800?
      Column(
        children: [
          _textTile(screenWidth),
          _image(screenWidth)
        ],
      ):
      Row(
        children: [
          _textTile(screenWidth),
          _image(screenWidth)
        ],
      ),
    );
  }
}

Widget _image(double screenWidth){
  return Expanded(
    child: Container(
      color: const Color.fromARGB(255, 33, 62, 165),
    ),
  );
}

Widget _textTile(double screenWidth){
  return Expanded(
    child: Container(
      padding: EdgeInsets.fromLTRB(screenWidth / 9.5, 20, screenWidth < 800 ? screenWidth / 9.5 : 100, 20),
      alignment: Alignment.centerRight,
      height: 750,
      color: const Color(0xff142667),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 30,),
          const Text('Sobre o Site', style: TextStyle(fontSize: 40),),
          const SizedBox(height: 30,),
          _textSession(),
        ],
      ),
    ),
  );
}

Widget _textSession(){
  return const SelectableText(
    'Esse site foi fundado com um objetivo e com um método, o objetivo é explicar o Amazonas e de certo modo o norte do Brasil, o método para conseguir esse objetivo ambicioso será por meio do trabalho jornalístico, da pesquisa, da conversa, por meio das artes, do convívio…\n\nTodo tipo de experiência e estudo válidos para compreender a sociedade do maior estado do Brasil. É uma ambição muito grande, mas o fundador desse site acredita ser possível ter sucesso, acredita porque o período em que o Brasil passa é diferente das décadas ou até séculos passados, estamos cada vez mais idealistas, e apesar de cada recuo que temos na política, de cada decepção por parte do nossos governos, um após o outro, a esperança do povo brasileiro nunca esteve tão grande por mudança.\n\nPortanto, a criação desse site, vai aproveitar essa energia inesgotável da sociedade para poder crescer. Quanto mais pessoas se interam de política, quanto mais pessoas pretendem estudar sobre política, economia, a sociedade em que vivem, quanto mais pessoas quiserem ter voz para apontar os problemas e propostas da sua realidade, mais adubo e terra terá os canais de informação que transmitirem o que esse povo tem a dizer. A necessidade das pessoas de comunicarem o que é o seu mundo e o que sentem, é o que mantém vivo qualquer canal de informação de massas, quando as pessoas não quiserem mais se expressar, esses canais, TVs, jornais etc morrerão. Esse canal espera por sua vontade de se comunicar, e vai evoluir cada vez'
      ,style: TextStyle(fontWeight: FontWeight.w300, fontFamily: 'GothamBook'),
  );
}