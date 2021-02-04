import 'package:flutter/material.dart';
import 'package:jokenpodamanu/Jogo.dart';

void main(){
  
    runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home:
          Container(
//            decoration: BoxDecoration(
//                image: DecorationImage(
//                    image: AssetImage("images/bg.png"),
//                    fit: BoxFit.fitWidth
//                )
//            ),
            child: Jogo(),
          ),
    ));
}