// ** Custom Components
import Avatar from "@components/avatar";

import moment from "moment";
import veg from "../../src/images/veg.svg";
import nonveg from "../../src/images/nonveg.svg";

// ** Third Party Components
// import axios from 'axios'
import {
  MoreVertical,
  Edit,
  FileText,
  Archive,
  Trash,
  Eye,
  Lock,
  Delete,
  Trash2,
} from "react-feather";

// ** Reactstrap Imports
import {
  Badge,
  UncontrolledDropdown,
  DropdownToggle,
  DropdownMenu,
  DropdownItem,
} from "reactstrap";

import EditOrderStatus from "./store/order/EditOrderStatus";

import AddSupplierType from "./store/supplier/AddUpdateSupplierType";
import AddFAQ from "./store/FAQ/AddUpdateFAQType";
import AddGalleryType from "./store/gallery/AddUpdateSupplierType";
import AddBannerType from "./store/banner/AddUpdateSupplierType";
import React from "react";
import UpdateProduct from "./store/products/AddUpdateProductType";
import AddUpdateData from "./store/Customers/AddUpdateData";

// ** Vars
// const states = ['success', 'danger', 'warning', 'info', 'dark', 'primary', 'secondary']

const status = {
  Pending: { title: "Pending", color: "light-secondary" },
  Accepted: { title: "Accepted", color: "light-info" },
  Check_In: { title: "Check in", color: "light-primary" },
  Check_Out: { title: "Check out", color: "light-success" },
  Cancel: { title: "Cancel", color: "light-danger" },
};
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


const paymentStatus = {
  true: { title: "pending", color: "light-secondary" },
  false: { title: "confirmed", color: "light-danger" },
 
};

const menuStatus = {
  Active: { title: "Active", color: "light-success" },
  InActive: { title: "InActive", color: "light-danger" },
};

const productDelete = {
  Yes: { title: "Yes", color: "light-success" },
  No: { title: "No", color: "light-danger" },
};

const CountriesStatus = {
  Active: { title: "Active", color: "light-success" },
  InActive: { title: "InActive", color: "light-danger" },
};

const tourStatus = {
  Pending: { title: "Pending", color: "light-secondary" },
  Reject: { title: "Reject", color: "light-danger" },
  Approve: { title: "Approve", color: "light-success" },
};

const supplierStatus = {
  Pending: { title: "Pending", color: "light-secondary" },
  Reject: { title: "Reject", color: "light-danger" },
  Approve: { title: "Approve", color: "light-success" },
};
const vendorsStatus = {
  0: { title: "Pending", color: "light-secondary" },
  1: { title: "Approve", color: "light-success" },
  2: { title: "Reject", color: "light-danger" },
  3: { title: "InActive", color: "light-danger" },
};

const formatOrderID = (id) => {
  
    if (id) {
      const incr_id_str = id.toString();
      return "OD" + incr_id_str.padStart(8, "0");
    } else {
      return id;
    }
  
}

// ** Get initial Data
// axios.get('/api/datatables/initial-data').then(response => {
//   data = response.data
// })
// ** Table Zero Config Column
export const basicColumns = [
  {
    name: "ID",
    sortable: true,
    maxWidth: "100px",
    selector: (row) => row.id,
  },
  {
    name: "Name",
    sortable: true,
    minWidth: "225px",
    selector: (row) => row.name,
  },
  {
    name: "Email",
    sortable: true,
    minWidth: "310px",
    selector: (row) => row.email,
  },
  {
    name: "Position",
    sortable: true,
    minWidth: "250px",
    selector: (row) => row.post,
  },
  {
    name: "Age",
    sortable: true,
    minWidth: "100px",
    selector: (row) => row.age,
  },
  {
    name: "Salary",
    sortable: true,
    minWidth: "175px",
    selector: (row) => row.salary,
  },
];
// ** Table ReOrder Column
export const reOrderColumns = [
  {
    name: "ID",
    reorder: true,
    sortable: true,
    maxWidth: "100px",
    selector: (row) => row.id,
  },
  {
    name: "Name",
    reorder: true,
    sortable: true,
    minWidth: "225px",
    selector: (row) => row.name,
  },
  {
    name: "Email",
    reorder: true,
    sortable: true,
    minWidth: "310px",
    selector: (row) => row.email,
  },
  {
    name: "Position",
    reorder: true,
    sortable: true,
    minWidth: "250px",
    selector: (row) => row.post,
  },
  {
    name: "Age",
    reorder: true,
    sortable: true,
    minWidth: "100px",
    selector: (row) => row.age,
  },
  {
    name: "Salary",
    reorder: true,
    sortable: true,
    minWidth: "175px",
    selector: (row) => row.salary,
  },
];

// ** Expandable table component
const ExpandableTable = ({ data }) => {
  return (
    <div className="expandable-content p-2">
      <p>
        <span className="fw-bold">City:</span> {data.city}
      </p>
      <p>
        <span className="fw-bold">Experience:</span> {data.experience}
      </p>
      <p className="m-0">
        <span className="fw-bold">Post:</span> {data.post}
      </p>
    </div>
  );
};

// ** Table Common Column
export const OrderListColumns = [
  {
    name: "Order Details",
    allowOverflow: true,
    minWidth: "100px",
    cell: (row) => {
      return (
        <div className="d-flex">
          <EditOrderStatus datas={row} length={false} />
        </div>
      );
    },
  },
  {
    name: "Order ID",
    sortable: true,
    minWidth: "150px",
    selector: (row) => row.order_number,
    cell: (row) => {
      return <span>#{row.order_number}</span>;
    },
  },
  {
    name: "User",
    sortable: true,
    minWidth: "200px",
    selector: (row) => row?._customer?.first_name + row?._customer?.last_name,
    cell: (row) => {
      return (
        <span>{row?._customer?.first_name + " " + row?._customer?.last_name}</span>
      );
    },
  },
  {
    name: "Delivery Option",
    minWidth: "200px",
    sortable: true,
    selector: (row) => `${row.delivery_type}`,
  },
  {
    name: "Sub Orders",
    minWidth: "150px",
    sortable: true,
    selector: (row) => `${row.orderItem?.length}`,
    cell: (row) => {
      return (
        <div className="d-flex">
          <EditOrderStatus datas={row} length={true} />
        </div>
      );
    },
  },
  {
    name: "Sub Total",
    minWidth: "150px",
    sortable: true,
    selector: (row) => `${row.sub_total?.toFixed(2)}`,
  },
  {
    name: "Delivery Charge",
    minWidth: "200px",
    sortable: true,
    selector: (row) => `${row.delivery_charge?.toFixed(2)}`,
  },
  {
    name: "Conv Fees",
    minWidth: "150px",
    sortable: true,
    selector: (row) => `${row.conveyance_charge?.toFixed(2)}`,
  },
  {
    name: "Discount",
    minWidth: "150px",
    sortable: true,
    selector: (row) => `${row.discount?.toFixed(2)}`,
  },
  {
    name: "Order Total",
    minWidth: "150px",
    sortable: true,
    selector: (row) =>
      `${(
        row.delivery_charge +
        row.sub_total +
        row.conveyance_charge -
        row.discount
      )?.toFixed(2)}`,
  },
];

function capitalizeFirstLetter(string) {
  return string.charAt(0).toUpperCase() + string.slice(1);
}
export const CustomerListColumns = [
  {
    name: "Actions",
    // allowOverflow: true,
    compact: true,
    width: "70px",
    cell: (row) => {
      return (
        <div className="d-flex">
          {/* <Eye style={{ cursor: "pointer" }} size={15} /> */}
          <AddUpdateData MenuItem={row} />

          {/* // datas={row} */}
        </div>
      );
    },
  },

  {
    name: "ID",
    sortable: true,
    minWidth: "25px",
    compact: true,
    selector: (row) => row.id,

    cell: (row) => <span>#{row.id}</span>,
  },
  {
    name: "Name",
    sortable: true,
    // minWidth: "140px",
    compact: true,

    minWidth: "200px",
    selector: (row) => row.first_name + " " + row.last_name,
  },
  {
    name: "Phone",
    sortable: true,
    compact: true,
    minWidth: "200px",
    selector: (row) => row.phone,
  },
  // {
  //   name: "Last Name",
  //   minWidth: "140px",
  //   compact: true,

  //   // sortable: row => row.,
  //   selector: (row) => row.last_name,
  // },
  // {
  //   name: "Email",
  //   sortable: true,
  //   minWidth: "200px",
  //   selector: (row) => row.email,
  // },
  {
    name: "Email",
    sortable: true,
    minWidth: "250px",
    compact: true,
    selector: (row) => row.email,

    cell: (row) => (
      <div className="d-flex">
        <div className="user-info text-truncate">
          <span className="d-block text-truncate">{row.email}</span>
        </div>
      </div>
    ),
  },

  {
    name: "User Type",
    minWidth: "100px",
    compact: true,

    sortable: true,

    selector: (row) => row.user_type,
    cell: (row) => {
      return <div>{capitalizeFirstLetter(row.user_type)}</div>;
    },
  },
  {
    name: "Status",
    minWidth: "100px",
    compact: true,

    sortable: true,

    selector: (row) => row.status,
    cell: (row) => {
      return (
        <Badge
          color={menuStatus[row.status === true ? "Active" : "InActive"].color}
          pill
        >
          {menuStatus[row.status === true ? "Active" : "InActive"].title}
        </Badge>
      );
    },
  },

  // {
  //   name: "Registration Date",
  //   sortable: true,
  //   minWidth: "180px",
  //   compact: true,

  //   selector: (row) => moment(row.createdAt).format("DD/MM/YYYY"),
  // },
];
export const SupplierListColumns = [
  {
    name: "Actions",
    // allowOverflow: true,
    compact: true,

    cell: (row) => {
      return (
        <div className="d-flex">
          <Eye style={{ cursor: "pointer" }} size={15} />
          {/* <EditOrderStatus /> */}
          {/* // datas={row} */}
        </div>
      );
    },
  },

  {
    name: "ID",
    sortable: true,
    minWidth: "25px",
    compact: true,
    selector: (row) => row.id,

    cell: (row) => <span>#{row.id}</span>,
  },
  {
    name: "Name",
    sortable: true,
    // minWidth: "140px",
    compact: true,

    minWidth: "200px",
    selector: (row) => row.first_name + " " + row.last_name,
  },
  // {
  //   name: "Last Name",
  //   minWidth: "140px",
  //   compact: true,

  //   // sortable: row => row.,
  //   selector: (row) => row.last_name,
  // },
  // {
  //   name: "Email",
  //   sortable: true,
  //   minWidth: "200px",
  //   selector: (row) => row.email,
  // },
  {
    name: "Email",
    sortable: true,
    minWidth: "250px",
    compact: true,
    selector: (row) => row.email,

    cell: (row) => (
      <div className="d-flex">
        <div className="user-info text-truncate">
          <span className="d-block text-truncate">{row.email}</span>
        </div>
      </div>
    ),
  },
  {
    name: "Status",
    minWidth: "100px",
    compact: true,

    sortable: true,

    selector: (row) => row.status,
    cell: (row) => {
      return (
        <Badge
          color={menuStatus[row.status === true ? "Active" : "InActive"].color}
          pill
        >
          {menuStatus[row.status === true ? "Active" : "InActive"].title}
        </Badge>
      );
    },
  },

  {
    name: "Registration Date",
    sortable: true,
    minWidth: "180px",
    compact: true,

    selector: (row) => moment(row.created_at).format("DD/MM/YYYY"),
  },
];

export const SupplierTypeListColumns = [
  {
    name: "Actions",
    allowOverflow: true,
    minWidth: "100px",
    compact: true,
    cell: (row) => {
      return (
        <div className="d-flex">
          {/* <DeleteMenuCatagory menuDelete={row} /> */}
          <AddSupplierType MenuItem={row} />
          
        </div>
      );
    },
  },
  {
    name: "id",
    sortable: true,
    minWidth: "100px",
    selector: (row) => row.id,
    cell: (row) => {
      return <span>#{row.id}</span>;
    },
  },
  {
    name: "Icon",
    sortable: false,
    minWidth: "200px",
    selector: (row) => {
      if (row.icon_url) {
        return (
          <img
            style={{ height: "40px", width: "60px", objectFit: "cover" }}
            src={row.icon_url}
          />
        );
      }
    },
  },
  {
    name: "name",
    sortable: true,
    minWidth: "300px",
    selector: (row) => row.name,
  },
  {
    name: "Status",
    minWidth: "110px",
    sortable: true,

    selector: (row) => row.status,

    cell: (row) => {
      return (
        <Badge
          color={menuStatus[row.status === true ? "Active" : "InActive"].color}
          pill
        >
          {menuStatus[row.status === true ? "Active" : "InActive"].title}
        </Badge>
      );
    },
  },
];

export const FAQListColumns = (onClick) => [
  {
    name: "Actions",
    allowOverflow: true,
    minWidth: "50px",
    compact: true,
    cell: (row) => {
      return (
        <div className="d-flex">
          {console.log("menuItems 134", row)}
          <AddFAQ MenuItem={row} />
          <Trash2
            style={{ cursor: "pointer", marginLeft: "10px" }}
            size={15}
            onClick={() => {
              onClick && onClick(row);
            }}
          ></Trash2>
        </div>
      );
    },
  },
  // {
  //   name: "",
  //   allowOverflow: true,
  //   minWidth: "50px",
  //   compact: true,
  //   cell: (row) => {
  //     return (
  //       <div className="d-flex">
  //         {/* <DeleteMenuCatagory menuDelete={row} /> */}
  //         <DeleteFAQ MenuItem={row} />
  //       </div>
  //     );
  //   },
  // },
  {
    name: "id",
    sortable: true,
    minWidth: "100px",
    selector: (row) => row._id,
    cell: (row) => {
      return <span>#{row._id}</span>;
    },
  },
  {
    name: "Question",
    sortable: true,
    minWidth: "200px",
    selector: (row) => row.question,
    cell: (row) => {
      return <span>{row.question}</span>;
    },
  },
  {
    name: "Answer",
    sortable: true,
    allowOverflow: true,
    minWidth: "300px",
    selector: (row) => row.answer,
    cell: (row) => {
      return <span>{row.answer}</span>;
    },
  },
  {
    name: "Added On",
    minWidth: "110px",
    sortable: true,

    selector: (row) => row.createdAt,

    cell: (row) => {
      return (
        <span>
          {row.createdAt && moment(row.createdAt).format("DD MMM YY")}
        </span>
      );
    },
  },
];

export const NotificationsListColumns = (onClick) => [
  {
    name: "Actions",
    allowOverflow: true,
    maxWidth: "10px",
    compact: true,
    cell: (row) => {
      return (
        <div className="d-flex">
          {console.log("menuItems 134", row)}
          {/* <AddFAQ MenuItem={row} /> */}
          <Trash2
            style={{ cursor: "pointer", marginLeft: "10px" }}
            size={15}
            onClick={() => {
              onClick && onClick(row);
            }}
          ></Trash2>
        </div>
      );
    },
  },
  // {
  //   name: "",
  //   allowOverflow: true,
  //   maxWidth: "0px",
  //   compact: true,
  //   cell: (row) => {
  //     return (
  //       <div className="d-flex">
  //         {/* <DeleteMenuCatagory menuDelete={row} /> */}
  //         <DeleteNotiFication MenuItem={row} />
  //       </div>
  //     );
  //   },
  // },
  {
    name: "id",
    sortable: true,
    minWidth: "90px",
    selector: (row) => row._id,
    cell: (row) => {
      return <span>#{row._id}</span>;
    },
  },
  {
    name: "Title",
    sortable: true,
    minWidth: "200px",
    selector: (row) => row.title,
    cell: (row) => {
      return <span>{row.title}</span>;
    },
  },
  {
    name: "Description",
    sortable: true,
    allowOverflow: true,
    minWidth: "400px",
    selector: (row) => row.description,
    cell: (row) => {
      return <span>{row.description}</span>;
    },
  },
  {
    name: "Added On",
    minWidth: "110px",
    sortable: true,

    selector: (row) => row.createdAt,

    cell: (row) => {
      return (
        <span>
          {row.createdAt && moment(row.createdAt).format("DD MMM YY")}
        </span>
      );
    },
  },
];

export const ProductsListColumns = [
  {
    name: "Actions",
    allowOverflow: true,
    minWidth: "100px",
    compact: true,
    cell: (row) => {
      return (
        <div className="d-flex">
          {/* <DeleteMenuCatagory menuDelete={row} /> */}
          <UpdateProduct MenuItem={row} />
        </div>
      );
    },
  },
  {
    name: "Product Id",
    sortable: true,
    minWidth: "150px",
    selector: (row) => row.id,
    cell: (row) => {
      return <span>#{row.id}</span>;
    },
  },
  {
    name: "Store Name",
    sortable: true,
    minWidth: "150px",
    selector: (row) => row._producer.name,
    cell: (row) => {
      return <span>{row._producer.name}</span>;
    },
  },
  {
    name: "Product Image",
    sortable: false,
    minWidth: "170px",
    selector: (row) => {
      if (row.image_url) {
        return (
          <img
            style={{ height: "40px", width: "60px", objectFit: "cover" }}
            src={row.image_url}
          />
        );
      }
    },
  },
  {
    name: "Product Name",
    sortable: true,
    minWidth: "200px",
    selector: (row) => row.name,
  },
  {
    name: "Rate",
    sortable: true,
    minWidth: "50px",
    selector: (row) => row.price,
  },
  {
    name: "Quantity",
    sortable: true,
    minWidth: "120px",
    selector: (row) => row.qty,
  },
  {
    name: "Status",
    minWidth: "110px",
    sortable: true,

    selector: (row) => row.visible,

    cell: (row) => {
      return (
        <Badge
          color={menuStatus[row.visible === true ? "Active" : "InActive"].color}
          pill
        >
          {menuStatus[row.visible === true ? "Active" : "InActive"].title}
        </Badge>
      );
    },
  },
  {
    name: "Deleted",
    minWidth: "110px",
    sortable: true,

    selector: (row) => row.deleted,

    cell: (row) => {
      return (
        <Badge
          color={productDelete[row.deleted === true ? "Yes" : "No"].color}
          pill
        >
          {productDelete[row.deleted === true ? "Yes" : "No"].title}
        </Badge>
      );
    },
  },
 
];

export const SKUListColumns = [
  {
    name: "Actions",
    allowOverflow: true,
    minWidth: "100px",
    compact: true,
    cell: (row) => {
      return (
        <div className="d-flex">
          {/* <DeleteMenuCatagory menuDelete={row} /> */}
          <AddGalleryType MenuItem={row} />
        </div>
      );
    },
  },
  {
    name: "id",
    sortable: true,
    minWidth: "100px",
    selector: (row) => row.id,
    cell: (row) => {
      return <span>#{row.id}</span>;
    },
  },
  {
    name: "Icon",
    sortable: false,
    minWidth: "200px",
    selector: (row) => {
      if (row.image_url) {
        return (
          <img
            style={{ height: "40px", width: "60px", objectFit: "cover" }}
            src={row.image_url}
          />
        );
      }
    },
  },
  {
    name: "title",
    sortable: true,
    minWidth: "300px",
    selector: (row) => row.title,
  },
  // {
  //   name: "Status",
  //   minWidth: "110px",
  //   sortable: true,

  //   selector: (row) => row.status,

  //   cell: (row) => {
  //     return (
  //       <Badge
  //         color={menuStatus[row.status === true ? "Active" : "InActive"].color}
  //         pill
  //       >
  //         {menuStatus[row.status === true ? "Active" : "InActive"].title}
  //       </Badge>
  //     );
  //   },
  // },
];

export const viewOrders = [
  
  {
    name: "id",
    sortable: true,
    minWidth: "100px",
    selector: (row) => row._id,
    cell: (row) => {
      return <span>#{formatOrderID(row._order.incr_id)}</span>;
    },
  },
  
  {
    name: "Product Name",
    sortable: true,
    minWidth: "200px",
    selector: (row) => row.product_name,
  },
  {
    name: "Rate",
    sortable: true,
    minWidth: "150px",
    selector: (row) => row.price,
  },
  {
    name: "Quantity",
    sortable: true,
    minWidth: "150px",
    selector: (row) => row.qty,
  },
  {
    name: "Total Rate",
    sortable: true,
    minWidth: "150px",
    selector: (row) => row.order_item_total || row.totalAmount ,
  },
  {
    name: "Order Date",
    sortable: true,
    minWidth: "150px",
    selector: (row) => moment(row.createdAt).format("YYYY-MM-DD"),
  },
  {
    name: "Order Status",
    sortable: true,
    minWidth: "150px",
    selector: (row) => row.status,
    cell: (row) => {
      return (
        <Badge color={orderStatusBadge[row.status].color} pill>
                        {row.status}
                      </Badge>
      );
    },
  },
  {
    name: "Payment Status",
    sortable: true,
    minWidth: "200px",
    selector: (row) => row.settlement_status,
    cell: (row) => <Badge color= {row.settlement_status ? "light-success" : "light-secondary"} pill>
    {row.settlement_status ? "Paid" : "Pending"}
  </Badge>,
   
    
  },
  
  // {
  //   name: "Status",
  //   minWidth: "110px",
  //   sortable: true,

  //   selector: (row) => row.status,

  //   cell: (row) => {
  //     return (
  //       <Badge
  //         color={menuStatus[row.status === true ? "Active" : "InActive"].color}
  //         pill
  //       >
  //         {menuStatus[row.status === true ? "Active" : "InActive"].title}
  //       </Badge>
  //     );
  //   },
  // },
];

export const BannerListColumns = [
  {
    name: "Actions",
    allowOverflow: true,
    minWidth: "100px",
    compact: true,
    cell: (row) => {
      return (
        <div className="d-flex">
          {/* <DeleteMenuCatagory menuDelete={row} /> */}
          <AddBannerType MenuItem={row} />
        </div>
      );
    },
  },
  {
    name: "id",
    sortable: true,
    minWidth: "100px",
    selector: (row) => row.id,
    cell: (row) => {
      return <span>#{row.id}</span>;
    },
  },
  {
    name: "Image",
    sortable: false,
    minWidth: "200px",
    selector: (row) => {
      if (row.image_url) {
        return (
          <img
            style={{ height: "40px", width: "60px", objectFit: "cover" }}
            src={row.image_url}
          />
        );
      }
    },
  },
  {
    name: "title",
    sortable: true,
    minWidth: "300px",
    selector: (row) => row.title,
  },
  
];

// ** Table Intl Column
export const multiLingColumns = [
  {
    name: "Name",
    sortable: true,
    minWidth: "200px",
    selector: (row) => row.name,
  },
  {
    name: "Position",
    sortable: true,
    minWidth: "250px",
    selector: (row) => row.post,
  },
  {
    name: "Email",
    sortable: true,
    minWidth: "250px",
    selector: (row) => row.email,
  },
  {
    name: "Date",
    sortable: true,
    minWidth: "150px",
    selector: (row) => row.start_date,
  },

  {
    name: "Salary",
    sortable: true,
    minWidth: "150px",
    selector: (row) => row.salary,
  },
  {
    name: "Status",
    sortable: true,
    minWidth: "150px",
    selector: (row) => row.status,
    cell: (row) => {
      return (
        <Badge color={status[row.status].color} pill>
          {status[row.status].title}
        </Badge>
      );
    },
  },
  {
    name: "Actions",
    allowOverflow: true,
    cell: () => {
      return (
        <div className="d-flex">
          <UncontrolledDropdown>
            <DropdownToggle className="pe-1" tag="span">
              <MoreVertical size={15} />
            </DropdownToggle>
            <DropdownMenu end>
              <DropdownItem>
                <FileText size={15} />
                <span className="align-middle ms-50">Details</span>
              </DropdownItem>
              <DropdownItem>
                <Archive size={15} />
                <span className="align-middle ms-50">Archive</span>
              </DropdownItem>
              <DropdownItem>
                <Trash size={15} />
                <span className="align-middle ms-50">Delete</span>
              </DropdownItem>
            </DropdownMenu>
          </UncontrolledDropdown>
          <Edit onClick={handleModal} size={15} />
        </div>
      );
    },
  },
];

// ** Table Server Side Column
export const serverSideColumns = [
  {
    sortable: true,
    name: "Full Name",
    minWidth: "225px",
    selector: (row) => row.title,
  },
  {
    sortable: true,
    name: "Email",
    minWidth: "250px",
    selector: (row) => row.email,
  },
  {
    sortable: true,
    name: "Position",
    minWidth: "250px",
    selector: (row) => row.post,
  },
  {
    sortable: true,
    name: "Office",
    minWidth: "150px",
    selector: (row) => row.city,
  },
  {
    sortable: true,
    name: "Start Date",
    minWidth: "150px",
    selector: (row) => row.start_date,
  },
  {
    sortable: true,
    name: "Salary",
    minWidth: "150px",
    selector: (row) => row.salary,
  },
];

// ** Table Adv Search Column
export const advSearchColumns = [
  {
    name: "Name",
    sortable: true,
    minWidth: "200px",
    selector: (row) => row.name,
  },
  {
    name: "Email",
    sortable: true,
    minWidth: "250px",
    selector: (row) => row.email,
  },
  {
    name: "Post",
    sortable: true,
    minWidth: "250px",
    selector: (row) => row.post,
  },
  {
    name: "City",
    sortable: true,
    minWidth: "150px",
    selector: (row) => row.city,
  },
  {
    name: "Date",
    sortable: true,
    minWidth: "150px",
    selector: (row) => row.start_date,
  },

  {
    name: "Salary",
    sortable: true,
    minWidth: "100px",
    selector: (row) => row.salary,
  },
];

export const PAGE_DATA_COUNT = 10;
export default ExpandableTable;
