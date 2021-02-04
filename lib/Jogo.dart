import 'package:audioplayers/audioplayers.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'dart:math';
import 'dart:async';

class Jogo extends StatefulWidget {
  @override
  _JogoState createState() => _JogoState();
}

class _JogoState extends State<Jogo> {

  var _imagemEscolhaPapai = AssetImage("images/interrogacao.png");
  var _imagemEscolhaManu  = AssetImage("images/interrogacao.png");
  var _escolhaManu        = null;
  var _escolhaPapai       = null;
  var _parar              = false;
  var _btIniciar          = true; // quando setar false, desabilita funcao do bt
  var _audioExec          = "";   // guarda qual é o audio que está executando

  AudioPlayer audioPlayer = AudioPlayer();
  AudioCache  audioCache = AudioCache(prefix: 'audios/');

  playAbertura() async {
      audioPlayer = await audioCache.play('escolha.mp3');
      _audioExec = "escolha.mp3";
      this._btIniciar = false;
  }

  playPapaiGanhou() async {
    _audioExec = "perdeu.mp3";
    audioPlayer = await audioCache.play('perdeu.mp3');
    this._btIniciar = false;
  }

  playManuGanhouUma() async {
    _audioExec = "ganhou_uma.mp3";
    audioPlayer = await audioCache.play('ganhou_uma.mp3');
    this._btIniciar = false;
  }


  playEmpate() async {
    _audioExec = "empate.mp3";
    audioPlayer = await audioCache.play('empate.mp3');
    this._btIniciar = false;
  }


  AssetImage imagemAleatoriaPapai(){

    var _imagensAleatorias = [
      AssetImage("images/papel.png"),
      AssetImage("images/pedra.png"),
      AssetImage("images/tesoura.png"),
    ];

    return _imagensAleatorias[Random().nextInt(_imagensAleatorias.length)];
  }

  AssetImage imagemAleatoriaManu(){
    var _imagensAleatorias = [
      AssetImage("images/pedra.png"),
      AssetImage("images/papel.png"),
      AssetImage("images/tesoura.png"),
    ];
    return _imagensAleatorias[Random().nextInt(_imagensAleatorias.length)];

  }

    void iniciarJogo(){
      this._parar        = false;
      this._btIniciar    = false; // desabilita o botão para não chamar novamente
      this._escolhaManu  = null;
      this._escolhaPapai = null;

      playAbertura();

      Timer.periodic(Duration(milliseconds: 500), (timer) {
          if(!this._parar){
              setState(() {
                this._imagemEscolhaPapai = imagemAleatoriaPapai();

                if(this._escolhaManu==null){
                  //== não escolheu ainda então fica trocando
                  this._imagemEscolhaManu  = imagemAleatoriaManu();
                }else{
                  this._imagemEscolhaManu = this._escolhaManu;
                }

              });
          }else{
              setState(() {
                this._escolhaPapai = _imagemEscolhaPapai;
                this._btIniciar = true; //habilita novamente o botão
              });
          }
        });
      }

      void validaVencedor(){

        var escolhaManu  = _imagemEscolhaManu.assetName;
        var escolhaPapai = _imagemEscolhaPapai.assetName;

        //=== PAPAI PEDRA
          if(escolhaPapai == 'images/pedra.png' && escolhaManu == 'images/tesoura.png'){
            //==papai venceu
            playPapaiGanhou();
          }
          if(escolhaPapai == 'images/pedra.png' && escolhaManu == 'images/papel.png'){
            //==papai perdeu
            playManuGanhouUma();
          }
          if(escolhaPapai == 'images/pedra.png' && escolhaManu == 'images/pedra.png'){
            //== empate
            playEmpate();
          }

        //=== PAPAI PAPEL
          if(escolhaPapai == 'images/papel.png' && escolhaManu == 'images/tesoura.png'){
            //==papai pardeu
            playManuGanhouUma();
          }
          if(escolhaPapai == 'images/papel.png' && escolhaManu == 'images/papel.png'){
            //==empate
            playEmpate();
          }
          if(escolhaPapai == 'images/papel.png' && escolhaManu == 'images/pedra.png'){
            //== papai venceu
            playPapaiGanhou();
          }

        //=== PAPAI TESOURA
          if(escolhaPapai == 'images/tesoura.png' && escolhaManu == 'images/tesoura.png'){
            //==empate
            playEmpate();
          }
          if(escolhaPapai == 'images/tesoura.png' && escolhaManu == 'images/papel.png'){
            //== papai venceu
            playPapaiGanhou();
          }
          if(escolhaPapai == 'images/tesoura.png' && escolhaManu == 'images/pedra.png'){
            //== papai perdeu
            playManuGanhouUma();
          }
      }

  @override
  Widget build(BuildContext context) {


    //== quando parar a musica para, executa a funcao que verifica
    //== quem ganhou
    audioPlayer.onPlayerCompletion.listen((event) {
      this._parar     = true;
      //setState(() {
        //== assim que acabar a musica da escolha,
        //== valida o vencedor
        if(_audioExec == "escolha.mp3"){
          validaVencedor();
        }

     // });
    });

    return Scaffold(
      //backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text("JokenPo da Manu"),
        backgroundColor: Colors.purple,
      ),
      body:
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 32, bottom: 16),
            child: Text(
              "Escolha do Papai",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold
              ),
            ),
          ),
          Image(
            image: this._imagemEscolhaPapai,
            width: 100,
            height: 100,
          ),
          Padding(
            padding: EdgeInsets.only(top:32, bottom: 16),
            child: Text(
              "Escolha da Manu",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold
              ),
            ),
          ),
          Image(
            image: this._imagemEscolhaManu,
            width: 100,
            height: 100,
          ),
          Padding(
            padding: EdgeInsets.only(top:32, bottom: 16),
            child:
            Container(
                width: 80,
                child:
                RaisedButton(
                    color: Colors.red,
                    onPressed: _btIniciar ? iniciarJogo : null,
                    child:
                    Padding(
                      padding: EdgeInsets.only(top: 15, bottom: 15),
                      child: Text("COMEÇAR!",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    )
                )
            ),
          ),
        ],
      ),
      bottomNavigationBar:
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(20),
            child:
            ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child:
              Container(
                padding: EdgeInsets.all(6),
                color: Colors.green,
                child:
                GestureDetector(
                  onTap: (){
                   this._escolhaManu = AssetImage("images/papel.png");
                  },
                  child: Image.asset('images/papel.png',
                            width: 60,
                            height: 60,
                            fit: BoxFit.fill,
                          ),
                )
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20),
            child:
            ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              clipBehavior: Clip.hardEdge,
              child:
              Container(
                padding: EdgeInsets.all(6),
                color: Colors.blue,
                child:
                GestureDetector(
                  onTap: (){
                    this._escolhaManu = AssetImage("images/pedra.png");
                  },
                  child: Image.asset('images/pedra.png',
                            width: 60,
                            height: 60,
                            fit: BoxFit.fill,
                          ),
                )
              ),
            ),

          ),
          Padding(
            padding: EdgeInsets.all(20),
            child:
            ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                clipBehavior: Clip.hardEdge,
                child:
                Container(
                  padding: EdgeInsets.all(6),
                  color: Colors.yellow,
                  child:
                  GestureDetector(
                    onTap: (){
                      this._escolhaManu = AssetImage("images/tesoura.png");
                    },
                    child: Image.asset('images/tesoura.png',
                                width: 60,
                                height: 60,
                                fit: BoxFit.fill,
                              ),
                  )
                )
            ),
          )
        ],
      ),
    );
  }
}

