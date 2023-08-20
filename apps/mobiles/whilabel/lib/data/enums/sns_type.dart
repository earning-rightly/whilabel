// json 파일도 주기
// enum SnsType { kakao, instargram, google, ios }

enum SnsType {
  kakao("Kakao"),
  instargram("Instargram"),
  google("Google"),
  apply("apply");

  final String text;
  const SnsType(this.text);

  @override
  String toString() => text;
}
