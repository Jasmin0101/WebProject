import 'package:chopper/chopper.dart';

part '../../../.gen/core/api/services/application.chopper.dart';

@ChopperApi()
abstract class ApplicationService extends ChopperService {
  @Post(path: '/application/create')
  Future<Response> applicationCreate(
    @Field('title') String title,
    @Field('text') String text,
  );

  @Get(path: '/application/view')
  Future<Response> applicationView({
// @Query используется для передачи параметров в строку запроса (query string) URL.
// Например, если вы вызовете applicationView(status: "send"), запрос будет отправлен как
// Копировать код
// GET /application/view?status=send
    @Query('status') String? status, // Параметр для фильтрации по статусу
  });

  @Post(path: '/application/my/edit')
  Future<Response> myApplicationEdit(
    @Field('title') String title,
    @Field('text') String text,
    @Field('id') int id,
  );

  @Get(path: '/application/my/view')
  Future<Response> myApplicationView();

  static ApplicationService create([ChopperClient? client]) =>
      _$ApplicationService(client);
}
