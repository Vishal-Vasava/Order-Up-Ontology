import { X } from "react-feather";

// ** Reactstrap Imports
import {
  Modal,
  ModalHeader,
  ModalBody,
  Card,
  Badge,
  CardTitle,
  Table,
} from "reactstrap";

// ** Styles
import "@styles/react/libs/flatpickr/flatpickr.scss";

const orderStatusBadge = {
  pending: { title: "pending", color: "light-secondary" },
  confirmed: { title: "confirmed", color: "light-danger" },
  ready: { title: "ready", color: "light-success" },
  shipped: { title: "shipped", color: "light-success" },
  delivered: { title: "delivered", color: "light-success" },
  rejected: { title: "rejected", color: "light-danger" },
  cancelled: { title: "cancelled", color: "light-secondary" },
  return_requested: { title: "return_requested", color: "light-secondary" },
  returned: { title: "returned", color: "light-success" },
  refund_process: { title: "refund_process", color: "light-secondary" },
  refunded: { title: "refunded", color: "light-success" },
  replace_requested: { title: "replace_requested", color: "light-secondary" },
  replaced: { title: "replaced", color: "light-success" },
};

const AddMenuItem = ({ open, handleModal, allData }) => {
  console.log("allDatasds", allData);
  const CloseBtn = (
    <X className="cursor-pointer" size={15} onClick={handleModal} />
  );

  return (
    <Modal
      isOpen={open}
      toggle={handleModal}
      className="sidebar-sm"
      modalClassName="modal-slide-in"
      contentClassName="pt-0"
      style={{ width: "60%" }}
    >
      <ModalHeader
        className="mb-1"
        toggle={handleModal}
        close={CloseBtn}
        tag="div"
      >
        <h5 className="modal-title">
          OrderID <b>#{allData.order_number}</b>
        </h5>
      </ModalHeader>
      <ModalBody className="flex-grow-1">
        <Card className="card-company-table">
          <CardTitle style={{ marginLeft: 30, marginTop: 20 }} tag="h4">
            All Order Items
          </CardTitle>
          <Table responsive>
            <thead>
              <tr>
                <th>ID</th>
                <th>Store</th>
                <th>Product</th>
                <th>Status</th>
                <th>Rate</th>
                <th>Qty</th>
                <th>Total</th>
              </tr>
            </thead>
            <tbody>
              {allData?.order_items.map((i) => {
                return (
                  <tr>
                    <td style={{ maxWidth: "150px" }}>
                      <span>#{i._id}</span>
                    </td>
                    <td>{i._producer?.name}</td>
                    <td>{i.product_name}</td>
                    <td>
                      <Badge color={orderStatusBadge[i.status].color} pill>
                        {i.status}
                      </Badge>
                    </td>
                    <td>{i.price?.toFixed(2)}</td>
                    <td>{i.qty?.toFixed(2)}</td>
                    <td>{(i.price * i.qty)?.toFixed(2)}</td>
                  </tr>
                );
              })}
            </tbody>
          </Table>
        </Card>
      </ModalBody>
    </Modal>
  );
};

export default AddMenuItem;
