// ignore_for_file: unnecessary_null_comparison, prefer_conditional_assignment

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class TelaHome extends StatefulWidget {
  const TelaHome({Key? key}) : super(key: key);

  @override
  _TelaHomeState createState() => _TelaHomeState();
}

class _TelaHomeState extends State<TelaHome> {
  /*
  
  //DESTA FORMA TRAS TODOS OS ITENS DA COLEÇÃO
  
  late CollectionReference products;

  @override
  void initState() {
    super.initState();
    products = FirebaseFirestore.instance.collection('products');
  }*/

  //DESTA FORMA TRAS SOMENTE OS ITENS LANÇAMENTOS

  final Query products = FirebaseFirestore.instance
      .collection('products')
      .where('lanc', isEqualTo: 's');

  @override
  Widget build(BuildContext context) {
//
//RECEBER DADOS DE OUTRA TELA
//
    var obj = Obj("Visitante", "");
    var teste = ModalRoute.of(context)!.settings.arguments as Obj;
    if (teste != null) obj = teste;
    //if (obj.nomeuser == null) obj.nomeuser = "Visitante";

    return Scaffold(
      appBar: AppBar(
        title: Text('Destaques'),
        centerTitle: true,
        backgroundColor: Colors.grey.shade500,
        actions: [
          Padding(
            padding: EdgeInsets.all(15),
            child: Text(obj.nomeuser),
          )
        ],
      ),
//
//CRIAÇÃO DO GRIDVIEW
//
      body: StreamBuilder<QuerySnapshot>(
        stream: products.snapshots(),
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
                  return itemLista(context, dados.docs[index], obj.nomeuser);
                },
              );
          }
        },
      ),
    );
  }
}

class FireStorageService extends ChangeNotifier {
  FireStorageService();
  static Future<dynamic> loadImage(BuildContext context, String image) async {
    return FirebaseStorage.instance.ref().child(image).getDownloadURL();
  }
}

Widget itemLista(BuildContext context, item, String user) {
  String cod = item.data()['cod'];
  String descr = item.data()['descr'];
  String det = item.data()['det'];
  String img = item.data()['img'];
  return GestureDetector(
    child: Card(
      elevation: 30,
      shadowColor: Colors.grey.shade500,
      child: GridTile(
        header: Padding(
          padding: EdgeInsets.all(MediaQuery.of(context).size.height / 100),
          child: Text(
            cod,
            textAlign: TextAlign.center,
          ),
        ),
        child: SizedBox(
          child: Padding(
            padding: EdgeInsets.all(MediaQuery.of(context).size.height / 20),
            child: FutureBuilder<Widget>(
              future: _getImage(context, img),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return SizedBox(
                    child: snapshot.data,
                  );
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }
                return Center(
                  child: Text("Erro"),
                );
              },
            ),
          ),
        ),
        footer: Padding(
          padding: EdgeInsets.all(MediaQuery.of(context).size.height / 100),
          child: Text(
            descr,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    ),
    onTap: () {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('DETALHES DO PRODUTO'),
              content: SizedBox(
                height: MediaQuery.of(context).size.height / 2,
                width: MediaQuery.of(context).size.height / 2,
                child: Column(
                  children: [
                    Expanded(
                      child: FutureBuilder<Widget>(
                        future: _getImage(context, img),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            return SizedBox(
                              //width: MediaQuery.of(context).size.width / 4,
                              //height: MediaQuery.of(context).size.width / 4,
                              child: snapshot.data,
                            );
                          }
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          }
                          return Center(
                            child: Text("Erro"),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height / 50),
                    Text(
                      det,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height / 50),
                    //BOTÃO ADICIONAR AO CARRINHO
                    //SE USUARIO LOGADO PERMITE ADICIONAR AO CARRINHO
                    //SENAO PEDE PARA SE LOGAR
                    (user != "Visitante")
                        ? ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Colors.grey.shade500),
                            onPressed: () {
                              //
                              //ENVIAR DADOS PARA CARRINHO E FECHAR
                              //
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text(
                                  'ADICIONADO AO ORÇAMENTO',
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                ),
                                duration: Duration(seconds: 4),
                              ));
                            },
                            child: Text('ADICIONAR AO ORÇAMENTO',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold)),
                          )
                        : Text(
                            "Logue para Adicionar ao Orçamento",
                            style: TextStyle(color: Colors.red),
                          ),
                    SizedBox(height: MediaQuery.of(context).size.height / 50),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.grey.shade500),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('FECHAR',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold)),
                    )
                  ],
                ),
              ),
            );
          });
    },
  );
}

Future<Widget> _getImage(BuildContext context, String imageName) async {
  Image image = Image.asset('imagens/icon.png');
  await FireStorageService.loadImage(context, imageName).then((value) {
    image = Image.network(value.toString(), fit: BoxFit.scaleDown);
  });
  return image;
}
