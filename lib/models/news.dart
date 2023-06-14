// ignore_for_file: unnecessary_this

import 'package:cloud_firestore/cloud_firestore.dart';

class News{

  String? _id;
  String? _date;
  String? _title;
  String? _category;
  String? _image;
  List<dynamic>? _elements;

  News.gerarId(){
    FirebaseFirestore db = FirebaseFirestore.instance;
    CollectionReference posts = db.collection('news');
    this.id = posts.doc().id;
  }

  News.fromDocumentSnapshot(DocumentSnapshot documentSnapshot){
    this.id = documentSnapshot['id'];
    this.date = documentSnapshot['date'];
    this.title = documentSnapshot['title'];
    this.category = documentSnapshot['category'];
    this.image = documentSnapshot['image'];
    this.elements = documentSnapshot['elements'];
  }

  Map<String, dynamic> toMap(){
    return {
      'id' : this.id,
      'date' : this.date,
      'title' : this.title,
      'category' : this.category,
      'image' : this.image,
      'elements' : this.elements,
    };
  }

 String? get id => this._id;

 set id(String? value) => this._id = value;

  get date => this._date;

 set date( value) => this._date = value;

  get title => this._title;

 set title( value) => this._title = value;

  get category => this._category;

 set category( value) => this._category = value;

  get image => this._image;

 set image( value) => this._image = value;

  get elements => this._elements;

 set elements( value) => this._elements = value;

}