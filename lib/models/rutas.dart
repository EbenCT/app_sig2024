class RouteData {
  final int bsrutnrut;
  final String bsrutdesc;
  final String bsrutabrv;
  final int bsruttipo;
  final int bsrutnzon;
  final String bsrutfcor;
  final int bsrutcper;
  final int bsrutstat;
  final int bsrutride;
  final String dNomb;
  final int gbzonNzon;
  final String dNzon;

  RouteData({
    required this.bsrutnrut,
    required this.bsrutdesc,
    required this.bsrutabrv,
    required this.bsruttipo,
    required this.bsrutnzon,
    required this.bsrutfcor,
    required this.bsrutcper,
    required this.bsrutstat,
    required this.bsrutride,
    required this.dNomb,
    required this.gbzonNzon,
    required this.dNzon,
  });

  factory RouteData.fromXml(Map<String, dynamic> data) {
    return RouteData(
      bsrutnrut: int.parse(data['bsrutnrut'] ?? '0'),
      bsrutdesc: data['bsrutdesc'] ?? '',
      bsrutabrv: data['bsrutabrv'] ?? '',
      bsruttipo: int.parse(data['bsruttipo'] ?? '0'),
      bsrutnzon: int.parse(data['bsrutnzon'] ?? '0'),
      bsrutfcor: data['bsrutfcor'] ?? '',
      bsrutcper: int.parse(data['bsrutcper'] ?? '0'),
      bsrutstat: int.parse(data['bsrutstat'] ?? '0'),
      bsrutride: int.parse(data['bsrutride'] ?? '0'),
      dNomb: data['dNomb'] ?? '',
      gbzonNzon: int.parse(data['GbzonNzon'] ?? '0'),
      dNzon: data['dNzon'] ?? '',
    );
  }
}
