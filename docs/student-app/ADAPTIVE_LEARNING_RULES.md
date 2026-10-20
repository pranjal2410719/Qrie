# Qrie Student App — Adaptive Learning Rules & Pedagogical Architecture

**Document Reference:** `docs/student-app/ADAPTIVE_LEARNING_RULES.md`  
**Status:** Approved Specification  
**Author:** Principal Learning Scientist & Pedagogical Systems Architect  

---

## 1. Core Pedagogical Axioms

1. **One mistake is a struggle signal, not a misconception:** A single incorrect response must never establish a permanent misconception diagnosis. Multiple consistent distractor patterns are required before triggering targeted interventions.
2. **Assisted success $\neq$ Independent mastery:** Solving a problem with a hint builds capability, but does not count toward unassisted mastery ($L_{\text{unassisted}}$).
3. **Correctness requires authoritative verification:** The client never self-scores an answer to award XP or advance mastery without server or answer-key confirmation.
4. **Missing evidence is unknown, not failure:** Unpracticed concepts are initialized with neutral prior beliefs ($L_0 = 0.10$ to $0.25$) rather than being marked as zero or failing.
5. **Zero static learner labeling:** The student application must never label a student with fixed identities (e.g. "slow learner", "visual learner", "non-math person").
6. **Respectful, encouraging tone:** Error messaging must explain the reasoning step rather than displaying harsh punitive warnings.
7. **Graceful degradation:** If LAM is unreachable, the student's learning journey continues smoothly through deterministic curriculum progression.
8. **Auditable evidence trail:** Every learning state transition is rooted in an immutable event in the backend ledger.

---

## 2. Division of Responsibilities

```
┌────────────────────────────────────────────────────────────────────────┐
│                        SERVICE BOUNDARY MAPPING                        │
├───────────────────────┬────────────────────────────────────────────────┤
│ Subsystem             │ Assigned Ownership                             │
├───────────────────────┼────────────────────────────────────────────────┤
│ Flutter Client        │ - UI Presentation & Animation                  │
│                       │ - Capturing active_ms & response time          │
│                       │ - Presenting hints returned by backend         │
│                       │ - Queuing interaction events offline           │
├───────────────────────┼────────────────────────────────────────────────┤
│ Qrie App Backend      │ - Authoritative answer key & symbolic checking │
│                       │ - Writing immutable session & event records    │
│                       │ - Session token & tenant scoping               │
│                       │ - Relay client with circuit breaker & fallback │
├───────────────────────┼────────────────────────────────────────────────┤
│ LAM Engine (Python)   │ - Bayesian Knowledge Tracing (BKT) calculation │
│                       │ - 9-level assistance escalation logic          │
│                       │ - Spaced retrieval half-life decay scheduling  │
│                       │ - 6-tier recommendation engine                 │
│                       │ - Misconception hypothesis finite state machine│
└───────────────────────┴────────────────────────────────────────────────┘
```

---

## 3. Bayesian Knowledge Tracing (BKT) Specification

LAM updates mastery probabilities using the standard four-parameter BKT model:
- $L_0$: Initial knowledge prior ($0.15$ for standard NCERT concepts).
- $T$: Probability of learning transition during an interaction step ($0.10$ to $0.20$).
- $G$: Probability of a guess ($0.25$ for 4-option MCQ, capped at $0.30$).
- $S$: Probability of a slip ($0.10$, capped at $0.15$).

### Update Rules (Strictly Server-Side in LAM):
1. **Posterior Probability given Observation ($O_t \in \{0, 1\}$):**
   $$P(L_t \mid O_t = 1) = \frac{P(L_{t-1}) \cdot (1 - S)}{P(L_{t-1}) \cdot (1 - S) + (1 - P(L_{t-1})) \cdot G}$$
   $$P(L_t \mid O_t = 0) = \frac{P(L_{t-1}) \cdot S}{P(L_{t-1}) \cdot S + (1 - P(L_{t-1})) \cdot (1 - G)}$$

2. **Transition Probability to Next Step ($t+1$):**
   $$P(L_{t+1}) = P(L_t \mid O_t) + (1 - P(L_t \mid O_t)) \cdot T$$

3. **Mastery Threshold:**
   A concept is marked **Mastered** when $P(L_{\text{unassisted}}) \ge 0.85$ across a minimum of 3 independent observations with uncertainty $\sigma^2 \le 0.05$.

---

## 4. The 9-Rung Assistance Escalation Ladder

When a student struggles during practice on SCR-08, assistance escalates gradually across 9 pedagogical levels:

```
Rung 8: Teacher Alert / In-Person Escalation
   ▲
Rung 7: Direct Instruction Narrative
   ▲
Rung 6: Guided Practice with Micro-Step Checks
   ▲
Rung 5: Fully Worked Isomorphic Example
   ▲
Rung 4: Alternative Conceptual Representation / Visual Diagram
   ▲
Rung 3: Scaffolded Substep Breakdown
   ▲
Rung 2: Strategic Domain Hint (Formula / Key Law Highlight)
   ▲
Rung 1: Metacognitive Rethink Prompt ("Check your units / sign")
   ▲
Rung 0: Independent Attempt (Cold Unassisted)
```

### Escalation Constraints:
- Escalation occurs strictly upon consecutive student errors or explicit student requests.
- Timer expiration alone **never** forces hint escalation without user consent.
- Reaching Rung 5 (Worked Example) triggers presentation of a fresh isomorphic question to verify comprehension independently.

---

## 5. Pedagogical Recommendation Hierarchy (6 Tiers)

LAM evaluates next-action recommendations according to a strict priority tier:

| Tier | Priority Tier Name | Condition | Next Recommended Action |
| :--- | :--- | :--- | :--- |
| **Tier 0** | **Safety & Stop Condition** | Rapid frustration signal (e.g. 5 consecutive fails) | Break recommendation; invite rest |
| **Tier 1** | **Prerequisite Repair** | Missing readiness on blocking prerequisite node | Route to prerequisite concept review |
| **Tier 2** | **Misconception Intervention**| Confirmed diagnosis hypothesis in FSM | Targeted conceptual contrast lesson |
| **Tier 3** | **Due Spaced Retrieval** | Retention strength decayed past threshold | 5-minute retrieval practice sprint |
| **Tier 4** | **Mastery Verification** | Near threshold ($0.75 \le L < 0.85$) | Challenge practice item (Rung 0) |
| **Tier 5** | **Curriculum Progression** | Current concept mastered ($\ge 0.85$) | Advance to next NCERT chapter concept |

---

## 6. Student-Facing Mastery Language Guidelines

To build growth mindset and avoid student anxiety:
- **Never say:** "You have a 42% failing grade in Photosynthesis."
- **Always say:** "You're building strong foundations in Photosynthesis! Practice 2 more questions to earn the Plant Scientist badge."
- **Never say:** "Permanent Master."
- **Always say:** "Concept Mastered (Verified) • Next refresh in 5 days."
