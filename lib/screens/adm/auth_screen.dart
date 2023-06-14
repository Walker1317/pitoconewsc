import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:mbl_am/widgets/app_bar.dart';
import 'package:mbl_am/widgets/error_tile.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  String? error;
  int tentativas = 0;
  bool loading = false;
  bool authorized = false;
  final TextEditingController controller = TextEditingController();
  final TextEditingController controllerEmail = TextEditingController();
  final TextEditingController controllerPass = TextEditingController();
  bool obscureText = true;
  bool signup = false;
  final _formKey = GlobalKey<FormState>();

  Future<bool> enterKey() async {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection('config').doc('keys').get();
    String pass = documentSnapshot['auth_key'];
    if(controller.text == pass){
      return true;
    } else {
      return false;
    }
  }

  signIn() async {
    setState(() {
      loading = true;
      error = null;
    });
    FirebaseAuth auth = FirebaseAuth.instance;
    try{
      await auth.signInWithEmailAndPassword(email: controllerEmail.text, password: controllerPass.text).then((value) => context.go('/adm'));
      setState(() {
        loading = false;
      });
    } catch (e){
      setState(() {
        loading = false;
        error = 'Não foi possível entrar, E-mail e(ou) senhas inválidos';
      });
    }
  }


  signUp() async {
    setState(() {
      loading = true;
      error = null;
    });
    FirebaseAuth auth = FirebaseAuth.instance;
    try{
      await auth.createUserWithEmailAndPassword(email: controllerEmail.text, password: controllerPass.text).then((value) => context.go('/adm'));
      setState(() {
        loading = false;
      });
    } catch (e){
      setState(() {
        loading = false;
        error = 'Não foi possível se cadastrar, verifique se o e-mail é válido.';
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: mblAppBar(context),
      body: authorized ? authWidget() : Center(
        child: SizedBox(
          width: screenWidth < 300 ? screenWidth : 300,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              error != null ?
              errorTile(error!): Container(),
              const Text('Digite a chave de acesso.'),
              const SizedBox(height: 10,),
              TextField(
                readOnly: loading,
                controller: controller,
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 10,),
              ElevatedButton(
                onPressed: loading ? null : ()  async{
                  setState(() {
                    error = null;
                  });
                  if(tentativas >= 5){
                    setState(() {
                      error = 'Número máximo de tentivas';
                    });
                  } else if(controller.text.isEmpty){
                    setState(() {
                      error = 'Código inválido';
                      tentativas++;
                    });
                  } else {
                    setState(() {
                      loading = true;
                    });
                    bool authorization = await enterKey();
                    setState(() {
                      loading = false;
                      if(authorization){
                        authorized = true;
                      } else {
                        error = 'Código inválido';
                        tentativas++;
                      }
                    });
                  }
                },
                child: loading ? const Padding(
                  padding: EdgeInsets.all(10),
                  child: CircularProgressIndicator(),
                ) : const Text('Validar')
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget authWidget(){
    double screenWidth = MediaQuery.of(context).size.width;
    return Form(
      key: _formKey,
      child: Center(
        child: SizedBox(
          width: screenWidth < 300 ? screenWidth : 300,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              error == null ? Container():
              errorTile(error!),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Login'),
                  const SizedBox(width: 10,),
                  Switch(
                    value: signup,
                    onChanged: (value){
                      setState(() {
                        signup = value;
                      });
                    }
                  ),
                  const SizedBox(width: 10,),
                  const Text('Cadastro'),
                ],
              ),
              const SizedBox(height: 20,),
              const Text('E-mail'),
              const SizedBox(height: 10,),
              TextFormField(
                controller: controllerEmail,
                readOnly: loading,
                style: const TextStyle(color: Colors.white),
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
              const SizedBox(height: 10,),
              const Text('Senha'),
              const SizedBox(height: 10,),
              TextFormField(
                controller: controllerPass,
                readOnly: loading,
                style: const TextStyle(color: Colors.white),
                obscureText: obscureText,
                validator: (text){
                  if(text!.length < 6){
                    return 'Senha muito curta';
                  } else {
                    return null;
                  }
                },
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    onPressed: (){
                      setState(() {
                        obscureText = !obscureText;
                      });
                    },
                    icon: Icon(obscureText ? Ionicons.eye_outline : Ionicons.eye_off_outline, color: Colors.white,)
                  ),
                ),
              ),
              const SizedBox(height: 20,),
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: loading ? null : (){
                    if(_formKey.currentState!.validate()){
                      signup ? signUp() : signIn();
                    }
                  },
                  child: loading ? const Padding(
                    padding: EdgeInsets.all(10),
                    child: CircularProgressIndicator(),
                  ) : Text(signup ? 'Cadastrar' : 'Entrar')
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}