import 'package:dartz/dartz.dart';
import 'package:yt_music/core/usecase/usecase.dart';
import 'package:yt_music/data/models/auth/create_user_req.dart';
import 'package:yt_music/domain/repository/auth/auth.dart';
import 'package:yt_music/service_locator.dart';

class SignupUseCase implements Usecase<Either,CreateUserReq> {


  @override
  Future<Either> call({CreateUserReq? params}) async {
    
    return await sl<AuthRepository>().signup(params!);
  }
  
}