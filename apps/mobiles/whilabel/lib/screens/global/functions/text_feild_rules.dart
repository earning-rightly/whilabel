String? checkAbleNameRule(String? value) {
  if (value == null || value.length < 2) return '2글자 이상 입력해주세요';

  if (value.toString().length > 10) return '최대 10자까지 입력 가능';

  if (RegExp(r'[!@#%^&*(),.?";:{}|<>-_+=]').hasMatch(value)) return '특수문자 x';

  if (RegExp('[0-9]').hasMatch(value)) return '숫자 입력 x';

  if (RegExp('[a-z | A-Z]').hasMatch(value)) return '영어 입력 x';

  if (RegExp(' ').hasMatch(value)) return '스페이스는 포함할 수 없습니다';

  if (!RegExp('[ㄱ-ㅎ|ㅏ-ㅣ|가-힣|ᆞ|ᆢ|ᄀᆞ|ᄂᆞ|ᄃᆞ|ᄅᆞ|ᄆᆞ|ᄇᆞ|ᄉᆞ|ᄋᆞ|ᄌᆞ|ᄎᆞ|ᄏᆞ|ᄐᆞ|ᄑᆞ|ᄒᆞ]')
      .hasMatch(value)) return '한글만 입력';

  return null;
}

String? checkAbleNickNameRule(String? value) {
  if (value == null || value.length < 2) return '2글자 이상 입력해주세요';

  if (value.toString().length > 15) return '최대 15자까지 입력 가능';

  if (RegExp(' ').hasMatch(value)) return '스페이스는 포함할 수 없습니다';

  if (RegExp(r'[!@#%^&*(),.?";:{}|<>+=]').hasMatch(value)) return '특수문자 x';

  if (!RegExp(
          r'[_|a-z|A-Z|0-9|ㄱ-ㅎ|ㅏ-ㅣ|가-힣|ᆞ|ᆢ|ᄀᆞ|ᄂᆞ|ᄃᆞ|ᄅᆞ|ᄆᆞ|ᄇᆞ|ᄉᆞ|ᄋᆞ|ᄌᆞ|ᄎᆞ|ᄏᆞ|ᄐᆞ|ᄑᆞ|ᄒᆞ]')
      .hasMatch(value)) return '[한글, 영어, 숫자, _ ]만 가능합니다';

  return null;
}
