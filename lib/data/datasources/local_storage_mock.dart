class LocalStorageMock {
  static final LocalStorageMock _instance = LocalStorageMock._internal();
  factory LocalStorageMock() => _instance;
  LocalStorageMock._internal();

  double userBalance = 500000.0;

  List<Map<String, dynamic>> transactions = [];

  final List<Map<String, dynamic>> availableFunds = [
    {
      'id': '1',
      'name': 'FPV_BTG_PACTUAL_RECAUDADORA',
      'minimumAmount': 75000.0,
      'category': 'FPV',
    },
    {
      'id': '2',
      'name': 'FPV_BTG_PACTUAL_ECOPETROL',
      'minimumAmount': 125000.0,
      'category': 'FPV',
    },
    {
      'id': '3',
      'name': 'DEUDAPRIVADA',
      'minimumAmount': 50000.0,
      'category': 'FIC',
    },
    {
      'id': '4',
      'name': 'FDO-ACCIONES',
      'minimumAmount': 250000.0,
      'category': 'FIC',
    },
    {
      'id': '5',
      'name': 'FPV_BTG_PACTUAL_DINAMICA',
      'minimumAmount': 100000.0,
      'category': 'FPV',
    },
  ];

  Set<String> subscribedFundIds = {};
}
