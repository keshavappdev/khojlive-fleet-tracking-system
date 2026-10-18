enum DeliveryStatus {assigned,accepted,arriving_pickup,picked_up,in_transit,arriving_destination,completed,cancelled}
const Map<DeliveryStatus,List<DeliveryStatus>> allowed={
 DeliveryStatus.assigned:[DeliveryStatus.accepted,DeliveryStatus.cancelled],
 DeliveryStatus.accepted:[DeliveryStatus.arriving_pickup,DeliveryStatus.cancelled],
 DeliveryStatus.arriving_pickup:[DeliveryStatus.picked_up,DeliveryStatus.cancelled],
 DeliveryStatus.picked_up:[DeliveryStatus.in_transit,DeliveryStatus.cancelled],
 DeliveryStatus.in_transit:[DeliveryStatus.arriving_destination,DeliveryStatus.cancelled],
 DeliveryStatus.arriving_destination:[DeliveryStatus.completed,DeliveryStatus.cancelled],
 DeliveryStatus.completed:[],DeliveryStatus.cancelled:[]
};
bool canTransition(DeliveryStatus from,DeliveryStatus to)=>allowed[from]?.contains(to)??false;
class Delivery {
 final String id,trackingCode,pickup,destination;
 final DeliveryStatus status;
 final int version;
 final double pickupLat,pickupLng,dropLat,dropLng;
 const Delivery({required this.id,required this.trackingCode,required this.pickup,required this.destination,required this.status,required this.version,required this.pickupLat,required this.pickupLng,required this.dropLat,required this.dropLng});
 factory Delivery.fromJson(Map<String,dynamic> j)=>Delivery(id:j['id'] as String,trackingCode:j['tracking_code'] as String,pickup:j['pickup'] as String,destination:j['destination'] as String,status:DeliveryStatus.values.byName(j['status'] as String),version:(j['version'] as num).toInt(),pickupLat:(j['pickup_lat'] as num).toDouble(),pickupLng:(j['pickup_lng'] as num).toDouble(),dropLat:(j['drop_lat'] as num).toDouble(),dropLng:(j['drop_lng'] as num).toDouble());
}
