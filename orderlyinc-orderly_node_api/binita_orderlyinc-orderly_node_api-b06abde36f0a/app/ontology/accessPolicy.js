function asRole(value) {
  const role = Number(value);
  return Number.isNaN(role) ? 0 : role;
}

function canReadOrder(actor, order, lines) {
  const role = asRole(actor.userType);
  if (role === 3) return true;
  if (role === 0) return Number(order.user_id) === Number(actor.userId);
  if (role === 1) return lines.some(line => Number(line.producer_id) === Number(actor.producerId));
  if (role === 2) return lines.some(line => Number(line.delivery_agent) === Number(actor.userId));
  return false;
}

function visibleOrderLines(actor, lines) {
  const role = asRole(actor.userType);
  if (role === 1) return lines.filter(line => Number(line.producer_id) === Number(actor.producerId));
  if (role === 2) return lines.filter(line => Number(line.delivery_agent) === Number(actor.userId));
  return lines;
}

module.exports = { asRole, canReadOrder, visibleOrderLines };
