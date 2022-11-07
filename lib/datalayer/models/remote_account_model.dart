import 'package:my_app/domain/entities/entities.dart';

class RemoteAccountModel {
  final String accessToken;

  RemoteAccountModel(this.accessToken);

  factory RemoteAccountModel.fromJson(Map json) =>
      RemoteAccountModel(json['acessToken']);

  AccountEntity toEntity() => AccountEntity(accessToken);
}