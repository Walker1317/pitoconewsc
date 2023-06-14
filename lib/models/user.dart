// ignore_for_file: unnecessary_this

import 'package:cloud_firestore/cloud_firestore.dart';

class Usuario{
  Usuario();

  String? _email;
  String? _nome;
  String? _fone;
  String? _bairro;
  String? _date;

  Usuario.fromDocumentSnapshot(DocumentSnapshot documentSnapshot){
    this.email = documentSnapshot['email'];
    this.nome = documentSnapshot['nome'];
    this.fone = documentSnapshot['fone'];
    this.bairro = documentSnapshot['bairro'];
    this.date = documentSnapshot['date'];
  }

  Map<String, dynamic> toMap(){
    return {
      'email' : this.email,
      'nome' : this.nome,
      'fone' : this.fone,
      'bairro' : this.bairro,
      'date' : Timestamp.now().toDate().toString(),
    };
  }

 String? get email => this._email;

 set email(String? value) => this._email = value;

  get nome => this._nome;

 set nome( value) => this._nome = value;

  get fone => this._fone;

 set fone( value) => this._fone = value;

  get bairro => this._bairro;

 set bairro( value) => this._bairro = value;

  get date => this._date;

 set date( value) => this._date = value;

}