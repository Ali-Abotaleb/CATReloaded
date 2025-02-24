import 'dart:io';
void main(){
  while(true){
    print("Enter first number: ");
      dynamic num1=stdin.readLineSync();
      if(num1=="exit")
        break;
    print("Enter second number: ");
      dynamic num2=stdin.readLineSync();
      if(num2=="exit")
        break;
    print("Enter operation (+, -, *, /): ");
      dynamic operation=stdin.readLineSync();
      if(operation=="exit")
        break;
      switch(operation){
        case "+":
          print("Result: ${double.parse(num1)+double.parse(num2)}");
          break;
        case "-":
          print("Result: ${double.parse(num1)-double.parse(num2)}");
          break;
        case "*":
          print("Result: ${double.parse(num1)*double.parse(num2)}");
          break;
        case "/":
          print("Result: ${double.parse(num1)/double.parse(num2)}");
          break;
        default:
          break;
    }
  }
}