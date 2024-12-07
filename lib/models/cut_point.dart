class CutPoint {
  final int bscocNcoc;//Nro corte
  final int bscntCodf;//Codigo fijo
  final int bscocNcnt;//Nro cuenta
  final String dNomb;// nombre propietario
  final int bscocNmor;//nro de ??
  final double bscocImor;//??creo que es el consumo
  final String bsmednser;//nro servicio
  final String bsmedNume;//nro ??
  final double bscntlati;//latitud
  final double bscntlogi;//longitud
  final String dNcat;//Nombre categoria
  final String dCobc;//Observacion
  final String dLotes;//Lote

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
