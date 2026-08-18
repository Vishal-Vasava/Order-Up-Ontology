const test = require('node:test');
const assert = require('node:assert/strict');
const { projectOrderContext } = require('../app/ontology/semanticProjector');
const { canReadOrder, visibleOrderLines } = require('../app/ontology/accessPolicy');

const fixture = {
  order: { order_id: 12, user_id: 7, dest_address: 4, order_date: '2026-08-01T12:00:00Z', sub_total: 20, delivery_charge: 3, grant_total: 23 },
  customer: { user_id: 7, first_name: 'Ada', last_name: 'Buyer', email_id: 'ada@example.test', mobile: '5550100' },
  destination: { ua_id: 4, address: '1 Main St', city: 'Austin', state: 'TX', country: 'US', zipcode: '78701', add_latitude: 30.2, add_longitude: -97.7 },
  lines: [{
    order_details_id: 21, order_id: 12, order_number: 'OD000012', producer_id: 3,
    product_id: 9, qty: 2, rate_per_hour: 10, total: 20, current_status: 2,
    delivery_agent: 11, product_name: 'Apples', product_qty: 40, display_status: 0,
    producer_name: 'Orchard', agent_first_name: 'Dee', agent_last_name: 'Driver'
  }],
  history: [{ order_history_id: 31, order_detail_id: 21, oh_status: 2, oh_date_time: '2026-08-01T13:00:00Z' }],
  returns: [],
  temperatures: [{ temp_his_id: 41, orders_detail_id: 21, device_id: 'truck-1', temperature: 4.2, created_at: '2026-08-01T13:05:00Z' }]
};

test('projects an order into stable linked semantic entities with provenance', () => {
  const context = projectOrderContext(fixture, new Date('2026-08-01T14:00:00Z'));
  assert.equal(context.order['@id'], 'https://orderlyinc.com/resource/Order/12');
  assert.equal(context.order.placedBy, 'https://orderlyinc.com/resource/Customer/7');
  assert.deepEqual(context.order.contains, ['https://orderlyinc.com/resource/OrderLine/21']);
  assert.equal(context.lines[0].product.availableQuantity, 40);
  assert.equal(context.lines[0].statusLabel, 'Shipped');
  assert.equal(context.lines[0].temperatureObservations[0].temperature, 4.2);
  assert.equal(context.lines[0].provenance.source.table, 'order_details_id');
  assert.equal(context.validation.valid, true);
});

test('reports invalid source graphs rather than inventing missing facts', () => {
  const context = projectOrderContext({ order: fixture.order, lines: [] }, new Date('2026-08-01T14:00:00Z'));
  assert.equal(context.validation.valid, false);
  assert.deepEqual(context.validation.issues.map(issue => issue.code), ['MISSING_CUSTOMER', 'ORDER_WITHOUT_LINES', 'MISSING_DESTINATION']);
});

test('enforces persona access to order context', () => {
  const lines = fixture.lines;
  assert.equal(canReadOrder({ userType: 0, userId: 7 }, fixture.order, lines), true);
  assert.equal(canReadOrder({ userType: 0, userId: 8 }, fixture.order, lines), false);
  assert.equal(canReadOrder({ userType: 1, producerId: 3 }, fixture.order, lines), true);
  assert.equal(canReadOrder({ userType: 2, userId: 11 }, fixture.order, lines), true);
  assert.equal(canReadOrder({ userType: 3, userId: 99 }, fixture.order, lines), true);
});

test('scopes producer and delivery-agent visibility to their own lines', () => {
  const lines = [
    ...fixture.lines,
    { order_details_id: 22, producer_id: 4, delivery_agent: 12 }
  ];
  assert.deepEqual(visibleOrderLines({ userType: 1, producerId: 3 }, lines).map(x => x.order_details_id), [21]);
  assert.deepEqual(visibleOrderLines({ userType: 2, userId: 12 }, lines).map(x => x.order_details_id), [22]);
  assert.equal(visibleOrderLines({ userType: 0, userId: 7 }, lines).length, 2);
});
