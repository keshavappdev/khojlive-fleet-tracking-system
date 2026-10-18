import 'dart:async';
import 'package:geolocator/geolocator.dart';
import '../../core/local_store.dart';
class LocationService {
 final LocalStore store;
 StreamSubscription<Position>? _sub;
 Position? _last;
 DateTime? _lastAccepted;
 LocationService(this.store);
 static bool shouldRecord({required double accuracy,required double distanceMeters,required Duration elapsed,bool lowBattery=false}){
   if(accuracy>100)return false;
   return distanceMeters>= (lowBattery?100:30)||elapsed>=Duration(seconds:lowBattery?180:60);
 }
 Future<void> start()async{
  if(_sub!=null)return;
  if(!await Geolocator.isLocationServiceEnabled())throw StateError('Location services disabled');
  var permission=await Geolocator.checkPermission();
  if(permission==LocationPermission.denied)permission=await Geolocator.requestPermission();
  if(permission==LocationPermission.denied||permission==LocationPermission.deniedForever)throw StateError('Location permission denied');
  _sub=Geolocator.getPositionStream(locationSettings:const LocationSettings(accuracy:LocationAccuracy.high,distanceFilter:15)).listen((p)async{
   final now=DateTime.now();final distance=_last==null?9999.0:Geolocator.distanceBetween(_last!.latitude,_last!.longitude,p.latitude,p.longitude);
   if(shouldRecord(accuracy:p.accuracy,distanceMeters:distance,elapsed:now.difference(_lastAccepted??DateTime.fromMillisecondsSinceEpoch(0)))){
    _last=p;_lastAccepted=now;await store.enqueueLocation(p.latitude,p.longitude,p.accuracy,p.timestamp);
   }
  });
 }
 Future<void> stop()async{await _sub?.cancel();_sub=null;}
}
