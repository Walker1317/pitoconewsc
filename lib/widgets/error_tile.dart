import 'package:flutter/material.dart';

Widget errorTile(String message){
  return Container(
    padding: const EdgeInsets.all(20),
    margin: const EdgeInsets.only(bottom: 10),
    decoration: BoxDecoration(
      color: Colors.redAccent[700],
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text(message, style: const TextStyle(color: Colors.white),),
  );
}