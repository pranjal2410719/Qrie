# Qrie Student App — Offline Architecture & Synchronization Specification

**Document Reference:** `docs/student-app/OFFLINE_SYNC_SPEC.md`  
**Status:** Approved Specification  
**Author:** Principal Distributed Systems Engineer & Flutter Storage Specialist  

---

## 1. Data Storage Classification

```
┌────────────────────────────────────────────────────────────────────────┐
│                        DATA STORAGE TAXONOMY                           │
├───────────────────┬──────────────────────┬─────────────────────────────┤
│ Category          │ Storage Engine       │ Data Held                   │
├───────────────────┼──────────────────────┼─────────────────────────────┤
│ Public / Content  │ SQLite / Drift Cache │ NCERT chapters, SVG diagrams│
│ Sensitive State   │ FlutterSecureStorage │ JWT, refresh tokens, user ID│
│ Session State     │ Drift Local DB       │ Active session questions    │
│ Durable Outbox    │ Drift Outbox Table   │ Pending interaction attempts│
└───────────────────┴──────────────────────┴─────────────────────────────┘
```

---

## 2. Durable Outbox Architecture

When a student practices while disconnected, the app records attempts locally into the durable `SyncOutboxItem` table before displaying provisional feedback.

```
+-----------------------------------------------------------+
|                      FLUTTER CLIENT                       |
|                                                           |
|  [Student Solves Item]                                    |
|          |                                                |
|          v                                                |
|  [Mint Client UUID]                                       |
|          |                                                |
|          v                                                |
|  [INSERT INTO sync_outbox (id, session_id, payload, ts)]  |
|          |                                                |
|          v                                                |
|  [Show Local Provisional Feedback]                        |
+-----------------------------+-----------------------------+
                              |
                              | Network Connectivity Restored
                              v
+-----------------------------------------------------------+
|                   BACKGROUND SYNC WORKER                  |
|                                                           |
|  [Fetch Batch of 20 Events (ORDER BY created_at ASC)]     |
|          |                                                |
|          v                                                |
|  [POST /api/v1/sync/events]                               |
+-----------------------------+-----------------------------+
                              |
                              v
+-----------------------------------------------------------+
|                     QRIE BACKEND                          |
|                                                           |
|  INSERT INTO ledger_event ... ON CONFLICT (id) DO NOTHING |
|          |                                                |
|          v                                                |
|  Return 200 OK {synced_ids: [...], duplicate_ids: [...]}   |
+-----------------------------------------------------------+
```

---

## 3. Synchronization Rules & Guarantees

### 3.1 Idempotency Guarantee
- Every interaction event has a client-minted UUID (`crypto.randomUUID()`) generated at the moment the answer is selected, **not** when transmitted over the network.
- Re-transmissions following dead connections or app crashes are safe no-ops due to PostgreSQL `ON CONFLICT (id) DO NOTHING`.

### 3.2 Ordering Requirements
- Events are submitted strictly chronologically by `created_at` timestamp.
- Out-of-order delivery is rejected or sorted server-side before feeding into BKT models.

### 3.3 Retry Policy: Exponential Backoff with Jitter
When a sync attempt fails due to network error (`SocketException`, timeout, or HTTP 5xx):
- Base delay: $t_0 = 1.0 \text{ second}$
- Maximum delay: $t_{\text{max}} = 60.0 \text{ seconds}$
- Backoff formula with random jitter:
  $$t_{\text{retry}} = \min\left(t_{\text{max}}, t_0 \cdot 2^{\text{attempt}} \pm \text{random}(0, 0.5 \cdot t_0)\right)$$

### 3.4 Queue Retention & Limits
- **Maximum Queue Size:** 500 events (equivalent to approximately 20 full practice sessions).
- **Eviction Policy:** If the outbox reaches 500 events on a prolonged offline device, the student is gently notified that new offline practice is paused until connectivity returns to safeguard un-synced work.
- **Expiry:** Events older than 30 days are archived locally and flagged for diagnostic review.

### 3.5 Partial Batch Success Handling
If a batch of 20 events encounters partial success:
- The backend returns explicit arrays: `{ synced_ids: [...], failed_ids: [...] }`.
- The client deletes only confirmed `synced_ids` from the local outbox.
- `failed_ids` remain in the outbox with incremented `retryCount` and logged error reasons.

### 3.6 Authentication Expiry During Sync
- If the sync worker receives `401 Unauthorized`, it halts the flush queue immediately.
- It attempts a silent refresh token exchange.
- If refresh succeeds, synchronization resumes. If refresh fails, it displays a status badge: *"Sync paused — Please sign in to save your 5 offline answers"*. No local events are deleted.
