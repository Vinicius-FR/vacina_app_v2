import 'package:flutter/material.dart';

import '../AppConfig.dist.dart';
//import 'package:url_launcher/url_launcher.dart';

class Politicas extends StatefulWidget {
  const Politicas({super.key});

  @override
  _PoliticasState createState() => _PoliticasState();
}

class _PoliticasState extends State<Politicas> {
  /*
  launchURL() async {
    const url =
        'https://juarez.sesa.fsp.usp.br/vacina-app/politica_privacidade.html';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
  */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(AppConfig.appTitle),
        ),
        /*
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                onPressed: launchURL,
                child: Text('Exibir políticas'),
                color: Colors.blue.withOpacity(0.4),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 150.0),
              ),
            ],
          ),
        ),
        */
        body: Container(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: const <Widget>[
              Text('Política de privacidade',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              SizedBox(
                height: 10,
              ),
              Text(
                'Última modificação: 04 de maio de 2020.',
                style: TextStyle(fontStyle: FontStyle.italic, fontSize: 12),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                  'O aplicativo "Minhas vacinas em dia" permite o acesso da população às informações disponíveis na caderneta de vacinação relativas à data que a dose da vacina foi aplicada e data prevista das próximas doses, destacando as doses que estão atrasadas. O aplicativo também possibilita o recebimento de alertas considerados importantes no calendário de vacinação, tais como datas e locais de campanhas de vacinação. Essa tecnologia beneficia qualquer usuário, em especial as mães e responsáveis pelas crianças, fortalecendo o vínculo dos usuários com os serviços de saúde.'),
              SizedBox(
                height: 10,
              ),
              Text(
                '1. Informações que coletamos',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(
                height: 10,
              ),
              Text('A única informação coletada é o CPF.'),
              SizedBox(
                height: 10,
              ),
              Text(
                '2. Como utilizamos suas informações',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                  'Seu CPF é utilizado para dar acesso ao aplicativo. As informações relacionadas ao seu CPF são tratadas de forma confidencial e usadas exclusivamente pela USP para executar as funções do aplicativo.'),
              SizedBox(
                height: 10,
              ),
              Text(
                '3. Compartilhamento de suas informações',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                  'Suas informações não são compartilhadas com nenhuma pessoa ou empresa fora da USP nem tão pouco com pessoas da USP que não estejam envolvidas no seu atendimento.'),
              SizedBox(
                height: 10,
              ),
              Text(
                '4. Como armazenamos suas informações',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                  'As informações coletadas são armazenadas nos servidores corporativos da USP mandendo assim a atualização da caderneta de vacinação.'),
              SizedBox(
                height: 10,
              ),
              Text(
                '5. Como entrar em contato conosco',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                  'Se tiver qualquer dúvida sobre esta Política de Privacidade ou sobre o aplicativo, utilize o canal de suporte descrito na página do aplicativo do Google Play e Apple Store.'),
              SizedBox(
                height: 10,
              ),
              Text(
                '6. Alterações em nossa política de privacidade',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                  'A USP pode modificar ou atualizar esta Política de Privacidade se necessário, portanto verifique-a periodicamente. A continuidade de uso do aplicativo após qualquer modificação implicará no aceite do mesmo.'),
            ],
          ),
        ));
  }
}
