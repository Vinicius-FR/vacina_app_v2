import 'package:flutter/material.dart';
import 'package:vacina_app_v2/AppConfig.dist.dart';
import 'package:vacina_app_v2/pages/Politicas.dart';
import 'package:vacina_app_v2/services/FireBaseService.dart';
import '../services/JwtService.dart';
import 'Pessoa.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();

  void acaoLogout(BuildContext context) async {
    await JwtService().logout();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginPage(),
      ),
      (Route<dynamic> route) => false,
    );
  }
}

class _LoginPageState extends State<LoginPage> {
  final loginController = TextEditingController();
  final senhaController = TextEditingController();
  bool? loggedin;

  @override
  void initState() {
    checkLoginState().then((value) {
      // terminou o async redesenha a tela
      setState(() {});
    });
    super.initState();
  }

  Future checkLoginState() async {
    final storage = FlutterSecureStorage();
    var jwtToken = await storage.read(key: "jwtToken");
    loggedin = false;
    if (jwtToken != null) {
      loggedin = true;
    }
  }

  Future acaoLogin() async {
    var arr =
        await JwtService().login(loginController.text, senhaController.text);
    if (arr["status"] == "success") {
      // configura comunicação com Firebase
      PushNotificacaoService pushNotification = PushNotificacaoService();
      pushNotification.initNotificacao();
      // informando servidor a chave FMC
      pushNotification.sendFMC();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const PessoaPage(),
        ),
        (Route<dynamic> route) => false,
      );
    } else {
      displayDialog(context, "Atenção", arr['message']);
    }
  }

  Widget doLogin() {
    if (loggedin == true) {
      // configura comunicação com Firebase
      PushNotificacaoService pushNotification = PushNotificacaoService();
      pushNotification.initNotificacao();
      // Atualiza data de login
      JwtService().refreshLoginDate();
      // Vai para a página de pessao
      return const PessoaPage();
    }
    return Container();
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
    if (loggedin == true) {
      return doLogin();
    }
    if (loggedin == null) {
      return const Scaffold(
        body: Center(
          child: Text("Carregando..."),
        ),
      );
    }
    return Scaffold(
        appBar: AppBar(
          title: const Text(AppConfig.appTitle),
        ),
        body: Container(
            padding: const EdgeInsets.only(top: 60, left: 40, right: 40),
            child: ListView(children: <Widget>[
              Center(
                child: SizedBox(
                  width: 100,
                  child: Image.asset("lib/assets/logo.png"),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                // autofocus: true,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Usuário",
                  labelStyle: TextStyle(
                    color: Colors.black38,
                    fontWeight: FontWeight.w400,
                    fontSize: 20,
                  ),
                ),
                style: const TextStyle(fontSize: 20),
                controller: loginController,
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                // autofocus: true,
                keyboardType: TextInputType.text,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Senha",
                  labelStyle: TextStyle(
                    color: Colors.black38,
                    fontWeight: FontWeight.w400,
                    fontSize: 20,
                  ),
                ),
                style: const TextStyle(fontSize: 20),
                controller: senhaController,
              ),
              TextButton(
                child: const Text(
                  "Entrar",
                ),
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all<Color>(
                      Colors.blue), // Cor do texto do botão
                ),
                onPressed: () async {
                  await acaoLogin();
                },
              ),
              TextButton(
                child: const Text(
                  "Política de privacidade",
                ),
                onPressed: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Politicas(),
                    ),
                  );
                },
              ),
            ])));
  }
}
