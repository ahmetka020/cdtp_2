class SeraModel{
  int _seraId;
  int _temperature;



  int get temperature => _temperature;

  set temperature(int value) {
    if(value >= 0 && value <= 255)
      _temperature = value;
    else if (value < 0)
      _temperature = 0;
    else
      _temperature = 255;
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