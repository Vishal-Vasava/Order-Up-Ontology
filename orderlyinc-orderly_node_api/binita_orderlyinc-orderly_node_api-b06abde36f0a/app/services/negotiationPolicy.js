const MINIMUM_BASKET = 20;
const MAXIMUM_DISCOUNT_PERCENT = 8;

function roundMoney(value) {
  return Math.round((Number(value) + Number.EPSILON) * 100) / 100;
}

function requestedDiscountPercent(message, subtotal) {
  const text = String(message || '').toLowerCase();
  const percent = text.match(/(\d+(?:\.\d+)?)\s*%/);
  if (percent) return Math.max(0, Number(percent[1]));

  const target = text.match(/(?:for|to|do|under|below)\s*\$?\s*(\d+(?:\.\d+)?)/);
  if (target && subtotal > 0) {
    return Math.max(0, ((subtotal - Number(target[1])) / subtotal) * 100);
  }
  return null;
}

function evaluateNegotiation({ message, subtotal, completedOrders, inventoryRatio }) {
  const basket = roundMoney(subtotal);
  if (basket < MINIMUM_BASKET) {
    return {
      eligible: false,
      reason: `Negotiation is available for baskets of $${MINIMUM_BASKET.toFixed(2)} or more.`,
      subtotal: basket,
    };
  }

  let maximumPercent = 2;
  const reasons = ['basket is eligible'];

  if (completedOrders >= 5) {
    maximumPercent += 2;
    reasons.push('returning customer');
  }
  if (completedOrders >= 10) maximumPercent += 1;
  if (basket >= 50) maximumPercent += 1;
  if (basket >= 100) {
    maximumPercent += 1;
    reasons.push('high-value basket');
  }
  if (inventoryRatio >= 3) {
    maximumPercent += 1;
    reasons.push('healthy inventory');
  }
  maximumPercent = Math.min(maximumPercent, MAXIMUM_DISCOUNT_PERCENT);

  const requestedPercent = requestedDiscountPercent(message, basket);
  const openingPercent = Math.max(1, Math.floor(maximumPercent * 0.75));
  const offeredPercent = roundMoney(
    Math.min(maximumPercent, requestedPercent == null ? openingPercent : requestedPercent),
  );
  const discountAmount = roundMoney(basket * offeredPercent / 100);

  return {
    eligible: true,
    subtotal: basket,
    requestedPercent: requestedPercent == null ? null : roundMoney(requestedPercent),
    offeredPercent,
    maximumPercent,
    discountAmount,
    offeredTotal: roundMoney(basket - discountAmount),
    reasons,
  };
}

module.exports = { evaluateNegotiation, requestedDiscountPercent };
