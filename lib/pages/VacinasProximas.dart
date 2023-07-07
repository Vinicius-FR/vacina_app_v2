import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/JwtService.dart';
import '../models/VacinaProxima.dart';
import 'Login.dart';

class VacinasProximasPage extends StatefulWidget {
  final String? codPessoa;

  const VacinasProximasPage({super.key, this.codPessoa});

  @override
  _VacinasProximasPageState createState() =>
      _VacinasProximasPageState(codPessoa ?? '');
}

class _VacinasProximasPageState extends State<VacinasProximasPage> {
  List<VacinaProxima>? items = [];
  final List<Color> colors = [
    Colors.yellow.withOpacity(0.5),
    Colors.red.withOpacity(0.5),
    Colors.red.withOpacity(0.9),
  ];
  final List<String> situacao = ["", " (Tomar já)", " (Atrasada)"];

  _VacinasProximasPageState(String codPessoa) {
    load(codPessoa);
  }

  Future load(String codPessoa) async {
    var arr = await JwtService().vacinasProximas(codPessoa);
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

  int getSituacao(DateTime d1, DateTime d2) {
    int diff1 = d1.difference(DateTime.now()).inDays;
    int diff2 = d2.difference(DateTime.now()).inDays;
    // Atrasda
    if (diff1 < 0 && diff2 < 0) return 2;
    // Em tempo
    if (diff1 < 0 && diff2 >= 0) return 1;
    // No futuro
    return 0;
  }

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
          var indexSituacao = getSituacao(items?[index].data ?? DateTime(0),
              items?[index].dataMax ?? DateTime(0));
          return Card(
            color: colors[indexSituacao],
            elevation: 10,
            child: ListTile(
              title: Text(items?[index].vacina ?? ''),
              subtitle: Text(
                  "${"Tomar em " + DateFormat("dd/MM/yyyy").format(items?[index].data ?? DateTime(0))} - Dose ${items?[index].dose ?? ''}${situacao[indexSituacao]}"),
            ),
          );
        },
      ),
    );
  }
}
