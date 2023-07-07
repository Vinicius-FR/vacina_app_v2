import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/JwtService.dart';
import '../models/Mensagem.dart';
import 'Login.dart';

class PessoaMensagemPage extends StatefulWidget {
  const PessoaMensagemPage({super.key});

  @override
  _PessoaMensagensState createState() => _PessoaMensagensState();
}

class _PessoaMensagensState extends State<PessoaMensagemPage> {
  List<Mensagem>? items = [];

  _PessoaMensagensState() {
    load();
  }

  Future load() async {
    var arr = await JwtService().mensagens();
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
            color: Colors.blueGrey.withOpacity(0.1),
            elevation: 2,
            child: Column(
              children: <Widget>[
                Container(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          items?[index].titulo ?? '',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ))),
                Container(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(items?[index].mensagem ?? ''))),
                Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      DateFormat("dd/MM/yyyy")
                          .format(items?[index].dataCriacao ?? DateTime(0)),
                      style: const TextStyle(fontSize: 10),
                    )),
              ],
            ),
          );
        },
      ),
    );
  }
}
