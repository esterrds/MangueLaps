//lista de carros e contador
class Car {
  Car.fromJson(
    this.numeroDoCarro,
    this.nomeDaEquipe,
  );

  int _numeroDeVoltas = 0;
  final int numeroDoCarro;
  final String nomeDaEquipe;

  int getVoltas() => _numeroDeVoltas;

  void increment() {
    if (_numeroDeVoltas >= 300) {
      _numeroDeVoltas = 300;
    } else {
      _numeroDeVoltas++;
    }
  }

  void decrement() {
    if (_numeroDeVoltas <= 0) {
      _numeroDeVoltas = 0;
    } else {
      _numeroDeVoltas--;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'equipe': nomeDaEquipe,
      'numero': numeroDoCarro.toString(),
      'voltas': _numeroDeVoltas.toString()
    };
  }
}
