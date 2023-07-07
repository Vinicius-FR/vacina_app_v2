import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/JwtService.dart';
import '../models/Pessoa.dart';
import 'Vacinas.dart';
import 'Login.dart';

class PessoaSelecionaPage extends StatefulWidget {
  const PessoaSelecionaPage({super.key});

  @override
  _PessoaSelecionaState createState() => _PessoaSelecionaState();
}

class _PessoaSelecionaState extends State<PessoaSelecionaPage> {
  List<Pessoa>? items = [];

  _PessoaSelecionaState() {
    load();
  }

  Future load() async {
    var arr = await JwtService().pessoas();
    if (arr["status"] == "success") {
      setState(() {
        items = arr['data'];
      });
    }
    if (arr["status"] == "token expirou") {
      setState(() {
        items = null;
      });
    }
    if (arr["message"] != "") {
      displayDialog(context, "Atenção", arr["message"]);
    }
  }

  void displayDialog(context, title, text) => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(title),
          content: Text(text),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Fechar"),
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(
                    Colors.blue), // Cor do texto do botão
              ),
            )
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    if (items == null) {
      const LoginPage().acaoLogout(context);
      return Container();
    }
    return Scaffold(
      body: ListView.builder(
        itemCount: items?.length ?? 0,
        itemBuilder: (context, index) {
          return Card(
            color: Colors.lightBlue.withOpacity(0.6),
            elevation: 10,
            child: ListTile(
              title: Text(items?[index].nome ?? ''),
              subtitle: Text(DateFormat("dd/MM/yyyy")
                  .format(items?[index].dtNasc ?? DateTime(0))),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VacinasPage(
                        codPessoa: items?[index].codPessoa,
                        nome: items?[index].nome),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
