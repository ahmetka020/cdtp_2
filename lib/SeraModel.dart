class SeraModel{
  int _seraId;
  var _temperature;
  String result;


  int get temperature => _temperature;

  set temperature(int value) {
    if(value == null){
      return;
    }
    _temperature = value;
  }

  int get seraId => _seraId;

  set seraId(int value) {
    _seraId = value;
  }
  SeraModel({seraId, temperature});
  factory SeraModel.fromJson(Map<String, dynamic> json) {
    return SeraModel(
      seraId: json['seraId'],
      temperature: json['temperature'],
    );
  }
}