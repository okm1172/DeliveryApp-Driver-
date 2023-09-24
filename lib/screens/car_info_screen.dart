import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../global/global.dart';
import '../splashScreen/splash_screen.dart';
import 'forgot_password_screen.dart';

class CarInfoScreen extends StatefulWidget {
  const CarInfoScreen({super.key});

  @override
  State<CarInfoScreen> createState() => _CarInfoScreenState();
}

class _CarInfoScreenState extends State<CarInfoScreen> {

  final carModelTextEditingController = TextEditingController();
  final carNumberTextEditingController = TextEditingController();
  final carColorTextEditingController = TextEditingController();

  List<String> carTypes = ["Car","CNG","Bike"];
  String? selectedCarType;

  final _formKey = GlobalKey<FormState>();

  _submit(){
    //유효성 검사
    if(_formKey.currentState!.validate()){
      Map driverCarInfoMap = {
        //trim은 앞 뒤 공백 제거해줌.
        "car_model" : carModelTextEditingController.text.trim(),
        "car_number" : carNumberTextEditingController.text.trim(),
        "car_color" : carColorTextEditingController.text.trim(),
        "type" : selectedCarType,
      };

      //Map형태로 firebase에 저장한다.
      DatabaseReference userRef = FirebaseDatabase.instance.ref().child("driverapp");
      userRef.child(currentUser!.uid).child("car_details").set(driverCarInfoMap);

      Fluttertoast.showToast(msg: 'Car details has been saved. Congratulations');
      Navigator.push(context,MaterialPageRoute(builder: (c)=> SplashScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {

    bool darkTheme = MediaQuery.of(context).platformBrightness == Brightness.light;

    return GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
          body: Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height,
                  child: Opacity(
                      opacity: 1,
                      child: FittedBox(
                          child : Image.asset('images/night.jpg'),
                          fit : BoxFit.fitHeight
                      )
                  ),
                ),
                ListView(
                    padding: EdgeInsets.all(0),
                    children: [
                      Column(
                        children: [
                          //Image.asset(darkTheme ? 'images/night.jpg' : 'images/night.jpg'),

                          SizedBox(height:80),

                          Text('Register',
                            style: TextStyle(
                              color: darkTheme ? Colors.amber.shade400 : Colors.blue,
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          Padding(
                            padding: EdgeInsets.fromLTRB(15, 20, 15, 50),
                            child: Form(
                                key: _formKey,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    TextFormField(
                                      inputFormatters: [
                                        LengthLimitingTextInputFormatter(50)
                                      ],
                                      style: TextStyle(color: Colors.grey,fontWeight: FontWeight.bold),
                                      decoration: InputDecoration(
                                        hintText: 'Car Model',
                                        hintStyle: TextStyle(
                                          color : Colors.grey,
                                        ),
                                        filled: true,
                                        fillColor: darkTheme ? Colors.black45 : Colors.grey.shade200,
                                        //꼭지점 둥글게 깎기
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(40),
                                            borderSide: BorderSide(
                                              style: BorderStyle.none,
                                              width: 0,
                                            )
                                        ),
                                        //textform 에서 말그대로 앞에 존재하는 icon를 말합니다.
                                        prefixIcon: Icon(Icons.person, color:darkTheme ? Colors.amber.shade400 : Colors.grey),
                                      ),
                                      autovalidateMode: AutovalidateMode.onUserInteraction,
                                      validator: (text) {
                                        if(text==null || text.isEmpty)
                                        {
                                          return "Name can\'t be empty";
                                        }
                                        if(text.length<2)
                                        {
                                          return "Please enter a valid name";
                                        }
                                        if(text.length>50)
                                        {
                                          return "Name can\'t be more than 50";
                                        }
                                      },
                                      onChanged: (text) => setState(() {
                                        carModelTextEditingController.text = text;
                                      }),
                                    ),

                                    SizedBox(height: 15),

                                    TextFormField(
                                      inputFormatters: [
                                        LengthLimitingTextInputFormatter(50)
                                      ],
                                      style: TextStyle(color: Colors.grey,fontWeight: FontWeight.bold),
                                      decoration: InputDecoration(
                                        hintText: 'Car Number',
                                        hintStyle: TextStyle(
                                          color : Colors.grey,
                                        ),
                                        filled: true,
                                        fillColor: darkTheme ? Colors.black45 : Colors.grey.shade200,
                                        //꼭지점 둥글게 깎기
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(40),
                                            borderSide: BorderSide(
                                              style: BorderStyle.none,
                                              width: 0,
                                            )
                                        ),
                                        //textform 에서 말그대로 앞에 존재하는 icon를 말합니다.
                                        prefixIcon: Icon(Icons.person, color:darkTheme ? Colors.amber.shade400 : Colors.grey),
                                      ),
                                      autovalidateMode: AutovalidateMode.onUserInteraction,
                                      validator: (text) {
                                        if(text==null || text.isEmpty)
                                        {
                                          return "Name can\'t be empty";
                                        }
                                        if(text.length<2)
                                        {
                                          return "Please enter a valid name";
                                        }
                                        if(text.length>50)
                                        {
                                          return "Name can\'t be more than 50";
                                        }
                                      },
                                      onChanged: (text) => setState(() {
                                        carNumberTextEditingController.text = text;
                                      }),
                                    ),

                                    SizedBox(height: 15),

                                    TextFormField(
                                      inputFormatters: [
                                        LengthLimitingTextInputFormatter(50)
                                      ],
                                      style: TextStyle(color: Colors.grey,fontWeight: FontWeight.bold),
                                      decoration: InputDecoration(
                                        hintText: 'Car Color',
                                        hintStyle: TextStyle(
                                          color : Colors.grey,
                                        ),
                                        filled: true,
                                        fillColor: darkTheme ? Colors.black45 : Colors.grey.shade200,
                                        //꼭지점 둥글게 깎기
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(40),
                                            borderSide: BorderSide(
                                              style: BorderStyle.none,
                                              width: 0,
                                            )
                                        ),
                                        //textform 에서 말그대로 앞에 존재하는 icon를 말합니다.
                                        prefixIcon: Icon(Icons.person, color:darkTheme ? Colors.amber.shade400 : Colors.grey),
                                      ),
                                      autovalidateMode: AutovalidateMode.onUserInteraction,
                                      validator: (text) {
                                        if(text==null || text.isEmpty)
                                        {
                                          return "Name can\'t be empty";
                                        }
                                        if(text.length<2)
                                        {
                                          return "Please enter a valid name";
                                        }
                                        if(text.length>50)
                                        {
                                          return "Name can\'t be more than 50";
                                        }
                                      },
                                      onChanged: (text) => setState(() {
                                        carColorTextEditingController.text = text;
                                      }),
                                    ),

                                    SizedBox(height: 20),

                                    DropdownButtonFormField(
                                      decoration: InputDecoration(
                                        hintText: 'Please Choose Car Type',
                                        prefixIcon: Icon(Icons.car_crash, color: darkTheme ? Colors.grey : Colors.blue),
                                        filled: true,
                                        fillColor: darkTheme ? Colors.black45 : Colors.grey.shade200,
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(40),
                                          borderSide: BorderSide(
                                            width: 0,
                                            style: BorderStyle.none,
                                          )
                                        ),
                                      ),
                                      items: carTypes.map((car) {
                                        return DropdownMenuItem(
                                              child: Text(
                                                car, style: TextStyle(
                                                  color: Colors.grey),
                                            ),
                                            value: car,

                                        );
                                      }).toList(),
                                      //changed된 value가 newvalue에 들어갑니다.
                                      onChanged: (newValue){
                                        setState(() {
                                          selectedCarType = newValue.toString();
                                        });
                                      },
                                    ),

                                    SizedBox(height: 20),

                                    ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          primary: darkTheme ? Colors.amber.shade300 : Colors.blue,
                                          onPrimary: darkTheme ? Colors.black : Colors.white,
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(30)
                                          ),
                                          minimumSize: Size(double.infinity, 50),
                                        ),
                                        onPressed: (){
                                          _submit();
                                        },
                                        child: Text(
                                            'Register',
                                            style: TextStyle(
                                              fontSize: 20,
                                            )
                                        )
                                    ),

                                    SizedBox(height:20),

                                    GestureDetector(
                                        onTap: (){
                                          Navigator.push(context,MaterialPageRoute(builder: (c) => ForgotPasswordScreen()));
                                        },
                                        child: Text(
                                          'Forget Password?',
                                          style: TextStyle(
                                              color: darkTheme ? Colors.amber.shade400 : Colors.blue
                                          ),
                                        )
                                    ),

                                    SizedBox(height:20),

                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Have an account?",
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 15,
                                          ),
                                        ),

                                        SizedBox(width:5),

                                        GestureDetector(
                                            onTap: (){},
                                            child: Text(
                                              "Sign In",
                                              style: TextStyle(
                                                fontSize:15,
                                                color: darkTheme ? Colors.amber.shade400 : Colors.blue,
                                              ),
                                            )
                                        )
                                      ],
                                    )
                                  ],
                                )
                            ),
                          )
                        ],
                      )
                    ]
                ),
              ]
          )
      ),
    );
  }
}
