import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:splashscreen/splashscreen.dart';

import 'lacamentos.dart';

class TelaInicial extends StatefulWidget {
  const TelaInicial({Key? key}) : super(key: key);

  @override
  _TelaInicialState createState() => _TelaInicialState();
}

class _TelaInicialState extends State<TelaInicial> {


  @override
  Widget build(BuildContext context) {
//
//SPLASHSCREEN PARA SIMULAR UM LOADING INICIAL
//
    return SplashScreen(
      seconds: 4,
      navigateAfterSeconds: Lancamentos(),
      title: Text('Seja Bem Vindo',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
      image: Image.asset('imagens/logo_farb.png'),
      gradientBackground: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Colors.grey.shade300, Colors.grey.shade700]),
      photoSize: 200,
      loaderColor: Colors.black,
    );
  }
}
