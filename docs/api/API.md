# KhojLive API contract

Base URL: `http://localhost:4000` locally. JWT access token header: `Authorization: Bearer <token>` for all protected endpoints.

- `POST /auth/login` `{email,password}` → `{accessToken,refreshToken,user}`
- `POST /auth/refresh` `{refreshToken}` → rotated tokens
- `POST /auth/logout` `{refreshToken}` → 204
- `GET /drivers/me` driver only
- `GET /drivers` dispatcher only
- `GET /drivers/:id` dispatcher or own driver
- `PATCH /drivers/status` `{status:"online"|"offline"}` driver only
- `GET /deliveries` assigned-driver or dispatcher list
- `GET /deliveries/:id` own assigned or dispatcher
- `POST /deliveries/:id/transition` `{operationId:UUID,expectedVersion:int,status:string,reason?:string}`; 409 version conflict with current record, 422 illegal transition
- `POST /locations` `{samples:[{sampleId:UUID,lat,lng,accuracy,recordedAt:ISO8601}]}` driver only; duplicate IDs ignored
- `GET /drivers/:id/location` most recent accepted location
- `GET /deliveries/:id/route` pickup/destination endpoints (not road geometry)
- `GET /risk/:deliveryId` dispatcher-only rules-based ETA risk
- `GET /health` unauthenticated liveness response

Socket.IO connects to API origin with `auth:{token:accessToken}`. Dispatcher subscribed to `driver:location`, `driver:status`, `delivery:updated`; socket reconnects automatically but REST `GET /drivers` + `GET /deliveries` is used to fill any gap. Server acknowledges with `connected` event.

Legal transitions: assigned→accepted→arriving_pickup→picked_up→in_transit→arriving_destination→completed; cancelling allowed from nonterminal states with reason. UI presents a single next-step button and intentionally avoids direct skip transitions.
