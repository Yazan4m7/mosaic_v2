import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';


class WriteToFile {
  static var directory;
  static var file;


  static void write(String text) async {
    if  (file == null) {
      directory = await getApplicationDocumentsDirectory();
      file = File('${directory.path}/MOSAIC_logs.txt');
    }
    await file.writeAsString('['+ DateTime.now().toString()+'] '+ text + "\n",mode: FileMode.append);
  }

  static openLogs() async{
    if  (file == null) {
      directory = await getApplicationDocumentsDirectory();
      file = File('${directory.path}/MOSAIC_logs.txt');
      write('Start of document');
      OpenFile.open(file.path);
    } else{
      OpenFile.open(file.path);

    }
  }
  static clearLogs() async{
    file.writeAsString("");
  }
}