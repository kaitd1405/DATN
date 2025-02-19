import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:ebookapp/controller/api.dart';
import 'package:ebookapp/view/bottom_view/bottom_view.dart';
import 'package:ebookapp/view/component/textfield_main.dart';
import 'package:ebookapp/view/register/ebook_register.dart';
import 'package:ebookapp/widget/common_pref.dart';
import 'package:ebookapp/widget/ebook_routes.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class EbookLogin extends StatefulWidget {
  const EbookLogin({super.key});

  @override
  State<EbookLogin> createState() => _EbookLoginState();
}

class _EbookLoginState extends State<EbookLogin> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  bool visibleLoading = false;

  Future login(
      {required TextEditingController email,
      required TextEditingController password,
      required BuildContext context,
      required Widget widget}) async {
    String getEmail = email.text;
    String getPassword = password.text;

    setState(() {
      visibleLoading = true;
    });

    var data = {'email': getEmail, 'password': getPassword};
    var req = await Dio()
        .post(ApiConstant().baseUrl() + ApiConstant().login, data: data);

    var decode = jsonDecode(req.data);
    if (decode[4] == 'Successfully login') {
      setState(() {
        visibleLoading = false;
      });
      //This is shared preference to save data
      saveLogin(id: decode[0], name: decode[1], email: decode[2], photo: '');
      pushAndRemove(context, BottomView());
    } else {
      setState(() {
        visibleLoading = false;
      });
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text(
                'Please double check your email or password',
                style: TextStyle(color: Colors.blue),
              ),
              actions: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Text('Okey'),
                )
              ],
            );
          });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadLogin().then((value) {
      setState(() {
        if (value != null) {
          pushAndRemove(context, BottomView());
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        margin: const EdgeInsets.only(top: 70),
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  Image.asset(
                    'asset/images/noimg.png',
                    width: 125,
                    height: 125,
                  ),
                  const Text(
                    'Hello, Welecome back !',
                    style: TextStyle(color: Colors.blue, fontSize: 24),
                  ),
                  TextFiledMain(
                      hintText: 'Enter your email',
                      iconFiled: Icons.email_outlined,
                      textController: email),
                  TextFiledMain(
                      hintText: 'Enter your password',
                      iconFiled: Icons.password_outlined,
                      textController: password,
                      typePassword: true),
                  GestureDetector(
                    onTap: () {
                      login(
                          email: email,
                          password: password,
                          context: context,
                          widget: widget);
                    },
                    child: Container(
                      margin: const EdgeInsets.only(
                          right: 20, left: 20, top: 17, bottom: 5),
                      padding: EdgeInsets.symmetric(
                          vertical: 1.2.h, horizontal: 1.5.h),
                      decoration: const BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      width: MediaQuery.of(context).size.width,
                      child: !visibleLoading
                          ? SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: const Text(
                                'Login',
                                style: TextStyle(color: Colors.white),
                                textAlign: TextAlign.center,
                              ),
                            )
                          : Visibility(
                              visible: visibleLoading,
                              child: SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  child: const Center(
                                    child: SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 1.5,
                                        color: Colors.white,
                                      ),
                                    ),
                                  )),
                            ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      margin: EdgeInsets.only(
                          right: 20, left: 20, bottom: 5, top: 1.5.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Dont have an account?',
                            style: TextStyle(color: Colors.black, fontSize: 17),
                          ),
                          const SizedBox(width: 10),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => EbookRegister()),
                                  (route) => false);
                            },
                            child: const Text(
                              'Register',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 17),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
