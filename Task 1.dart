void main() {
  List<int> arr=[10, 20, 23, 45, 96, 10, 21, 22, 21];
  List<int> s_arr=[];
  for(int i=0;i<arr.length;i++){
    bool exists=false;
    for(int j=0;j<s_arr.length;j++){
      if(arr[i]==s_arr[j]){
        exists=true;
        break;
      }
    }
    if(!exists)
      s_arr.add(arr[i]);
  }
  List<int> rev_arr=[];
  for(int i=s_arr.length-1;i>=0;i--)
    rev_arr.add(s_arr[i]);
  print(rev_arr);
}
