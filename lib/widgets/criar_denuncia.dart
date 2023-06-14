// ignore_for_file: avoid_web_libraries_in_flutter

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:ionicons/ionicons.dart';
import 'dart:html' as html;

import 'package:mbl_am/models/denuncia.dart';

class FazerDenuncia extends StatefulWidget {
  const FazerDenuncia({super.key});

  @override
  State<FazerDenuncia> createState() => _FazerDenunciaState();
}

class _FazerDenunciaState extends State<FazerDenuncia> {
  final TextEditingController controllerNome = TextEditingController();
  final TextEditingController controllerEmail = TextEditingController();
  final TextEditingController controllerContato = TextEditingController();
  final TextEditingController controllerMensagem = TextEditingController();
  final TextEditingController controllerImage = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  html.File? file;
  bool succes = false;
  bool loading = false;

  Future<String> uploadFile(html.File file, String path) async{
    String url = '';
    String fileName = Timestamp.now().millisecondsSinceEpoch.toString();
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference pastaRaiz = storage.ref();
    Reference arquivo = pastaRaiz.child("denuncias")
    .child("$path/$fileName.jpg");
    UploadTask task = arquivo.putBlob(file);
    await task.then((p0) async {
     url = await p0.ref.getDownloadURL();
    });
    debugPrint(url);
    return url;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Form(
      key: _formKey,
      child: Container(
        height: 800,
        width: screenWidth,
        decoration: const BoxDecoration(
          //image: DecorationImage(image: AssetImage(assetName))
        ),
        child: Container(
          width: screenWidth,
          height: 800,
          color: const Color.fromARGB(255, 33, 62, 165),
          child: Center(
            child: Container( 
              width: screenWidth < 800 ? screenWidth : 800,
              padding: EdgeInsets.symmetric(horizontal: screenWidth < 800 ? 20 : 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 40),
                    child: Text("FAÇA SUA DENÚNCIA", textAlign: TextAlign.center, style: TextStyle(fontSize: 40),),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: Colors.black26,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextFormField(
                      controller: controllerNome,
                      readOnly: loading,
                      style: const TextStyle(color: Colors.white, fontSize: 14, fontFamily: 'GothamBook'),
                      cursorColor: Colors.white,
                      decoration: InputDecoration(
                        labelText: 'Digite seu nome',
                        labelStyle: const TextStyle(color: Colors.white, fontSize: 14, fontFamily: 'GothamBook'),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.white60, width: 2),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.white60, width: 2),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.redAccent[700]!, width: 2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.white, width: 2)
                        ),
                      ),
                      validator: (text){
                        if(text!.isEmpty){
                          return 'Digite seu nome';
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: Colors.black26,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextFormField(
                      controller: controllerEmail,
                      readOnly: loading,
                      style: const TextStyle(color: Colors.white, fontSize: 14, fontFamily: 'GothamBook'),
                      cursorColor: Colors.white,
                      decoration: InputDecoration(
                        labelText: 'Digite seu E-mail',
                        labelStyle: const TextStyle(color: Colors.white, fontSize: 14, fontFamily: 'GothamBook'),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.white60, width: 2),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.white60, width: 2),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.redAccent[700]!, width: 2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.white, width: 2)
                        ),
                      ),
                      validator: (text){
                        if(!text!.contains("@")){
                          return 'E-mail inválido';
                        } else if(!text.contains(".")){
                          return 'E-mail inválido';
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: Colors.black26,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextFormField(
                      controller: controllerContato,
                      readOnly: loading,
                      style: const TextStyle(color: Colors.white, fontSize: 14, fontFamily: 'GothamBook'),
                      cursorColor: Colors.white,
                      decoration: InputDecoration(
                        labelText: 'Seu Contato (ddd + telefone)',
                        labelStyle: const TextStyle(color: Colors.white, fontSize: 14, fontFamily: 'GothamBook'),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.white60, width: 2),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.white60, width: 2),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.redAccent[700]!, width: 2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.white, width: 2)
                        ),
                      ),
                      validator: (text){
                        if(text!.isEmpty){
                          return 'Digite sua mensagem';
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: Colors.black26,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextFormField(
                      controller: controllerMensagem,
                      readOnly: loading,
                      maxLines: 6,
                      style: const TextStyle(color: Colors.white, fontSize: 14, fontFamily: 'GothamBook'),
                      cursorColor: Colors.white,
                      decoration: InputDecoration(
                        labelText: 'Digite sua mensagem...',
                        labelStyle: const TextStyle(color: Colors.white, fontSize: 14, fontFamily: 'GothamBook'),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.white60, width: 2),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.white60, width: 2),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.redAccent[700]!, width: 2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.white, width: 2)
                        ),
                      ),
                      validator: (text){
                        if(text!.isEmpty){
                          return 'Digite sua mensagem';
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),
                  textFormFielMbl(controllerImage, 'Enviar conteúdo (Clique para selecionar)', readOnly: true,
                  suffixIcon: IconButton(onPressed: (){
                    setState(() {
                      file = null;
                      controllerImage.clear();
                    });
                  }, icon: const Icon(Ionicons.close_outline)),
                  onTap: () async {
                    var mediaData = await ImagePickerWeb.getImageAsFile();
                    if(mediaData != null){
                      setState(() {
                        file = mediaData;
                        controllerImage.text = file!.name;
                      });
                    }
                  }),
                  SizedBox(
                    height: 60,
                    child: ElevatedButton(
                      onPressed: loading ? null : () async {
                        if(_formKey.currentState!.validate()){
                          setState(() {
                            loading = true;
                          });
                          Denuncia denuncia = Denuncia.gerarId();
                          denuncia.date = Timestamp.now().toDate().toString();
                          denuncia.name = controllerNome.text;
                          denuncia.email = controllerEmail.text;
                          denuncia.phone = controllerContato.text;
                          denuncia.message = controllerMensagem.text;
                          if(file != null){
                            denuncia.image = await uploadFile(file!, 'denuncias');
                          }
                          FirebaseFirestore.instance.collection('denuncias').doc(denuncia.id).set(denuncia.toMap())
                          .then((value){
                            setState(() {
                              loading = false;
                              succes = true;
                              controllerNome.clear();
                              controllerEmail.clear();
                              controllerContato.clear();
                              controllerMensagem.clear();
                              controllerImage.clear();
                            });
                          }).catchError((e){
                            setState(() {
                              loading = false;
                            });
                          });
                        }
                      },
                      child: loading ? const Center(child: CircularProgressIndicator(),) : const Text("Enviar", style: TextStyle(color: Colors.black, fontSize: 20),)
                    ),
                  ),
                  succes ?
                  const Padding(
                    padding: EdgeInsets.only(top: 30),
                    child: Text('Sua denúncia foi enviada, obrigado pela contribuição!', style: TextStyle(fontFamily: 'GothamBook'), textAlign: TextAlign.center,),
                  ):
                  Container(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget textFormFielMbl(TextEditingController? controller, String? labelText, {
    int? maxLines, bool? readOnly, Function()? onTap, String? Function(String?)? validator,
    Widget? suffixIcon,
  }){
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextFormField(
        onTap: onTap ?? (){},
        validator: validator ?? (text){return null;},
        controller: controller,
        maxLines: maxLines ?? 1,
        readOnly: readOnly ?? false,
        style: const TextStyle(color: Colors.white, fontSize: 14, fontFamily: 'GothamBook'),
        cursorColor: Colors.white,
        decoration: InputDecoration(
          suffix: suffixIcon ?? Container(),
          labelText: labelText,
          labelStyle: const TextStyle(color: Colors.white, fontSize: 14, fontFamily: 'GothamBook'),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.white60, width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.white60, width: 2),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.redAccent[700]!, width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.white, width: 2)
          ),
        ),
      ),
    );
  }

}