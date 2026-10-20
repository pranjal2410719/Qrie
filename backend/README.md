# Qrie AI Backend

Modular, high-throughput Node.js backend powered by Fastify and TypeScript for Qrie AI.

---

## Capabilities

- **Multi-Tenant Scoping:** Strictly enforces school isolation (`school_id`) across all data queries.
- **Role-Based Authorization:** Explicit permission enforcement for `student`, `teacher`, `school_admin`, and `super_admin`.
- **Roster & Academic Management:** Manages schools, classes, students, teachers, and enrollments.
- **Trusted LAM Adapter:** Server-to-server relay delivering verified learning evidence to LAM and receiving adaptive recommendations.
- **Request Tracing & Metrics:** Correlated `req_<id>` tracking, structured logging, and RFC 7807 error responses.

---

## Development

```bash
# Install dependencies
npm install

# Run in development mode
npm run dev

# Run automated tests
npm run test

# Build for production
npm run build
```
