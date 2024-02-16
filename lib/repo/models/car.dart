class Carro {
  Carro.fromJson(Map<String, dynamic> json)
      : nome = json['nome'],
        numero = json['numero'] ?? 123,
        voltas = json['voltas'],
        tipo = json['tipo'] ?? false;

  Carro(
      {required this.nome,
      required this.numero,
      required this.voltas,
      required this.tipo});
  String nome;
  int numero;
  int voltas = 0;
  bool tipo;

  int getVoltas() => voltas;

  void increment() {
    if (voltas >= 300) {
      voltas = 300;
    } else {
      voltas++;
    }
    //print("equipe: $nome, voltas: $voltas");
  }

  void decrement() {
    if (voltas <= 0) {
      voltas = 0;
    } else {
      voltas--;
    }
    //print("equipe: $nome, voltas: $voltas");
  }

  @override
  String toString() {
    return "{carro: $numero, equipe: $nome, voltas: $voltas}";
  }

  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'numero': numero,
      'voltas': getVoltas(),
      'tipo': tipo
    };
  }
}
