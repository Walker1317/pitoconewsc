// ignore_for_file: unnecessary_this

import 'package:cloud_firestore/cloud_firestore.dart';

class Denuncia{

  String? _id;
  String? _date;
  String? _name;
  String? _email;
  String? _phone;
  String? _message;
  String? _image;

  Denuncia.gerarId(){
    FirebaseFirestore db = FirebaseFirestore.instance;
    CollectionReference posts = db.collection('denuncias');
    this.id = posts.doc().id;
  }

  Denuncia.fromDocumentSnapshot(DocumentSnapshot documentSnapshot){
    this.id = documentSnapshot['id'];
    this.date = documentSnapshot['date'];
    this.name = documentSnapshot['name'];
    this.email = documentSnapshot['email'];
    this.phone = documentSnapshot['phone'];
    this.message = documentSnapshot['message'];
    this.image = documentSnapshot['file'];
  }

  Map<String, dynamic> toMap(){
    return {
      'id' : this.id,
      'date' : this.date,
      'name' : this.name,
      'email' : this.email,
      'phone' : this.phone,
      'message' : this.message,
      'file' : this.image,
    };
  }

  
 String? get id => this._id;

 set id(String? value) => this._id = value;

  get date => this._date;

 set date( value) => this._date = value;

  get name => this._name;

 set name( value) => this._name = value;

  get email => this._email;

 set email( value) => this._email = value;

  get phone => this._phone;

 set phone( value) => this._phone = value;

  get message => this._message;

 set message( value) => this._message = value;

  get image => this._image;

 set image( value) => this._image = value;

}