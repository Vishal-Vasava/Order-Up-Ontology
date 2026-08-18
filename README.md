# Order-Up Ontology

Ontology-oriented evolution of the OrderUp commerce platform.

This monorepo contains:

- `Order-Up-mobile app` — Flutter customer, store-manager, and delivery application.
- `Orderly_admin` — React administration portal.
- `orderlyinc-orderly_node_api` — Node.js and MySQL API.
- `OrderUp_Ontology_Case_Study` — architecture and product documentation.

The current prototype includes semantic order context, persona-aware ontology access,
natural-language intent capture, deterministic basket negotiation policy, and optional
OpenAI-assisted intent classification and product-image generation.

Local `.env` files are intentionally excluded. Start from the checked-in example files
and supply credentials only in your local environment.

For Flutter, provide client configuration with `--dart-define` values such as
`GOOGLE_MAPS_API_KEY`, `GOOGLE_PLACES_API_KEY`, `MAPBOX_ACCESS_TOKEN`,
`FIREBASE_API_KEY`, `FIREBASE_APP_ID`, `FIREBASE_MESSAGING_SENDER_ID`,
`FIREBASE_PROJECT_ID`, `STRIPE_PUBLISHABLE_KEY`, and `STRIPE_MERCHANT_ID`.
Platform Firebase files (`google-services.json`, `GoogleService-Info.plist`, and the
web messaging service worker) are environment-specific and are not committed.
