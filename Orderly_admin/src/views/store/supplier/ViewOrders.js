import React, {
  Fragment,
  useState,
  forwardRef,
  useEffect,
  useRef,
} from "react";

import {
  Row,
  Col,
  Card,
  Input,
  Label,
  Button,
  CardTitle,
  CardBody,
  CardText,
  CardHeader,
  DropdownMenu,
  DropdownItem,
  DropdownToggle,
  UncontrolledButtonDropdown,
} from "reactstrap";
import { useNavigate, useParams } from "react-router-dom";
import axios from "axios";

import AddUpdateModal from "./AddUpdateModal";
import DataTable from "react-data-table-component";
import { ActivityListColumns, SKUListColumns, viewOrders } from "../../data";
import {
  ChevronDown,
  Share,
  Printer,
  FileText,
  File,
  Grid,
  Copy,
  Plus,
  Search,
} from "react-feather";

import ReactPaginate from "react-paginate";
import toast from "react-hot-toast";
import AddMenuItemList from "../menu-item/AddMenuItemList";
import { IconButton } from "@mui/material";
import EditSharpIcon from "@mui/icons-material/EditSharp";
import { PendingActions, PhotoCamera, PublishedWithChanges } from "@mui/icons-material";
import userPlaceHolder from "../../../assets/images/avatars/avatar-blank.png";

const BootstrapCheckbox = forwardRef((props, ref) => (
  <div className="form-check">
    <Input type="checkbox" ref={ref} {...props} />
  </div>
));

const ViewOrders = () => {
  const [activityTitle, setActivityTitle] = useState("");
  const [modal, setModal] = useState(false);
  const [isView, setIsview] = useState(false);
  const [currentPage, setCurrentPage] = useState(0);
  const [activities, setActivities] = useState([]);
  const [searchValue, setSearchValue] = useState("");
  const [filteredData, setFilteredData] = useState([]);
  const [diliveryBefore, setDiliveryBefore] = useState("");
  const [description, setDescription] = useState("");


  const token = localStorage.getItem("token");
  const navigate = useNavigate();
  const params = useParams()


  const [selectedLogo, setSelectedLogo] = useState();
  const [activityImage, setactivityImage] = useState();
  const [activityImageFile, setactivityImageFile] = useState();
  const [selectedSettle, setSelectedSettle] = useState("AllOrder")
  const [deliveryError, setDeliveryError] = useState("")
  const [payValue, setPayValue] = useState("")


  const handlePagination = (page) => {
    setCurrentPage(page.selected);
  };

  const CustomPagination = () => (
    <ReactPaginate
      previousLabel=""
      nextLabel=""
      forcePage={currentPage}
      onPageChange={(page) => handlePagination(page)}
      pageCount={searchValue.length ? Math.ceil(filteredData.length / 7) : Math.ceil(activities.length / 7) || 1}
      breakLabel="..."
      pageRangeDisplayed={2}
      marginPagesDisplayed={2}
      activeClassName="active"
      pageClassName="page-item"
      breakClassName="page-item"
      nextLinkClassName="page-link"
      pageLinkClassName="page-link"
      breakLinkClassName="page-link"
      previousLinkClassName="page-link"
      nextClassName="page-item next-item"
      previousClassName="page-item prev-item"
      containerClassName="pagination react-paginate separated-pagination pagination-sm justify-content-end pe-1 mt-1"
    />
  );

  const handleFilter = (e) => {
    const value = e.target.value;
    let updatedData = [];
    setSearchValue(value);
    if (value.length) {
      updatedData = activities.filter((item) => {
        const startsWith =
          item._id.toString().toLowerCase().startsWith(value.toLowerCase()) ||

          item.product_name.toLowerCase().startsWith(value.toLowerCase()) ||
          item.status.toLowerCase().startsWith(value.toLowerCase()) ||
          item.price.toString().toLowerCase().startsWith(value.toLowerCase()) ||
          (item.order_item_total || item.totalAmount)?.toString().toLowerCase().startsWith(value.toLowerCase()) ||
          item.qty.toString().toLowerCase().startsWith(value.toLowerCase())
        // item.status.toLowerCase().startsWith(value.toLowerCase());



        const includes =
          item._id.toString().toLowerCase().includes(value.toLowerCase()) ||
          item.product_name.toLowerCase().includes(value.toLowerCase()) ||
          item.status.toLowerCase().includes(value.toLowerCase()) ||
          item.price?.toString().toLowerCase().includes(value.toLowerCase()) ||
          (item.order_item_total || item.totalAmount)?.toString().toLowerCase().includes(value.toLowerCase()) ||
          item.qty.toString()?.toLowerCase().includes(value.toLowerCase())
        // item.status.toLowerCase().includes(value.toLowerCase());


        if (startsWith) {
          return startsWith;
        } else if (!startsWith && includes) {
          return includes;
        } else return null;
      });
      setFilteredData(updatedData);
      setSearchValue(value);
    }
  };

  const getRecord = (id) => {
    axios
      .get(`/admin/storeorder/${id}`, { headers: { Authorization: `Bearer ${token}` } })
      .then((response) => {
        setActivities(response.data.data);
      })
      .catch((err) => {
        console.log(err);
        ``;
      });
  }
  useEffect(() => {
    if (params?.id) {
      getRecord(params?.id);
    }
  }, [params?.id]);

  const createActivity = () => {
    const formData = new FormData();
    formData.append("title", activityTitle);
    formData.append("title", activityTitle);
    formData.append("image", activityImageFile);

    axios({
      method: "post",
      url: "/admin/gallery/create",

      headers: {
        "content-type": "application/json",
        Authorization: `Bearer ${token}`,
      },
      data: formData,
    })
      .then((response) => {

        navigate(`${process.env.REACT_APP_FOLDER}/activity-listing`);
        toast.success(response.data.message);
      })
      .catch((err) => {
        console.log(err);


        toast.error(err.response.data.message);
      });
  };

  function convertArrayOfObjectsToCSV(array) {
    let result;

    const columnDelimiter = ",";
    const lineDelimiter = "\n";
    const keys = Object.keys(activities[0]);

    result = "";
    result += keys.join(columnDelimiter);
    result += lineDelimiter;

    array.forEach((item) => {
      let ctr = 0;
      keys.forEach((key) => {
        if (ctr > 0) result += columnDelimiter;

        result += item[key];

        ctr++;
      });
      result += lineDelimiter;
    });

    return result;
  }

  // ** Downloads CSV
  function downloadCSV(array) {
    const link = document.createElement("a");
    let csv = convertArrayOfObjectsToCSV(array);
    if (csv === null) return;

    const filename = "export.csv";

    if (!csv.match(/^data:text\/csv/i)) {
      csv = `data:text/csv;charset=utf-8,${csv}`;
    }

    link.setAttribute("href", encodeURI(csv));
    link.setAttribute("download", filename);
    link.click();
  }

  const handleSearch = () => {
    if (!diliveryBefore) {
      setDeliveryError("Required this field")
      return false
    } else {
      setDeliveryError("")


    }
    axios
      .post(`/admin/settlement  `,
        {
          deliveryBefore: parseInt(diliveryBefore),
          _producer: params?.id,

        },
        { headers: { Authorization: `Bearer ${token}` } })
      .then((response) => {
        console.log("sfcfsfs response", response);
        if (response?.data?.data[0]) {
          const data = response?.data?.data[0].records
          setActivities(data)
          if (data?.length) {
            setIsview(true)
            setPayValue(response.data.data[0]?.totalSum)
          } else {
            setIsview(false)
          }
        } else {
          setActivities([])
          toast.error("No data found!")
          setIsview(false)
        }
      })
      .catch((err) => {
        console.log(err);
        console.log("sfcfsfs error", err);

        toast.error("Something went Wrong!")

      });

  }

  const handlePay = () => {
    axios
      .post(`/admin/settlement/pay`,
        {
          deliveryBefore: diliveryBefore,
          _producer: params?.id,
          total: payValue,
          description:description

        },
        { headers: { Authorization: `Bearer ${token}` } })
      .then((response) => {
        toast.success(response?.data?.data?.message)
        setIsview(false)

      })
      .catch((err) => {
        toast.error("Something went Wrong!")

      });
  }

  return (
    <div>
      {modal ?
        <AddUpdateModal
          activity={{}}
          open={modal}
          handleModal={() => {



            getRecord();
            setModal(!modal)

          }}
          setModal={() => { }}
          isadd={true}
        />
        : null}

      <Card>
        <CardHeader >


          <div style={{ display: "flex", width: "100%" }}>
            <div
              style={{
                fontSize: "1.2585rem",
                marginTop: "15px",
                marginLeft: "10px",
                fontFamily: "inherit",
                fontWeight: "500",

                color: "#5e5873",
                width: "100%",
              }}
            >
              View Orders
            </div>

            <div style={{ marginRight: "20px", width: "100%", display: "flex", justifyContent: "end" }}>
              <div
                class="btn-group shadow"
                role="group"
                aria-label="select version"
                style={{ width: "auto" }}
              >
                <button
                  type="button"
                  className={"btn"}
                  style={{
                    backgroundColor:
                      selectedSettle === "AllOrder" ? "#7366F0" : "white",
                    color: selectedSettle === "AllOrder" ? "white" : "black",
                  }}
                  onClick={() => {
                    setSelectedSettle("AllOrder");
                    getRecord(params?.id)
                  }}
                >
                  <span>
                    <PendingActions /> All Order
                  </span>
                </button>
                <button
                  type="button"
                  className={"btn"}
                  // style={{ backgroundColor: "red", color: "yellow" }}
                  style={{
                    backgroundColor:
                      selectedSettle != "AllOrder" ? "#7366F0" : "white",
                    color: selectedSettle != "AllOrder" ? "white" : "black",
                  }}
                  onClick={() => {
                    setSelectedSettle("SettleMent");

                  }}
                >
                  <PublishedWithChanges /> Settlement
                </button>
              </div>
            </div>
          </div>


        </CardHeader>


        {/* <CardText style={{ display: "flex" }}>
            <div className="mb-1" style={{ width: "50%", marginRight: "1rem" }}>
              <Label className="form-label" for="input-default">
                Activity Title
              </Label>
              <Input
                type="text"
                id="input-default"
                placeholder="Enter Activity Name"
                value={activityTitle}
                onChange={(e) => setActivityTitle(e.target.value)}
              />
            </div>

            <div className="flex justify-end items-end">
              <Label
                className="form-label"
                for="input-default"
              // style={{  marginLeft: "1rem" }}
              >
                Activity Image
              </Label>

              <div>
                <img
                  src={activityImage ? activityImage : userPlaceHolder}
                  style={{
                    objectFit: "cover",
                    width: "100px",
                    height: "100px",
                    border: "1px solid #d3d3d3",
                    padding: "0.2rem",
                  }}
                />
                <input
                  hidden
                  accept="image/*"
                  id="icon-button-file"
                  type="file"
                  onChange={(e) => {
                    if (e.target.files.length) {
                      setactivityImage(URL.createObjectURL(e.target.files[0]));
                      setactivityImageFile(e.target.files[0]);
                    }
                  }}
                />
                <label htmlFor="icon-button-file">
                  <IconButton
                    color="primary"
                    className="p-0 ml-6"
                    aria-label="upload picture"
                    component="span"
                    style={{ marginLeft: "1rem" }}
                  >
                    <PhotoCamera />
                  </IconButton>
                </label>
              </div>
            </div>
          </CardText> */}


      </Card>
      {selectedSettle === "SettleMent" ?
        <Card>
          <CardBody>
            <Row>
              <Col md={3}>
                <div className="mb-1">
                  <Label className="form-label" for="input-default">
                    Dilivered Before*
                  </Label>
                  <Input
                    type="number"
                    id="input-default"
                    // placeholder=""
                    name="diliveredBefore"
                    required
                    invalid={deliveryError ? true : false}
                    value={diliveryBefore}
                    onChange={(e) => {
                      setDiliveryBefore(e.target.value)
                      if (e.target.value) {
                        setDeliveryError("")
                      } else {
                        setDeliveryError("Required this field")

                      }
                    }}

                  />
                  {deliveryError && (
                    <p
                      className="text-danger mb-0"
                      style={{ marginTop: "6px" }}
                    >
                      {deliveryError}
                    </p>
                  )}
                </div>
              </Col>
              <Col md={"auto"} >
                <div style={{ marginTop: "32px" }}>
                  Days
                </div>

              </Col>
              <Col md={3} >
                <div >
                  <Button className="mt-2" color="primary" onClick={handleSearch}>
                    <Search size={15} style={{ marginRight: "6px" }} />
                    <span className="align-middle">Search</span>
                  </Button>
                </div>

              </Col>



              {isView ? <> <Col md={1}>
                <div className="mb-1">
                  <Label className="form-label" for="input-default">
                    Pay
                  </Label>
                  <Input
                    type="number"
                    id="input-default"
                    // placeholder=""
                    name="diliveredBefore"
                    disabled

                    value={payValue}
                  // onChange={(e) => handleChange("Rate", e.target.value)}

                  />

                </div>
              </Col>
              <Col md={2}>
                <div className="mb-1">
                  <Label className="form-label" for="input-default">
                    Description
                  </Label>
                  <Input
                    type="text"
                    id="input-default"
                    // placeholder=""
                    name="description"
                     placeholder="Enter Description"

                    value={description}
                  onChange={(e) => setDescription( e.target.value)}

                  />

                </div>
              </Col>

                <Col md={2} >
                  <div >
                    <Button className="mt-2" color="primary" onClick={handlePay}>
                      {/* <Search size={15} style={{marginRight:"6px"}}/> */}
                      <span className="align-middle">Pay</span>
                    </Button>
                  </div>

                </Col>
              </> : ""}


            </Row>
          </CardBody>
        </Card> : ""}
      <Card>
        <CardHeader className="flex-md-row flex-column align-md-items-center align-items-start border-bottom">
          <CardTitle tag="h4"></CardTitle>
          <div className="d-flex mt-md-0 mt-1">

            <UncontrolledButtonDropdown>
              <DropdownToggle color="secondary" caret outline>
                <Share size={15} />
                <span className="align-middle ms-50">Export</span>
              </DropdownToggle>
              <DropdownMenu>
                <DropdownItem className="w-100">
                  <Printer size={15} />
                  <span className="align-middle ms-50">Print</span>
                </DropdownItem>
                <DropdownItem
                  className="w-100"
                  onClick={() => downloadCSV(activities)}
                >
                  <FileText size={15} />
                  <span className="align-middle ms-50">CSV</span>
                </DropdownItem>
                <DropdownItem className="w-100">
                  <Grid size={15} />
                  <span className="align-middle ms-50">Excel</span>
                </DropdownItem>

              </DropdownMenu>
            </UncontrolledButtonDropdown>
            {/* <Button className="ms-2" color="primary" onClick={handleModal}>
              <Plus size={15} />
              <span className="align-middle ms-50">Create Activity</span>
            </Button> */}
          </div>
        </CardHeader>
        <Row className="justify-content-end mx-0">
          <Col
            className="d-flex align-items-center justify-content-end mt-1"
            md="6"
            sm="12"
          >
            <Label className="me-1" for="search-input">
              Search
            </Label>
            <Input
              className="dataTable-filter mb-50"
              type="text"
              bsSize="sm"
              id="search-input"
              value={searchValue}
              onChange={handleFilter}
            />
          </Col>
        </Row>

        <div className="react-dataTable react-dataTable-selectable-rows">
          <DataTable
            noHeader
            pagination
            // selectableRows
            columns={viewOrders}
            paginationPerPage={7}
            className="react-dataTable"
            sortIcon={<ChevronDown size={10} />}
            paginationComponent={CustomPagination}
            paginationDefaultPage={currentPage + 1}
            selectableRowsComponent={BootstrapCheckbox}
            data={searchValue.length ? filteredData : activities}
          />
        </div>
      </Card>
      {/* {modal && <AddActivity open={modal} handleModal={handleModal} />} */}
    </div>
  );
};

export default ViewOrders;
