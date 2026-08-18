const crypto = require('crypto');
const OpenAI = require('openai');
const sql = require('../utils/dbConnection');
const { evaluateNegotiation } = require('./negotiationPolicy');

const offers = new Map();
const OFFER_TTL_MS = 10 * 60 * 1000;

function query(statement, values = []) {
  return new Promise((resolve, reject) => {
    sql.query(statement, values, (error, rows) => error ? reject(error) : resolve(rows));
  });
}

async function cartContext(userId) {
  const rows = await query(
    `SELECT ct.product_id, ct.qty, pl.product_name, pl.rate_per_hour,
            pl.product_qty, pl.producerid, producer.producer_name
       FROM cart_tb ct
       JOIN product_list pl ON pl.product_id = ct.product_id
       LEFT JOIN producer_list producer ON producer.producer_id = pl.producerid
      WHERE ct.user_id = ? AND pl.display_status = 0`,
    [userId],
  );
  if (!rows.length) {
    const error = new Error('Add items to your basket before negotiating.');
    error.status = 409;
    error.code = 'EMPTY_BASKET';
    throw error;
  }

  const producerIds = [...new Set(rows.map((row) => Number(row.producerid)))];
  if (producerIds.length !== 1) {
    const error = new Error('Please negotiate one store basket at a time.');
    error.status = 409;
    error.code = 'MULTI_STORE_BASKET';
    throw error;
  }

  const subtotal = rows.reduce((sum, row) => sum + Number(row.rate_per_hour) * Number(row.qty), 0);
  const inventoryRatio = rows.reduce(
    (sum, row) => sum + Number(row.product_qty) / Math.max(1, Number(row.qty)), 0,
  ) / rows.length;
  const orderRows = await query('SELECT COUNT(*) AS count FROM order_tb WHERE user_id = ?', [userId]);

  return {
    producerId: producerIds[0],
    storeName: rows[0].producer_name || 'this store',
    subtotal,
    inventoryRatio,
    completedOrders: Number(orderRows[0]?.count || 0),
    items: rows.map((row) => ({ id: Number(row.product_id), name: row.product_name, qty: Number(row.qty) })),
  };
}

async function classifyIntent(message) {
  const fallback = () => ({
    isNegotiation: /(discount|deal|cheaper|better price|off|haggle|negotiate|under|below|\$\s*\d+)/i.test(message),
    source: 'fallback',
  });
  const deterministic = fallback();
  if (deterministic.isNegotiation) {
    return { isNegotiation: true, source: 'deterministic' };
  }
  if (!process.env.OPENAI_API_KEY) return deterministic;
  try {
    const client = new OpenAI({ apiKey: process.env.OPENAI_API_KEY });
    const response = await client.responses.create({
      model: process.env.OPENAI_TEXT_MODEL || 'gpt-5-mini',
      input: [
        {
          role: 'system',
          content: 'Classify whether a customer message is asking for a lower basket price, discount, free delivery, or deal. Reply with only NEGOTIATION or OTHER.',
        },
        { role: 'user', content: String(message).slice(0, 500) },
      ],
      max_output_tokens: 16,
    });
    return {
      isNegotiation: String(response.output_text || '').trim().toUpperCase() === 'NEGOTIATION',
      source: 'openai',
    };
  } catch (_) {
    return fallback();
  }
}

async function negotiate(userId, message) {
  const cleanMessage = String(message || '').trim();
  if (!cleanMessage) {
    const error = new Error('Tell the store what deal you would like.');
    error.status = 400;
    error.code = 'EMPTY_INTENT';
    throw error;
  }

  const intent = await classifyIntent(cleanMessage);
  if (!intent.isNegotiation) {
    const error = new Error('This demo currently handles basket-price negotiations. Try “Can I get 5% off?”');
    error.status = 422;
    error.code = 'UNSUPPORTED_INTENT';
    throw error;
  }

  const context = await cartContext(userId);
  const decision = evaluateNegotiation({ message: cleanMessage, ...context });
  if (!decision.eligible) return { ...decision, storeName: context.storeName, interpretation: intent.source };

  const offerId = crypto.randomUUID();
  const expiresAt = new Date(Date.now() + OFFER_TTL_MS);
  const offer = {
    offerId,
    userId,
    producerId: context.producerId,
    storeName: context.storeName,
    items: context.items,
    ...decision,
    status: 'proposed',
    expiresAt: expiresAt.toISOString(),
    interpretation: intent.source,
  };
  offers.set(offerId, offer);
  return offer;
}

function accept(userId, offerId) {
  const offer = offers.get(String(offerId));
  if (!offer || offer.userId !== userId) {
    const error = new Error('Offer was not found.');
    error.status = 404;
    error.code = 'OFFER_NOT_FOUND';
    throw error;
  }
  if (Date.parse(offer.expiresAt) <= Date.now()) {
    offers.delete(offer.offerId);
    const error = new Error('This offer has expired. Please negotiate again.');
    error.status = 410;
    error.code = 'OFFER_EXPIRED';
    throw error;
  }
  offer.status = 'accepted_preview';
  offer.acceptedAt = new Date().toISOString();
  return offer;
}

module.exports = { negotiate, accept };
