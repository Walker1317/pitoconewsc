import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firestore_ui/animated_firestore_list.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:mbl_am/models/denuncia.dart';
import 'package:mbl_am/models/news.dart';
import 'package:mbl_am/models/user.dart';
import 'package:mbl_am/widgets/app_bar.dart';

class AdmScreen extends StatefulWidget {
  const AdmScreen({super.key});

  @override
  State<AdmScreen> createState() => _AdmScreenState();
}

class _AdmScreenState extends State<AdmScreen> {

  String state = 'default';
  String dateFormat(String dateFormat, String time){
    return DateFormat(dateFormat, 'pt_BR').format(DateTime.parse(time));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: mblAppBar(context),
      body: FirebaseAuth.instance.currentUser == null?
      const Center(child: Text('Você não tem permissão para usar essa página.'),):
      widgetManage()
    );
  }

  Widget widgetManage(){
    switch (state) {
      case 'default':
        return defaultWidget();
      case 'denuncia':
        return denuncias();
      case 'cadastros':
        return cadastros();
      case 'noticias':
        return noticias();
      default:
        return defaultWidget();
    }
  }

  Widget denuncias(){
    double screenWidth = MediaQuery.of(context).size.width;
    return Center(
      child: SizedBox(
        width: screenWidth < 1000 ? screenWidth : 1000,
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(20),
              height: 50,
              width: screenWidth,
              child: ElevatedButton(
                onPressed: (){
                  setState(() {
                    state = 'default';
                  });
                },
                child: const Row(
                  children: [
                    Icon(Icons.arrow_back),
                    SizedBox(width: 10,),
                    Text('Voltar à página de ADM'),
                  ],
                )
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Text('Denúncias', style: TextStyle(fontSize: 30),),
            ),
            Expanded(
              child: FirestoreAnimatedList(
                query: FirebaseFirestore.instance.collection('denuncias')
                .orderBy('date', descending: true)
                .withConverter<Denuncia>(
                fromFirestore: (snapshot, _)=> Denuncia.fromDocumentSnapshot(snapshot),
                toFirestore: (value, options) => {},),
                emptyChild: const Padding(
                  padding: EdgeInsets.all(20),
                  child: Text('Não há denúncias'),
                ),
                itemBuilder: (context, snapshot, animation, index){
                  dynamic denuncia = snapshot!.data();
                  return Container(
                    margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20)
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                                child: SelectableText('${dateFormat(DateFormat.YEAR_MONTH_DAY, denuncia.date)} às ${dateFormat(DateFormat.HOUR24_MINUTE, denuncia.date)}', style: const TextStyle(fontFamily: 'GothamBook', color: Colors.grey),),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                child: SelectableText(denuncia.name, style: const TextStyle(color: Colors.black, fontSize: 24),),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                child: SelectableText(denuncia.email, style: const TextStyle(fontFamily: 'GothamBook', color: Colors.grey),),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                child: SelectableText(denuncia.phone, style: const TextStyle(fontFamily: 'GothamBook', color: Colors.grey),),
                              ),
                              const Divider(),
                              Padding(
                                padding: const EdgeInsets.all(20),
                                child: SelectableText(denuncia.message, style: const TextStyle(fontFamily: 'GothamBook', color: Colors.black),),
                              ),
                              denuncia.image == null ? Container():
                              Padding(
                                padding: const EdgeInsets.all(20),
                                child: CachedNetworkImage(imageUrl: denuncia.image),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: PopupMenuButton<int>(
                            initialValue: 0,
                            onSelected: (int item) {
                              FirebaseFirestore.instance.collection('denuncias').doc(denuncia.id).delete();
                            },
                            color: Colors.grey[900],
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
                              PopupMenuItem<int>(
                                value: 0,
                                onTap: (){},
                                child: Text('Deletar', style: TextStyle(color: Colors.redAccent[700]),),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  );
                }
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget cadastros(){
    double screenWidth = MediaQuery.of(context).size.width;
    return Center(
      child: SizedBox(
        width: screenWidth < 1000 ? screenWidth : 1000,
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(20),
              height: 50,
              width: screenWidth,
              child: ElevatedButton(
                onPressed: (){
                  setState(() {
                    state = 'default';
                  });
                },
                child: const Row(
                  children: [
                    Icon(Icons.arrow_back),
                    SizedBox(width: 10,),
                    Text('Voltar à página de ADM'),
                  ],
                )
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Text('Cadastros', style: TextStyle(fontSize: 30),),
            ),
            Expanded(
              child: FirestoreAnimatedList(
                query: FirebaseFirestore.instance.collection('users')
                .orderBy('date', descending: true)
                .withConverter<Usuario>(
                fromFirestore: (snapshot, _)=> Usuario.fromDocumentSnapshot(snapshot),
                toFirestore: (value, options) => {},),
                emptyChild: const Padding(
                  padding: EdgeInsets.all(20),
                  child: Text('Não há cadastros'),
                ),
                itemBuilder: (context, snapshot, animation, index){
                  dynamic usuario = snapshot!.data();
                  return Container(
                    padding: const EdgeInsets.all(20),
                    margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20)
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              SelectableText('Criado em: ${dateFormat(DateFormat.YEAR_MONTH_DAY, usuario.date)} às ${dateFormat(DateFormat.HOUR24_MINUTE, usuario.date)}', style: const TextStyle(fontFamily: 'GothamBook', color: Colors.grey),),
                              SelectableText(usuario.nome, style: const TextStyle(color: Colors.black, fontSize: 20),),
                              SelectableText(usuario.email, style: const TextStyle(fontFamily: 'GothamBook', color: Colors.grey),),
                              SelectableText(usuario.fone, style: const TextStyle(fontFamily: 'GothamBook', color: Colors.grey),),
                              SelectableText(usuario.bairro, style: const TextStyle(fontFamily: 'GothamBook', color: Colors.grey),),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: PopupMenuButton<int>(
                            initialValue: 0,
                            onSelected: (int item) {
                              FirebaseFirestore.instance.collection('users').doc(usuario.email).delete();
                            },
                            color: Colors.grey[900],
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
                              PopupMenuItem<int>(
                                value: 0,
                                onTap: (){},
                                child: Text('Deletar', style: TextStyle(color: Colors.redAccent[700]),),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  );
                }
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget noticias(){
    double screenWidth = MediaQuery.of(context).size.width;
    return Center(
      child: SizedBox(
        width: screenWidth < 1000 ? screenWidth : 1000,
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(20),
              height: 50,
              width: screenWidth,
              child: ElevatedButton(
                onPressed: (){
                  setState(() {
                    state = 'default';
                  });
                },
                child: const Row(
                  children: [
                    Icon(Icons.arrow_back),
                    SizedBox(width: 10,),
                    Text('Voltar à página de ADM'),
                  ],
                )
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Text('Notícias', style: TextStyle(fontSize: 30),),
            ),
            Expanded(
              child: FirestoreAnimatedList(
                query: FirebaseFirestore.instance.collection('news')
                .orderBy('date', descending: true)
                .withConverter<News>(
                fromFirestore: (snapshot, _)=> News.fromDocumentSnapshot(snapshot),
                toFirestore: (value, options) => {},),
                emptyChild: const Padding(
                  padding: EdgeInsets.all(20),
                  child: Text('Não há noticias'),
                ),
                itemBuilder: (context, snapshot, animation, index){
                  dynamic news = snapshot!.data();
                  return InkWell(
                    onTap: (){
                      context.go('/noticias/${news.id}');
                    },
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20)
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                SelectableText('Criado em: ${dateFormat(DateFormat.YEAR_MONTH_DAY, news.date)} às ${dateFormat(DateFormat.HOUR24_MINUTE, news.date)}', style: const TextStyle(fontFamily: 'GothamBook', color: Colors.grey),),
                                SelectableText(news.title, style: const TextStyle(color: Colors.black, fontSize: 20),),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: PopupMenuButton<int>(
                              initialValue: 0,
                              onSelected: (int item) {
                                FirebaseFirestore.instance.collection('news').doc(news.id).delete();
                              },
                              color: Colors.grey[900],
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
                                PopupMenuItem<int>(
                                  value: 0,
                                  onTap: (){},
                                  child: Text('Deletar', style: TextStyle(color: Colors.redAccent[700]),),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    ),
                  );
                }
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget defaultWidget(){
    double screenWidth = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: Column(
        children: [
          Center(
            child: SizedBox(
              width: screenWidth < 1000 ? screenWidth : 1000,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 40,),
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 50,
                          child: ElevatedButton(
                            onPressed: (){
                              context.go('/createNews');
                            },
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Ionicons.add_outline),
                                SizedBox(width: 10,),
                                Text('Criar notícia'),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10,),
                      Expanded(
                        child: SizedBox(
                          height: 50,
                          child: ElevatedButton(
                            onPressed: (){
                              setState(() {
                                state = 'noticias';
                              });
                            },
                            child: const Text('Notícias')
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20,),
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 50,
                          child: ElevatedButton(
                            onPressed: (){
                              setState(() {
                                state = 'denuncia';
                              });
                            },
                            child: const Text('Denúncias')
                          ),
                        ),
                      ),
                      const SizedBox(width: 10,),
                      Expanded(
                        child: SizedBox(
                          height: 50,
                          child: ElevatedButton(
                            onPressed: (){
                              setState(() {
                                state = 'cadastros';
                              });
                            },
                            child: const Text('Cadastros')
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20,),
                  TextButton(
                    onPressed: (){
                      FirebaseAuth.instance.signOut();
                      context.go('/auth');
                    },
                    child: const Text('Sair da conta', style: TextStyle(color: Colors.red),),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}