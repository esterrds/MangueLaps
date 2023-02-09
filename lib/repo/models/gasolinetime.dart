class GasolineTime {
  GasolineTime.fromJson(Map<String, dynamic> json)
      : tempoGasolina = json['tempoGasolina'],
        gasolina = json['gasolina'];

  GasolineTime({required this.tempoGasolina, required this.gasolina});
  String tempoGasolina = '00:00:00';
  late int idTG;
  bool gasolina = true;
  String abastecendo = '';

  void fuel() {
    if (gasolina == true) {
      abastecendo = 'Não';
    } else {
      abastecendo = 'Sim';
    }
  }

  Map<String, dynamic> toJson() {
    return {'tempoGasolina': tempoGasolina, 'abastecendo': abastecendo};
  }

  @override
  String toString() {
    return '{tempo: $tempoGasolina, abastecendo: $abastecendo}';
  }
}