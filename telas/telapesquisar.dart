// ignore_for_file: unnecessary_null_comparison

import 'package:catalogo_farb/telas/telahome.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../main.dart';


class TelaPesquisar extends StatefulWidget {
  const TelaPesquisar({Key? key}) : super(key: key);

  @override
  _TelaPesquisarState createState() => _TelaPesquisarState();
}

class _TelaPesquisarState extends State<TelaPesquisar> {
  var pesquisar = TextEditingController();
  
/*
  @override
  void initStat() {
    super.initState();
    _pesquisar('');
  }
*/
  @override
  Widget build(BuildContext context) {
    var obj = Obj("Visitante", "");
    var teste = ModalRoute.of(context)!.settings.arguments as Obj;
    if (teste != null) obj = teste;
    
    Query pesquisa = FirebaseFirestore.instance
        .collection('products')
        .where("lanc", isEqualTo: '');

    //Query pesquisa = _pesquisar('');
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.shade500,
        actions: <Widget>[
          IconButton(
              onPressed: () {
                _pesquisar(pesquisar.text);
              },
              icon: Icon(Icons.search_outlined))
        ],
        title: TextField(
          controller: pesquisar,
          decoration: InputDecoration(hintText: 'PESQUISAR'),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: pesquisa.snapshots(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return Center(
                child: Text('Sem Conexão'),
              );
            case ConnectionState.waiting:
              return Center(
                child: CircularProgressIndicator(),
              );
            default:
              final dados = snapshot.requireData;
              return GridView.builder(
                padding:
                    EdgeInsets.all(MediaQuery.of(context).size.height / 50),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: (MediaQuery.of(context).size.width ~/ 180)),
                scrollDirection: Axis.vertical,
                itemCount: dados.size,
                itemBuilder: (context, index) {
                  return itemLista(context, dados.docs[index],obj.nomeuser);
                },
              );
          }
        },
      ),
    );
  }
}

_pesquisar(String text) async {
  Query pesquisa = FirebaseFirestore.instance
      .collection('products')
      .where("lanc", isEqualTo: text);
  return pesquisa;
}
