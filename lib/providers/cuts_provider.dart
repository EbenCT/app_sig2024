import 'package:flutter/material.dart';
import '../models/cut.dart';

class CutsProvider with ChangeNotifier {
  List<Cut> _cuts = [];

  List<Cut> get cuts => _cuts;

  void setCuts(List<Cut> newCuts) {
    _cuts = newCuts;
    notifyListeners();
  }

  void updateCut(Cut updatedCut) {
    int index = _cuts.indexWhere((cut) => cut.id == updatedCut.id);
    if (index != -1) {
      _cuts[index] = updatedCut;
      notifyListeners();
    }
  }
}
