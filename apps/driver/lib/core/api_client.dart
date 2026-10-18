import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'config.dart';
class ApiClient {
 final Dio dio=Dio(BaseOptions(baseUrl:Config.apiUrl,connectTimeout:const Duration(seconds:8),receiveTimeout:const Duration(seconds:8)));
 final FlutterSecureStorage storage=const FlutterSecureStorage();
 ApiClient(){dio.interceptors.add(InterceptorsWrapper(onRequest:(options,handler)async{final token=await storage.read(key:'access');if(token!=null)options.headers['Authorization']='Bearer $token';handler.next(options);},onError:(error,handler)async{
   if(error.response?.statusCode==401&&!error.requestOptions.path.contains('/auth/')){
    final refresh=await storage.read(key:'refresh');if(refresh!=null){try{final r=await Dio(BaseOptions(baseUrl:Config.apiUrl)).post('/auth/refresh',data:{'refreshToken':refresh});await storage.write(key:'access',value:r.data['accessToken'] as String);await storage.write(key:'refresh',value:r.data['refreshToken'] as String);final retry=error.requestOptions;retry.headers['Authorization']='Bearer ${r.data['accessToken']}';return handler.resolve(await dio.fetch(retry));}catch(_){await logoutLocal();}}
   }handler.next(error);
 }));}
 Future<bool> isLoggedIn()async=>await storage.read(key:'refresh')!=null;
 Future<void> login(String email,String password)async{final r=await dio.post('/auth/login',data:{'email':email,'password':password});if(r.data['user']['role']!='driver')throw StateError('Use driver account');await storage.write(key:'access',value:r.data['accessToken'] as String);await storage.write(key:'refresh',value:r.data['refreshToken'] as String);}
 Future<void> logout()async{final refresh=await storage.read(key:'refresh');try{if(refresh!=null)await dio.post('/auth/logout',data:{'refreshToken':refresh});}catch(_){}await logoutLocal();}
 Future<void> logoutLocal()async{await storage.delete(key:'access');await storage.delete(key:'refresh');}
}
