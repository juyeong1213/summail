
import 'package:flutter/material.dart';
import 'package:get/get.dart';


import '../../controller/login_controller.dart';
import '../../controller/registeration_controller.dart';
import '../../google_login/google_login.dart';
import '../../google_login/webview.dart';
import '../widgets/input_fields.dart';
import '../widgets/submit_button.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart'; // GetX 라이브러리를 사용하기 위한 import

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  // 컨트롤러 정의
  final RegisterationController registerationController = Get.put(RegisterationController());
  final LoginController loginController = Get.put(LoginController());

  final isLogin = false.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack( // Stack 위젯을 사용하여 이미지와 위젯들을 겹치게 함
        children: [
          Container( // 백그라운드 이미지를 채우기 위한 Container
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/t2.jpeg"), // 여기에 원하는 배경 이미지 경로를 입력하세요
                fit: BoxFit.cover, // 이미지가 전체 화면을 채우도록 설정
              ),
            ),
          ),
          SingleChildScrollView( // 기존의 SingleChildScrollView를 Stack의 두 번째 자식으로 이동
            child: Padding(
              padding: const EdgeInsets.all(36),
              child: Center(
                child: Obx(
                      () => Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 30),
                      /*Image.asset(
                        'assets/sum.jpeg',
                        width: 200, // 이미지의 너비를 설정하세요
                        height: 100, // 이미지의 높이를 설정하세요
                      ),*/
                      const SizedBox(height: 100),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white, backgroundColor: !isLogin.value ? Colors.deepPurple : Colors.purple[200],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                              ),
                              elevation: 5, // 버튼에 그림자 추가
                            ),
                            onPressed: () {
                              isLogin.value = false;
                            },
                            child: const Text('Register'),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white, backgroundColor: isLogin.value ? Colors.deepPurple : Colors.purple[200],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                              ),
                              elevation: 5,
                            ),
                            onPressed: () {
                              isLogin.value = true;
                            },
                            child: const Text('Login'),
                          )
                        ],
                      ),
                      const SizedBox(height: 80),
                      isLogin.value ? loginWidget() : registerWiget(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget googleLoginButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white, backgroundColor: Colors.white54,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
        ),
        elevation: 4,
      ),
      onPressed: () {
        Get.to(() => const WebView()); // WebView 화면으로 이동
      },
      child: const Text('Google Login'),
    );
  }


  Widget loginWidget(){
    return Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        InputTextFieldWidget(
          textEditingController: loginController.emailController,
          hintText: 'email address',
        ),
        const SizedBox(
          height: 20,
        ),
        InputTextFieldWidget(
          textEditingController: loginController.passwordController,
          hintText: 'password',
        ),
        const SizedBox(
          height: 20,
        ),
        SubmitButton(
          onPressed: () => loginController.loginWithEmail(), title: 'Login',
        ),
        const SizedBox(height: 20),
        googleLoginButton(), // 구글 로그인 버튼 추가

      ],
    );
  }
  Widget registerWiget(){
    return Column(
      children: [
        InputTextFieldWidget(
          textEditingController: registerationController.nameController,
          hintText: 'name',
        ),
        const SizedBox(height: 20),
        InputTextFieldWidget(
          textEditingController: registerationController.emailController,
          hintText: 'email address',
        ),
        const SizedBox(height: 20),
        InputTextFieldWidget(
          textEditingController: registerationController.passwordController,
          hintText: 'password',
        ),
        const SizedBox(height: 20),
        SubmitButton(onPressed: () => registerationController.registerWithEmail(), title: 'Register'),
        //googleLoginButton()
        const SizedBox(height: 20),
        googleLoginButton(), // 구글 로그인 버튼 추가
      ],
    );
  }
}



/*
class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  RegisterationController registerationController = Get.put(RegisterationController());
  LoginController loginController = Get.put(LoginController());

  var isLogin = false.obs;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(36),
          child: Center(
            child: Obx(
                  () => Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    Text(
                      '썸메일V',
                      style: TextStyle(
                          fontSize: 30,
                          color: Colors.purple[900],
                          fontWeight: FontWeight.w400
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MaterialButton(
                          color: !isLogin.value ? Colors.white : Colors.amber,
                          onPressed: (){
                            isLogin.value = false;
                          },
                          child: const Text('Register'),
                        ),
                        MaterialButton(
                          color: isLogin.value ? Colors.white: Colors.amber,
                          onPressed: (){
                            isLogin.value = true;
                          },
                          child: const Text('Login'),
                        )
                      ],
                    ),
                    //GoogleLogin(),
                    const SizedBox(
                      height: 80,
                    ),
                    isLogin.value ? loginWidget() : registerWiget()
                  ]),
            ),
          ),
        ),
      ),
    );
  }

Widget googleLoginButton() {
    return MaterialButton(
      color: Colors.blue[400],
      onPressed: () {
        Get.to(() => WebView()); // GetX를 사용하여 WebViewExample 화면으로 이동
      },
      child: Text(
        'Google Login',
        style: TextStyle(color: Colors.white),
      ),
    );
  }



  Widget loginWidget(){
    return Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        InputTextFieldWidget(
          textEditingController: loginController.emailController,
          hintText: 'email address',
        ),
        const SizedBox(
          height: 20,
        ),
        InputTextFieldWidget(
          textEditingController: loginController.passwordController,
          hintText: 'password',
        ),
        const SizedBox(
          height: 20,
        ),
        SubmitButton(
          onPressed: () => loginController.loginWithEmail(), title: 'Login',
        ),
        const SizedBox(height: 20),
        googleLoginButton(), // 구글 로그인 버튼 추가

      ],
    );
  }
  Widget registerWiget(){
    return Column(
      children: [
        InputTextFieldWidget(
          textEditingController: registerationController.nameController,
          hintText: 'name',
        ),
        const SizedBox(height: 20),
        InputTextFieldWidget(
          textEditingController: registerationController.emailController,
          hintText: 'email address',
        ),
        const SizedBox(height: 20),
        InputTextFieldWidget(
          textEditingController: registerationController.passwordController,
          hintText: 'password',
        ),
        const SizedBox(height: 20),
        SubmitButton(onPressed: () => registerationController.registerWithEmail(), title: 'Register'),
        //googleLoginButton()
        const SizedBox(height: 20),
        googleLoginButton(), // 구글 로그인 버튼 추가
      ],
    );
  }


}
*/

