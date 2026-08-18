import 'dart:io';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart';
import 'package:permission_handler/permission_handler.dart';

class PdfApi {
  static Future<File> saveDocument({
    required String name,
    required Document pdf,
  }) async {
    final bytes = await pdf.save();
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$name');
    await file.writeAsBytes(bytes);
    return file;
  }

  //check permission status
  static Future getRequestPermission() async {
    const permission = Permission.storage;
    if (!await permission.isGranted) {
      await Permission.storage.request().isGranted;
    }
    return await permission.isGranted;
  }

  static Future openFile(File file) async {
    final url = file.path;
    await OpenFilex.open(url);
  }
}
