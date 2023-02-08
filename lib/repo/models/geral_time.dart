class GeralTime {
  GeralTime.fromJson(Map<String, dynamic> json) : tempo = json['tempoGeral'];

  GeralTime({required this.tempo});
  String tempo = '00:00:00';
  late int id;

  Map<String, dynamic> toJson() {
    return {'tempoGeral': tempo};
  }

  @override
  String toString() {
    return '{tempo de volta: $tempo}';
  }
}
