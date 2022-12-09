// ignore_for_file: unnecessary_null_comparison

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../main.dart';

class TelaCarrinho extends StatefulWidget {
  const TelaCarrinho({Key? key}) : super(key: key);

  @override
  _TelaCarrinhoState createState() => _TelaCarrinhoState();
}

class _TelaCarrinhoState extends State<TelaCarrinho> {
  late CollectionReference listateste;
  @override
  void initState() {
    super.initState();

    listateste = FirebaseFirestore.instance.collection('listateste');
  }

  var txtCod = TextEditingController();
  var txtDescricao = TextEditingController();
  var txtDetalhes = TextEditingController();
  var txtCategoria = TextEditingController();

  getDocumentById(id) async {
    // select * from tb_cafes where id = 1;
    await FirebaseFirestore.instance
        .collection('listateste')
        .doc(id)
        .get()
        .then((doc) {
      txtCod.text = doc.get('cod');
      txtDescricao.text = doc.get('descricao');
      txtDetalhes.text = doc.get('detalhes');
      txtCategoria.text = doc.get('categoria');
    });
  }

  Widget novaLista(item) {
    String cod = item.data()['cod'];
    String descr = item.data()['descricao'];
    return Card(
      elevation: MediaQuery.of(context).size.height / 50,
      shadowColor: Colors.grey.shade200,
      child: ListTile(
          title: Text(cod),
          subtitle: Text(descr),
          trailing: IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              listateste.doc(item.id).delete();
            },
          ),
          onTap: () {
            getDocumentById(item.id);
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("Modificar"),
                    content: SizedBox(
                      height: MediaQuery.of(context).size.height / 2,
                      width: MediaQuery.of(context).size.height / 2,
                      child: Column(
                        children: [
                          TextField(
                            controller: txtCod,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.w300,
                            ),
                            decoration: const InputDecoration(
                              labelText: 'Codigo',
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextField(
                            controller: txtDescricao,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.w300,
                            ),
                            decoration: const InputDecoration(
                              labelText: 'Descrição',
                            ),
                          ),
                          const SizedBox(height: 40),
                          TextField(
                            controller: txtDetalhes,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.w300,
                            ),
                            decoration: const InputDecoration(
                              labelText: 'Detalhes',
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextField(
                            controller: txtCategoria,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.w300,
                            ),
                            decoration: const InputDecoration(
                              labelText: 'Categoria',
                            ),
                          ),
                          const SizedBox(height: 40),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 150,
                                child: OutlinedButton(
                                  child: const Text('Salvar'),
                                  onPressed: () {
                                    //
                                    // ATUALIZAR DOCUMENTO NO FIRESTORE
                                    //
                                    FirebaseFirestore.instance
                                        .collection('listateste')
                                        .doc(item.id.toString())
                                        .set({
                                      'cod': txtCod.text,
                                      'descricao': txtDescricao.text,
                                      'detalhes': txtDetalhes.text,
                                      'categoria': txtCategoria.text
                                    });
    
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                      content:
                                          Text('Operação realizada com sucesso!'),
                                      duration: Duration(seconds: 2),
                                    ));
    
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ),
                              SizedBox(
                                width: 150,
                                child: OutlinedButton(
                                    child: const Text('Cancelar'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    }),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                });
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
//
//ROTINA PARA RECEBER DADOS DE OUTRA TELA
//
    var obj = Obj("Visitante", "");
    var teste = ModalRoute.of(context)!.settings.arguments as Obj;
    if (teste != null) obj = teste;

    return Scaffold(
      appBar: AppBar(
        title: Text('Editar'),
        centerTitle: true,
        backgroundColor: Colors.grey.shade500,
        actions: [
          Padding(
            padding: EdgeInsets.all(15),
            child: Text(obj.nomeuser),
          )
        ],
      ),
      body: (obj.nomeuser == "Visitante")
          ? Center(
              child: Text("Faça Login para alterar Produtos"),
            )
          : StreamBuilder<QuerySnapshot>(
              stream: listateste.snapshots(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                    return const Center(
                      child: Text('Não foi possivel carregar'),
                    );
                  case ConnectionState.waiting:
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  default:
                    final dados = snapshot.requireData;
                    return Container(
                      padding: EdgeInsets.all(MediaQuery.of(context).size.height / 50),
                      child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          
                          itemCount: dados.size,
                          itemBuilder: (context, index) {
                            return
                              novaLista(dados.docs[index]);
                          }),
                    );
                }
              },
            ),
      backgroundColor: Colors.grey.shade100,
      floatingActionButton: FloatingActionButton(
        foregroundColor: Colors.white,
        backgroundColor: Colors.grey,
        child: const Icon(Icons.add),
        onPressed: () {
          if (obj.nomeuser != "Visitante") {
            txtCod.text = "";
            txtDescricao.text = "";
            txtDetalhes.text = "";
            txtCategoria.text = "";
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("Adicionar Novo"),
                    content: SizedBox(
                      height: MediaQuery.of(context).size.height / 2,
                      width: MediaQuery.of(context).size.height / 2,
                      child: Column(
                        children: [
                          TextField(
                            controller: txtCod,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.w300,
                            ),
                            decoration: const InputDecoration(
                              labelText: 'Codigo',
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextField(
                            controller: txtDescricao,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.w300,
                            ),
                            decoration: const InputDecoration(
                              labelText: 'Descrição',
                            ),
                          ),
                          const SizedBox(height: 40),
                          TextField(
                            controller: txtDetalhes,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.w300,
                            ),
                            decoration: const InputDecoration(
                              labelText: 'Detalhes',
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextField(
                            controller: txtCategoria,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.w300,
                            ),
                            decoration: const InputDecoration(
                              labelText: 'Categoria',
                            ),
                          ),
                          const SizedBox(height: 40),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 150,
                                child: OutlinedButton(
                                  child: const Text('Salvar'),
                                  onPressed: () {
                                    //
                                    // ADICIONAR DOCUMENTO NO FIRESTORE
                                    //
                                    FirebaseFirestore.instance
                                        .collection('listateste')
                                        .add({
                                      'cod': txtCod.text,
                                      'descricao': txtDescricao.text,
                                      'detalhes': txtDetalhes.text,
                                      'categoria': txtCategoria.text
                                    });

                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                      content: Text(
                                          'Operação realizada com sucesso!'),
                                      duration: Duration(seconds: 2),
                                    ));

                                    Navigator.of(context).pop();
                                  },
                                ),
                              ),
                              SizedBox(
                                width: 150,
                                child: OutlinedButton(
                                    child: const Text('Cancelar'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    }),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                });
          }
        },
      ),
    );
  }
}
