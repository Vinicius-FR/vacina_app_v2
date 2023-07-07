import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/VacinaAplicada.dart';
import '../services/JwtService.dart';
import 'Login.dart';

class VacinasAplicadasPage extends StatefulWidget {
  final String? codPessoa;

  const VacinasAplicadasPage({super.key, this.codPessoa});

  @override
  _VacinasAplicadasPageState createState() =>
      _VacinasAplicadasPageState(codPessoa ?? '');
}

class _VacinasAplicadasPageState extends State<VacinasAplicadasPage> {
  List<VacinaAplicada>? items = [];

  _VacinasAplicadasPageState(String codPessoa) {
    load(codPessoa);
  }

  Future load(String codPessoa) async {
    var arr = await JwtService().vacinasAplicadas(codPessoa);
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
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(
                    Colors.blue), // Cor do texto do botão
              ),
              child: const Text("Fechar"),
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
            color: Colors.green.withOpacity(0.4),
            elevation: 10,
            child: ListTile(
              title: Text(items?[index].vacina ?? ''),
              subtitle: Text(DateFormat("dd/MM/yyyy")
                      .format(items?[index].data ?? DateTime(0)) +
                  " - Dose " +
                  (items?[index].dose ?? '')),
            ),
          );
        },
      ),
    );
  }
}
