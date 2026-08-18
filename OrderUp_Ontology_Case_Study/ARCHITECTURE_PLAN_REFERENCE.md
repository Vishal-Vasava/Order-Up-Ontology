# OrderUp Ontology and AI Architecture Plan

This file preserves the agreed architectural direction for future OrderlyInc work.

## Core architectural boundary

AI may read broadly, reason probabilistically, and propose narrowly. Only deterministic services may commit business transactions.

- MySQL remains the authoritative operational system of record.
- The existing Node.js commerce API retains transaction, authorization, workflow, pricing, payment, inventory, claims, and status-transition logic.
- AI-generated actions must pass through a governed action gateway with authorization, policy, confidence/impact checks, human approval where required, and audit logging.
- The ontology and knowledge graph are semantic read models synchronized from operational domain events; they do not replace the transactional core.

## Target platform layers

1. Experience: Flutter, React admin portal, dashboards, chat, and voice.
2. Experience/API boundary: API gateway/BFF, session management, identity/tenant/role context, semantic query API, governed action gateway, and real-time events.
3. AI orchestration: agent runtime, model gateway, context builder, ontology-aware RAG, prompt/tool registry, guardrails, semantic cache, evaluation, tracing, and feedback.
4. Ontology and knowledge: schema registry, operational knowledge graph, vector and feature stores, rules/reasoning, entity resolution, provenance/confidence/temporal facts, and a commerce digital twin.
5. Decision intelligence: recommendations, demand forecasting, ETA/delay prediction, routing and delivery-agent assignment, risk, anomaly detection, personalization, and optimization solvers.
6. Deterministic core: orders, inventory, pricing, payments/refunds, claims, notifications, permissions, and state machines.
7. Event integration: transactional outbox, CDC, event bus, ontology projectors, feature/embedding pipelines, real-time streams, and MySQL/graph reconciliation.
8. Platform operations: managed compute or Kubernetes, optional GPU inference, observability, model registry, CI/CD, secrets, and model quality/cost/drift monitoring.

## Model deployment strategy

Use a unified model gateway so applications and orchestration do not depend directly on one vendor.

- Cloud or strong private LLMs: complex reasoning, long-context analysis, and conversation.
- Small/local models: classification, intent detection, extraction, routing, and high-volume summarization.
- Specialized predictive models: ETA, demand, operational risk, and anomalies.
- Optimization solvers: routing and allocation.
- Embedding/reranking models: semantic retrieval.
- Vision models: product, claim, and proof-of-delivery evidence.
- Speech models: voice activity detection, denoising, speech-to-text, language/intent detection, and text-to-speech.
- Deterministic rules: every transactional validation and commit.

## Voice-action controls

- Require explicit confirmation for consequential actions; silence is never approval.
- Show transcripts where possible and separate dictation from execution.
- Use constrained, structured action schemas.
- Verify identity, role, assignment, and policy before execution.
- Support low-connectivity queued drafts.
- Audit the transcript, proposal, confirmation, execution result, and relevant context.

## Recommended implementation order

1. Create the canonical order-store-inventory-delivery ontology.
2. Add a transactional outbox and domain events to the deterministic core.
3. Build the operational knowledge graph as a read model.
4. Expose a semantic query service.
5. Introduce the unified model gateway.
6. Deliver read-only platform-manager and store-manager copilots.
7. Add ETA, anomaly, demand, and delivery-ranking models.
8. Introduce governed action proposals with human approval.
9. Add voice interaction for delivery agents.
10. Permit narrowly bounded automation only after sufficient evaluation and audit evidence.

## Existing architecture baseline

- Flutter serves customer, store-manager/producer, and delivery-agent personas.
- React primarily serves platform-management functions.
- Node.js/Express controllers contain current workflow and transaction logic.
- MySQL is the source of truth; relationships are currently implicit in tables, IDs, joins, and code.
- Firebase provides authentication and push notifications; object storage holds product images; payments use an external provider.
- Current interactions are primarily API request/response, without a shared semantic reasoning layer.

