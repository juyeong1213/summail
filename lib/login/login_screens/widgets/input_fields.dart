import 'package:flutter/material.dart';

// InputTextFieldWidget 클래스 정의
class InputTextFieldWidget extends StatelessWidget {
  // 생성자에서 textEditingController와 hintText를 필수 인자로 받음
  const InputTextFieldWidget({Key? key, required this.textEditingController, required this.hintText}) : super(key: key);

  // final 키워드를 사용하여 변수를 불변으로 만듦
  final TextEditingController textEditingController;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    // 입력 필드를 담은 컨테이너 반환
    return Container(
      height: 46, // 컨테이너 높이 설정
      child: TextField(
        controller: textEditingController, // TextField의 컨트롤러 설정
        decoration: InputDecoration(
            alignLabelWithHint: true, // 라벨과 힌트 텍스트를 상단에 정렬
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black) // 포커스 상태일 때 밑줄 색상 설정
            ),
            fillColor: Colors.white54, // 필드의 배경 색상 설정
            hintText: hintText, // 힌트 텍스트 설정
            hintStyle: TextStyle(color: Colors.grey), // 힌트 텍스트 스타일 설정
            contentPadding: EdgeInsets.only(bottom: 15), // 내용 패딩 설정
            focusColor: Colors.white60 // 포커스 색상 설정
        ),
      ),
    );
  }
}



/*
import 'package:flutter/material.dart';

class InputTextFieldWidget extends StatelessWidget {
  const InputTextFieldWidget(TextEditingController nameController, String s, {super.key, required this.textEditingController, required this.hintText});
  final TextEditingController textEditingController;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      child: TextField(
        controller: textEditingController,
        decoration: InputDecoration(
          alignLabelWithHint: true,
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black)
          ),
          fillColor: Colors.white54,
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey),
          contentPadding: EdgeInsets.only(bottom: 15),
          focusColor: Colors.white60
        ),
      ),
    );
  }
}
*/
