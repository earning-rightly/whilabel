String? checkAbleNameRule(String? value) {
  if (value == null || value.length < 2) return '2글자 이상 입력해주세요.';

  if (value.toString().length > 10) return '최대 10자까지 입력 가능합니다.';

  if (!RegExp(r'^[가-힣]+$').hasMatch(value)) return '한글만 입력 가능합니다.';

  return null;
}

String? checkAbleNickNameRule(String? value) {
  if (value == null || value.length < 2) return '2글자 이상 입력해주세요.';

  if (value.length > 20) return '최대 20자까지 입력 가능';

  if (!RegExp(r'^[_a-zA-Z0-9가-힣]+$')
      .hasMatch(value)) return '[한글, 영문, 숫자, 언더바]만 사용 가능합니다.';

  return null;
}
