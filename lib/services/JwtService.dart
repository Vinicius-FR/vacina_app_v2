import 'dart:async';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import '../AppConfig.dist.dart';
import '../models/Mensagem.dart';
import '../models/Pessoa.dart';
import '../models/VacinaAplicada.dart';
import '../models/VacinaProxima.dart';

class JwtService {
  final jwtTokenKey = "jwtToken";
  final apiServerUrl = AppConfig.apiServerUrl + "/api/app-vacina";

  Future login(String username, String password) async {
    debugPrint("Contactando servidor para fazer login $apiServerUrl/login ...");
    try {
      var res = await http.post("$apiServerUrl/login",
          body: {"usuario": username, "senha": password});
      if (res.statusCode == 200) {
        var jwt = json.decode(res.body);
        var jwtToken = jwt['data'];
        var storage = FlutterSecureStorage();
        await storage.write(key: jwtTokenKey, value: jwtToken);
        debugPrint("=== JWT token ===");
        debugPrint(jwtToken);
        return {'status': 'success', "message": "", "data": null};
      } else {
        debugPrint("=== Erro de autenticação ===");
        debugPrint("Status: ${res.statusCode}");
        return {
          'status': 'login incorreto',
          "message": "Usuário ou Senha incorreto",
          "data": null
        };
      }
    } catch (e) {
      debugPrint('Exception Error: $e');
      return {
        'status': 'sem conexao',
        "message": "Sem conexção com a Interner",
        "data": null
      };
    }
  }

  Future logout() async {
    var storage = FlutterSecureStorage();
    await storage.delete(key: jwtTokenKey);
  }

  Future refreshLoginDate() async {
    debugPrint("Atualizando data de login...");
    try {
      var storage = FlutterSecureStorage();
      var jwtToken = await storage.read(key: jwtTokenKey);
      var res = await http.get(
        Uri.parse("$apiServerUrl/login/refreshdate"),
        headers: {HttpHeaders.authorizationHeader: jwtToken ?? ''},
      );
      if (res.statusCode == 200) {
        return {'status': 'success', "message": "", "data": null};
      }
      if (res.statusCode == 404 || res.statusCode == 500) {
        // token expirou ou usuário não encontrado
        debugPrint('token expirou');
        return {
          'status': 'token expirou',
          "message": "Faça novo login",
          "data": null
        };
      }
    } catch (e) {
      debugPrint('Exception Error: $e');
      return {
        'status': 'sem conexao',
        "message": "Sem conexção com a Interner",
        "data": null
      };
    }
    return {'status': 'error', "message": "Erro desconhecido", "data": null};
  }

  Future alterarSenha(String novaSenha) async {
    debugPrint("Contactando servidor para alterar senha...");
    try {
      var storage = FlutterSecureStorage();
      var jwtToken = await storage.read(key: jwtTokenKey);
      var res = await http.post("$apiServerUrl/pessoa/alterar-senha", headers: {
        HttpHeaders.authorizationHeader: jwtToken
      }, body: {
        "password": novaSenha,
      });
      debugPrint(res.body);
      debugPrint(res.statusCode.toString());
      if (res.statusCode == 200) {
        var jsonRes = json.decode(res.body);
        if (jsonRes['message'].length > 0) {
          var mensagens = jsonRes['message'].join(', ') + '.';
          return {'status': 'invalido', "message": mensagens, "data": null};
        }
        return {'status': 'success', "message": "", "data": null};
      }
      if (res.statusCode == 404 || res.statusCode == 500) {
        // token expirou ou usuário não encontrado
        return {
          'status': 'token expirou',
          "message": "Faça novo login",
          "data": null
        };
      }
    } catch (e) {
      debugPrint('Exception Error: $e');
      return {
        'status': 'sem conexao',
        "message": "Sem conexção com a Interner",
        "data": null
      };
    }
    return {'status': 'error', "message": "Erro desconhecido", "data": null};
  }

  Future sendFMC(String fmcToken) async {
    debugPrint("Enviando FMC token para o servidor...");
    //debugPrint("=== FMC token ===");
    //debugPrint(fmcToken);
    try {
      var storage = FlutterSecureStorage();
      var jwtToken = await storage.read(key: jwtTokenKey);
      var res = await http.post("$apiServerUrl/pessoa/firebase/fcm", headers: {
        HttpHeaders.authorizationHeader: jwtToken
      }, body: {
        "token": fmcToken,
      });
      if (res.statusCode == 200) {
        return true;
      }
      if (res.statusCode == 404 || res.statusCode == 500) {
        // token expirou ou usuário não encontrado
        debugPrint('token expirou');
        return null;
      }
    } catch (e) {
      print('Exception Error: $e');
    }
    return null;
  }

  Future pessoas() async {
    debugPrint("Contactando servidor para carregar pessoas...");
    try {
      var storage = FlutterSecureStorage();
      var jwtToken = await storage.read(key: jwtTokenKey);
      var res = await http.get(
        "$apiServerUrl/pessoa",
        headers: {HttpHeaders.authorizationHeader: jwtToken},
      );
      debugPrint(res.body);
      if (res.statusCode == 200) {
        var items = List<Pessoa>();
        var jsonRes = json.decode(res.body);
        jsonRes['data']?.forEach((element) {
          items.add(Pessoa.fromJson(element));
        });
        return {'status': 'success', "message": "", "data": items};
      }
      if (res.statusCode == 404 || res.statusCode == 500) {
        // token expirou ou usuário não encontrado
        debugPrint('token expirou');
        return {
          'status': 'token expirou',
          "message": "Faça novo login",
          "data": null
        };
      }
    } catch (e) {
      debugPrint('Exception Error: $e');
      return {
        'status': 'sem conexao',
        "message": "Sem conexção com a Interner",
        "data": null
      };
    }
    return {'status': 'error', "message": "Erro desconhecido", "data": null};
  }

  Future mensagens() async {
    debugPrint("Contactando servidor para carregar mensagens...");
    try {
      var storage = FlutterSecureStorage();
      var jwtToken = await storage.read(key: jwtTokenKey);
      var res = await http.get(
        "$apiServerUrl/pessoa/mensagens",
        headers: {HttpHeaders.authorizationHeader: jwtToken},
      );
      //debugPrint(res.body);
      if (res.statusCode == 200) {
        var items = List<Mensagem>();
        var jsonRes = json.decode(res.body);
        jsonRes['data']?.forEach((element) {
          items.add(Mensagem.fromJson(element));
        });
        return {'status': 'success', "message": "", "data": items};
      }
      if (res.statusCode == 404 || res.statusCode == 500) {
        // token expirou ou usuário não encontrado
        debugPrint('token expirou');
        return {
          'status': 'token expirou',
          "message": "Faça novo login",
          "data": null
        };
      }
    } catch (e) {
      debugPrint('Exception Error: $e');
      return {
        'status': 'sem conexao',
        "message": "Sem conexção com a Interner",
        "data": null
      };
    }
    return {'status': 'error', "message": "Erro desconhecido", "data": null};
  }

  Future vacinasProximas(String codPessoa) async {
    debugPrint(
        "Contactando servidor para carregar proximas vacinas de $codPessoa...");
    try {
      var storage = FlutterSecureStorage();
      var jwtToken = await storage.read(key: jwtTokenKey);
      var res = await http.get(
        "$apiServerUrl/pessoa/proximas/$codPessoa",
        headers: {HttpHeaders.authorizationHeader: jwtToken},
      );
      //debugPrint(res.body);
      if (res.statusCode == 200) {
        var items = List<VacinaProxima>();
        var jsonRes = json.decode(res.body);
        jsonRes['data']?.forEach((element) {
          items.add(VacinaProxima.fromJson(element));
        });
        return {'status': 'success', "message": "", "data": items};
      }
      if (res.statusCode == 404 || res.statusCode == 500) {
        // token expirou ou usuário não encontrado
        debugPrint('token expirou');
        return {
          'status': 'token expirou',
          "message": "Faça novo login",
          "data": null
        };
      }
    } catch (e) {
      debugPrint('Exception Error: $e');
      return {
        'status': 'sem conexao',
        "message": "Sem conexção com a Interner",
        "data": null
      };
    }
    return {'status': 'error', "message": "Erro desconhecido", "data": null};
  }

  Future vacinasAplicadas(String codPessoa) async {
    debugPrint(
        "Contactando servidor para carregar vacinas aplicadas de $codPessoa...");
    try {
      var storage = FlutterSecureStorage();
      var jwtToken = await storage.read(key: jwtTokenKey);
      var res = await http.get(
        "$apiServerUrl/pessoa/aplicadas/$codPessoa",
        headers: {HttpHeaders.authorizationHeader: jwtToken},
      );
      debugPrint(res.body);
      if (res.statusCode == 200) {
        var items = List<VacinaAplicada>();
        var jsonRes = json.decode(res.body);
        jsonRes['data']?.forEach((element) {
          items.add(VacinaAplicada.fromJson(element));
        });
        return {'status': 'success', "message": "", "data": items};
      }
      if (res.statusCode == 404 || res.statusCode == 500) {
        // token expirou ou usuário não encontrado
        debugPrint('token expirou');
        return {
          'status': 'token expirou',
          "message": "Faça novo login",
          "data": null
        };
      }
    } catch (e) {
      debugPrint('Exception Error: $e');
      return {
        'status': 'sem conexao',
        "message": "Sem conexção com a Interner",
        "data": null
      };
    }
    return {'status': 'error', "message": "Erro desconhecido", "data": null};
  }
}
