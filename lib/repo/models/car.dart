class Car {
  Car(
    this.numeroDoCarro,
    this.nomeDaEquipe,
  );

  int _numeroDeVoltas = 0;
  final int numeroDoCarro;
  final String nomeDaEquipe;

  int getVoltas() => _numeroDeVoltas;

  void increment() {
    _numeroDeVoltas++;
  }

  void decrement() {
    _numeroDeVoltas--;
  }
}
