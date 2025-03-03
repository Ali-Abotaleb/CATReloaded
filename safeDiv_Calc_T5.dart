import 'dart:io';
dynamic safeDivide(num num1, num? num2){
  if(num2==null||num2==0)
    return"Cannot divide by zero!";
  return num1/num2;
}
void main(){
  print("Enter first number: ");
  num num1=num.parse(stdin.readLineSync()!);
  print("Enter second number: ");
  num num2=num.parse(stdin.readLineSync()!);
  print(safeDivide(num1,num2));
}