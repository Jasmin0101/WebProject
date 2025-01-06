import 'package:chopper/chopper.dart';

part '../../../.gen/core/api/services/user.chopper.dart';

@ChopperApi()
abstract class UserService extends ChopperService {
  @Post(path: '/login')
  Future<Response> login(
    @Field('login') String login,
    @Field('password') String password,
  );
  @Post(path: '/checkPassword')
  Future<Response> checkPassword(
    @Field('currentPassword') String currentPassword,
  );

  @Post(path: '/registration')
  Future<Response> registration(
    @Field('name') String name,
    @Field('surname') String surname,
    @Field('email') String email,
    @Field('city') int city,
    @Field('login') String login,
    @Field('password') String password,
    @Field('dob') String dob,
  );

  @Get(path: '/user/me/view')
  Future<Response> userMeView();

  @Post(path: '/user/me/edit')
  Future<Response> edit(
    @Field('name') String name,
    @Field('surname') String surname,
    @Field('email') String email,
    @Field('city') int city,
    @Field('login') String login,
    @Field('password') String password,
    @Field('dob') String dob,
  );

  @Get(path: '/cities/view')
  Future<Response> citiesView();

  static UserService create([ChopperClient? client]) => _$UserService(client);
}
