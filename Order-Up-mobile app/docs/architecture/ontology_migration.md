# Ontology-Based Architecture Migration

Order-Up currently keeps most API response models directly inside feature
`domain` folders. That works for screens, but it creates duplicated concepts
across product, cart, order, inventory, offers, and delivery. The ontology layer
adds a shared app vocabulary while keeping API-specific DTOs at repository
boundaries.

## Target Shape

- `lib/src/ontology` contains shared entity, relation, type, and registry
  primitives.
- `lib/src/ontology/order_up` contains the Order-Up business vocabulary.
- `lib/src/ontology/adapters` maps existing feature DTOs into ontology entities.
- Feature repositories continue to own API calls and response parsing.
- Cubits and screens can gradually consume ontology entities where shared
  reasoning, cross-feature reuse, search, filtering, or personalization are
  needed.

## Migration Rules

1. Keep remote API JSON parsing in feature repositories or feature DTOs.
2. Do not make UI widgets parse ontology metadata directly.
3. Prefer ontology adapters when a concept crosses feature boundaries.
4. Consolidate duplicated concepts only after a compatibility adapter exists.
5. Preserve current behavior feature-by-feature; avoid large rewrites.

## Initial Shared Concepts

- Customer
- Producer / store / supplier
- Product
- Category
- Cart and cart item
- Order and order item
- Address
- Currency
- Inventory item
- Offer
- Review
- Notification
- Delivery
- Payment

## Recommended Migration Order

1. Product catalog: product, currency, producer, filters, reviews.
2. Cart: cart item to product relationships and delivery slots.
3. Orders: order item to product, customer, address, payment, and fulfillment.
4. Manager inventory: reuse product and producer vocabulary.
5. Offers: connect customers and products through offer relations.
6. Delivery and notifications: attach operational state to orders/customers.

## Done In First Pass

- Added ontology primitives for ids, types, entities, references, relations,
  relation definitions, attributes, and registries.
- Added the first Order-Up ontology registry.
- Added a product DTO to ontology entity adapter.

