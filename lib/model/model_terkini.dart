class ModelTerkini {
  String? strTanggal;
  String? strJam;
  String? strDateTime;
  String? strCoordinates;
  String? strLintang;
  String? strBujur;
  String? strMagnitude;
  String? strKedalaman;
  String? strWilayah;
  String? strPotensi;
  String? strDirasakan;
  String? strShakemap;

  ModelTerkini(
      {this.strTanggal,
      this.strJam,
      this.strDateTime,
      this.strCoordinates,
      this.strLintang,
      this.strBujur,
      this.strMagnitude,
      this.strKedalaman,
      this.strWilayah,
      this.strPotensi,
      this.strDirasakan,
      this.strShakemap});

  ModelTerkini.fromJson(Map<String, dynamic> json) {
    strTanggal = json['gempa']['Tanggal'].toString();
    strJam = json['gempa']['Jam'].toString();
    strDateTime = json['gempa']['DateTime'].toString();
    strCoordinates = json['gempa']['Coordinates'].toString();
    strLintang = json['gempa']['Lintang'].toString();
    strBujur = json['gempa']['Bujur'].toString();
    strMagnitude = json['gempa']['Magnitude'].toString();
    strKedalaman = json['gempa']['Kedalaman'].toString();
    strWilayah = json['gempa']['Wilayah'].toString();
    strPotensi = json['gempa']['Potensi'].toString();
    strDirasakan = json['gempa']['Dirasakan'].toString();
    strShakemap = json['gempa']['Shakemap'].toString();
  }

  static List<ModelTerkini> fromJsonList(List list) {
    if (list.isEmpty) return List<ModelTerkini>.empty();
    return list.map((item) => ModelTerkini.fromJson(item)).toList();
  }
}
