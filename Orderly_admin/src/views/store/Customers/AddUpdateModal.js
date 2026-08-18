// ** React Imports
import { useState, useEffect } from "react";

// ** Third Party Components

import { Mail, MapPin, Phone, Truck, User, X } from "react-feather";
import { selectThemeColors } from "@utils";
import makeAnimated from "react-select/animated";
import "@styles/react/libs/flatpickr/flatpickr.scss";
import Select from "react-select";

// ** Reactstrap Imports
import {
  Modal,
  Input,
  Label,
  Button,
  ModalHeader,
  ModalBody,
  InputGroup,
  InputGroupText,
  Row,
  Col,
} from "reactstrap";

// ** Styles
import "@styles/react/libs/flatpickr/flatpickr.scss";
import axios from "axios";
import { useNavigate } from "react-router-dom";
import toast from "react-hot-toast";

import { IconButton } from "@mui/material";
import { PhotoCamera } from "@mui/icons-material";
import userPlaceHolder from "../../../assets/images/avatars/avatar-blank.png";
import { formatPhoneNumber1 } from "../../../utility/helper";

const AddUpdateModal = ({ open, handleModal, activity, isadd }) => {
  const [state, setState] = useState({
    status: false,
    assignAs: "",
  });
  const [allStores, setAllStores] = useState([]);
  const [select, setSelect] = useState();
  const token = localStorage.getItem("token");
  const animatedComponents = makeAnimated();
  const [validation, setValidation] = useState({
    selectproducer: "",
  });

  const handleChange = (e) => {
    if (!e.value) {
      setValidation({
        ...validation,
        selectproducer: "Please Select Producer",
      });
    } else {
      setValidation({
        ...validation,
        selectproducer: "",
      });
    }
    setSelect(e);
  };

  const navigate = useNavigate();
  const getRecord = () => {
    axios
      .get("/admin/stores", { headers: { Authorization: `Bearer ${token}` } })
      .then((response) => {
        console.log("activities", response.data);
        const stores = response.data;
        const allStore = stores.map((i) => {
          return { label: i.name, value: i._id };
        });
        setAllStores(allStore);
        setState({ status: true, assignAs: "producer" });
      })
      .catch((err) => {});
  };

  const CloseBtn = (
    <X className="cursor-pointer" size={15} onClick={handleModal} />
  );

  const handelSubmit = async () => {
    if (state.assignAs === "producer" && !select?.value) {
      setValidation({
        ...validation,
        selectproducer: "Please select a producer",
      });
      return false;
    }

    let payload = {
      user_id: activity?._id,
    };
    let url;

    if (state.assignAs === "producer") {
      url = "admin/store/assign_user";
      payload.producer_id = select?.value;
    } else {
      url = "admin/user/make_agent";
    }

    await axios({
      method: "post",
      url: url,
      headers: {
        // "content-type": "application/json",
        Authorization: `Bearer ${token}`,
      },
      data: payload,
    })
      .then((response) => {
        handleModal();
        navigate(`${process.env.REACT_APP_FOLDER}/customers-listing`);
        // setModal(false)
        toast.success("Assign Successfully");
      })
      .catch((err) => {
        toast.error(
          err.response.data.message
            ? err.response.data.message
            : "Something wrong"
        );
      });
  };

  return (
    <>
      <Modal
        isOpen={open}
        toggle={handleModal}
        className="sidebar-lg"
        modalClassName="modal-slide-in"
        contentClassName="pt-0"
      >
        <ModalHeader
          className="mb-1"
          toggle={handleModal}
          close={CloseBtn}
          tag="div"
        >
          <h5 classNam="modal-title">
            {isadd ? "User Details" : `User Details`}
          </h5>
        </ModalHeader>
        <ModalBody className="flex-grow-1">
          <div className="mb-1" style={{ padding: "10px" }}>
            <Row>
              <Col md={12}>
                <div className="mb-1">
                  <h5>
                    <User /> Full Name
                  </h5>
                  <div> {`${activity?.first_name} ${activity?.last_name}`}</div>
                </div>
                <hr />
              </Col>
              <Col md={12}>
                <div className="mb-1">
                  <h5>
                    <Mail /> Email
                  </h5>
                  <div> {activity?.email}</div>
                </div>
                <hr />
              </Col>
              <Col md={12}>
                <div className="mb-1">
                  <h5>
                    {" "}
                    <Phone /> Contact Number
                  </h5>
                  <div> +{activity?.phone}</div>
                </div>
                <hr />
              </Col>
              {/* <Col md={12}>
              <div className="mb-1">
                <h5>Address</h5>
                <div> {activity?.email}</div>
              </div>
              <hr />
            </Col> */}
              <Col md={12}>
                <div className="mb-1">
                  <h5>
                    <MapPin /> Zip Code
                  </h5>
                  <div> {activity?.zip_code}</div>
                </div>
                <hr />
              </Col>
              <Col md={12}>
                <div className="mb-1">
                  <h5>
                    <User />
                    Type
                  </h5>
                  <div> {activity?.user_type}</div>
                </div>
                <hr />
              </Col>
            </Row>

            {/* <div
            className="d-flex flex-column mb-1"
            style={{ marginTop: "0.5rem" }}
          >
            <Label for="switch-success" className="form-check-label mb-50">
              Activity {check === true ? "ON" : "OFF"}
            </Label>
            <div className="form-switch form-check-success">
              <Input
                type="switch"
                id="switch-success"
                name="success"
                checked={check}
                onChange={(e) => setCheck(e.target.checked ? true : false)}
              />
            </div>
          </div> */}

            <div className="mt-1">
              {activity?.user_type === "consumer" && (
                <>
                  <Button
                    style={{ margin: "10px 5px 0px 5px" }}
                    color="primary"
                    onClick={() => {
                      getRecord();
                    }}
                  >
                    Make Store Manager
                  </Button>

                  <Button
                    style={{ margin: "10px 5px 0px 5px" }}
                    color="primary"
                    onClick={() =>
                      setState({ status: true, assignAs: "delivery_agent" })
                    }
                  >
                    Make Delivery Manager
                  </Button>
                </>
              )}

              <Button
                style={{ margin: "10px 5px 0px 5px" }}
                color="secondary"
                onClick={handleModal}
                outline
              >
                Cancel
              </Button>
            </div>
          </div>
        </ModalBody>
      </Modal>

      <Modal
        isOpen={state.status}
        toggle={() => setState({ ...state, status: !state.status })}
        className="modal-dialog-centered"
        onClosed={() => {
          setState({ ...state, status: false });
        }}
      >
        <ModalHeader
          className="bg-transparent"
          toggle={() => setState({ ...state, status: !state.status })}
        ></ModalHeader>
        <ModalBody className="px-sm-5 mx-50 pb-5">
          <h4 className="text-center mb-1">
            {state.assignAs === "producer"
              ? "Make User as Store Manager"
              : "Make User as Delivery Manager"}
          </h4>
          <hr />
          <Row tag="form" className="gy-1 gx-2 mt-75">
            {state.assignAs === "producer" ? (
              <>
                <Col sm="12" className="mb-1">
                  <Col sm="12" className="mb-1">
                    <h6 className="form-h6" for="Status">
                      Select Producer
                    </h6>
                    <Select
                      isClearable={false}
                      required={true}
                      theme={selectThemeColors}
                      closeMenuOnSelect={true}
                      value={select}
                      components={animatedComponents}
                      onChange={(e) => handleChange(e)}
                      options={allStores}
                      className="react-select"
                      classNamePrefix="select"
                    />

                    {validation.selectproducer && (
                      <p
                        className="text-danger mb-0"
                        style={{ marginTop: "6px" }}
                      >
                        {validation.selectproducer}
                      </p>
                    )}
                  </Col>
                </Col>
              </>
            ) : (
              <>
                <Col sm="12" className="mb-1">
                  <h6 for="Status">
                    Do you really want make this user as Delivery Manager?
                  </h6>
                  {/* {validation.selectStore && (
                <p className="text-danger mb-0" style={{ marginTop: "6px" }}>
                  {validation.selectStore}
                </p>
              )} */}
                </Col>
              </>
            )}
            <hr />

            <Col className="text-center mt-1" xs={12}>
              <Button className="me-1" color="primary" onClick={handelSubmit}>
                Submit
              </Button>
              <Button
                color="secondary"
                outline
                onClick={() => {
                  setState({ ...state, status: !state.status });
                  // reset();
                }}
              >
                Cancel
              </Button>
            </Col>
          </Row>
        </ModalBody>
      </Modal>
    </>
  );
};

export default AddUpdateModal;
