import 'package:flutter/material.dart';
import 'package:vacina_app_v2/AppConfig.dist.dart';
import 'Politicas.dart';
import 'AlterarSenha.dart';
import 'Login.dart';
import 'PessoaMensagem.dart';
import 'PessoaSeleciona.dart';

enum MenuAcoes { politicas, alterar_senha, sair }

class PessoaPage extends StatefulWidget {
  const PessoaPage({super.key});

  @override
  _PessoaPageState createState() => _PessoaPageState();
}

class _PessoaPageState extends State<PessoaPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(AppConfig.appTitle),
          automaticallyImplyLeading: false, // Retira botao back
          actions: <Widget>[
            PopupMenuButton<MenuAcoes>(
              itemBuilder: (BuildContext context) {
                return [
                  const PopupMenuItem<MenuAcoes>(
                    value: MenuAcoes.politicas,
                    child: Text('Política de Privacidade'),
                  ),
                  const PopupMenuItem<MenuAcoes>(
                    value: MenuAcoes.alterar_senha,
                    child: Text('Alterar senha'),
                  ),
                  const PopupMenuItem<MenuAcoes>(
                    value: MenuAcoes.sair,
                    child: Text('Sair'),
                  ),
                ];
              },
              onSelected: (MenuAcoes result) {
                switch (result) {
                  case MenuAcoes.politicas:
                    {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Politicas(),
                        ),
                      );
                    }
                    break;
                  case MenuAcoes.alterar_senha:
                    {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AlterarSenhaPage(),
                        ),
                      );
                    }
                    break;
                  case MenuAcoes.sair:
                    {
                      const LoginPage().acaoLogout(context);
                    }
                    break;
                }
              },
            )
          ],
          bottom: const TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.perm_identity),
                text: 'Pessoas',
              ),
              Tab(
                icon: Icon(Icons.mail_outline),
                text: 'Mensagens',
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            PessoaSelecionaPage(),
            PessoaMensagemPage(),
          ],
        ),
      ),
    );
  }
}
