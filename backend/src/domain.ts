export const statuses = ['assigned','accepted','arriving_pickup','picked_up','in_transit','arriving_destination','completed','cancelled'] as const;
export type DeliveryStatus = typeof statuses[number];
const allowed: Record<DeliveryStatus, DeliveryStatus[]> = {
 assigned:['accepted','cancelled'], accepted:['arriving_pickup','cancelled'],
 arriving_pickup:['picked_up','cancelled'], picked_up:['in_transit','cancelled'],
 in_transit:['arriving_destination','cancelled'], arriving_destination:['completed','cancelled'],
 completed:[], cancelled:[]
};
export function canTransition(from:DeliveryStatus,to:DeliveryStatus):boolean { return allowed[from]?.includes(to) ?? false; }
export function deliveryRisk(etaAt:string|null, status:DeliveryStatus, now=Date.now()) {
 if(status==='completed'||status==='cancelled') return {level:'none',minutesLate:0,explanation:'Delivery is not active'};
 if(!etaAt) return {level:'unknown',minutesLate:0,explanation:'ETA is not available'};
 const minutesLate=Math.max(0,Math.round((now-new Date(etaAt).getTime())/60000));
 const level=minutesLate>=15?'high':minutesLate>=5?'medium':'low';
 return {level,minutesLate,explanation: minutesLate>0?`Delivery is ${minutesLate} minutes past its expected ETA. Review the route and contact the driver.`:'Delivery is currently within its ETA window.'};
}
