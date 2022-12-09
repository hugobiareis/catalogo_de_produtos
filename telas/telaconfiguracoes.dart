// ignore_for_file: unnecessary_null_comparison

import 'package:catalogo_farb/telas/lacamentos.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '/main.dart';

class TelaConfiguracoes extends StatefulWidget {
  const TelaConfiguracoes({Key? key}) : super(key: key);

  @override
  _TelaConfiguracoesState createState() => _TelaConfiguracoesState();
}

class _TelaConfiguracoesState extends State<TelaConfiguracoes> {
//
//VARIAVEIS PARA O TEXTBOX DE USUSARIO E SENHA E DOS SWITCHS
//
  var usuario = TextEditingController();
  var senha = TextEditingController();
  var email = TextEditingController();
  bool swnotif = false;
  bool swsound = false;

  @override
  Widget build(BuildContext context) {
    var obj = Obj("Visitante", "");
    var teste = ModalRoute.of(context)!.settings.arguments as Obj;
    if (teste != null) obj = teste;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade500,
        centerTitle: true,
        title: Text(
          'Configurações',
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          //
          //IMAGEM E TEXTBOX DE LOGIN
          //
          Image.asset('imagens/logo_farb.png'),
          //
          //CONDICIONAL PARA SABER SE ESTÁ LOGADO OU COMO VISITANTE
          //
          (obj.nomeuser == 'Visitante')
              ? Expanded(
                  //
                  //SE SIM EXECUTA ESSE CONTAINER
                  //
                  child: Padding(
                    padding: EdgeInsets.all(
                      MediaQuery.of(context).size.height / 30,
                    ),
                    //
                    //ORGANIZA OS ITEMS EMPILHADOS
                    //
                    child: Column(
                      children: [
                        //CAMPO USUARIO
                        TextField(
                          controller: email,
                          decoration: InputDecoration(
                            labelText: 'E-mail',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        //CAMPO SENHA
                        TextField(
                          obscureText: true,
                          enableSuggestions: false,
                          autocorrect: false,
                          controller: senha,
                          decoration: InputDecoration(
                            labelText: 'Senha',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        //BOTÃO DE LOGIN
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: Colors.grey.shade500),
                          onPressed: () {
                            login(email.text, senha.text, obj);
                          },
                          child: Text('LOGIN',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold)),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        //BOTAO ESQUECI MINHA SENHA
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: Colors.grey.shade500),
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('ESQUECI MINHA SENHA'),
                                    content: SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height /
                                              4,
                                      child: Column(
                                        children: [
                                          //
                                          //CAMPO DE TEXTO E BOTAO DE ESQUECI SENHA
                                          //
                                          TextField(
                                            controller: email,
                                            decoration: InputDecoration(
                                              labelText: 'email',
                                              border: OutlineInputBorder(),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 30,
                                          ),
                                          //BOTÃO DE ESQUECI A SENHA
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                primary: Colors.grey.shade500),
                                            onPressed: () {
                                              //
                                              //ENVIAR DADOS PARA RECUPERAR SENHA E FECHAR
                                              //
                                              Navigator.of(context).pop();
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                content: Text(
                                                  'VERIFIQUE SUA CAIXA DE ENTRADA',
                                                  textAlign: TextAlign.center,
                                                ),
                                                duration: Duration(seconds: 4),
                                              ));
                                            },
                                            child: Text('RECUPERAR SENHA',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ),
                                        ],
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text(
                                          'FECHAR',
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      )
                                    ],
                                  );
                                });
                          },
                          child: Text('ESQUECI MINHA SENHA',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold)),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        //
                        //BOTÃO CADASTRAR
                        //
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: Colors.grey.shade500),
                          onPressed: () {
                            //
                            //CHAMAR OUTRA TELA
                            //
                            Navigator.pushNamed(context, 't3', arguments: null);
                          },
                          child: Text('CADASTRAR',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ),
                )
              //
              //SE NAO EXECUTA ESSE EXPANDED
              //
              : Expanded(
                  child: Column(
                    children: [
                      Text(
                        "Você está logado como " + obj.nomeuser,
                        style: TextStyle(fontSize: 30),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 20,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.grey.shade500),
                        onPressed: () {
                          FirebaseAuth.instance.signOut();
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Lancamentos(),
                            ),
                          );
                        },
                        child: Text('LOGOUT',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
          //
          //SWITCHS DE CONFIGURAÇAO
          //
          Row(
            children: [
              Switch(
                  value: swnotif,
                  onChanged: (value) {
                    swnotif = value;
                  }),
              Text('Notificações'),
            ],
          ),
          Row(
            children: [
              Switch(
                  value: swsound,
                  onChanged: (value) {
                    swsound = value;
                  }),
              Text('Sons')
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 50,
          ),
          //
          //BOTAO DAS INFORMAÇOES SOBRE
          //
          ElevatedButton(
            style: ElevatedButton.styleFrom(primary: Colors.grey.shade500),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('SOBRE'),
                      content: SizedBox(
                        height: MediaQuery.of(context).size.height / 2,
                        width: MediaQuery.of(context).size.height / 2,
                        child: Column(
                          children: [
                            ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: Image.asset('imagens/hugo.png')),
                            Text(
                                'O tema escolhido foi um catálogo virtual, podendo furamente se tornar uma loja virtual'),
                            Text(
                                'O objetivo é fornecer para os clientes uma forma de localizar os itens vendidos pela empresa através de pesquisa'),
                            Text(
                                'Aplicatico desenvolvido por Hugo Biazibetti Reis R.A. 2840482013050.'),
                            Text(
                                'Trabalho avaliativo da matéria de Programação de Dispositivos Móveis professor Rodrigo Plotz.'),
                            Text('Contato hugo.reis3@fatec.sp.gov.br')
                          ],
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            'FECHAR',
                            style: TextStyle(color: Colors.black),
                          ),
                        )
                      ],
                    );
                  });
            },
            child: Text('SOBRE',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold)),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 50,
          )
        ],
      ),
    );
  }

  void login(email, senha, Obj objeto) {
    FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: senha)
        .then((value) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(value.user!.uid)
          .get()
          .then((value) {
        objeto.nomeuser = value.data()!['nome'];
        Navigator.of(context).pushReplacementNamed('t2', arguments: objeto);
      });
    }).catchError((erro) {
      var mensagem = '';
      if (erro.code == 'user-not-found') {
        mensagem = 'ERRO: Usuário não encontrado';
      } else if (erro.code == 'wrong-password') {
        mensagem = 'ERRO: Senha incorreta';
      } else if (erro.code == 'invalid-email') {
        mensagem = 'ERRO: Email inválido';
      } else {
        mensagem = erro.message;
      }

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(mensagem), duration: const Duration(seconds: 2)));
    });
  }
}
