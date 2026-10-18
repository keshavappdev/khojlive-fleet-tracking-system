import 'dart:async';
import 'dart:math';
import 'package:dio/dio.dart';
import 'api_client.dart';
import 'local_store.dart';
class SyncManager {
 final LocalStore store;final ApiClient api;
 Timer? _timer;bool _busy=false;int _failures=0;
 SyncManager(this.store,this.api);
 void start(){_timer ??=Timer.periodic(const Duration(seconds:15),(_)=>sync());sync();}
 void stop(){_timer?.cancel();_timer=null;}
 Future<void> sync()async{
 if(_busy)return;_busy=true;
 try{final pending=await store.pending();for(final item in pending){
  try{final payload=item['payload'] as Map<String,dynamic>;
   if(item['kind']=='transition'){
    final result=await api.dio.post('/deliveries/${payload['deliveryId']}/transition',data:{'operationId':payload['operationId'],'expectedVersion':payload['expectedVersion'],'status':payload['status'],'reason':payload['reason']});
    await store.synced(item['id'] as String,delivery:Map<String,dynamic>.from(result.data as Map));
   }else{await api.dio.post('/locations',data:{'samples':[payload]});await store.synced(item['id'] as String);}
   _failures=0;
  }on DioException catch(e){if(e.response?.statusCode==409||e.response?.statusCode==422||e.response?.statusCode==403){stop();break;} _failures++;break;}
 }
 }catch(_){_failures++;}finally{_busy=false;}
 }
 Duration get suggestedBackoff=>Duration(seconds:min(300,pow(2,min(_failures,8)).toInt())+Random().nextInt(3));
}
