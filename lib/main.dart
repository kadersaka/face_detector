import 'package:camera/camera.dart';
import 'package:face_detector/screens/my_home_page.dart';
import 'package:flutter/material.dart';
import 'package:splash_screen_view/SplashScreenView.dart';

List<CameraDescription>? cameras;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  cameras = await availableCameras();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MaskY',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MySplash(),
    );
  }
}

class MySplash extends StatefulWidget {
  const MySplash({Key? key}) : super(key: key);

  @override
  _MySplashState createState() => _MySplashState();
}

class _MySplashState extends State<MySplash> {
  @override
  Widget build(BuildContext context) {

    return SplashScreenView(
      navigateRoute: MyHomePage(title: "MaskY",),
      duration: 3000,
      imageSize: 130,
      imageSrc: "assets/images/logo.png",
      backgroundColor: Colors.blueGrey,
      text: "MaskY",
      textType: TextType.ColorizeAnimationText,
      textStyle: TextStyle(
        fontSize: 40.0,
      ),
      colors: [
        Colors.purple,
        Colors.blue,
        Colors.yellow,
        Colors.red,
      ],
    );
  }
}
