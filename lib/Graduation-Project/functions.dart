import 'package:number_system/number_system.dart';

// The following list orders bitwise and shift
// operators starting from the highest precedence to the lowest:
// Bitwise complement operator ~
// Shift operators <<, >>, and >>>
// Logical AND operator &
// Logical exclusive OR operator ^
// Logical OR operator |

String AND (String a, String b) {
  var adec = a.binaryToDec();
  var bdec = b.binaryToDec();
  return ((adec & bdec).decToBinary());
}
String NAND (String a, String b) {
  var adec = a.binaryToDec();
  var bdec = b.binaryToDec();
  return ((~(adec & bdec)).decToBinary());
}
String OR (String a, String b) {
  var adec = a.binaryToDec();
  var bdec = b.binaryToDec();
  return ((adec | bdec).decToBinary());
}
String NOR (String a, String b) {
  var adec = a.binaryToDec();
  var bdec = b.binaryToDec();
  return ((~(adec | bdec)).decToBinary());
}
