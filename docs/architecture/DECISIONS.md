# Architecture decisions

## Boundaries

UI watches Riverpod state; domain state rules live in pure Dart/TypeScript. Local Drift owns the persistent outbox. Backend validates every state transition transactionally and broadcasts only after commit. WebSocket delivery is advisory, REST responses and DB are canonical.

## Conflict policy

An operation carries an expected version and unique idempotency key. If the authoritative server version differs, 409 includes current delivery. Current prototype preserves unsynced local action and stops sync. A production client must show resolution options and support explicit rebase/discard/dispatcher intervention; automatic last-write-wins would be unsafe.

## Location policy

Reject GPS accuracy >100m; record on >=30m motion or >=60 seconds. With low battery, sampling policy helper allows >=100m or >=180 seconds, but battery events are not wired in this prototype. Server records GPS with supplied capture time and receive time, with uniqueness per sample ID. In production enforce acceptable time skew, consent, time-limited retention, rate limits and geospatial indexing.

## Real-time lifecycle

Socket connects after login, joins server-authorized role-specific room, reconnects on loss; dispatcher periodically refetches snapshots. Multiple app-server nodes would need Socket.IO distributed adapter and shared event ordering or persistent broker. Do not infer exact location from last sample if stale.
