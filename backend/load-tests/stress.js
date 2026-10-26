import http from 'k6/http';
import { check, sleep } from 'k6';

export const options = {
  stages: [
    { duration: '2m', target: 100 }, // Ramp to 100 VUs
    { duration: '3m', target: 250 }, // Ramp to 250 VUs
    { duration: '5m', target: 500 }, // Peak stress at 500 VUs
    { duration: '2m', target: 0 },   // Ramp-down to 0 VUs
  ],
  thresholds: {
    http_req_failed: ['rate<0.05'], // error rate < 5% under extreme stress
    http_req_duration: ['p(95)<1500', 'p(99)<3000'], // 95% below 1.5s under 500 VUs
  },
};

const BASE_URL = __ENV.API_URL || 'http://localhost:4000';

export default function () {
  // 1. Session Authentication
  const authPayload = JSON.stringify({ identifier: `STRESS-USER-${__VU}` });
  const authRes = http.post(`${BASE_URL}/api/v1/auth/session`, authPayload, {
    headers: { 'Content-Type': 'application/json' },
  });

  const authSuccess = check(authRes, {
    'session active': (r) => r.status === 200,
  });

  if (!authSuccess) {
    sleep(1);
    return;
  }

  const token = JSON.parse(authRes.body).access_token;
  const authHeaders = {
    'Content-Type': 'application/json',
    'Authorization': `Bearer ${token}`,
  };

  // 2. Heavy Outbox Event Sync
  const events = [];
  for (let i = 0; i < 5; i++) {
    events.push({
      id: `evt_stress_${__VU}_${__ITER}_${i}`,
      event_type: 'attempt',
      session_id: `sess_stress_${__VU}`,
      item_id: 'q4',
      concept_ids: ['physics.mechanics.pressure'],
      correctness: true,
      created_at: new Date().toISOString(),
    });
  }

  const syncRes = http.post(
    `${BASE_URL}/api/v1/sync/events`,
    JSON.stringify({ events }),
    { headers: authHeaders }
  );

  check(syncRes, {
    'sync accepted': (r) => r.status === 200 || r.status === 503,
  });

  sleep(1);
}
