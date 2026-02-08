import 'package:currency_converter/imageReq.dart';
import 'package:flutter/material.dart';
import './calculator.dart';
import './loginPage.dart';
import './registerationPage.dart';
import './apiCalling.dart';
import './userDetailsAndPreferences.dart';

void main() {
  runApp(const MyApp());
}

Widget dialPadButton(String text) {
  return Container(
    // color: Colors.green,
    padding: EdgeInsets.all(25),
    margin: EdgeInsets.all(10),
    decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(10)
    ),
    child: Text(
        text,
        style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20
        ),
    )
  );
}

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: Scaffold(
//         appBar: AppBar(
//           backgroundColor: Colors.red,
//           title: Text(
//             "Dial Pad",
//             style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
//           ),
//         ),
//         body: Container(
//           padding: EdgeInsets.symmetric(vertical: 60),
//           child: Center(
//             child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                     // Row(
//                     //     mainAxisAlignment: MainAxisAlignment.center,
//                     //     children: [
//                     //         dialPadButton("1"),
//                     //         dialPadButton("2"),
//                     //         dialPadButton("3")
//                     //     ],
//                     // ),
//                     // Row(
//                     //     mainAxisAlignment: MainAxisAlignment.center,
//                     //     children: [
//                     //         dialPadButton("4"),
//                     //         dialPadButton("5"),
//                     //         dialPadButton("6")
//                     //     ],
//                     // ),
//                     // Row(
//                     //     mainAxisAlignment: MainAxisAlignment.center,
//                     //     children: [
//                     //         dialPadButton("7"),
//                     //         dialPadButton("8"),
//                     //         dialPadButton("9")
//                     //     ],
//                     // ),
//                     // Row(
//                     //     mainAxisAlignment: MainAxisAlignment.center,
//                     //     children: [
//                     //         dialPadButton("*"),
//                     //         dialPadButton("0"),
//                     //         dialPadButton("#")
//                     //     ],
//                     // ),
//                     Image.asset("/assets/images/1.png", height: 20, width: 20,),
//                     Icon(Icons.person),
//                     ListView(
//                       children: [
//                         ListTile(
//                           leading: Icon(Icons.person),
//                           title: Text("Name"),
//                           subtitle: Text("Age"),
//                           trailing: Icon(Icons.call),
//                         )
//                       ],
//                     )
//                 ],
//           )
//         ),
//         ),
//       ),
//     );
//   }
// }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ImageReqPage(),
    );
  }
}