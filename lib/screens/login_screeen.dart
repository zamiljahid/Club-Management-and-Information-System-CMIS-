import 'package:flutter/material.dart';
class LoginScreen extends StatelessWidget{
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
  return Scaffold(
    body: Stack(
      children: [
        Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors:[Color(0xff8c0000), Color(0xffda2851)]
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 60.0,left: 15),

            child:
            Column(
              children: [
                Text('Welcome To!',style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                    fontWeight: FontWeight.bold
                ),
                ),
            SizedBox(height: 10,),
            Text('Club Management & Information System',style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold
                ),
                ),
              ],

            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 200.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40),
                topRight: Radius.circular(40)
              ),
              color: Colors.white,
            ),
            height: double.infinity,
            width: double.infinity,
            child: Padding(
              padding: EdgeInsets.only(left: 18.0,right: 18),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 10,),
                    Container(
                      padding: EdgeInsets.all(8), // Border width
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: [Color(0xff8c0000), Color(0xffda2851)],),
                           shape: BoxShape.circle),
                      child: ClipOval(
                        child: SizedBox.fromSize(
                          size: Size.fromRadius(80), // Image radius
                          child: Image.asset('assets/images/appIcon.jpg', fit: BoxFit.cover),
                        ),
                      ),
                    ),
                    SizedBox(height: 60,),
                    TextField(
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 2, color: Colors.redAccent),
                        ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 2, color: Color(0xff8c0000)),
                          ),
                        suffixIcon: Icon(Icons.email,color:  Color(0xff8c0000),),
                        label: Text('Email',style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xff8c0000),
                
                        ),)
                      ),
                    ),
                    SizedBox(height: 10,),
                    TextField(
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 2, color: Colors.redAccent),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 2, color:Color(0xff8c0000)),
                          ),
                          suffixIcon: Icon(Icons.visibility_off,color:Color(0xff8c0000),),
                          label: Text('Password',style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xff8c0000),
                          ),)
                      ),
                    ),
                    SizedBox(height: 70,),
                    Container(
                      height: 55,
                        width: 300,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        gradient: LinearGradient(
                            colors:
                            [Color(0xff8c0000), Color(0xffda2851)
                            ]),
                      ),
                      child: Center(child: Text('SIGN IN',style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.white
                      ),),),
                
                    )
                  ],
                
                
                ),
              ),
            ),
          ),
        )
      ],
    )
  );
  }
}