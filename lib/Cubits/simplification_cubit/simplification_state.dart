part of 'simplification_cubit.dart';

@immutable
abstract class SimplificationState {}

class SimplificationInitial extends SimplificationState {}

class SimplificationExprUpdate extends SimplificationState {}

class SimplificationResult extends SimplificationState {}

class SimplificationIsNormalChange extends SimplificationState {}

class SimplificationHistoryUpdate extends SimplificationState {}
