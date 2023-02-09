// //lista de carros e contador
// class Car {
//   int _numeroDeVoltas = 0;
//   final int numeroDoCarro;
//   final String nomeDaEquipe;

//   Car(this.nomeDaEquipe, this.numeroDoCarro);

//   int getVoltas() => _numeroDeVoltas;

//   void increment() {
//     if (_numeroDeVoltas >= 300) {
//       _numeroDeVoltas = 300;
//     } else {
//       _numeroDeVoltas++;
//     }
//     _numeroDeVoltas = _numeroDeVoltas;
//     print("carro: $numeroDoCarro, voltas: $_numeroDeVoltas");
//   }

//   void decrement() {
//     if (_numeroDeVoltas <= 0) {
//       _numeroDeVoltas = 0;
//     } else {
//       _numeroDeVoltas--;
//     }
//     _numeroDeVoltas = _numeroDeVoltas;
//     print("carro: $numeroDoCarro, voltas: $_numeroDeVoltas");
//   }

//   @override
//   String toString() {
//     return "{carro: $numeroDoCarro, equipe: $nomeDaEquipe, voltas: $_numeroDeVoltas}";
//   }
// }
