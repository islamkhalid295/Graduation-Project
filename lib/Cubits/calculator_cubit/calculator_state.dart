part of 'calculator_cubit.dart';

@immutable
abstract class CalculatorState {}

class CalculatorInitial extends CalculatorState {}

class CalculatorEprUpdate extends CalculatorState {}

class CalculatorResult extends CalculatorState {}

class CalculatorNumberSystemChange extends CalculatorState {}

class CalculatorIsSignedChange extends CalculatorState {}
