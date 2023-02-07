class BreakTime {
  BreakTime.fromJson(Map<String, dynamic> json)
      : tempoBox = json['tempoBox'],
        idTB = json['idTB'],
        quebrado = json['quebrado'];

  BreakTime({required this.tempoBox, required this.isbreak});
  String tempoBox = '00:00:00';
  late int idTB;
  bool isbreak = false;
  String quebrado = '';

  void isBreak() {
    if (isbreak == false) {
      quebrado = 'Não';
    } else {
      quebrado = 'Sim';
    }
  }

  Map<String, dynamic> toJson() {
    return {'tempoBox': tempoBox, 'numero': idTB, 'quebrado': quebrado};
  }
}
