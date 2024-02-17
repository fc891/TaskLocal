// Contributers: Richard N.
// organizaes the data into one area

class TaskCategory {
  String name;
  String imagePath;
  
  TaskCategory({
    required this.name,
    required this.imagePath
  });

  String get _name => name;
  String get _imagePathh => imagePath;
}