class CutPoint {
  final int bscocNcoc;
  final int bscntCodf;
  final int bscocNcnt;
  final String dNomb;
  final int bscocNmor;
  final double bscocImor;
  final String bsmednser;
  final String bsmedNume;
  final double bscntlati;
  final double bscntlogi;
  final String dNcat;
  final String dCobc;
  final String dLotes;

  CutPoint({
    required this.bscocNcoc,
    required this.bscntCodf,
    required this.bscocNcnt,
    required this.dNomb,
    required this.bscocNmor,
    required this.bscocImor,
    required this.bsmednser,
    required this.bsmedNume,
    required this.bscntlati,
    required this.bscntlogi,
    required this.dNcat,
    required this.dCobc,
    required this.dLotes,
  });

  factory CutPoint.fromXml(Map<String, dynamic> data) {
    return CutPoint(
      bscocNcoc: int.parse(data['bscocNcoc'] ?? '0'),
      bscntCodf: int.parse(data['bscntCodf'] ?? '0'),
      bscocNcnt: int.parse(data['bscocNcnt'] ?? '0'),
      dNomb: data['dNomb'] ?? '',
      bscocNmor: int.parse(data['bscocNmor'] ?? '0'),
      bscocImor: double.parse(data['bscocImor'] ?? '0.0'),
      bsmednser: data['bsmednser'] ?? '',
      bsmedNume: data['bsmedNume'] ?? '',
      bscntlati: double.parse(data['bscntlati'] ?? '0.0'),
      bscntlogi: double.parse(data['bscntlogi'] ?? '0.0'),
      dNcat: data['dNcat'] ?? '',
      dCobc: data['dCobc'] ?? '',
      dLotes: data['dLotes'] ?? '',
    );
  }
}
