// ignore_for_file: deprecated_member_use, prefer_collection_literals

import 'dart:convert';

import 'dart:io';
import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:flutter_document_picker/flutter_document_picker.dart';
import 'package:pdf/PdfFirebase/Modal.dart';

import 'package:pdf/PdfFirebase/secondPage.dart';



class FirstPage extends StatefulWidget {
  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
   List<Modal> itemList= [] ;
  // PlatformFile? pickedFile;
   final mainReference = FirebaseDatabase.instance.reference().child('Database');

   Future<firebase_storage.UploadTask?> uploadFile(File file) async {  
  if (file == null) {  
    print('No file picked');
    return null;  
  } 

  firebase_storage.UploadTask uploadTask;  
  
  // Create a Reference to the file  
  firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance  
  .ref()  
      .child('playground')  
      .child('/some-file.pdf');  
  
  final metadata = firebase_storage.SettableMetadata(  
      contentType: 'file/pdf',  
      customMetadata: {'picked-file-path': file.path});  
  print("Uploading..!");  
  
  uploadTask = ref.putData(await file.readAsBytes(), metadata);  

  final snapshot= await uploadTask.whenComplete(() => null);

  final urlDownload=await snapshot.ref.getDownloadURL();
  
  print("done..!"); 
  documentFileUpload(urlDownload); 
  return Future.value(uploadTask);  
}
String CreateCryptoRandomString([int length = 32]) {
    //generate key
    final Random _random=Random.secure();
    var values=List<int>.generate(length, (i) => _random.nextInt(256));
    return base64Url.encode(values);
  }

void documentFileUpload(String str) {
    var data = {
      "PDF":str,
      "FileName":"My new Book",
      //store data
    };
    mainReference.child(CreateCryptoRandomString()).set(data).then((v) {
      print("Store Successfully");
    });
  }

  // @override
  // void initState() {
  //   mainReference.once().then((DataSnapshot snap){
  //    //get data from firebase
  //   });
  // }
  
  
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text("Pdf With Firebase"),
      ),
      body: itemList.length==0?Text("Loading"):ListView.builder(
        itemCount:itemList.length,
        
        itemBuilder:  (context,index){
          return Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: GestureDetector(
                onTap: (){
                  String passData=itemList[index].link;
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context)=>ViewPdf(),
                          settings: RouteSettings(
                          )
                      )
                  );
                },
                child: Stack(
                  children: <Widget>[
                    Container(
                      height: 100,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('bg999.jpg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Center(
                      child: Container(
                        height: 140,
                        child: Card(
                          margin: EdgeInsets.all(18),
                          elevation: 7.0,
                          child: Center(
                            child: Text(itemList[index].name+" "+(index+1).toString()),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async{

          final path = await FlutterDocumentPicker.openDocument();  
          print(path);  
          File file = File(path!);  
          firebase_storage.UploadTask? task = await uploadFile(file);
       

        },
        child: Icon(Icons.add,color: Colors.white,),
        backgroundColor: Colors.red,
      ),
    );
  }
 

    @override
  void initState() {
    mainReference.once().then((DatabaseEvent snap){

      var dat=snap.snapshot.value as Map<String,dynamic>;

//       Map<String, dynamic> map = {
       
//         'PDF': 'My',
//   'FileName': 'new',
  
// };
      print("############### $dat");
      
      // itemList.clear();
      
      dat.forEach((key,value)
      {
        
        Modal m= Modal(value['PDF'],value['FileName']);
        itemList.add(m);
      }
      
      
      );
      setState(() {
        print("value is ");
        print(itemList.length);
      }
      );
      
     //get data from firebase
    });
  }
  
  }
  


