import { Fragment, useEffect, useState } from "react";
import axios from "axios";
import {
  Row,
  Col,
  TabContent,
  TabPane,
  CardTitle,
  Label,
  Input,
} from "reactstrap";
// ** Demo Components
import ConnectionsTabContent from "./ConnectionsTabContent";

// ** Styles
import "@styles/react/libs/flatpickr/flatpickr.scss";
import "@styles/react/pages/page-account-settings.scss";
import { useLocation, useNavigate } from "react-router-dom";

import Select from "react-select"; // eslint-disable-line
import makeAnimated from "react-select/animated";
import { selectThemeColors } from "@utils";
import { Button, Modal, ModalHeader, ModalBody, ModalFooter } from "reactstrap";
import { useSelector } from "react-redux";
import BasicDetailsSupplier from "../../superadmin/BasicDetailsSupplier";
import CompanyDetailsSupplier from "../../superadmin/CompanyDetailsSupplier";
import toast from "react-hot-toast";
import BasicDetailLoadingView from "../../superadmin/BasicDetailLoadingView";
import Tabs from "./Tabs";

const options = [
  { label: "Pending", value: "Pending" },
  { label: "Approve", value: "Approve" },
  { label: "Reject", value: "Reject" },
];

const AccountSettings = (props) => {
  const animatedComponents = makeAnimated();
  const navigate = useNavigate();

  const [supplier, setSupplier] = useState();

  const user = useSelector((state) => state.user.userData);
  const token = localStorage.getItem("token");

  const [modal, setModal] = useState(false);

  console.log("status", status.value);
  const [rejectNote, setRejectNote] = useState("");

  const [activeTab, setActiveTab] = useState("1");

  useEffect(() => {
    if (user) {
      console.log("USER ID " + user.id);
      getSupplierAPIcall();
    }
  }, [user, token]);

  const getSupplierAPIcall = () => {
    axios
      .post(
        "/admin/getsupplierbyid",
        {
          id: user.id,
        },
        { headers: { Authorization: `Bearer ${token}` } }
      )
      .then((response) => {
        console.log("response ABCCC " + JSON.stringify(response.data));
        if (response && response.data && response.data.data) {
          setSupplier(response.data.data);
        } else {
          toast.error("Something went wrong.");
        }
      })
      .catch((err) => {
        console.log(err);
        toast.error(err.response.data.message);
      });
  };

  const updateSupplier = async (status) => {
    setModal(false);

    axios
      .post(
        "/supplier/updatesupplier",
        {
          id: supplier.id,
          profile: supplier.logo,
          first_name: supplier.first_name,
          last_name: supplier.last_name,
          email: supplier.email,
          country_code: supplier.country_code,
          phone_number: supplier.phone_number,
          company_name: supplier.company_name,
          company_name_ja: supplier.company_name_ja,
          company_name_ko: supplier.company_name_ko,

          supplier_type_id: supplier.supplier_type_id,
          description: supplier.description,
          address_line_1: supplier.address_line_1,
          address_line_2: supplier.address_line_2,
          latitude: supplier.latitude,
          longitude: supplier.longitude,
          website_url: supplier.website_url,
          status: status.value,

          highlights: JSON.stringify(supplier.highlights),
          highlights_ko: JSON.stringify(supplier.highlights_ko),
          highlights_ja: JSON.stringify(supplier.highlights_ja),
        },
        { headers: { Authorization: `Bearer ${token}` } }
      )
      .then((response) => {
        toast.success(response.data.message);

        if (props && props.updateDone) {
          props.updateDone();
        }
        getSupplierAPIcall();
      })
      .catch((err) => {
        console.log(err);
        toast.error(err.response.data.message);
      });
  };

  const toggleTab = (tab) => {
    setActiveTab(tab);
  };

  const toggleModal = () => {
    setModal(true);
  };

  const handleClose = () => {
    setModal(false);
  };
  const renderModal = (
    <div className={`theme-modal-primary`}>
      <Modal
        isOpen={modal}
        toggle={toggleModal}
        className="modal-dialog-centered"
        modalClassName="primary"
      >
        <ModalHeader toggle={() => handleClose()}>Reject Note</ModalHeader>
        <ModalBody>
          <Label className="form-label" for="tripname">
            Reject Note
          </Label>
          <Input
            id="store"
            name="tourname"
            placeholder="Enter Reject Note"
            value={rejectNote}
            onChange={(e) => setRejectNote(e.target.value)}
          />
        </ModalBody>
        <ModalFooter>
          <Button
            color="primary"
            onClick={() => updateSupplier(status, rejectNote)}
          >
            Submit
          </Button>
        </ModalFooter>
      </Modal>
    </div>
  );

  return (
    <Fragment>
      <CardTitle className="mb-2">
        <Row>
          <Col xs={7} lg={9}>
            <div
              style={{
                fontSize: "1.2585rem",
                marginTop: "10px",
                marginLeft: "10px",
                fontFamily: "inherit",
                fontWeight: "500",
                lineHeight: "1.2",
                color: "#5e5873",
              }}
            >
              My Details
            </div>
          </Col>
          {user.role === "superadmin" && (
            <Col xs={5} lg={3}>
              <div>
                <Select
                  isClearable={false}
                  theme={selectThemeColors}
                  closeMenuOnSelect={true}
                  components={animatedComponents}
                  value={status}
                  onChange={(e) => {
                    if (e.value === "Reject") {
                      setModal(true);
                    } else {
                      updateSupplier(e);
                    }
                    setStatus(e);
                  }}
                  placeholder="status"
                  options={options}
                  className="react-select"
                  classNamePrefix="select"
                />
              </div>
            </Col>
          )}
          <Col>
            <div className="demo-inline-spacing">{renderModal}</div>
          </Col>
        </Row>
      </CardTitle>

      <Row>
        <Col xs={12}>
          <Tabs className="mb-2" activeTab={activeTab} toggleTab={toggleTab} />

          <TabContent activeTab={activeTab}>
            <TabPane tabId="1">
              {supplier ? (
                <BasicDetailsSupplier supplierData={supplier} />
              ) : (
                <BasicDetailLoadingView />
              )}
            </TabPane>
            <TabPane tabId="2">
              {/* <BusinessDetails vendors={vendorsData} /> */}
            </TabPane>
            <TabPane tabId="3">
              {supplier ? (
                <CompanyDetailsSupplier supplierData={supplier} />
              ) : (
                <BasicDetailLoadingView />
              )}
            </TabPane>
            <TabPane tabId="5">
              <ConnectionsTabContent />
            </TabPane>
          </TabContent>
        </Col>
      </Row>
    </Fragment>
  );
};

export default AccountSettings;
