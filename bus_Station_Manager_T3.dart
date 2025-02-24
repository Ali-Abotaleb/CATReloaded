import 'dart:io';
int bus=12;
void main(){
  while(true){
    print("Enter group size: ");
    var grp=int.parse(stdin.readLineSync()!);
    if(grp==0){
      print("All buses are handled. Program ended.");
      break;
    }
    else if(grp<=bus){
    bus-=grp;
    print("Seats remaining: $bus");
    }
    else{
      bus=12;
      print("Not enough seats! Moving to the next bus.");
      print("New Bus Started.");
      bus-=grp;
    print("Seats remaining: $bus");
    }
  }
}