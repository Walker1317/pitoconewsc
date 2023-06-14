import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mbl_am/models/user.dart';

class CadastroSession extends StatefulWidget {
  const CadastroSession({super.key});

  @override
  State<CadastroSession> createState() => _CadastroSessionState();
}

class _CadastroSessionState extends State<CadastroSession> {
  bool loading = false;
  String message = "";
  final _formKey = GlobalKey<FormState>();
  bool terms = false;
  final TextEditingController controllerName = TextEditingController();
  final TextEditingController controllerEmail = TextEditingController();
  final TextEditingController controllerBairro = TextEditingController();
  final TextEditingController controllerPhone = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Form(
      key: _formKey,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal:  screenWidth < 800 ? 20 : 0),
        width: screenWidth < 800 ? screenWidth : 800,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 20, bottom: 40),
              child: Text(
                "FIQUE POR DENTRO DE NOSSAS NOVIDADES",
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
            ),
            Row(
              children: [
                Flexible(
                  child: TextFormField(
                    style: const TextStyle(color: Colors.white),
                    readOnly: loading,
                    controller: controllerName,
                    validator: (text){
                      if(text!.isEmpty){
                        return "Digite seu nome";
                      } else {
                        return null;
                      }
                    },
                    decoration: const InputDecoration(
                      labelText: 'Seu Nome Completo',
                      labelStyle: TextStyle(color: Colors.white, fontFamily: 'GothamBook', fontSize: 14),
                    ),
                  ),
                ),
                const SizedBox(width: 10,),
                Flexible(
                  child: TextFormField(
                    style: const TextStyle(color: Colors.white),
                    readOnly: loading,
                    controller: controllerEmail,
                    validator: (text){
                      if(!text!.contains("@")){
                        return "E-mail inválido";
                      } else if(!text.contains(".")){
                        return "E-mail inválido";
                      } else {
                        return null;
                      }
                    },
                    decoration: const InputDecoration(
                      labelText: 'E-mail',
                      labelStyle: TextStyle(color: Colors.white, fontFamily: 'GothamBook', fontSize: 14),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10,),
            Row(
              children: [
                Flexible(
                  child: TextFormField(
                    style: const TextStyle(color: Colors.white),
                    readOnly: loading,
                    controller: controllerBairro,
                    decoration: const InputDecoration(
                      labelText: 'Bairro',
                      labelStyle: TextStyle(color: Colors.white, fontFamily: 'GothamBook', fontSize: 14),
                    ),
                  ),
                ),
                const SizedBox(width: 10,),
                Flexible(
                  child: TextFormField(
                    style: const TextStyle(color: Colors.white),
                    readOnly: loading,
                    controller: controllerPhone,
                    decoration: const InputDecoration(
                      labelText: 'Seu contato (ddd + telefone)',
                      labelStyle: TextStyle(color: Colors.white, fontFamily: 'GothamBook', fontSize: 14),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20,),
            Row(
              children: [
                Checkbox(value: terms, onChanged: (value){
                  setState(() {
                    terms = value!;
                  });
                }),
                const SizedBox(height: 10,),
                const Text('Concordo em ser notificado através de meu E-mail sempre que houver novidades.')
              ],
            ),
            const SizedBox(height: 20,),
            SizedBox(
              height: 60,
              child: ElevatedButton(
                onPressed: loading ? null : () async {
                  if(_formKey.currentState!.validate()){
                    if(!terms){
                      setState(() {
                        message = 'Você precisa aceitar os termos';
                      });
                    } else {
                      setState(() {
                      loading = true;
                    });
                    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection('users').doc(controllerEmail.text).get();
                    if(documentSnapshot.exists){
                      setState(() {
                        message = 'Este e-mail ja está cadastrado';
                        loading = false;
                      });
                    } else {
                      Usuario usuario = Usuario();
                      usuario.email = controllerEmail.text;
                      usuario.nome = controllerName.text;
                      usuario.bairro = controllerBairro.text;
                      usuario.fone = controllerPhone.text;
                      FirebaseFirestore.instance.collection('users').doc(controllerEmail.text).set(usuario.toMap())
                      .then((value){
                        setState(() {
                          loading = false;
                          message = 'Cadastrado com sucesso!';
                        });
                      }).catchError((e){
                        setState(() {
                          loading = false;
                          message = 'Oops, Tivemos um problema com isso.';
                        });
                      });
                    }
                    }
                  }
                },
                child: loading ? const Center(child: CircularProgressIndicator(),) : const Text('Cadastrar', style: TextStyle(color: Colors.black, fontSize: 20),)
              ),
            ),
            const SizedBox(height: 20,),
            message.isNotEmpty ?
            Text(
              message,
              style: const TextStyle(fontFamily: 'GothamBook'),
              textAlign: TextAlign.center,
            ) : Container(),
            const SizedBox(height: 20,),
          ],
        ),
      ),
    );
  }
}