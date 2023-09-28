import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'my_page_event.freezed.dart';

@freezed
abstract class MyPageEvent with _$MyPageEvent {
  const factory MyPageEvent.changePushAlimValue(String uid) =
      ChangePushAlimValue;
  const factory MyPageEvent.changeMarketingAlimValue(String uid) =
      ChangeMarketingAlimValue;
  const factory MyPageEvent.withdrawAccount(String uid) = WithdrawAccount;

  const factory MyPageEvent.sendEmail(String uid) = SendEmail;
}
