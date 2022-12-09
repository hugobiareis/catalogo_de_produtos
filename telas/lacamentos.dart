import 'package:flutter/material.dart';

import 'telacarrinho.dart';
import 'telaconfiguracoes.dart';
import 'telahome.dart';
import 'telapesquisar.dart';

class Lancamentos extends StatefulWidget {
  const Lancamentos({Key? key}) : super(key: key);

  @override
  _LancamentosState createState() => _LancamentosState();
}

class _LancamentosState extends State<Lancamentos> {
//
//CONFIGURAÇÕES DO BOTTOM NAVIGATOR BAR
//
  var telaAtual = 0;
  var pageController = PageController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pageController,
        children: const [
          TelaHome(),
          TelaPesquisar(),
          TelaCarrinho(),
          TelaConfiguracoes()
        ],
        onPageChanged: (index) {
          setState(() {
            telaAtual = index;
          });
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.grey.shade700,
        iconSize: 40,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white.withOpacity(.4),
        selectedFontSize: 16,
        unselectedFontSize: 16,
        currentIndex: telaAtual,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.search_outlined), label: 'Pesquisar'),
          BottomNavigationBarItem(
              icon: Icon(Icons.edit_outlined), label: 'Editar'),
              //icon: Icon(Icons.shopping_cart_outlined), label: 'Orçamento'),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings_outlined), label: 'Configurações'),
        ],
        onTap: (index) {
            telaAtual = index;
          pageController.animateToPage(index,
              duration: Duration(microseconds: 300), curve: Curves.easeIn);
        },
      ),
    );
  }
}