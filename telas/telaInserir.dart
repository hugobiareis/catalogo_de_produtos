// ignore_for_file: file_names, unnecessary_null_comparison

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class TelaInserir extends StatefulWidget {
  const TelaInserir({Key? key}) : super(key: key);

  @override
  _TelaInserirState createState() => _TelaInserirState();
}

class _TelaInserirState extends State<TelaInserir> {
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

  @override
  Widget build(BuildContext context) {
    var obj = Obj("Visitante", "");
    var teste = ModalRoute.of(context)!.settings.arguments as Obj;
    if (teste != null) obj = teste;

    if (obj.id != "") {
      if (txtCod.text.isEmpty &&
          txtDescricao.text.isEmpty &&
          txtDetalhes.text.isEmpty &&
          txtCategoria.text.isEmpty) {
        getDocumentById(obj.id);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Inserir/Modificar'),
        centerTitle: true,
        backgroundColor: Colors.grey.shade500,
        actions: [
          Padding(
            padding: EdgeInsets.all(15),
            child: Text(obj.nomeuser),
          )
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(50),
        child: ListView(
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
                      if (obj.id == null) {
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
                      } else {
                        //
                        // ATUALIZAR DOCUMENTO NO FIRESTORE
                        //
                        FirebaseFirestore.instance
                            .collection('listateste')
                            .doc(obj.id.toString())
                            .set({
                          'cod': txtCod.text,
                          'descricao': txtDescricao.text,
                          'detalhes': txtDetalhes.text,
                          'categoria': txtCategoria.text
                        });
                      }

                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Operação realizada com sucesso!'),
                        duration: Duration(seconds: 2),
                      ));

                      Navigator.pop(context);
                    },
                  ),
                ),
                SizedBox(
                  width: 150,
                  child: OutlinedButton(
                      child: const Text('Cancelar'),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
