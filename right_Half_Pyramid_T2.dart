import 'dart:io';
void main(){
  print("Enter number of rows: ");
  int num=int.parse(stdin.readLineSync()!);
  for(int i=1;i<=num;i++){
    for(int j=1;j<=i;j++){
      stdout.write("*");
    }
    if(i<num)
      print("");
  }
} 