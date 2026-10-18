import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:uuid/uuid.dart';
import '../features/deliveries/domain/delivery.dart';
class LocalStore {
 final _RawDb _db=_RawDb();
 Future<void> init() async {
   await _db.customStatement('CREATE TABLE IF NOT EXISTS deliveries (id TEXT PRIMARY KEY, payload TEXT NOT NULL, pending_status TEXT)');
   await _db.customStatement('CREATE TABLE IF NOT EXISTS queue (id TEXT PRIMARY KEY, kind TEXT NOT NULL, payload TEXT NOT NULL, created_at TEXT NOT NULL)');
 }
 Future<List<Delivery>> deliveries() async {final rows=await _db.customSelect('SELECT payload FROM deliveries').get();return rows.map((r)=>Delivery.fromJson(jsonDecode(r.read<String>('payload')) as Map<String,dynamic>)).toList();}
 Future<String?> pendingStatus(String id) async {final rows=await _db.customSelect('SELECT pending_status FROM deliveries WHERE id=?',variables:[Variable.withString(id)]).get();return rows.isEmpty?null:rows.first.readNullable<String>('pending_status');}
 Future<void> storeDeliveries(List<dynamic> remote) async {
  await _db.transaction(()=>Future.wait(remote.map((r)async{
   final j=Map<String,dynamic>.from(r as Map);
   await _db.customStatement('INSERT INTO deliveries (id,payload,pending_status) VALUES (?,?,NULL) ON CONFLICT(id) DO UPDATE SET payload=excluded.payload WHERE deliveries.pending_status IS NULL',[j['id'],jsonEncode(j)]);
  })));
 }
 Future<void> enqueueTransition(Delivery delivery,DeliveryStatus status,{String? reason}) async {
  final id=const Uuid().v4();
  await _db.transaction(() async {
   await _db.customStatement('INSERT INTO queue(id,kind,payload,created_at) VALUES(?,?,?,?)',[id,'transition',jsonEncode({'deliveryId':delivery.id,'operationId':id,'status':status.name,'expectedVersion':delivery.version,'reason':reason}),DateTime.now().toUtc().toIso8601String()]);
   await _db.customStatement('UPDATE deliveries SET pending_status=? WHERE id=?',[status.name,delivery.id]);
  });
 }
 Future<void> enqueueLocation(double lat,double lng,double accuracy,DateTime time)async {
  final id=const Uuid().v4();
  await _db.customStatement('INSERT INTO queue(id,kind,payload,created_at) VALUES(?,?,?,?)',[id,'location',jsonEncode({'sampleId':id,'lat':lat,'lng':lng,'accuracy':accuracy,'recordedAt':time.toUtc().toIso8601String()}),time.toUtc().toIso8601String()]);
 }
 Future<List<Map<String,dynamic>>> pending()async{
  final rows=await _db.customSelect('SELECT id,kind,payload FROM queue ORDER BY created_at LIMIT 100').get();
  return rows.map((r)=>{'id':r.read<String>('id'),'kind':r.read<String>('kind'),'payload':jsonDecode(r.read<String>('payload'))}).toList();
 }
 Future<void> synced(String id,{Map<String,dynamic>? delivery})async{
  await _db.transaction(()async{
   await _db.customStatement('DELETE FROM queue WHERE id=?',[id]);
   if(delivery!=null)await _db.customStatement('UPDATE deliveries SET payload=?,pending_status=NULL WHERE id=?',[jsonEncode(delivery),delivery['id']]);
  });
 }
 Future<int> pendingCount()async{final rows=await _db.customSelect('SELECT COUNT(*) AS count FROM queue').get();return rows.first.read<int>('count');}
 Future<void> close()=>_db.executor.close();
}

class _RawDb extends DatabaseConnectionUser {
 _RawDb():super(driftDatabase(name:'khojlive_driver'));
}
