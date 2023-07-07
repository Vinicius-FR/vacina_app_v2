class Pessoa {
  String? codPessoa;
  String? nome;
  DateTime? dtNasc;

  Pessoa.fromJson(Map<String, dynamic> json) {
    codPessoa = json['id'].toString();
    nome = json['nome'];
    dtNasc = DateTime.parse(json['dt_nasc']);
  }
}
