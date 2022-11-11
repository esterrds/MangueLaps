class User {
  dynamic numero;
  dynamic nome;
  int voltas = 0;

  User({this.numero, this.nome});

  User.fromJson(Map<String, dynamic> json) {
    numero = json['numero'];
    nome = json['nome'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['numero'] = this.numero;
    data['nome'] = this.nome;
    return data;
  }

  @override
  String toString() {
    return "Nome: " + this.nome + "\nNº: " + this.numero;
  }
}
