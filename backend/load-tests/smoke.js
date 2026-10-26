import http from 'k6/http';
import { check, sleep } from 'k6';

export const options = {
  vus: 5,
  duration: '1m',
  thresholds: {
    http_req_failed: ['rate<0.01'], // error rate < 1%
    http_req_duration: ['p(95)<500', 'p(99)<1000'], // p95 < 500ms, p99 < 1000ms
  },
};

const BASE_URL = __ENV.API_URL || 'http://localhost:4000';

export default function () {
  // 1. Health check
  const healthRes = http.get(`${BASE_URL}/health/live`);
  check(healthRes, {
    'health live status is 200': (r) => r.status === 200,
  });

  // 2. Public school branding lookup
  const brandingRes = http.get(`${BASE_URL}/api/v1/public/school/branding?school_code=DPS-RKP-042`);
  check(brandingRes, {
    'school branding status is 200': (r) => r.status === 200,
    'branding has school_id': (r) => JSON.parse(r.body).school_id === 'sch_dps_rkp',
  });

  sleep(1);
}
