import 'package:flutter/material.dart';
import 'package:vacina_app_v2/AppConfig.dist.dart';
import '../services/JwtService.dart';

import 'Pessoa.dart';

class AlterarSenhaPage extends StatelessWidget {
  final novaSenhaController = TextEditingController();
  final novaSenhaConfirmarController = TextEditingController();

  AlterarSenhaPage({super.key});

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

  void alterarSenha(BuildContext context) async {
    if (novaSenhaController.text == novaSenhaConfirmarController.text) {
      var arr = await JwtService().alterarSenha(novaSenhaController.text);
      if (arr["status"] == "success") {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const PessoaPage(),
          ),
          (Route<dynamic> route) => false,
        );
      } else {
        displayDialog(context, "Atenção", arr["message"]);
      }
    } else {
      displayDialog(context, "Atenção", "As senhas não são iguais!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(AppConfig.appTitle),
        ),
        body: Container(
            padding: const EdgeInsets.only(top: 60, left: 40, right: 40),
            child: ListView(children: <Widget>[
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Alterar Senha",
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                // autofocus: true,
                keyboardType: TextInputType.text,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Nova senha",
                  labelStyle: TextStyle(
                    color: Colors.black38,
                    fontWeight: FontWeight.w400,
                    fontSize: 20,
                  ),
                ),
                style: const TextStyle(fontSize: 20),
                controller: novaSenhaController,
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                // autofocus: true,
                keyboardType: TextInputType.text,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Confirme a nova senha",
                  labelStyle: TextStyle(
                    color: Colors.black38,
                    fontWeight: FontWeight.w400,
                    fontSize: 20,
                  ),
                ),
                style: const TextStyle(fontSize: 20),
                controller: novaSenhaConfirmarController,
              ),
              TextButton(
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all<Color>(
                      Colors.blue), // Cor do texto do botão
                ),
                onPressed: () {
                  alterarSenha(context);
                },
                child: const Text(
                  "Enviar",
                ),
              ),
            ])));
  }
}
