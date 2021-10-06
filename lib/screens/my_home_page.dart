import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';

import '../main.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

 CameraImage? _imageCamera;
 CameraController? _cameraController;
 bool _isWorking = false;
 String result = "";


 Future<void>launchCamera()async{
   _cameraController = CameraController(cameras![0], ResolutionPreset.max);
   _cameraController!.initialize().then((_) {
     if (!mounted) {
       return;
     }
     setState(() {
       _cameraController!.startImageStream((image){
         if(!_isWorking){
           setState(() {
             _isWorking = true;
             _imageCamera = image;
             runModelOnImageStream();
           });
         }
       });
     });
   });
 }

 Future<void> loadModel()async{
   await Tflite.loadModel(model: "assets/model.tflite", labels: "assets/labels.txt");
 }

 Future<void> runModelOnImageStream()async{
   if(_imageCamera != null){
     List? _recognition = await Tflite.runModelOnFrame(bytesList: _imageCamera!.planes.map((plane){
      return plane.bytes;
     }).toList(),
     imageHeight: _imageCamera!.height,
     imageWidth: _imageCamera!.width,
     imageMean: 127.5,
     imageStd: 127.5,
     rotation: 90,
     numResults: 1,
     asynch: true,
     );
     _recognition!.forEach((response) {
       setState(() {
         result += response["label"]+"\n";
       });
     });
   }
 }

  @override
  void initState() {
    ///Load our trained model from asset file
    launchCamera();
    loadModel();
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
   Size _size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        elevation: 1.0,
        backgroundColor: Colors.white,
        centerTitle: true,
          title: Text(result, style: TextStyle(color: Colors.black),),
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 15.0),
          child:Expanded(
            child: Container(
            // height: _size.height,
            child: _cameraController!.value.isInitialized ?
            AspectRatio(
              aspectRatio: _cameraController!.value.aspectRatio,
              child: CameraPreview(_cameraController!),
            )
                :
            Container(),
          ),

        )
              /*
          Column(
            children: [
              Positioned(
                top:0,
                left: 0,
                width: double.infinity,
                height: _size.height,
                child: Container(
                  height: _size.height,
                  child: _cameraController!.value.isInitialized ?
                  AspectRatio(
                    aspectRatio: _cameraController!.value.aspectRatio,
                    child: CameraPreview(_cameraController!),
                  )
                  :
                  Container(),
                ),
              ),
              Container(
                child: Text(result),
              )
            ],
          )
          */
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black87,
        onPressed: (){
          setState(() {
            result = "";
          });
        },
        tooltip: 'PickImage',
        child: Icon(Icons.add, color: Colors.amber,),
      ), // This trailing comma makes auto-formatting nicer for build methods.
      bottomNavigationBar: _createBottomAppBar(),

    );
  }

  BottomAppBar _createBottomAppBar() {
    return BottomAppBar(
      elevation: 2.0,
      color: Colors.white,
      shape: CircularNotchedRectangle(),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10.0),
            ),
          ],
        ),
      ),
    );
  }
}
