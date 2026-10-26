import http from 'k6/http';
import { check, sleep } from 'k6';

export const options = {
  stages: [
    { duration: '1m', target: 20 },  // Ramp-up to 20 users over 1 min
    { duration: '3m', target: 50 },  // Ramp-up to 50 users over 3 mins
    { duration: '5m', target: 50 },  // Stay at 50 users for 5 mins
    { duration: '1m', target: 0 },   // Ramp-down to 0 users
  ],
  thresholds: {
    http_req_failed: ['rate<0.01'], // error rate < 1%
    http_req_duration: ['p(95)<500', 'p(99)<1000'], // 95% of requests must complete below 500ms
  },
};

const BASE_URL = __ENV.API_URL || 'http://localhost:4000';

export default function () {
  // 1. Session Auth
  const authPayload = JSON.stringify({ identifier: `STD-${__VU}-${__ITER}` });
  const authRes = http.post(`${BASE_URL}/api/v1/auth/session`, authPayload, {
    headers: { 'Content-Type': 'application/json' },
  });

  const authSuccess = check(authRes, {
    'auth session status is 200': (r) => r.status === 200,
    'token received': (r) => JSON.parse(r.body).access_token !== undefined,
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

  // 2. Practice Answer Submission (Authoritative Grading)
  const answerPayload = JSON.stringify({
    question_id: 'q4',
    numeric_input: 25,
    assistance_rung: 0,
    duration_ms: 2500,
  });

  const answerRes = http.post(
    `${BASE_URL}/api/v1/learning/sessions/sess_${__VU}/answers`,
    answerPayload,
    { headers: authHeaders }
  );

  check(answerRes, {
    'answer submission status is 200': (r) => r.status === 200,
    'answer is verified correct': (r) => JSON.parse(r.body).is_correct === true,
  });

  // 3. Adaptive Recommendation Request
  const recRes = http.get(
    `${BASE_URL}/api/v1/learning/recommendations/next?concept_id=physics.mechanics.pressure`,
    { headers: authHeaders }
  );

  check(recRes, {
    'recommendation status is 200': (r) => r.status === 200,
    'recommendation has action_type': (r) => JSON.parse(r.body).action_type !== undefined,
  });

  sleep(1);
}
