class ModelWallet {
  late int id;
  late String numero, type;
  late int status;

  ModelWallet(this.id, this.numero, this.type, this.status);

  static ModelWallet fromJson(Map<String, dynamic> json) => ModelWallet(
      json['id'], json['numero'], json['type'], int.parse(json['status']));
}
