import 'package:flutter/material.dart';

import 'app_config.dart';

class DocumentationElement {
  String title;
  String description;
  TruthTable? truthTable;
  List<Example> example;
  DocumentationElement({
    required this.title,
    required this.description,
    this.truthTable,
    required this.example,
  });
  Widget showTT(String theme) {
    TextStyle header = const TextStyle(
      color: ThemeColors.blueColor,
      fontWeight: FontWeight.bold,
      fontSize: 18,
    );
    TextStyle text = TextStyle(
      color: theme == 'light'
          ? ThemeColors.lightBlackText
          : ThemeColors.darkWhiteText,
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    return (truthTable is! UnariTruthTable)
        ? Table(
            border: TableBorder.all(
              color: theme == 'light'
                  ? ThemeColors.darkElemBG.withOpacity(0.5)
                  : ThemeColors.lightElemBG.withOpacity(0.5),
              width: 1,
              borderRadius: BorderRadius.circular(3),
            ),
            children: [
              TableRow(children: [
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: Text(
                    'A',
                    style: header,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: Text(
                    'B',
                    style: header,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: Text(
                    'A ${title.substring(0, title.indexOf('Operator') - 1).toUpperCase()} B',
                    style: header,
                  ),
                ),
              ]),
              TableRow(children: [
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: Text(
                    '0',
                    style: text,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: Text(
                    '0',
                    style: text,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: Text(
                    truthTable!.zeroZero,
                    style: text,
                  ),
                ),
              ]),
              TableRow(children: [
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: Text(
                    '0',
                    style: text,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: Text(
                    '1',
                    style: text,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: Text(
                    truthTable!.zeroOne,
                    style: text,
                  ),
                ),
              ]),
              TableRow(children: [
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: Text(
                    '1',
                    style: text,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: Text(
                    '0',
                    style: text,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: Text(truthTable!.oneZero),
                ),
              ]),
              TableRow(children: [
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: Text(
                    '1',
                    style: text,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: Text(
                    '1',
                    style: text,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: Text(
                    truthTable!.oneOne,
                    style: text,
                  ),
                ),
              ]),
            ],
          )
        : Table(
            border: TableBorder.all(
              color: theme == 'light'
                  ? ThemeColors.darkElemBG.withOpacity(0.5)
                  : ThemeColors.lightElemBG.withOpacity(0.5),
              width: 1,
              borderRadius: BorderRadius.circular(3),
            ),
            children: [
                TableRow(children: [
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: Text(
                      'A',
                      style: header,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: Text(
                      '${title.substring(0, title.indexOf('Operator') - 1).toUpperCase()} B',
                      style: header,
                    ),
                  ),
                ]),
                TableRow(children: [
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: Text(
                      '0',
                      style: text,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: Text(
                      truthTable!.zeroZero,
                      style: text,
                    ),
                  ),
                ]),
                TableRow(children: [
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: Text(
                      '1',
                      style: text,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: Text(
                      truthTable!.oneOne,
                      style: text,
                    ),
                  ),
                ]),
              ]);
  }
}

class Example {
  String num1;
  String num2;
  String operation;
  String result;
  Example({
    required this.num1,
    required this.num2,
    required this.operation,
    required this.result,
  });
}

class UnariExample extends Example {
  UnariExample({
    required String num1,
    required String num2,
    required String operation,
    required String result,
  }) : super(num1: num1, num2: num2, operation: operation, result: result);
}

class TruthTable {
  String zeroZero;
  String zeroOne;
  String oneZero;
  String oneOne;
  TruthTable({
    required this.zeroZero,
    required this.zeroOne,
    required this.oneZero,
    required this.oneOne,
  });
}

class UnariTruthTable extends TruthTable {
  UnariTruthTable({required String zero, required String one})
      : super(oneOne: zero, zeroZero: one, oneZero: 'nn', zeroOne: 'nn');
}
