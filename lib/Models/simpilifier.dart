import 'dart:math';

import 'package:flutter/widgets.dart';

import 'digital_parser.dart';

class Simplifier {
  late List<Map<String, dynamic>> _soms;
  late List<String> _vars;
  //late int _noOfVars;
  List<String> dontCareComditions = [];

  Simplifier({required String expr}) {
    this._vars = getExprVariables(expr);
    //this._noOfVars = _vars.length;
    this._soms = getSumOfMinterms(expr, _vars)
        .map((v) => {
              'soms': {int.parse(v, radix: 2)},
              'som': v,
              'click': false
            })
        .toList();
    _soms.sort(sortComaparable);
  }

  Simplifier.advanced(
      {required List<String> somOfMinterms,
      required List<String> variables,
      this.dontCareComditions = const []}) {
    this._vars = variables;
    //this._noOfVars = _vars.length;
    this._soms = somOfMinterms
        .map((v) => {
              'soms': {int.parse(v, radix: 2)},
              'som': v,
              'click': false
            })
        .toList();
    _soms.sort(sortComaparable);
  }
  bool isalpha(String ch) {
    return ((ch.codeUnitAt(0) >= 'a'.codeUnitAt(0) &&
            ch.codeUnitAt(0) <= 'f'.codeUnitAt(0)) ||
        (ch.codeUnitAt(0) >= 'A'.codeUnitAt(0) &&
            ch.codeUnitAt(0) <= 'F'.codeUnitAt(0)));
  }

  List<String> getExprVariables(String expr) {
    Set<String> variables = {};
    for (int i = 0; i < expr.length; i++) {
      if (isalpha(expr[i])) variables.add(expr[i]);
    }
    print(variables.toList());

    return variables.toList();
  }

  List<String> getSumOfMinterms(String expr, List<String> variables) {
    List<String> soms = List.empty(growable: true);
    String binResult;
    int len = variables.length;
    String newExpr = expr;
    for (int a = 0; a < pow(2, len); a++) {
      binResult = a.toRadixString(2).toString();
      binResult = binResult.padLeft(len, '0');
      newExpr = expr;
      for (int i = 0; i < variables.length; i++) {
        newExpr = newExpr.replaceAll(variables[i], binResult[i]);
      }
      Parser p = Parser(newExpr, "bin");
      if (p.sampleParser() == 1) {
        soms.add(binResult);
        print('Soms = $soms');
      }
    }
    return soms;
  }

  int sortComaparable(Map<String, dynamic> a, Map<String, dynamic> b) =>
      getNoOfOnes(a['som']) - getNoOfOnes(b['som']);

  int getNoOfDiferences(String som, String som2) {
    int count = 0;
    for (int i = 0; i < som.length; i++) {
      if (som[i] != som2[i]) {
        count++;
      }
    }
    return count;
  }

  int getNoOfOnes(String som) {
    int count = 0;
    for (int i = 0; i < som.length; i++) {
      if (som[i] == '1') {
        count++;
      }
    }
    return count;
  }

  Map<String, dynamic>? compareElements(
      Map<String, dynamic> a, Map<String, dynamic> b) {
    if (getNoOfDiferences(a['som'], b['som']) == 1) {
      Map<String, dynamic> temp = Map.from(a);
      temp['soms'] = a['soms'].union(b['soms']);
      a['click'] = true;
      b['click'] = true;
      for (int i = 0; i < _vars.length; i++) {
        if (a['som'][i] != b['som'][i])
          temp['som'] = a['som'].toString().replaceRange(i, i + 1, '-');
      }
      temp['click'] = false;
      return temp;
    } else
      return null;
  }

  bool isContains(List<Map<String, dynamic>> soms, Map<String, dynamic> som) {
    bool flag = false;
    soms.forEach((element) {
      if (getNoOfDiferences(element['som'], som['som']) == 0) {
        flag = true;
        return;
      }
    });
    return flag;
  }

  List<Map<String, dynamic>> compare(List<Map<String, dynamic>> soms) {
    List<Map<String, dynamic>> newSoms = List.empty(growable: true);
    bool flag = false;
    for (int i = 0; i < soms.length; i++) {
      for (int j = i + 1; j < soms.length; j++) {
        if (getNoOfOnes(soms[j]['som']) > getNoOfOnes(soms[i]['som']) + 1)
          break;
        Map<String, dynamic>? temp = compareElements(soms[i], soms[j]);
        if (temp != null && !isContains(newSoms, temp)) {
          newSoms.add(temp);
          flag = true;
        }
      }
    }
    soms.forEach((element) {
      if (!element['click']) newSoms.add(element);
    });
    newSoms.sort(sortComaparable);
    newSoms.add({'isCompared': flag});

    return newSoms;
  }

  bool checkDependency(Set som, int index, List<Map<String, dynamic>> soms) {
    List temp = List.empty(growable: true);
    for (int i = 0; i < soms.length; i++) {
      if (i == index) continue;
      temp.addAll(soms[i]['soms']);
    }
    Set allsoms = temp.toSet();
    if (som.difference(allsoms).isEmpty) return true;
    return false;
  }

  List<Map<String, dynamic>> getIndependentTerms(
      List<Map<String, dynamic>> soms) {
    List<Map<String, dynamic>> temp = List.from(soms);
    for (int i = 0; i < temp.length; i++) {
      if (checkDependency(temp[i]['soms'], i, temp)) {
        temp.removeAt(i);
      }
    }
    return temp;
  }

  List<Map<String, dynamic>> simplifySumOfMinterms() {
    List<Map<String, dynamic>> temp = List.from(_soms);
    bool flag = true;
    while (flag) {
      temp = List.from(compare(temp));
      flag = temp[temp.length - 1]['isCompared'];
      temp = temp.sublist(0, temp.length - 1);
    }
    return getIndependentTerms(temp);
  }

  String simpilify() {
    List<Map<String, dynamic>> soms = simplifySumOfMinterms();
    String str = 'f(${_vars.join(', ')}) = ';
    soms.forEach((element) {
      String som = element['som'];
      // str += '( ';
      for (int i = 0; i < _vars.length; i++) {
        if (som[i] == '-')
          continue;
        else if (som[i] == '1')
          str += '${_vars[i]}.';
        else if (som[i] == '0') str += '${_vars[i]}\'.';
      }
      str = str.substring(0, str.length - 1);
      // str += ' )+';
      str += ' + ';
    });
    str = str.substring(0, str.length - 3);
    return str;
  }
}
