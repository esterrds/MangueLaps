//lista de carros e contador
class Car {
  Car.fromJson(
    this.numeroDoCarro,
    this.nomeDaEquipe,
  );

  int _numeroDeVoltas = 0;
  final int numeroDoCarro;
  final String nomeDaEquipe;

  Car(this._numeroDeVoltas, this.nomeDaEquipe, this.numeroDoCarro);

  int getVoltas() => _numeroDeVoltas;

  void increment() {
    if (_numeroDeVoltas >= 300) {
      _numeroDeVoltas = 300;
    } else {
      _numeroDeVoltas++;
    }
    this._numeroDeVoltas = _numeroDeVoltas;
    print("carro: ${this.numeroDoCarro}, voltas: ${this._numeroDeVoltas}");
  }

  void decrement() {
    if (_numeroDeVoltas <= 0) {
      _numeroDeVoltas = 0;
    } else {
      _numeroDeVoltas--;
    }
    this._numeroDeVoltas = _numeroDeVoltas;
    print("carro: ${this.numeroDoCarro}, voltas: ${this._numeroDeVoltas}");
  }

  Map<String, dynamic> toJson() {
    return {
      'equipe': nomeDaEquipe,
      'numero': numeroDoCarro.toString(),
      'voltas': _numeroDeVoltas.toString()
    };
  }

  @override
  String toString() {
    // TODO: implement toString
    return "Equipes: {carro: ${this.numeroDoCarro}, equipe: ${this.nomeDaEquipe}, voltas: ${this._numeroDeVoltas}}";
  }
}
