import 'package:flutter_test/flutter_test.dart';
import 'package:khojlive_driver/features/deliveries/domain/delivery.dart';
import 'package:khojlive_driver/features/tracking/location_service.dart';
void main(){test('delivery transitions validated',(){expect(canTransition(DeliveryStatus.assigned,DeliveryStatus.accepted),true);expect(canTransition(DeliveryStatus.assigned,DeliveryStatus.completed),false);});test('GPS filter drops bad accuracy',(){expect(LocationService.shouldRecord(accuracy:150,distanceMeters:500,elapsed:const Duration(minutes:10)),false);expect(LocationService.shouldRecord(accuracy:12,distanceMeters:35,elapsed:Duration.zero),true);});}
