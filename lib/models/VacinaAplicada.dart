class VacinaAplicada {
  String? vacina;
  String? dose;
  DateTime? data;

  VacinaAplicada.fromJson(Map<String, dynamic> json) {
    vacina = json['vacina'];
    dose = json['dose'];
    data = DateTime.parse(json['data']);
  }
}
