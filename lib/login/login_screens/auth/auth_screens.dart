
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:summail/login/google_login/google_login.dart';

import '../../controller/login_controller.dart';
import '../../controller/registeration_controller.dart';
import '../widgets/input_fields.dart';
import '../widgets/submit_button.dart';


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
        Get.to(() => Google_login()); // GetX를 사용하여 WebViewExample 화면으로 이동
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

