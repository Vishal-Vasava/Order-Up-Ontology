const test = require('node:test');
const assert = require('node:assert/strict');
const { evaluateNegotiation } = require('../app/services/negotiationPolicy');

test('caps an explicit request at the deterministic maximum', () => {
  const result = evaluateNegotiation({
    message: 'Can I get 20% off?',
    subtotal: 120,
    completedOrders: 12,
    inventoryRatio: 4,
  });
  assert.equal(result.eligible, true);
  assert.equal(result.maximumPercent, 8);
  assert.equal(result.offeredPercent, 8);
  assert.equal(result.offeredTotal, 110.4);
});

test('converts a requested basket total into a discount', () => {
  const result = evaluateNegotiation({
    message: 'Can you do $95?',
    subtotal: 100,
    completedOrders: 0,
    inventoryRatio: 1,
  });
  assert.equal(result.offeredPercent, 4);
  assert.equal(result.offeredTotal, 96);
});

test('rejects baskets below the minimum ticket size', () => {
  const result = evaluateNegotiation({
    message: 'Any deal?',
    subtotal: 10,
    completedOrders: 20,
    inventoryRatio: 10,
  });
  assert.equal(result.eligible, false);
});
