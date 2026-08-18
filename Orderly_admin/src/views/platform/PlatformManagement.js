import React, { useEffect, useState } from "react";
import axios from "axios";
import toast from "react-hot-toast";
import { Button, Card, CardBody, CardHeader, CardTitle, Col, Input, Label, Row, Table } from "reactstrap";

const auth = () => ({ headers: { Authorization: `Bearer ${localStorage.getItem("token")}` } });
const message = (error) => error?.response?.data?.message || "Request failed";

const Field = ({ label, ...props }) => (
  <Col md="4" className="mb-1">
    <Label>{label}</Label>
    <Input {...props} />
  </Col>
);

export const Stores = () => {
  const [rows, setRows] = useState([]);
  const [form, setForm] = useState({ producer_name: "", prod_desc: "", manager_first_name: "", manager_last_name: "", manager_email: "", manager_mobile: "" });
  const load = () => axios.get("/admin/producers", auth()).then(r => setRows(r.data.producers || [])).catch(e => toast.error(message(e)));
  useEffect(() => {
    load();
  }, []);
  const change = e => setForm({ ...form, [e.target.name]: e.target.value });
  const create = () => axios.post("/admin/create_producer", form, auth()).then(() => {
    toast.success("Store created");
    setForm({ producer_name: "", prod_desc: "", manager_first_name: "", manager_last_name: "", manager_email: "", manager_mobile: "" });
    load();
  }).catch(e => toast.error(message(e)));
  const toggle = row => axios.post("/admin/update_producer_status", { producer_id: row.producer_id, status: Number(row.manager_status) === 0 ? 1 : 0 }, auth()).then(load).catch(e => toast.error(message(e)));
  return <>
    <Card><CardHeader><CardTitle>Store Management</CardTitle></CardHeader><CardBody>
      <Row>
        <Field label="Store name*" name="producer_name" value={form.producer_name} onChange={change} />
        <Field label="Manager first name*" name="manager_first_name" value={form.manager_first_name} onChange={change} />
        <Field label="Manager last name" name="manager_last_name" value={form.manager_last_name} onChange={change} />
        <Field label="Manager mobile*" name="manager_mobile" value={form.manager_mobile} onChange={change} />
        <Field label="Manager email" type="email" name="manager_email" value={form.manager_email} onChange={change} />
        <Field label="Description" name="prod_desc" value={form.prod_desc} onChange={change} />
      </Row>
      <Button color="primary" disabled={!form.producer_name || !form.manager_first_name || !form.manager_mobile} onClick={create}>Create Store</Button>
    </CardBody></Card>
    <Card><CardBody><Table responsive hover><thead><tr><th>ID</th><th>Store</th><th>Manager</th><th>Mobile</th><th>Status</th><th /></tr></thead><tbody>
      {rows.map(row => <tr key={row.producer_id}><td>{row.producer_id}</td><td>{row.producer_name}</td><td>{`${row.manager_first_name || ""} ${row.manager_last_name || ""}`}</td><td>{row.manager_mobile}</td><td>{Number(row.manager_status) === 0 ? "Active" : "Inactive"}</td><td><Button size="sm" color={Number(row.manager_status) === 0 ? "danger" : "success"} outline onClick={() => toggle(row)}>{Number(row.manager_status) === 0 ? "Deactivate" : "Activate"}</Button></td></tr>)}
      {!rows.length && <tr><td colSpan="6" className="text-center">No stores yet</td></tr>}
    </tbody></Table></CardBody></Card>
  </>;
};

export const DeliveryAgents = () => {
  const empty = { first_name: "", last_name: "", mobile: "", email_id: "" };
  const [rows, setRows] = useState([]);
  const [form, setForm] = useState(empty);
  const load = () => axios.get("/admin/delivery_agents", auth()).then(r => setRows(r.data.delivery_agents || [])).catch(e => toast.error(message(e)));
  useEffect(() => {
    load();
  }, []);
  const change = e => setForm({ ...form, [e.target.name]: e.target.value });
  const create = () => axios.post("/admin/create_delivery_agent", form, auth()).then(() => { toast.success("Delivery agent created"); setForm(empty); load(); }).catch(e => toast.error(message(e)));
  const toggle = row => axios.post("/admin/update_delivery_agent_status", { user_id: row.user_id, status: Number(row.status) === 0 ? 1 : 0 }, auth()).then(load).catch(e => toast.error(message(e)));
  return <>
    <Card><CardHeader><CardTitle>Delivery Agent Management</CardTitle></CardHeader><CardBody><Row>
      <Field label="First name*" name="first_name" value={form.first_name} onChange={change} />
      <Field label="Last name" name="last_name" value={form.last_name} onChange={change} />
      <Field label="Mobile*" name="mobile" value={form.mobile} onChange={change} />
      <Field label="Email" type="email" name="email_id" value={form.email_id} onChange={change} />
    </Row><Button color="primary" disabled={!form.first_name || !form.mobile} onClick={create}>Create Delivery Agent</Button></CardBody></Card>
    <Card><CardBody><Table responsive hover><thead><tr><th>ID</th><th>Name</th><th>Mobile</th><th>Email</th><th>Status</th><th /></tr></thead><tbody>
      {rows.map(row => <tr key={row.user_id}><td>{row.user_id}</td><td>{`${row.first_name || ""} ${row.last_name || ""}`}</td><td>{row.mobile}</td><td>{row.email_id}</td><td>{Number(row.status) === 0 ? "Active" : "Inactive"}</td><td><Button size="sm" color={Number(row.status) === 0 ? "danger" : "success"} outline onClick={() => toggle(row)}>{Number(row.status) === 0 ? "Deactivate" : "Activate"}</Button></td></tr>)}
      {!rows.length && <tr><td colSpan="6" className="text-center">No delivery agents yet</td></tr>}
    </tbody></Table></CardBody></Card>
  </>;
};

export const Products = () => {
  const empty = { producer_id: "", product_name: "", product_desc: "", rate_per_hour: "", product_qty: "" };
  const [rows, setRows] = useState([]);
  const [stores, setStores] = useState([]);
  const [form, setForm] = useState(empty);
  const load = () => Promise.all([axios.get("/admin/products", auth()), axios.get("/admin/producers", auth())]).then(([products, producers]) => {
    setRows(products.data.products || []); setStores(producers.data.producers || []);
  }).catch(e => toast.error(message(e)));
  useEffect(() => {
    load();
  }, []);
  const change = e => setForm({ ...form, [e.target.name]: e.target.value });
  const create = () => axios.post("/admin/create_product", { ...form, product_qty: Number(form.product_qty), rate_per_hour: Number(form.rate_per_hour) }, auth()).then(() => { toast.success("Product and inventory created"); setForm(empty); load(); }).catch(e => toast.error(message(e)));
  const toggle = row => axios.post("/admin/update_product_status", { product_id: row.product_id, display_status: Number(row.display_status) === 0 ? 1 : 0 }, auth()).then(load).catch(e => toast.error(message(e)));
  return <>
    <Card><CardHeader><CardTitle>Products and Inventory</CardTitle></CardHeader><CardBody><Row>
      <Col md="4" className="mb-1"><Label>Store*</Label><Input type="select" name="producer_id" value={form.producer_id} onChange={change}><option value="">Select store</option>{stores.map(store => <option key={store.producer_id} value={store.producer_id}>{store.producer_name}</option>)}</Input></Col>
      <Field label="Product name*" name="product_name" value={form.product_name} onChange={change} />
      <Field label="Rate*" type="number" min="0" step="0.01" name="rate_per_hour" value={form.rate_per_hour} onChange={change} />
      <Field label="Inventory quantity*" type="number" min="0" name="product_qty" value={form.product_qty} onChange={change} />
      <Field label="Description" name="product_desc" value={form.product_desc} onChange={change} />
    </Row><Button color="primary" disabled={!form.producer_id || !form.product_name || form.rate_per_hour === "" || form.product_qty === ""} onClick={create}>Add Product</Button></CardBody></Card>
    <Card><CardBody><Table responsive hover><thead><tr><th>ID</th><th>Product</th><th>Store</th><th>Rate</th><th>Inventory</th><th>Status</th><th /></tr></thead><tbody>
      {rows.map(row => <tr key={row.product_id}><td>{row.product_id}</td><td>{row.product_name}</td><td>{row.producer_name}</td><td>{row.rate_per_hour}</td><td>{row.product_qty}</td><td>{Number(row.display_status) === 0 ? "Active" : "Inactive"}</td><td><Button size="sm" color={Number(row.display_status) === 0 ? "danger" : "success"} outline onClick={() => toggle(row)}>{Number(row.display_status) === 0 ? "Deactivate" : "Activate"}</Button></td></tr>)}
      {!rows.length && <tr><td colSpan="7" className="text-center">No products yet</td></tr>}
    </tbody></Table></CardBody></Card>
  </>;
};
