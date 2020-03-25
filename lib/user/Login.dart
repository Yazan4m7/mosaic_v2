import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mosaic/business/Logger.dart';
import 'package:mosaic/user/User_Controller.dart';

class Login extends StatelessWidget {

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    //var scaffoldKey = GlobalKey<ScaffoldState>();
    ScreenUtil.instance = ScreenUtil()..init(context);
    return MaterialApp(
      theme: ThemeData(primaryColor: Colors.lightBlue),
      home: Scaffold(
        appBar: AppBar(backgroundColor: Colors.white,iconTheme: new IconThemeData(color: Colors.black)),
        //key: scaffoldKey,
        drawer:new Drawer(
          child:new ListView(
            children: <Widget>[
            Container(
            height: 150.0,
            child: DrawerHeader(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0,60,0.0,0),
                  child: Text('Nothing is here yet.', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30,color: Colors.white)),
                ),
                decoration: BoxDecoration(
                    color: Colors.black87
                ),

            ),
          ),

              new ListTile(
                title: Text("Logs"),
                trailing: Icon(Icons.folder),
                onTap:(){ Logger.openLogs();}
              )
            ],
          ),
        ),

        body: Stack(
          children: <Widget>[

            Container(
              width: MediaQuery.of(context).size.width,
              //margin: EdgeInsets.only(top: 270),
              decoration: BoxDecoration(
                // borderRadius: BorderRadius.circular(20),
                color: Colors.white,
              ),
              child: Padding(
                padding: EdgeInsets.all(23),
                child: ListView(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(80.0, 0, 80.0, 10),
                      child: Image.asset(
                        "assets/images/logo.png",
                        width: ScreenUtil.getInstance().setWidth(600),
                        height: ScreenUtil.getInstance().setHeight(600),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                      child: Container(
                        color: Color(0xfff5f5f5),

                        child: TextFormField(
                          controller: usernameController,
                          style: TextStyle(
                              color: Colors.black87, fontFamily: 'SFUIDisplay'),
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Username',
                              prefixIcon: Icon(Icons.person_outline),
                              labelStyle: TextStyle(fontSize: 15)),
                        ),
                      ),
                    ),
                    Container(
                      color: Color(0xfff5f5f5),
                      child: TextFormField(
                        controller: passwordController,
                        obscureText: true,
                        style: TextStyle(
                            color: Colors.black, fontFamily: 'SFUIDisplay'),
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Password',
                            prefixIcon: Icon(Icons.lock_outline),
                            labelStyle: TextStyle(fontSize: 15)),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: MaterialButton(
                        onPressed: () {
                          UserController.logIn(usernameController.text.trim(),
                              passwordController.text.trim(), context);
                        },
                        child: Text(
                          'SIGN IN',
                          style: TextStyle(
                            fontSize: 15,
                            fontFamily: 'SFUIDisplay',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        color: Colors.black,
                        elevation: 0,
                        minWidth: 400,
                        height: 50,
                        textColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
