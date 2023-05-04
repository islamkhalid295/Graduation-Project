class documentationElement {
  String title;
  String description;
  List<Example> example;
  documentationElement({
    required this.title,
    required this.description,
    required this.example,
  });
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
