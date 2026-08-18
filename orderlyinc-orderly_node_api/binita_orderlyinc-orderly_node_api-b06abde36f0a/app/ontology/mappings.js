const ONTOLOGY_VERSION = '1.0.0';
const BASE_IRI = 'https://orderlyinc.com/resource';

const TABLE_MAPPINGS = Object.freeze({
  users_tb: { id: 'user_id', types: { 0: 'Customer', 1: 'StoreManager', 2: 'DeliveryAgent', 3: 'PlatformManager' } },
  producer_list: { id: 'producer_id', type: 'Producer' },
  product_list: { id: 'product_id', type: 'Product' },
  order_tb: { id: 'order_id', type: 'Order' },
  order_details_id: { id: 'order_details_id', type: 'OrderLine' },
  user_address: { id: 'ua_id', type: 'Address' },
  order_history: { id: 'order_history_id', type: 'OrderStatusEvent' },
  product_return: { id: 'return_id', type: 'ReturnRequest' },
  temp_location_history: { id: 'temp_his_id', type: 'TemperatureObservation' }
});

function iri(type, id) {
  return `${BASE_IRI}/${type}/${encodeURIComponent(String(id))}`;
}

module.exports = { ONTOLOGY_VERSION, BASE_IRI, TABLE_MAPPINGS, iri };

