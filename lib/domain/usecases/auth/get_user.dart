import 'package:dartz/dartz.dart';
import 'package:yt_music/core/usecase/usecase.dart';
// import 'package:yt_music/domain/entities/auth/user.dart';
import 'package:yt_music/domain/repository/auth/auth.dart';
import 'package:yt_music/service_locator.dart';

class GetUserUseCase implements Usecase<Either,dynamic> {
  @override
  Future<Either> call({params}) async{
    return await sl<AuthRepository>().getUser();
  }

}