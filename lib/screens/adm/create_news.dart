// ignore_for_file: deprecated_member_use, avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:cloud_functions_platform_interface/src/https_callable_options.dart';
//import 'package:cloud_functions_web/cloud_functions_web.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:mbl_am/models/news.dart';
import 'package:mbl_am/models/user.dart';
import 'package:mbl_am/widgets/app_bar.dart';
import 'dart:async';

import 'package:mbl_am/widgets/error_tile.dart';

class CreateNews extends StatefulWidget {
  const CreateNews({super.key});

  @override
  State<CreateNews> createState() => _CreateNewsState();
}

class _CreateNewsState extends State<CreateNews> {
  List<Map<String, dynamic>> contents = [];
  html.File? image;
  String? error;
  bool loading = false;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController controllerTitle = TextEditingController();
  final TextEditingController controllerCategory = TextEditingController();
  
  Map<String, dynamic> content({required String type, String contentC = '', html.File? file,}){
    return {
      'type' : type,
      'content' : contentC,
      'textEditingController' : TextEditingController(),
      'image' : file,
    };
  }

  Future<String> uploadFile(html.File file, String path) async{
    String url = '';
    String fileName = Timestamp.now().millisecondsSinceEpoch.toString();
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference pastaRaiz = storage.ref();
    Reference arquivo = pastaRaiz.child("news")
    .child("$path/$fileName.jpg");
    UploadTask task = arquivo.putBlob(file);
    await task.then((p0) async {
     url = await p0.ref.getDownloadURL();
    });
    debugPrint(url);
    return url;
  }

  Future uploadNews() async {
    setState(() {
      loading = true;
    });
    News news = News.gerarId();
    String imageUrl = '';
    try{
      imageUrl = await uploadFile(image!, news.id!);
      for(int i = 0; i < contents.length; i++) {
        Map<String, dynamic> content = contents[i];
        if(content['type'] == 'file'){
          String url = await uploadFile(content['image'], news.id!);
          content.update('content', (value) => url);
          contents.removeAt(i);
          contents.insert(i, content);
        }
      }
    } catch (e){
      debugPrint("ERRO: $e");
      setState(() {
        loading = false;
        error = e.toString();
      });
    }

    List<Map<String, dynamic>> finalContents = contents.map((e) => {'type' : e['type'], 'content' : e['type'] != "file" ? e['textEditingController'].text : e['content']}).toList();
    news.title = controllerTitle.text;
    news.category = controllerCategory.text;
    news.date = Timestamp.now().toDate().toString();
    news.image = imageUrl;
    news.elements = finalContents;

    FirebaseFirestore.instance.collection('news').doc(news.id).set(news.toMap()).then((value) async {
      sendEmails('Nova notícia: ${controllerTitle.text}', contents.where((element) => element['type'] != "file")
      .map<String>((e) => '${e['textEditingController'].text}\n\n')
      .toList().toString().replaceAll('[', '').replaceAll(']', ''));
      setState(() {
        loading = false;
        controllerCategory.clear();
        controllerTitle.clear();
        image = null;
        contents = [];
      });
    }).catchError((e){
      setState(() {
        loading = false;
        error = e.toString();
      });
    });

  }

  

  /*Future<void> sendEmails(List<String> recipients, String subject, String body) async {
    final functions = FirebaseFunctionsWeb.instance.delegateFor(region: 'southamerica-east1');
    final sendEmailsCallable = functions.httpsCallable('https://pitoconews.co', 'sendEmails', HttpsCallableOptions());

    try {
      await sendEmailsCallable.call({
        'recipients': recipients,
        'subject': subject,
        'body': body,
      });
      debugPrint('Emails sent successfully');
    } catch (e) {
      debugPrint('Failed to send emails: $e');
    }


  }*/

  sendEmails(String subject, String emailBody) async {
    QuerySnapshot query = await FirebaseFirestore.instance.collection('users').get();
    for(var i = 0; i < query.docs.length; i++){
      Usuario usuario = Usuario.fromDocumentSnapshot(query.docs[i]);
      await sendEmail(usuario.email!, subject, emailBody);
    }
  }

  Future sendEmail(String sendEmailTo, String subject, String emailBody) async {
    await FirebaseFirestore.instance.collection('mail').add({
      'to' : sendEmailTo,
      'message': {
        'subject': subject,
        'text': emailBody
      }
    }).then((value){
      debugPrint("Queued email for delivery");
    });
  }
/*
  Future sendEmail(String subjectS, String contentS) async{
   QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('users').get();
   List<String> emails = querySnapshot.docs.map<String>((e) => e['email']).toList();
   /*for(int i = 0; i < emails.length; i++){
    debugPrint(emails[i]);
   }*/

  sendEmails(emails, subjectS, contentS);

    /*final mailer = Mailer('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');
    const fromAddress = Address('pitoconewsc@gmail.com');
    final content = Content('text/plain', contentS);
    final subject = subjectS;
    final personalization = Personalization(emails);

    final email =
        Email([personalization], fromAddress, subject, content: [content]);
    await mailer.send(email).then((result) {
      debugPrint('EMAILS ENVIADOS');
    });*/
  }*/

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: mblAppBar(context),
      body: FirebaseAuth.instance.currentUser == null?
      const Center(child: Text('Você não tem permissão para isso'),):
      Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: screenWidth < 800 ? 10 : 0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40,),
              Center(
                child: SizedBox(
                  width: screenWidth < 800 ? screenWidth : 800,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      error == null ?
                      Container():
                      errorTile(error!),
                      const Text('Detalhes da notícia', style: TextStyle(fontSize: 20),),
                      const Text('Digite abaixo os detalhes da notícia.', style: TextStyle(fontWeight: FontWeight.w300, fontSize: 12),),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Divider(),
                      ),
                      image == null ? Container():
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Text(image!.name)//Align(alignment: Alignment.centerLeft, child: Image.memory(image!., height: 100,)),
                      ),
                      FormField<html.File>(
                        initialValue: image,
                        validator: (value){
                          if(image == null){
                            return 'Escolha uma imagem de capa';
                          } else {
                            return null;
                          }
                        },
                        builder: (form){
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 300,
                                child: ElevatedButton(
                                  onPressed: loading ? null :  () async{
                                    var currentImage = await ImagePickerWeb.getImageAsFile();
                                    if(currentImage != null){
                                      setState(() {
                                        image = currentImage;
                                      });
                                    }
                                  },
                                  child: const Text('Escolher imagem de capa')
                                ),
                              ),
                              !form.hasError ? Container() :
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Text(form.errorText!, style: TextStyle(color: Colors.redAccent[700]),),
                              )
                            ],
                          );
                        }
                      ),
                      const SizedBox(height: 20,),
                      TextFormField(
                        readOnly: loading,
                        controller: controllerTitle,
                        validator: (text){
                          if(text!.isEmpty){
                            return 'Digite o título da notícia.';
                          } else {
                            return null;
                          }
                        },
                        decoration: const InputDecoration(
                          labelText: 'Título',
                        ),
                        cursorColor: Colors.white,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w300),
                      ),
                      const SizedBox(height: 10,),
                      TextFormField(
                        readOnly: loading,
                        controller: controllerCategory,
                        validator: (text){
                          if(text!.isEmpty){
                            return 'Digite a categoría da notícia.';
                          } else {
                            return null;
                          }
                        },
                        decoration: const InputDecoration(
                          labelText: 'Categoria',
                        ),
                        cursorColor: Colors.white,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w300),
                      ),
                      const SizedBox(height: 50,),
                      const Text('Elementos da notícia', style: TextStyle(fontSize: 20),),
                      const Text('Adicione abaixo os tópicos que deseja e personalize-os.', style: TextStyle(fontWeight: FontWeight.w300, fontSize: 12),),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Divider(),
                      ),
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: contents.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index){
                          Map<String, dynamic> content = contents[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Flexible(child: sessionManagement(content)),
                                IconButton(
                                  onPressed: (){
                                    setState(() {
                                      contents.removeAt(index);
                                    });
                                  },
                                  icon: const Icon(Icons.close, color: Colors.white,)
                                ),
                              ],
                            ),
                          );
                        }
                      ),
                      const SizedBox(height: 20,),
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 33, 62, 165).withOpacity(0.2),
                          border: Border.all(
                            width: 2,
                            color: const Color.fromARGB(255, 33, 62, 165),
                          )
                        ),
                        child: Column(
                          children: [
                            const Text('Adicionar Sessão',),
                            const SizedBox(height: 20,),
                            Row(
                              children: [
                                addButton(onPressed: (){
                                  setState(() {
                                    contents.add(content(type: 'title',));
                                  });
                                }, icon: Icons.add, title: "Título"),
                                const SizedBox(width: 10,),
                                addButton(onPressed: (){
                                  setState(() {
                                    contents.add(content(type: 'paragraph',));
                                  });
                                }, icon: Icons.add, title: "Descrição"),
                                const SizedBox(width: 10,),
                                addButton(onPressed: () async {
                                  var mediaData = await ImagePickerWeb.getImageAsFile();
                                  if(mediaData != null){
                                    setState(() {
                                      contents.add(content(type: 'file', file: mediaData));
                                    });
                                  }
                                }, icon: Icons.add, title: "Anexo"),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Divider(),
                      ),
                      SizedBox(
                        height: 50,
                        child: ElevatedButton(
                          onPressed: loading ? null : (){
                            if(_formKey.currentState!.validate()){
                              uploadNews(); 
                            }
                          },
                          child: loading ? const CircularProgressIndicator() : const Text('Criar notícia')
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget addButton({required Function()? onPressed, required IconData icon, required String title}){
    return Flexible(
      child: ElevatedButton(
        onPressed: loading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(0)
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon),
            const SizedBox(width: 5,),
            Flexible(child: Text(title,)),
          ],
        )
      ),
    );
  }

  Widget sessionManagement(Map<String, dynamic> content){
    switch (content['type']){
      case 'paragraph':
        return descriptionForm(content['textEditingController']);
      case 'title':
        return titleForm(content['textEditingController']);
      case 'file':
        return fileForm(content['image']);
      default:
        return Container();
    }
  }

  Widget titleForm(TextEditingController textEditingController){
    return TextFormField(
      readOnly: loading,
      controller: textEditingController,
      decoration: const InputDecoration(
        labelText: 'Título',
      ),
      cursorColor: Colors.white,
      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w300),
    );
  }

  Widget fileForm(html.File image){
    return Text('Imagem Selecionada: ${image.name}');//Image.memory(image.);
  }

  Widget descriptionForm(TextEditingController textEditingController){
    return TextFormField(
      readOnly: loading,
      controller: textEditingController,
      decoration: const InputDecoration(
        labelText: 'Descrição',
      ),
      maxLines: 10,
      cursorColor: Colors.white,
      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w300),
    );
  }
}