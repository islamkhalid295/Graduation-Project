part of 'simplification_cubit.dart';

@immutable
abstract class SimplificationState {}

class SimplificationInitial extends SimplificationState {}

class SimplificationEprUpdate extends SimplificationState {}

class SimplificationResult extends SimplificationState {}

class SimplificationIsNormalChange extends SimplificationState {}
