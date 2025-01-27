import 'package:chopper/chopper.dart';

part '../../../.gen/core/api/services/admin.chopper.dart';

@ChopperApi()
abstract class AdminService extends ChopperService {
  @Get(path: 'application/admin/view')
  Future<Response> viewApplications(
    @Query("page") int page, {
    @Query("status") String? status,
  });

  @Post(path: 'application/info_req')
  Future<Response> infoReq(
    @Field("application_id") int applicationId,
  );
  static AdminService create([ChopperClient? client]) => _$AdminService(client);
}
