
// The following list orders bitwise and shift
// operators starting from the highest precedence to the lowest:
// Bitwise complement operator ~
// Shift operators <<, >>, and >>>
// Logical AND operator &
// Logical exclusive OR operator ^
// Logical OR operator |
int binaryToDec(String s){
  return int.parse(s, radix: 2);
}
String decToBinary(int s){
  return s.toRadixString(2);
}
String decToHex(int s){
  return s.toRadixString(16);
}
String decToOctal(int s){
  return s.toRadixString(8);
}
String AND (String a, String b) {
  var adec = binaryToDec(a);
  var bdec = binaryToDec(b);
  return (decToBinary(adec & bdec));
}
String NAND (String a, String b) {
  var adec = binaryToDec(a);
  var bdec = binaryToDec(b);
  return (decToBinary(~(adec & bdec)));
}
String OR (String a, String b) {
  var adec = binaryToDec(a);
  var bdec = binaryToDec(b);
  return (decToBinary(adec | bdec));
}
String NOR (String a, String b) {
  var adec = binaryToDec(a);
  var bdec = binaryToDec(b);
  return (decToBinary(~(adec | bdec)));
}
