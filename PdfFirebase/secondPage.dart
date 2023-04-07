
import 'package:easy_pdf_viewer/easy_pdf_viewer.dart';
import 'package:flutter/material.dart';




class ViewPdf extends StatefulWidget {
  @override
  _ViewPdfState createState() => _ViewPdfState();
}

class _ViewPdfState extends State<ViewPdf> {
  late PDFDocument doc;

  
  
  @override
  Widget build(BuildContext context) {
    //get data from first class
     Object? data=ModalRoute.of(context)?.settings.arguments;
    
    
    ViewNow() async {
       doc = await PDFDocument.fromURL(data.toString());
      setState(() {

      });
    }

   
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text("Retrieve Pdf"),
      ),
      body: doc==null?() {
      
         ViewNow();
         if(doc==null)
         {
           return Text("loading");
         }
         
       }():PDFViewer(document: doc),
     );
   }
   
 }
 