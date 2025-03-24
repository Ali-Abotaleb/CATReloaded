import 'dart:convert';
import 'dart:io';
abstract class Person {
  String _name;
  int _age;
  Person(this._name, this._age);
  String get name => _name;
  int get age => _age;
  set name(String newName) => _name = newName;
  set age(int newAge) => _age = newAge;
  @override
  String toString();
  Map<String, dynamic> toJson();
}
class Subject {
  String _name;
  double _grade;
  Subject(this._name, this._grade) {
    if (_grade < 0 || _grade > 100) {
      throw ArgumentError('Grade must be between 0 and 100');
    }
  }
  String get name => _name;
  double get grade => _grade;
  void updateGrade(double newGrade) {
    if (newGrade < 0 || newGrade > 100) {
      throw ArgumentError('Grade must be between 0 and 100');
    }
    _grade = newGrade;
  }
  @override
  String toString() => 'Subject{name: $_name, grade: $_grade}';
  Map<String, dynamic> toJson() => {'name': _name, 'grade': _grade};
  factory Subject.fromJson(Map<String, dynamic> json) =>
      Subject(json['name'], json['grade'].toDouble());
}
class Student extends Person {
  String _studentID;
  String _gradeLevel;
  final List<Subject> _subjects = [];
  Student(String name, int age, this._studentID, this._gradeLevel)
      : super(name, age);
  String get studentID => _studentID;
  String get gradeLevel => _gradeLevel;
  List<Subject> get subjects => List.unmodifiable(_subjects);
  set gradeLevel(String newLevel) => _gradeLevel = newLevel;
  void addSubject(Subject subject) {
    if (_subjects.any((s) => s.name == subject.name)) {
      throw Exception('Subject already exists');
    }
    _subjects.add(subject);
  }
  void removeSubject(String subjectName) {
    _subjects.removeWhere((s) => s.name == subjectName);
  }
  void updateSubjectGrade(String subjectName, double newGrade) {
    final subject = _subjects.firstWhere(
      (s) => s.name == subjectName,
      orElse: () => throw Exception('Subject not found'),
    );
    subject.updateGrade(newGrade);
  }
  double calculateAverage() {
    if (_subjects.isEmpty) return 0.0;
    return _subjects.map((s) => s.grade).reduce((a, b) => a + b) / _subjects.length;
  }
  @override
  String toString() {
    return 'Student{name: $name, age: $age, ID: $_studentID, Grade Level: $_gradeLevel, '
        'Subjects: $_subjects, Average: ${calculateAverage().toStringAsFixed(2)}}';
  }
  @override
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'age': age,
      'studentID': _studentID,
      'gradeLevel': _gradeLevel,
      'subjects': _subjects.map((s) => s.toJson()).toList(),
    };
  }
  factory Student.fromJson(Map<String, dynamic> json) {
    final student = Student(
      json['name'],
      json['age'],
      json['studentID'],
      json['gradeLevel'],
    );
    final subjects = (json['subjects'] as List)
        .map((s) => Subject.fromJson(s))
        .toList();
    student._subjects.addAll(subjects);
    return student;
  }
}
class StudentManager {
  final List<Student> _students = [];
  void addStudent(Student student) {
    if (_students.any((s) => s.studentID == student.studentID)) {
      throw Exception('Student ID already exists');
    }
    _students.add(student);
  }
  void removeStudent(String studentID) {
    if (!_students.any((s) => s.studentID == studentID)) {
      throw Exception('Student not found');
    }
    _students.removeWhere((s) => s.studentID == studentID);
  }
  void updateStudent(String studentID, String newName, int newAge, String newGradeLevel) {
    final student = getStudent(studentID);
    student.name = newName;
    student.age = newAge;
    student.gradeLevel = newGradeLevel;
  }
  Student getStudent(String studentID) => _students.firstWhere(
    (s) => s.studentID == studentID,
    orElse: () => throw Exception('Student not found'),
  );
  void displayAllStudents() {
    if (_students.isEmpty) {
      print('No students found');
      return;
    }
    _students.forEach(print);
  }
  void sortStudents(int sortType) {
    switch (sortType) {
      case 1:
        _students.sort((a, b) => a.name.compareTo(b.name));
        break;
      case 2:
        _students.sort((a, b) => a.age.compareTo(b.age));
        break;
      case 3:
        _students.sort((a, b) => b.calculateAverage().compareTo(a.calculateAverage()));
        break;
      default:
        throw ArgumentError('Invalid sort type');
    }
  }
  List<Student> get students => List.unmodifiable(_students);
  void loadStudents(List<Student> students) => _students.addAll(students);
}
class StudentFileHandler {
  static Future<void> saveToFile(String filename, List<Student> students) async {
    final file = File(filename);
    await file.writeAsString(jsonEncode(students.map((s) => s.toJson()).toList()));
  }
  static Future<List<Student>> loadFromFile(String filename) async {
    final file = File(filename);
    if (!await file.exists()) return [];
    final contents = await file.readAsString();
    final jsonList = jsonDecode(contents) as List;
    return jsonList.map((s) => Student.fromJson(s)).toList();
  }
}
void main() async {
  final manager = StudentManager();
  await loadInitialData(manager);
  while (true) {
    printMainMenu();
    final choice = int.tryParse(stdin.readLineSync() ?? '') ?? 0;
    switch (choice) {
      case 1:
        await manageStudents(manager);
        break;
      case 2:
        sortStudents(manager);
        break;
      case 3:
        printReports(manager);
        break;
      case 4:
        await saveData(manager);
        break;
      case 5:
        print('Exiting...');
        return;
      default:
        print('Invalid choice');
    }
  }
}
Future<void> loadInitialData(StudentManager manager) async {
  try {
    final students = await StudentFileHandler.loadFromFile('students.json');
    manager.loadStudents(students);
  } catch (e) {
    print('Error loading data: $e');
  }
}
void printMainMenu() {
  print('\n📚 Welcome to the Student Management System 📚');
  print('1. Manage Students');
  print('2. Sort Students');
  print('3. Print Reports');
  print('4. Save Data to JSON');
  print('5. Exit');
  print('Enter your choice: ');
}

// Management Functions
Future<void> manageStudents(StudentManager manager) async {
  while (true) {
    print('\n--- Manage Students ---');
    print('1. Add Student');
    print('2. Remove Student');
    print('3. Update Student');
    print('4. Manage Subjects');
    print('5. Display All Students');
    print('6. Back');
    print('Enter choice: ');
    final choice = int.tryParse(stdin.readLineSync() ?? '') ?? 0;
    if (choice == 6) return;
    try {
      switch (choice) {
        case 1:
          addStudentHandler(manager);
          break;
        case 2:
          removeStudentHandler(manager);
          break;
        case 3:
          updateStudentHandler(manager);
          break;
        case 4:
          manageSubjectsHandler(manager);
          break;
        case 5:
          manager.displayAllStudents();
          break;
        default:
          print('Invalid choice');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}
void addStudentHandler(StudentManager manager) {
  print('Enter student name: ');
  final name = stdin.readLineSync() ?? '';
  print('Enter age: ');
  final age = int.tryParse(stdin.readLineSync() ?? '') ?? 0;
  print('Enter student ID: ');
  final id = stdin.readLineSync() ?? '';
  print('Enter grade level: ');
  final level = stdin.readLineSync() ?? '';
  if (name.isEmpty || id.isEmpty || level.isEmpty) {
    throw Exception('Invalid input');
  }
  manager.addStudent(Student(name, age, id, level));
  print('Student added successfully');
}
void removeStudentHandler(StudentManager manager) {
  print('Enter student ID to remove: ');
  final id = stdin.readLineSync() ?? '';
  manager.removeStudent(id);
  print('Student removed successfully');
}
void updateStudentHandler(StudentManager manager) {
  print('Enter student ID to update: ');
  final id = stdin.readLineSync() ?? '';
  print('Enter new name: ');
  final name = stdin.readLineSync() ?? '';
  print('Enter new age: ');
  final age = int.tryParse(stdin.readLineSync() ?? '') ?? 0;
  print('Enter new grade level: ');
  final level = stdin.readLineSync() ?? '';
  manager.updateStudent(id, name, age, level);
  print('Student updated successfully');
}
void manageSubjectsHandler(StudentManager manager) {
  print('Enter student ID: ');
  final id = stdin.readLineSync() ?? '';
  final student = manager.getStudent(id);
  while (true) {
    print('\n--- Manage Subjects ---');
    print('1. Add Subject');
    print('2. Remove Subject');
    print('3. Update Grade');
    print('4. Show Subjects');
    print('5. Back');
    print('Enter choice: ');
    final choice = int.tryParse(stdin.readLineSync() ?? '') ?? 0;
    if (choice == 5) return;
    try {
      switch (choice) {
        case 1:
          addSubjectHandler(student);
          break;
        case 2:
          removeSubjectHandler(student);
          break;
        case 3:
          updateGradeHandler(student);
          break;
        case 4:
          student.subjects.forEach(print);
          break;
        default:
          print('Invalid choice');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}
void addSubjectHandler(Student student) {
  print('Enter subject name: ');
  final name = stdin.readLineSync() ?? '';
  print('Enter grade: ');
  final grade = double.tryParse(stdin.readLineSync() ?? '') ?? 0;
  student.addSubject(Subject(name, grade));
  print('Subject added successfully');
}
void removeSubjectHandler(Student student) {
  print('Enter subject name to remove: ');
  final name = stdin.readLineSync() ?? '';
  student.removeSubject(name);
  print('Subject removed successfully');
}
void updateGradeHandler(Student student) {
  print('Enter subject name: ');
  final name = stdin.readLineSync() ?? '';
  print('Enter new grade: ');
  final grade = double.tryParse(stdin.readLineSync() ?? '') ?? 0;
  student.updateSubjectGrade(name, grade);
  print('Grade updated successfully');
}
void sortStudents(StudentManager manager) {
  print('\n--- Sort Students ---');
  print('1. By Name');
  print('2. By Age');
  print('3. By Average Grade');
  print('Enter choice: ');
  final choice = int.tryParse(stdin.readLineSync() ?? '') ?? 0;
  try {
    manager.sortStudents(choice);
    manager.displayAllStudents();
  } catch (e) {
    print('Error: $e');
  }
}
void printReports(StudentManager manager) {
  print('\n--- Print Reports ---');
  print('1. Highest/Lowest Grades');
  print('2. Above Average Students');
  print('3. Below Average Students');
  print('4. Full Student List');
  print('Enter choice: ');
  final choice = int.tryParse(stdin.readLineSync() ?? '') ?? 0;
  switch (choice) {
    case 1:
      printHighLow(manager);
      break;
    case 2:
      printAboveAverage(manager);
      break;
    case 3:
      printBelowAverage(manager);
      break;
    case 4:
      manager.displayAllStudents();
      break;
    default:
      print('Invalid choice');
  }
}
void printHighLow(StudentManager manager) {
  if (manager.students.isEmpty) return;
  final sorted = List.of(manager.students)
    ..sort((a, b) => b.calculateAverage().compareTo(a.calculateAverage()));
  print('Highest Grade: ${sorted.first}');
  print('Lowest Grade: ${sorted.last}');
}
void printAboveAverage(StudentManager manager) {
  final students = manager.students;
  if (students.isEmpty) return;
  final totalAverage = students
      .map((s) => s.calculateAverage())
      .reduce((a, b) => a + b) / students.length;
  print('Students above average ($totalAverage.toStringAsFixed(2)):');
  students
      .where((s) => s.calculateAverage() > totalAverage)
      .forEach(print);
}
void printBelowAverage(StudentManager manager) {
  final students = manager.students;
  if (students.isEmpty) return;
  final totalAverage = students
      .map((s) => s.calculateAverage())
      .reduce((a, b) => a + b) / students.length;
  print('Students below average ($totalAverage.toStringAsFixed(2)):');
  students
      .where((s) => s.calculateAverage() < totalAverage)
      .forEach(print);
}
Future<void> saveData(StudentManager manager) async {
  print('Saving data...');
  try {
    await StudentFileHandler.saveToFile('students.json', manager.students);
    print('Data saved successfully');
  } catch (e) {
    print('Error saving data: $e');
  }
}
