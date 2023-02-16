class GasolineTime {
  GasolineTime.fromJson(Map<String, dynamic> json)
      : tempoGasolina = json['tempoGasolina'],
        gasolina = json['gasolina'] ?? true;

  GasolineTime({required this.tempoGasolina});
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
    return {'tempoGasolina': tempoGasolina};
  }

  @override
  String toString() {
    return '{tempo: $tempoGasolina}';
  }
}
