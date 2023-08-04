# Whilabel Main Appication

Whilabel Main Flutter Application

## Structure

- data
    - user
        - user_entity.dart
        - user_dto.dart
    - whisky
    - distillery
    - ...
- domain
    - user
        - user_repository.dart
            - repository 역할 기술
        - user_firebase_repository_impl.dart
            - firebase 에서 repository를 구현한 구현체
            - Entity <-> DTO CRUD
        - user_usecase / user_service.dart
            - 실제 비즈니스 로직
    - whisky
    - ...
- view
    - home
        - home_view.dart
            - DTO를 뿌려줌
        - home_view_model.dart
            - DTO 들을 가져와 state로 관리
    - ...