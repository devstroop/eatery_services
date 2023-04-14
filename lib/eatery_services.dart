library eatery_services;

import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class FileServices {
  static Future<Directory> basePath() async {
    Directory baseDirectory = await getApplicationSupportDirectory();
    return baseDirectory;
  }

  static Future<Directory> libraryPath() async {
    Directory galleryDirectory = Directory('${(await basePath()).path}\\images');
    if (!galleryDirectory.existsSync()) {
      await galleryDirectory.create(recursive: true);
    }
    return galleryDirectory;
  }

  static Future<Directory> archivePath() async {
    Directory galleryDirectory = Directory('${(await basePath()).path}\\archive');
    if (!galleryDirectory.existsSync()) {
      galleryDirectory.create(recursive: true);
    }
    return galleryDirectory;
  }

  static Future<File?> copy(
      {required String target, required Directory directory, bool overwrite = false}) async {
    File? output;
    String? fileName = File(target).existsSync() ? path.basename(File(target).path) : null;
    if (fileName != null) {
      if(!overwrite) {
        int index = 1;
        while(File('${directory.path}\\$fileName').existsSync()){
          List<String> temp = fileName!.split('.');
          String ext = temp.last;
          temp.removeLast(); // remove extension
          List<String> temp2 = temp.join('.').split('-');
          if(temp2.last == '${index - 1}'){
            temp2.removeLast(); // remove index
          }
          fileName = '${temp2.join('-')}-$index.$ext';
          index++;
        }
      }
      output = await File(target).copy('${directory.path}\\$fileName');
    } else {
      output = null;
    }
    return output;
  }

  static Future<File?> move(
      {required String target, required Directory directory, bool overwrite = false}) async {
    File? output;
    String? fileName = File(target).existsSync() ? path.basename(File(target).path) : null;
    if (fileName != null) {
      if(!overwrite) {
        int index = 1;
        while(File('${directory.path}\\$fileName').existsSync()){
          List<String> temp = fileName!.split('.');
          String ext = temp.last;
          temp.removeLast(); // remove extension
          List<String> temp2 = temp.join('.').split('-');
          if(temp2.last == '${index - 1}'){
            temp2.removeLast(); // remove index
          }
          fileName = temp2.join('-') + '-$index.$ext';
          index++;
        }
      }
      output = await File(target).copy('${directory.path}\\$fileName');
      await File(target).delete();
    } else {
      output = null;
    }
    return output;
  }
  static Future delete(String target) async {
    await (File(target)).delete();
  }
  
  static Future<List<String>> getImages() async {
    List<String> files = [];
    Directory directory = await libraryPath();
    List<FileSystemEntity> kfiles =  directory.listSync();
    kfiles.sort((a, b) => a.statSync().accessed.compareTo(a.statSync().accessed)); // recheck
    for(FileSystemEntity file in kfiles){
      files.add(file.path);
    }
    return files;
  }

  static Future<String> absImage(String imagePath) async {
    Directory directory = await FileServices.libraryPath();
    return '${directory.path}\\$imagePath';
  }
}
