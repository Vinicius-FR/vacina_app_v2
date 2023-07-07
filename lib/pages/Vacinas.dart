import 'package:flutter/material.dart';
import 'VacinasAplicadas.dart';
import 'VacinasProximas.dart';

class VacinasPage extends StatelessWidget {
  final String? codPessoa;
  final String? nome;
  VacinasPage({this.codPessoa, this.nome});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(nome ?? ''),
          bottom: TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.event),
                text: 'Próximas',
              ),
              Tab(
                icon: Icon(Icons.event_available),
                text: 'Aplicadas',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            VacinasProximasPage(codPessoa: codPessoa),
            VacinasAplicadasPage(codPessoa: codPessoa),
          ],
        ),
      ),
    );
  }
}
