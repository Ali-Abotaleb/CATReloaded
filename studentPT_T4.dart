// import 'dart:io';
// void main(){
//   Map<String,double> studentsG={};
//   while(true){
//   print("Enter student name: ");
//   String name=stdin.readLineSync()!;
//   if(name=="done")
//     break;
//   print("Enter $name grade: ");
//   double grade=double.parse(stdin.readLineSync()!);
//   studentsG[name]=grade;
// }
// print("Results: ");

// }
import 'dart:io';
import 'dart:collection';
void main() {
  Map<String, double> students={};
  while (true) {
    stdout.write("Enter student name (or 'done' to finish): ");
    final name = stdin.readLineSync()?.trim();
    if (name == null || name.toLowerCase() == 'done') break;
    if (name.isEmpty) {
      print("Name cannot be empty.");
      continue;
    }
    double? grade;
    do {
      stdout.write("Enter ${name}'s grade: ");
      final gradeInput = stdin.readLineSync()?.trim();
      try {
        grade = double.parse(gradeInput ?? '');
        if (grade < 0) {
          print("Grade cannot be negative.");
          grade = null;
        }
      } catch (e) {
        print("Invalid grade. Please enter a numeric value.");
        grade = null;
      }
    } while (grade == null);
    students[name] = grade;
  }
  if (students.isEmpty) {
    print("No students entered.");
    return;
  }
  final sortedEntries = SplayTreeSet<MapEntry<String, double>>(
    (a, b) {
      final gradeCompare = b.value.compareTo(a.value);
      return gradeCompare != 0 ? gradeCompare : a.key.compareTo(b.key);
    },
  )..addAll(students.entries);
  final highest = sortedEntries.first;
  final lowest = sortedEntries.last;
  final average = students.values.fold<double>(0.0, (sum, grade) => sum + grade) / students.length;
  final aboveAverage = sortedEntries.where((entry) => entry.value > average).map((e) => e.key).toList();
  print("\nResults:\n");
  print("Highest Grade: ${highest.value} (${highest.key})");
  print("Lowest Grade: ${lowest.value} (${lowest.key})");
  print("Average Grade: ${average.toStringAsFixed(1)}");
  print("\nSorted Grades (High to Low): (${sortedEntries.map((e) => '${e.key} (${e.value})').join(', ')})");
  print("Above Average Students: ${aboveAverage.join(', ')}");
}