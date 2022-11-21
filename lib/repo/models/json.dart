// //classe das equipes, onde serão recebidos os dados de registro e número de voltas
class JoaoManjador {
  int? nDoCarro;
  String? team;
  int? nDeVoltas;

  JoaoManjador({this.nDoCarro, this.team, this.nDeVoltas});

  JoaoManjador.fromJson(Map<String, dynamic> json) {
    nDoCarro = json['nDoCarro'];
    team = json['team'];
    nDeVoltas = json['nDeVoltas'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nDoCarro'] = this.nDoCarro;
    data['team'] = this.team;
    data['nDeVoltas'] = this.nDeVoltas;
    return data;
  }
}
