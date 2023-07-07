class Mensagem {
  late String id;
  late String titulo;
  late String mensagem;
  late DateTime dataCriacao;

  Mensagem.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    titulo = json['titulo'];
    mensagem = json['mensagem'];
    dataCriacao = DateTime.parse(json['data_criacao']);
  }
}
