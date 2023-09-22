import 'package:driverapp/screens/register_screen.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../assist/assist_methods.dart';
import '../global/global.dart';
import '../splashScreen/splash_screen.dart';
import 'forgot_password_screen.dart';
import 'main_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {


  final emailTextEditingController = TextEditingController();
  final passwordTextEditingController = TextEditingController();

  bool _passwordVisible = false;

  final _formKey = GlobalKey<FormState>();

  void _submit() async{
    if(_formKey.currentState!.validate()){
      try {
        await firebaseAuth.signInWithEmailAndPassword(
          //trim은 문자열 앞과 뒤 공백을 제거해줍니다.
          email: emailTextEditingController.text.trim(),
          password: passwordTextEditingController.text.trim(),
        ).then((auth) async{
          //이런것들은 firebase 공식 문서 찾아가면서 하나하나 작성해나가야하는데.
          //인도인은 쉽게쉽게 적어버리네
          DatabaseReference userRef = FirebaseDatabase.instance.ref().child("driverapp");
          userRef.child(firebaseAuth.currentUser!.uid).once().then((value) async{
            final snap = value.snapshot;
            if(snap.value!=null) {
              currentUser = auth.user;
              await Fluttertoast.showToast(msg: "Successfully Logged In");
              Navigator.push(context,MaterialPageRoute(builder: (c) => MainScreen()));
            }
            else{
              await Fluttertoast.showToast(msg: "No record exist with this email");
              firebaseAuth.signOut();
              Navigator.push(context,MaterialPageRoute(builder: (c) => SplashScreen()));
            }
          }
          );
        }).catchError((errorMessage){
          Fluttertoast.showToast(msg: "Error occured: \n $errorMessage");
        });
      } catch (e, s) {
        print(s);
      }
    }
    else{
      Fluttertoast.showToast(msg: "Not all field are valid");
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

                          Text('Login',
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
                                        hintText: 'Email',
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
                                        prefixIcon: Icon(Icons.email, color:darkTheme ? Colors.amber.shade400 : Colors.grey),
                                      ),
                                      autovalidateMode: AutovalidateMode.onUserInteraction,
                                      validator: (text) {
                                        if(text==null || text.isEmpty)
                                        {
                                          return "Email can\'t be empty";
                                        }
                                        if(EmailValidator.validate(text)==true)
                                        {
                                          return null;
                                        }
                                        if(text.length<2)
                                        {
                                          return "Please enter a valid email";
                                        }
                                        if(text.length>99)
                                        {
                                          return "email can\'t be more than 99";
                                        }
                                      },
                                      onChanged: (text) => setState(() {
                                        emailTextEditingController.text = text;
                                      }),
                                    ),

                                    SizedBox(height: 15),

                                    TextFormField(
                                      obscureText: !_passwordVisible,
                                      inputFormatters: [
                                        LengthLimitingTextInputFormatter(50)
                                      ],
                                      style: TextStyle(color: Colors.grey,fontWeight: FontWeight.bold),
                                      decoration: InputDecoration(
                                          hintText: 'Password',
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
                                          prefixIcon: Icon(Icons.key, color:darkTheme ? Colors.amber.shade400 : Colors.grey),
                                          suffixIcon: IconButton(
                                            onPressed: () {
                                              setState(() {
                                                _passwordVisible = !_passwordVisible;
                                              });
                                            },
                                            icon: Icon(_passwordVisible ? Icons.visibility : Icons.visibility_off,
                                              color: darkTheme ? Colors.amber.shade400 : Colors.grey,
                                            ),
                                          )
                                      ),
                                      autovalidateMode: AutovalidateMode.onUserInteraction,
                                      validator: (text) {
                                        if(text==null || text.isEmpty)
                                        {
                                          return "Password can\'t be empty";
                                        }
                                        if(text.length<6)
                                        {
                                          return "Please enter a valid password";
                                        }
                                        if(text.length>50)
                                        {
                                          return "Password can\'t be more than 50";
                                        }
                                        return null;
                                      },
                                      onChanged: (text) => setState(() {
                                        passwordTextEditingController.text = text;
                                      }),
                                    ),

                                    SizedBox(height: 15),

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
                                            'Login',
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
                                          "Doesn't have an account?",
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 15,
                                          ),
                                        ),

                                        SizedBox(width:5),

                                        GestureDetector(
                                            onTap: (){
                                              Navigator.push(context,MaterialPageRoute(builder: (c) => RegisterScreen()));
                                            },
                                            child: Text(
                                              "Register",
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
      )
    );
  }
}
