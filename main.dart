// ignore_for_file: prefer_const_literals_to_create_immutables, import_of_legacy_library_into_null_safe, prefer_conditional_assignment, unnecessary_null_comparison

import 'package:catalogo_farb/telas/telaInserir.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'telas/lacamentos.dart';
import 'telas/telacadastro.dart';
import 'telas/telainicial.dart';

//ROTINA PRINCIPAL
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: "Catálogo FARB",
    //ROTAS A SEREM UTILIZADAS PELO NAVIGATOR
    initialRoute: 't1',
    routes: {
      't1': (context) => TelaInicial(),
      't2': (context) => Lancamentos(),
      't3': (context) => TelaCadastro(),
      't4_inserir': (context) => TelaInserir()
    },
  ));
}

class Obj {
  String nomeuser;
  var id;
  Obj(this.nomeuser, this.id);
}


/* 
//PARA EXECUTAR O APP

flutter run -d chrome --no-sound-null-safety --web-renderer=html

//PARA CRIAR O ICONE DO APLICATICO
locarliar no pubspec.yaml

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_launcher_icons: "^0.9.2"
  # The "flutter_lints" package below contains a set of recommended lints to
  # encourage good coding practices. The lint set provided by the package is
  # activated in the `analysis_options.yaml` file located at the root of your
  # package. See that file for information about deactivating specific lint
  # rules and activating additional ones.
  flutter_lints: ^1.0.0
flutter_icons:
  android: true
  ios: true
  image_path: "imagens/icon.png"    <-----------------x


depois executar
flutter pub pub run flutter_launcher_icons:main
*/






