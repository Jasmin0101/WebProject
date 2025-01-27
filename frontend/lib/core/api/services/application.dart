import 'package:chopper/chopper.dart';
import 'package:http/http.dart' show MultipartFile;

part '../../../.gen/core/api/services/application.chopper.dart';

@ChopperApi()
abstract class ApplicationService extends ChopperService {
  @Post(path: '/application/close')
  Future<Response> close(
    @Field('application_id') int applicationId,
  );

  @Post(path: '/application/add/text')
  Future<Response> addText(
    @Field('application_id') int applicationId,
    @Field('text') String text,
  );

  @Get(path: '/application/view/page')
  Future<Response> viewPage(
    @Query('application_id') int applicationId,
    @Query('page') int page,
  );

  @Get(path: '/application/view')
  Future<Response> view(
    @Query('application_id') int applicationId,
  );

  @Post(path: '/application/{id}/add/file')
  @multipart
  Future<Response> uploadFile(
    @Path('id') int applicationId,
    @PartFile('file') MultipartFile file,
  );

  static ApplicationService create([ChopperClient? client]) =>
      _$ApplicationService(client);
}
