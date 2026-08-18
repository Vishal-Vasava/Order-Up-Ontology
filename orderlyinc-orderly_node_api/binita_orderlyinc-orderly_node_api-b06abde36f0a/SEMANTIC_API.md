# OrderUp Semantic API — Milestone 1

This milestone adds a read-only semantic projection over the existing MySQL commerce data. MySQL and the existing Node API remain authoritative; these endpoints do not execute commands or update records.

## Authentication and access

All semantic endpoints are registered after the existing JWT authentication middleware.

- Customers can read their own orders.
- Store managers can read orders containing lines from their producer/store.
- Delivery agents can read orders containing lines assigned to them.
- Platform managers can read all order contexts.
- Store-manager and delivery-agent responses are scoped to their associated lines; sibling lines belonging to another producer or agent are excluded.
- Active product availability is visible to authenticated users. Removed products are visible only to their store manager or a platform manager.

## Endpoints

### `GET /semantic/orders/:id/context`

Returns a linked order context containing customer, destination, order lines, products, producers, assigned delivery agents, status history, returns, temperature observations, provenance, and validation results.

### `GET /semantic/products/:id/availability`

Returns a product, its producer, and its current inventory availability.

### `GET /semantic/deliveries/:id/context`

The identifier is the existing `order_details_id`. Returns the relevant order, destination, delivery/order-line context, status history, returns, and temperature observations.

## Semantic identifiers

Entities receive stable identifiers in this form:

```text
https://orderlyinc.com/resource/Order/12
https://orderlyinc.com/resource/OrderLine/21
https://orderlyinc.com/resource/Product/9
```

The ontology vocabulary is defined in `app/ontology/orderup.ttl`. The JSON responses use a compact JSON-LD-style representation and include the ontology version and source-record provenance.

## Run tests

```bash
npm test
```

## Deliberate milestone boundaries

- No graph database is required yet.
- No transactional outbox or CDC is included yet.
- No AI model or model vendor dependency is included.
- No AI-proposed action can mutate commerce data.

The next milestone is a transactional outbox and incremental ontology projector so the semantic read model can move from request-time projection to event-driven synchronization.
