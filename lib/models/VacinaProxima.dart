class VacinaProxima {
  String? vacina;
  String? dose;
  DateTime? data;
  DateTime? dataMax;

  VacinaProxima.fromJson(Map<String, dynamic> json) {
    vacina = json['vacina'];
    dose = json['dose'];
    data = DateTime.parse(json['data']);
    dataMax = DateTime.parse(json['data_max']);
  }
}
