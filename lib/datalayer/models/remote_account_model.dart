import 'package:my_app/datalayer/http/http.dart';
import 'package:my_app/domain/entities/entities.dart';

class RemoteAccountModel {
  final String accessToken;

  RemoteAccountModel(this.accessToken);

  factory RemoteAccountModel.fromJson(Map json) {
    if (!json.containsKey('acessToken')) {
      throw HttpError.invalidData;
    }
    return RemoteAccountModel(json['acessToken']);
  }

  AccountEntity toEntity() => AccountEntity(accessToken);
}
